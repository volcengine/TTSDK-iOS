//
//  TTVideoEngine+Preload.h
//  TTVideoEngine
//
//  Created by 黄清 on 2018/11/28.
//

#import "TTVideoEngine.h"
#import "TTVideoEngineUtil.h"
#if __has_include(<VCPreloadStrategy/VCMediaLoadTask.h>)
#import <VCPreloadStrategy/VCMediaLoadTask.h>
#else
#import "VCMediaLoadTask.h"
#endif
#import "TTVideoEnginePreloadMedia.h"
#import "TTVideoEngineLoadProgress.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TTMDLGETValueType) {
    TTMDLGetChecksumInfo    =  624,
};

/// Default priority, will enque task from the back.
FOUNDATION_EXTERN const NSInteger TTVideoEnginePrloadPriorityDefault;
/// High priority, will enque task from the front.
FOUNDATION_EXTERN const NSInteger TTVideoEnginePrloadPriorityHigh;
/// Highest priority, will enque task from the front ,and only be canceled by the key.
FOUNDATION_EXTERN const NSInteger TTVideoEnginePrloadPriorityHighest;


typedef NSString *_Nullable(^TTVideoEngineReturnStringBlock)(TTVideoEnginePlayAPIVersion apiVersion, NSString *vid);
typedef void (^TTVideoEngineSpeedInfoBlock)(int64_t timeIntervalMs, int64_t size, NSString *type, NSString *key);


@class AVMDLDataLoaderConfigure;
@class TTVideoEngineLocalServerCDNLog;
@class TTVideoEngineLocalServerTaskInfo;
@class TTVideoEngineLocalServerConfigure;
@class TTVideoEngineLocalServerCacheInfo;
@class TTVideoEnginePreloaderVideoModelItem;
@class TTVideoEnginePreloaderURLItem;
@class TTVideoEngineLoadProgress;
@protocol TTVideoEngineInternalDelegate;

/// This protocol describe the deteil of extern DNS Parser's result.
@protocol TTVideoEngineExternDNSParserDataSource<NSObject>

@required
/// Host name
- (NSString *)hostName;
/// ⚠️ IP list of host name.
- (NSArray *)ipList;
/// The effective duration of this result. (unit: second)
- (NSInteger)ttl;

@end

/// This protocol provide the origin parm of DNS entry.
@protocol TTVideoEngineExternDNSParserDelegate<NSObject>

@required
/// Provide the url which you want to parse.
- (void)setUrl:(NSURL *)url;

@end

@protocol TTVideoEnginePreloadDelegate <NSObject>

@optional
/// Local server, An error occurred.
- (void)preloaderErrorForVid:(nullable NSString *)vid errorType:(TTVideoEngineDataLoaderErrorType)errorType error:(NSError *)error;
/// Local server, Log update.
/// ⚠️ Called in an asynchronous thread, Serial queue.
- (void)localServerLogUpdate:(NSDictionary *)logInfo;
/// Local server, Test speed.
/// ⚠️ Called in an asynchronous thread, Serial queue.
- (void)localServerTestSpeedInfo:(NSTimeInterval)timeInternalMs size:(NSInteger)sizeByte;
/// Local server, task progress.
/// ⚠️ Called in an asynchronous thread, Serial queue.
- (void)localServerTaskProgress:(TTVideoEngineLocalServerTaskInfo *)taskInfo;
/// Local server, getstring value by key.
/// ⚠️ Called in an asynchronous thread.
- (NSString *)localServerGetStringBykey:(NSString *)key code:(NSInteger)code type:(NSInteger)type;
/// cdn log
- (void)localServerCDNLog:(NSDictionary *)log;
/// load progress
/// ⚠️ Called in an asynchronous thread, Serial queue.
- (void)mediaLoaderLoadProgress:(TTVideoEngineLoadProgress *)loadProgress;

- (NSDictionary*)localServerGetCustomHttpHeader:(NSString *)url;

@end

@interface TTVideoEngine()

/// Local server switch.
@property(nonatomic, assign) BOOL proxyServerEnable;
@property(nonatomic, assign) BOOL medialoaderEnable;
@property(nonatomic, assign) BOOL medialoaderNativeEnable;
@property(nonatomic, assign) BOOL medialoaderProtocolRegistered;


@property(nonatomic, nullable, weak) id<TTVideoEngineInternalDelegate>internalDelegate;

@end

@class TTVideoEnginePreloaderVidItem;
@class TTVideoEngineMultiEncodingUrlSource;
@class TTVideoEngineCopyCacheItem;
@interface TTVideoEngine (Preload)

/**
 Play media with url,through a local proxy server
 About key, if can get media's fileHash, it's the best key.
 
 @param url The source link of media.
 @param key The unique identity of meida.
 */
- (void)ls_setDirectURL:(NSString *)url key:(NSString *)key;
/// Custom cache file path.
- (void)ls_setDirectURL:(NSString *)url filePath:(NSString *)filePath;
/** Set a set of urls. */
- (void)ls_setDirectURLs:(NSArray<NSString *> *)urls key:(NSString *)key;
/// Custom cache file path.
- (void)ls_setDirectURLs:(NSArray<NSString *> *)urls filePath:(NSString *)filePath;

/// Play media with url,use mdl to load data.
/// @param url the url of media.
/// @param key the cache key of file.
/// @param videoId Optional, the video-id of media.
- (void)ls_setDirectURL:(NSString *)url key:(NSString *)key videoId:(nullable NSString *)videoId;

/// Play media with url,use mdl to load data.
/// @param urls the urls of media.
/// @param key the cache key of file.
/// @param videoId Optional, the video-id of media.
- (void)ls_setDirectURLs:(NSArray<NSString *> *)urls key:(NSString *)key videoId:(nullable NSString *)videoId;

/// Play media with multi-encdoing source and use mdl to load data.
/// Although multi URIs passed, but it will ONLY load the one which match the encode type source decided by current codec strategy.
/// @see TTVideoEngineCodecStrategy
/// @param urlSource Url source model's object.
- (void)ls_setMultiEncodingUrlSource:(TTVideoEngineMultiEncodingUrlSource *)urlSource withCodecStrategy:(TTVideoEngineCodecStrategy)strategy;

/// MARK: - Module Manager

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
// - - - - - - - - - - - - - - -  Module   - - - - - - - - - - - - - - - //
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

/**
 Local server configure.
 Custom configure before call ls_start.
 
 @return configure object.
 */
//+ (AVMDLDataLoaderConfigure *)ls_loaderConfigure DEPRECATED_MSG_ATTRIBUTE("use ls_localServerConfigure");

/*
 maxCacheSize    : 100M
 openTimeOut     : 5s
 rwTimeOut       : 5s
 tryCount        : 0, limitless
 cachDirectory   : ../Cache/md5(@"avmdl_default_file_dir")
 */
+ (TTVideoEngineLocalServerConfigure *)ls_localServerConfigure;

/**
 Use vid to preload data or use vid to play video through a local proxy
 server, need to get media information through vid.
 Fetch video info, control the max concurrent number.

 @param number concurrent number, [0~4] Default:4
 */
+ (void)ls_setMaxConcurrentNumber:(NSInteger)number;

/**
 Use vid to preload data or use vid to play video through a local proxy server,
 need to provide the necessary information to get the media data,
 so you need to set up the delegate

 @param delegate pre-load delegate
 */
+ (void)ls_setPreloadDelegate:(nullable id<TTVideoEnginePreloadDelegate>)delegate;

/**
 add speed info callback
 */
+ (void)ls_setSpeedInfoCallback:(nullable TTVideoEngineSpeedInfoBlock)block;

/**
 In case of you need customize HTTPDNS parse.
 ⚠️ You should call this method before MDL call ls_start.
 */
+ (void)ls_setCustomDNSParser:(nonnull id<TTVideoEngineExternDNSParserDataSource, TTVideoEngineExternDNSParserDelegate>)parser;

/**
 Start local server.
 Generally, [TTVideoEngine ls_start] should be your first step in using localserver.
 */
+ (void)ls_start;

/**
 Local server run status.
 If return NO, need call ls_start.
 
 @return Module status.
 */
+ (BOOL)ls_isStarted;

/**
 Get medialoader native handle for player
 */
+ (void*)ls_getNativeMedialoaderHandle;

/**
 Stop local server.
 */
//+ (void)ls_stop;

/**
 Close local server.
 Cannot use local server, call [TTVideoEngine ls_start] if you need to use again.
 */
+ (void)ls_close;

/// MARK: - Task Manager

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
// - - - - - - - - - - - - - - Task Manager  - - - - - - - - - - - - - - //
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

/**
 Use vid to preload data or use vid to play video through a local proxy server,
 internally, ls_startTaskByKey: is called.

 @param key The unique identity of media. filehash is a good choice.
 @param vidItem preload info for vid.
 */
+ (void)ls_addTask:(NSString *)key vidItem:(TTVideoEnginePreloaderVidItem *)vidItem DEPRECATED_MSG_ATTRIBUTE("Please use ls_addTaskWithVidItem:");

/// Preload with urls
+ (void)ls_addTaskWithURLItem:(TTVideoEnginePreloaderURLItem *)urlItem;

/// Preload with vid.
+ (void)ls_addTaskWithVidItem:(TTVideoEnginePreloaderVidItem *)vidItem;

/// Preload with video-model.
+ (void)ls_addTaskWithVideoModelItem:(TTVideoEnginePreloaderVideoModelItem *)videoModelItem;

/// preload videoModle, key is filehash field.
+ (void)ls_addTask:(TTVideoEngineModel *)infoModel resolution:(TTVideoEngineResolutionType)type preloadSize:(NSInteger)preloadSize;
/// Custom cache file path.
+ (void)ls_addTask:(TTVideoEngineModel *)infoModel resolution:(TTVideoEngineResolutionType)type preloadSize:(NSInteger)preloadSize filePath:(nullable NSString *(^)(TTVideoEngineURLInfo *urlInfo))filePath;

+ (void)ls_addTask:(TTVideoEngineModel *)infoModel resolution:(TTVideoEngineResolutionType)type params:(nullable NSDictionary *)params preloadSize:(NSInteger)preloadSize;


+ (void)ls_copyCache:(TTVideoEngineCopyCacheItem *)copyCacheItem;

/**
 Use url to preload data or use url to play video through a local proxy server,
 internally, ls_startTaskByKey: is called.
 
 @param key The unique identity of media. filehash is a good choice.
 @param videoId video-id
 @param preSize pre-load size, like 5*1024*1024(5M)
 @param url url of media.
 */
+ (void)ls_addTask:(NSString *)key vid:(nullable NSString *)videoId preSize:(NSInteger)preSize url:(NSString *)url;
/// Custom cache file path.
+ (void)ls_addTaskForUrl:(NSString *)url vid:(nullable NSString *)videoId preSize:(NSInteger)preSize filePath:(NSString *)filePath;
/** Preload a set of urls. */
+ (void)ls_addTask:(NSString *)key vid:(nullable NSString *)videoId preSize:(NSInteger)preSize urls:(NSArray<NSString *> *)urls;
/// Custom cache file path.
+ (void)ls_addTaskForUrls:(NSArray<NSString *> *)urls vid:(nullable NSString *)videoId preSize:(NSInteger)preSize filePath:(NSString *)filePath;

///pre connect by url
+ (void)ls_preConnectUrl:(NSString *)url;

/// custom preload strategy.
@property (nonatomic, assign, class) TTVideoEnginePrelaodStrategy preloadStrategy;

/**
 Cancel task by key.

 @param key key The unique identity of media. Before you use it for addTask:...
 */
+ (void)ls_cancelTaskByKey:(NSString *)key;
/// Custom cache file path.
+ (void)ls_cancelTaskByFilePath:(NSString *)filePath;

/// Cancel preload task by videoId.
/// @param vid videoId.
+ (void)ls_cancelTaskByVideoId:(NSString *)vid;

/**
 Cancel all task.
 */
+ (void)ls_cancelAllTasks;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
// - - - - - - - - - - - - - - Cache Manager  - - - - - - - - - - - -  - //
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

/**
 Clear all cache data.
 */
+ (void)ls_clearAllCaches;

/**
 Remove the file disk cache by key.
 
 @param key the file hash.
 */
+ (void)ls_removeFileCacheByKey:(NSString *)key;


/**
 Get all cache data size.
 */
+ (int64_t)ls_getAllCacheSize;

/// Get the cache size asynchronously
+ (void)ls_getAllCacheSizeWithCompletion:(void(^)(int64_t cacheSize))block;

/**
 Get cache size by a valid key.
 */
+ (int64_t)ls_getCacheSizeByKey:(NSString *)key;
+ (void)ls_getCacheSizeByKey:(NSString *)key result:(void(^)(int64_t size))result;
/// Custom cache file path.
+ (int64_t)ls_getCacheSizeByFilePath:(NSString *)filePath;
+ (void)ls_getCacheSizeByFilePath:(NSString *)filePath result:(void(^)(int64_t size))result;

+ (int64_t)ls_getCacheFileSize:(TTVideoEngineModel *)infoModel resolution:(TTVideoEngineResolutionType)resolution;

+ (void)ls_getCacheFileSize:(TTVideoEngineModel *)infoModel
                 resolution:(TTVideoEngineResolutionType)resolution
                     result:(void(^)(int64_t size))result;

/**
 Get cache info by a valid key.
 */
+ (nullable TTVideoEngineLocalServerCacheInfo *)ls_getCacheFileInfoByKey:(NSString *)key;
/// Custom cache file path.
+ (nullable TTVideoEngineLocalServerCacheInfo *)ls_getCacheFileInfoByFilePath:(NSString *)filePath;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
// - - - - - - - - - - - - - - DNS Setting   - - - - - - - - - - - - - - //
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

/**
 Set dns ttl

 @param ttl Time to live
 */
+ (void)ls_DNSTTL:(NSInteger)ttl;
+ (NSInteger)ls_getDNSTTL;

/// Configure DNS parse type
/// @param mainType main dns parser type, default is local.
/// @param backupType backup dns parser type, default is local.
+ (void)ls_mainDNSParseType:(TTVideoEngineDnsType)mainType backup:(TTVideoEngineDnsType)backupType;
+ (TTVideoEngineDnsType)ls_getMainDNSParseType;
+ (TTVideoEngineDnsType)ls_getBackupDNSParseType;

// this method will start bytedance httpdns service without anyother method, before ls_start.
+ (void)ls_startByteDanceHttpDnsWithAccountID:(NSString *)accountID key:(NSString *)key;

/**
 The time of backup parser wait.

 @param second default is 0.0f, The unit is seconds.
 */
+ (void)ls_backupDNSParserWaitTime:(double)second;
+ (double)ls_getBackupDNSParserWaitTime;

/**
 set the method of dns resolution

 @param parallel mainDns and backupDns start at the same moment and default is 0
 */
+ (void)ls_setDNSParallel:(NSInteger)parallel;

/**
 get the method of dns resolution
 
 @return whether mainDns and backupDns start at the same moment , yes if 1, no if 0
 */
+ (NSInteger)ls_getDNSParallel;

/**
 set the refresh method of dns resolution

 @param refresh dns resolution refresh by iteself
 */
+ (void)ls_setDNSRefresh:(NSInteger)refresh;

/**
 get the refresh method of dns resolution
 
 @return whether dns resolution refresh by itself
 */
+ (NSInteger)ls_getDNSRefresh;

/// Clear all dns cache.
+ (void)ls_clearAllDNSCache;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
// - - - - - - - - - - - - - -  AutoTrim - - - - - - - - - - - - - - - - //
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - -//

/**
 disable auto-trim mechanism for video key.
 
 @param key media key.
 */
+ (void)ls_disableAutoTrimForKey:(NSString *)key;


/**
 enable auto-trim mechanism for video key.
 
 @param key media key.
 */
+ (void)ls_enableAutoTrimForKey:(NSString *)key;


/**
 get cdnlog by filekey.
 
 @param key media key.
 */
+ (NSDictionary*)ls_getCDNLog:(NSString *)key;


/**
 generate sub url cache key
 
 @param key  url cache key
 @param subUrl  sub url cdn url
 @return cache key of sub url
 */
+ (NSString*)ls_generateKey:(NSString *)key subUrl:(NSString *)subUrl;

/**
 generate mdl proxy url
 
 @param key  cache key of file
 @param url  url of file
 @return mdl proxy url
 */
+ (NSString *)ls_proxyUrl:(NSString *)key url:(NSString *)url;


@end

/// MARK: - Private Method

@protocol TTVideoEngineLocalServerToEngineProtocol <NSObject>

- (void)updateCacheProgress:(NSString *)key flag:(NSInteger)flag observer:(id)observer progress:(CGFloat)progress;

@end

@interface TTVideoEngine(PreloadPrivate)
- (NSString*)_ls_proxyUrl:(NSString *)key rawKey:(NSString *)rawKey urls:(NSArray<NSString *> *)urls extraInfo:(nullable NSString *)extra filePath:(nullable NSString *)filePath;
- (void)_ls_logProxyUrl:(NSString *)proxyUrl;
- (void)_ls_addTask:(nullable NSString *)videoId
                key:(NSString *)key
         resolution:(TTVideoEngineResolutionType)type
           proxyUrl:(NSString *)proxyUrl
      decryptionKey:(nullable NSString *)decryptionKey
               info:(TTVideoEngineURLInfo *)info
               urls:(NSArray *)urls;
+ (NSString *)_ls_getMDLVersion;
- (NSString*)_ls_getMDLPlayLog:(NSString *)traceId;
- (void)_ls_removePlayTaskByKeys:(NSArray *)keys;
- (void)_registerMdlProtocolHandle;
+ (void)_ls_addObserver:(__weak id)observer forKey:(NSString *)key;
+ (void)_ls_removeObserver:(__weak id)observer forKeys:(NSArray *)keys;
+ (nullable NSString *)_ls_keyFromFilePath:(NSString *)filePath;
+ (void)_ls_forceRemoveFileCacheByKey:(NSString *)key;
+ (void)_ls_startMediaLoadTaskbyTask:(VCMediaLoadTask *)mediaTask;
+ (NSInteger)_ls_getPreloadTaskNumber;
+ (float)_ml_getNetworkSpeed;
+ (void)_ml_playStall:(NSString *)playSourceId;
+ (void)_ml_playStallEnd:(NSString *)playSourceId;
+ (void)_ml_playingSourceId:(NSString *)playSourceId;
+ (void)_ml_pausingSourceId:(NSString *)playSourceId;
+ (void)_ml_stopSourceId:(NSString *)playSourceId;
@end

/// key and cacheFilePath are two-choice relationships, one of which must have a vaild value.
@interface TTVideoEnginePreloaderURLItem : NSObject
/// Cache-key.
@property (nonatomic, copy, nullable) NSString *key;

@property (nonatomic, copy, nullable) NSArray<NSString *> *urls;
/// Optional
@property (nonatomic, copy, nullable) NSString *videoId;
/// Custom cache file path.
@property (nonatomic, copy, nullable) NSString *cacheFilePath;
/// example: 800 * 1024;  800k
@property (nonatomic, assign) NSInteger preloadSize;
/// Default value is TTVideoEnginePrloadPriorityDefault.
@property (nonatomic, assign) NSInteger priorityLevel;

@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *subTag;

/// Set custom header
- (void)setCustomHeaderValue:(NSString *)value forKey:(NSString *)key;

/// preload task end.
@property (nonatomic, copy, nullable) void(^preloadEnd)(TTVideoEngineLocalServerTaskInfo *_Nullable info, NSError *_Nullable error);

/// preload task cancel call back.
@property (nonatomic, copy, nullable) void(^preloadCanceled)(void);


/// preload task started
/// info @{@"index": @(index), @"url": url}
@property (nonatomic, copy, nullable) void(^preloadDidStart)(NSDictionary *_Nullable info);

+ (nullable instancetype)urlItem:(NSString *)key
                         videoId:(nullable NSString *)videoId
                     preloadSize:(NSInteger)preloadSize
                            urls:(NSArray<NSString *> *)urls;


+ (nullable instancetype)urlItemWithKey:(NSString *)key
                                videoId:(nullable NSString *)videoId
                                   urls:(NSArray<NSString *> *)urls
                            preloadSize:(NSInteger)preloadSize;

+ (nullable instancetype)urlItemWitFilePath:(NSString *)cacheFilePath
                                    videoId:(nullable NSString *)videoId
                                       urls:(NSArray<NSString *> *)urls
                                preloadSize:(NSInteger)preloadSize;

/// Create a preload url item which support multi-encoding resource.
/// Will only preload one specific encode type source.
/// @param source multi-encoding url source.
/// @param videoId VideoId of the play source, nullable.
/// @param preloadSize preload size
+ (nullable instancetype)urlItemWithMultiEncodingUrlSource:(TTVideoEngineMultiEncodingUrlSource *)source
                                                   videoId:(nullable NSString *)videoId
                                               preloadSize:(NSInteger)preloadSize
                                             codecStrategy:(TTVideoEngineCodecStrategy)strategy;

@end

@interface TTVideoEnginePreloaderVideoModelItem : NSObject
/// Resolution information for which you want to preload data.
@property (nonatomic, assign) TTVideoEngineResolutionType resolution;
/// video-model info.
@property (nonatomic, strong, nullable) TTVideoEngineModel *videoModel;
/// example: 800 * 1024;  800k
@property (nonatomic, assign) NSInteger preloadSize;

///preload to millisecond, work when videomodel have fitterifno, othrewise use preloadSize
@property (nonatomic, assign) NSInteger preloadMilliSecond;

///preload form millisecond offset, work when videomodel have fitterifno, othrewise from start
@property (nonatomic, assign) NSInteger preloadMilliSecondOffset;

@property (nonatomic, nullable, strong) NSDictionary *params;

/// Default value is TTVideoEnginePrloadPriorityDefault.
@property (nonatomic, assign) NSInteger priorityLevel;

@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *subTag;

/// Using urlInfos.
@property (nonatomic, copy, nullable) void(^usingUrlInfo)(NSArray<TTVideoEngineURLInfo *> *urlInfos);
/// Custom cache file path.
@property (nonatomic, copy, nullable) NSString *(^cacheFilePath)(TTVideoEngineURLInfo *urlInfo);
/// preload task end.
@property (nonatomic, copy, nullable) void(^preloadEnd)(TTVideoEngineLocalServerTaskInfo *_Nullable info, NSError *_Nullable error);

/// preload task cancel call back.
@property (nonatomic, copy, nullable) void(^preloadCanceled)(void);

/// preload task started
/// info @{@"index": @(index), @"url": url}
@property (nonatomic, copy, nullable) void(^preloadDidStart)(NSDictionary *_Nullable info);

+ (instancetype)videoModelItem:(TTVideoEngineModel *)data
                    resolution:(TTVideoEngineResolutionType)resolution
                   preloadSize:(NSInteger)preloadSize
                        params:(nullable NSDictionary *)params;

+ (instancetype)videoModelItem:(TTVideoEngineModel *)data
                    resolution:(TTVideoEngineResolutionType)resolution
      preloadMilliSecondOffset:(NSInteger)preloadMilliSecondOffset
                   preloadSize:(NSInteger)preloadSize
                        params:(nullable NSDictionary *)params;


@end


/// Task rawItem for vid.
@interface TTVideoEnginePreloaderVidItem : NSObject

@property (nonatomic, nullable, copy) NSString *videoId;
@property (nonatomic,   copy) NSString *playAuthToken;
@property (nonatomic, assign) TTVideoEngineResolutionType resolution;
/// example: 800 * 1024;  800k
@property (nonatomic, assign) NSInteger preloadSize;
@property (nonatomic, assign) TTVideoEngineEncodeType codecType;
@property (nonatomic, assign) BOOL h265Enable;
@property (nonatomic, assign) BOOL dashEnable;
@property (nonatomic, assign) BOOL httpsEnable;
@property (nonatomic, assign) BOOL encryptionEnable;
@property (nonatomic, assign) BOOL hlsEnable;
@property (nonatomic, nullable, strong) NSDictionary *params;

@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *subTag;

/// Default value is TTVideoEnginePrloadPriorityDefault.
@property (nonatomic, assign) NSInteger priorityLevel;
/// Default: NO
@property (nonatomic, assign) BOOL onlyFetchVideoModel;
/// OPtional, resolution map.
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSNumber *> *resolutionMap;

/// Fetch video-model finish.
@property (nonatomic, copy, nullable) void (^fetchDataEnd)(TTVideoEngineModel *_Nullable model, NSError *_Nullable error);
/// Using urlInfos.
@property (nonatomic, copy, nullable) void(^usingUrlInfo)(NSArray<TTVideoEngineURLInfo *> *urlInfos);
/// Custom cache file path.
@property (nonatomic, copy, nullable) NSString *(^cacheFilePath)(TTVideoEngineURLInfo *urlInfo);
/// preload task end.
@property (nonatomic, copy, nullable) void(^preloadEnd)(TTVideoEngineLocalServerTaskInfo *_Nullable info, NSError *_Nullable error);

/// preload task cancel call back.
@property (nonatomic, copy, nullable) void(^preloadCanceled)(void);
/// preload task started
/// info @{@"index": @(index), @"url": url}
@property (nonatomic, copy, nullable) void(^preloadDidStart)(NSDictionary *_Nullable info);

/**
Create a preload vid-item.

@param vid videoId
@param playAuthToken playAuthToken
@param resolution preload resolution
@param preloaderSize preloader size
@param h265 ish265
@param enableEncryption is enable encrypted video
@param hlsEnable is enable hls video playing
@return return value descriptio
*/
+ (instancetype)preloaderVidItem:(NSString *)vid
                           token:(NSString *)playAuthToken
                       reslution:(TTVideoEngineResolutionType)resolution
                     preloadSize:(NSInteger)preloaderSize
                       ish265:(BOOL)h265
                      encryption:(BOOL)enableEncryption
                       hlsEnable:(BOOL)hlsEnable;

/**
Create a preload vid-item.

@param vid videoId
@param playAuthToken playAuthToken
@param resolution preload resolution
@param preloaderSize preloader size
@param h265 ish265
@param enableEncryption is enable encrypted video
@return return value descriptio
*/
+ (instancetype)preloaderVidItem:(NSString *)vid
                           token:(NSString *)playAuthToken
                       reslution:(TTVideoEngineResolutionType)resolution
                     preloadSize:(NSInteger)preloaderSize
                       ish265:(BOOL)h265
                      encryption:(BOOL)enableEncryption;

// For fetch video-model.
+ (instancetype)preloaderVidItem:(NSString *)vid token:(NSString *)playAuthToken onlyFetchVideoModel:(BOOL)only;

+ (instancetype)preloaderVidItem:(NSString *)vid
                           token:(NSString *)playAuthToken
                       reslution:(TTVideoEngineResolutionType)resolution
                     preloadSize:(NSInteger)preloaderSize
                           codec:(TTVideoEngineEncodeType)codecType
                      encryption:(BOOL)enableEncryption
                       hlsEnable:(BOOL)hlsEnable;

@end

@interface TTVideoEngineLocalServerTaskInfo : NSObject
/// If you customize the cache file path, you must ignore this field.
/// Task key. using url .the key is you set, using vidItem ,the key is fileHash.
@property (nonatomic,   copy) NSString *key;
/// Video-id.
@property (nonatomic, nullable, copy) NSString *videoId;
/// Using resolution.
@property (nonatomic, assign) TTVideoEngineResolutionType resolution;
/// The local file path of media.
@property (nonatomic, nullable, copy) NSString *localFilePath;
/// The origin size of media.
@property (nonatomic, assign) int64_t mediaSize;
/// Non-stop cache size from scratch.
@property (nonatomic, assign) int64_t cacheSizeFromZero;
/// Decryption key.
@property (nonatomic, nullable, copy) NSString *decryptionKey;
/// PreloadSize.
@property (nonatomic, assign) int64_t preloadSize;
/// Play or Preload.
@property (nonatomic, assign) TTVideoEngineDataLoaderTaskType taskType;
/// Using data, just for vid-item.
@property (nonatomic, nullable, strong) TTVideoEngineURLInfo *urlInfo;
@end

@interface TTVideoEngineLocalServerCacheInfo : NSObject

@property(nonatomic, assign) int64_t mediaSize;
@property(nonatomic, assign) int64_t cacheSizeFromZero;
@property(nonatomic,   copy) NSString *localFilePath;

@end

@interface TTVideoEngineCopyCacheItem : NSObject


/**
 * destPath, absolute path with file name
 */
@property (nonnull, nonatomic, copy) NSString* destPath;

/**
 * filekey
 */
@property (nonnull, nonatomic, copy) NSString* fileKey;

/**
 * 如果正在下载过程如播放，是否等待下载完
 */
@property (nonatomic, assign) BOOL waitIfCaching;
@property (nonatomic, copy) void (^completionBlock)(BOOL isSuccess,NSError* _Nullable  err);

- (instancetype)initWithKey:(NSString *)key
                   destPath:(NSString *)path
            completionBlock:(void (^)(BOOL isSuccess, NSError* err))completionBlock;

- (instancetype)initWithKey:(NSString *)key
                   destPath:(NSString *)path
               waitIfCaching:(BOOL)waitIfCaching
            completionBlock:(void (^)(BOOL isSuccess, NSError* err))completionBlock;

@end

@interface TTVideoEngineLocalServerCDNLog : NSObject
/// Task key.
@property (nonatomic,   copy) NSString *fileKey;
/// host.
@property (nonatomic, nullable, copy) NSString *host;
/// host.
@property (nonatomic, nullable, copy) NSString *url;
/// server ip.
@property (nonatomic, nullable, copy) NSString *serverIp;
/// xcache.
@property (nonatomic, nullable, copy) NSString *xCache;
/// xmcache.
@property (nonatomic, nullable, copy) NSString *xMCache;
/// contentlength.
@property (nonatomic, assign) int64_t contentLength;
/// contentlength.
@property (nonatomic, assign) int64_t reqStartT;
/// contentlength.
@property (nonatomic, assign) int64_t reqEndT;

@end

typedef NSNumber*  VEMDLKeyType;
#ifndef VEKMDLKEY
#define VEKMDLKEY(key)  @(key)
#endif

/// VEMDLKey
/// Use these keys, set value correspond the key, also get value correspod the key.
/// Please use marco VEKMDLKEY(key), example: VEKMDLKEY(VEMDLKeyMaxCacheSize_NSInteger)
typedef NS_ENUM(NSInteger, VEMDLKey) {
    /// medialoader key start config pass to mdl native
    /// The max cache data size.
    VEMDLKeyMaxCacheSize_NSInteger = (1<<14) + 3,
    /// TCP establishment time.
    VEMDLKeyOpenTimeOut_NSInteger,
    /// TCP read write time.
    VEMDLKeyRWTimeOut_NSInteger,
    /// Error occurred, number of retries.
    VEMDLKeyTryCount_NSInteger,
    /// Paralle task number.
    VEMDLKeyPreloadParallelNum_NSInteger,
    /// is enable oc dns parse.
    VEMDLKeyEnableExternDNS_BOOL,
    /// reuse socket.
    VEMDLKeyEnableSoccketReuse_BOOL,
    /// socket idle timeout.
    VEMDLKeySocketIdleTimeout_NSInteger,
    /// checksumlevel.
    VEMDLKeyChecksumLevel_NSInteger,
    /// The longest time that cached data exists. unit is second.
    /// Default value is 14*24*60*60, 14 day.
    VEMDLKeyMaxCacheAge_NSInteger,
    /// The Cache data folder.
    VEMDLKeyCachDirectory_NSString,
    
    /// is enable auth play
    VEMDLKeyIsEnableAuth_NSInteger,
    
    // heart beat interval, 0 is disable, unit: ms
    VEMDLKeyHeartBeatInterval_NSInteger,
    /// download dir.
    VEMDLKeyDownloadDirectory_NSString,
    
    VEMDLKeyWriteFileNotifyIntervalMS_NSInteger,
    
    VEMDLKeyIsEnableLazyBufferPool_BOOL,
    
    VEMDLKeyIsEnablePreConnect_BOOL,
    
    VEMDLKeyPreConnectNum_NSInteger,
    
    VEMDLKeyIsEnableMDLAlog_BOOL,
    
    VEMDLKeyIsEnableNewBufferpool_BOOL,
    VEMDLKeyNewBufferpoolBlockSize_NSInteger,
    VEMDLKeyNewBufferpoolResidentSize_NSInteger,
    VEMDLKeyNewBufferpoolGrowBlockCount_NSInteger,
    
    VEMDLKeyIsEnableSessionReuse_BOOL,
    VEMDLKeySessionTimeout_NSInteger,
    VEMDLKeyMaxTlsVersion_NSInteger,
    
    VEMDLKeyIsEnableLoaderPreempt_BOOL,
    VEMDLKeyNextDownloadThreshold_NSInteger,
    
    VEMDLKeyMaxIPV4Count_NSInteger,
    VEMDLKeyMaxIPV6Count_NSInteger,
    
    VEMDLKeyIsEnablePlayLog_BOOL,
    
    VEMDLKeyIsEnableFileExtendBuffer_BOOL,
    
    VEMDLKeyIsEnableNetScheduler_BOOL,
    VEMDLKeyIsNetSchedulerBlockAllNetErr_BOOL,
    VEMDLKeyNetSchedulerBlockErrCount_NSInteger,
    VEMDLKeyNetSchedulerBlockDuration_NSInteger,
    VEMDLKeyIsAllowTryLastUrl_BOOL,
    VEMDLKeyIsEnableLocalDNSThreadOptimize_BOOL,
    
    VEMDLKeyIsEnableCacheReqRange_BOOL,
    
    VEMDLKeyConnectPoolStragetyValue_NSInteger,
    VEMDLKeyMaxAliveHostNum_NSInteger,
    VEMDLKeyMaxSocketReuseCount_NSInteger,
    
    VEMDLKeyFileExtendSizeKB_NSInteger,
    VEMDLKeyIsEnableFixCancelPreload_BOOL,
    
    VEMDLKeyIsEnableDNSNoLockNotify_BOOL,
    
    VEMDLKeyIsEnableEarlyData_NSInteger,
    
    VEMDLKeyIsCacheDirMaxCacheSize_NSDictionary,
        
    /// medialoader key end
};

@interface TTVideoEngineLocalServerConfigure : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 Set options by VEKMDLKEY
 Example:
 [self setOptions:@{VEKMDLKEY(VEMDLKeyMaxSocketReuseCount_NSInteger),@(1)}];
                      |                   |          |                          |
                Generate key            Field     valueType                   value
 @param options key is one of VEMDLKeys, value defined id type.
 */
- (void)setOptions:(NSDictionary<VEMDLKeyType,id> *)options;

/// key is a type of VEMDLKey or VEKGetKey.
- (void)setOptionForKey:(VEMDLKeyType)key value:(id)value;

- (id)getOptionBykey:(VEMDLKeyType)key;

/// The max cache data size.
@property(nonatomic, assign) NSInteger maxCacheSize;
/// TCP establishment time.
@property(nonatomic, assign) NSInteger openTimeOut;
/// TCP read write time.
@property(nonatomic, assign) NSInteger rwTimeOut;
/// Error occurred, number of retries.
@property(nonatomic, assign) NSInteger tryCount;
/// Paralle task number.
@property(nonatomic, assign) NSInteger preloadParallelNum;
/// is enable oc dns parse.
@property(nonatomic, assign) BOOL enableExternDNS;
/// reuse socket.
@property(nonatomic, assign) BOOL enableSoccketReuse;
/// socket idle timeout.
@property(nonatomic, assign) NSInteger socketIdleTimeout;
/// checksumlevel.
@property(nonatomic, assign) NSInteger checksumLevel;
/// The longest time that cached data exists. unit is second.
/// Default value is 14*24*60*60, 14 day.
@property(nonatomic, assign) NSInteger maxCacheAge;
/// The Cache data folder.
@property(nonatomic, nullable, copy) NSString *cachDirectory;

/// is enable auth play
@property(nonatomic, assign) NSInteger isEnableAuth;

// heart beat interval, 0 is disable, unit: ms
@property(nonatomic, assign) NSInteger heartBeatInterval;
/// download dir.
@property(nonatomic, nullable, copy) NSString *downloadDirectory;

@property(nonatomic, assign) NSInteger writeFileNotifyIntervalMS;

@property(nonatomic, assign) NSInteger forbidByPassCookie;
/// Whether to report network log
/// Convenient to solve online issue
@property (nonatomic,assign) BOOL reportNetLogEnable;

@property(nonatomic, assign) BOOL isEnableLazyBufferPool;

@property(nonatomic, assign) BOOL isEnablePreConnect;

@property(nonatomic, assign) NSInteger preConnectNum;

@property(nonatomic, assign) BOOL isEnableMDLAlog;

@property(nonatomic, assign) BOOL isEnableNewBufferpool;
@property(nonatomic, assign) NSInteger newBufferpoolBlockSize;
@property(nonatomic, assign) NSInteger newBufferpoolResidentSize;
@property(nonatomic, assign) NSInteger newBufferpoolGrowBlockCount;

@property(nonatomic, assign) BOOL isEnableSessionReuse;
@property(nonatomic, assign) NSInteger sessionTimeout;
@property(nonatomic, assign) NSInteger maxTlsVersion;

@property(nonatomic, assign) BOOL isEnableLoaderPreempt;
@property(nonatomic, assign) NSInteger nextDownloadThreshold;

@property(nonatomic, assign) NSInteger maxIPV4Count;
@property(nonatomic, assign) NSInteger maxIPV6Count;

@property(nonatomic, assign) BOOL isEnablePlayLog;

@property(nonatomic, assign) BOOL isEnableFileExtendBuffer;

@property(nonatomic, assign) BOOL isEnableNetScheduler;
@property(nonatomic, assign) BOOL isNetSchedulerBlockAllNetErr;
@property(nonatomic, assign) NSInteger netSchedulerBlockErrCount;
@property(nonatomic, assign) NSInteger netSchedulerBlockDuration;
@property(nonatomic, assign) BOOL isAllowTryLastUrl;
@property(nonatomic, assign) BOOL isEnableLocalDNSThreadOptimize;

@property(nonatomic, assign) BOOL isEnableCacheReqRange;

@property(nonatomic, assign) NSInteger connectPoolStragetyValue;
@property(nonatomic, assign) NSInteger maxAliveHostNum;
@property(nonatomic, assign) NSInteger maxSocketReuseCount;
@property(nonatomic, assign) NSInteger fileExtendSizeKB;
@property(nonatomic, assign) BOOL isEnableFixCancelPreload;
@property(nonatomic, assign) BOOL isEnableDNSNoLockNotify;
@property(nonatomic, assign) NSInteger isEnableEarlyData;
@property(nonatomic, nullable, copy) NSDictionary<NSString*, NSNumber*>* cacheDirMaxCacheSize;

@end

@protocol TTVideoEngineInternalDelegate <NSObject>

@optional
- (void)didFinishVideoDataDownloadForKey:(NSString *)key;
- (void)noVideoDataToDownloadForKey:(NSString *)key;

@end

@interface TTVideoEngine (Downloader_Private)
+ (nullable NSString *)_ls_downloadUrl:(NSString *)key
                                rawKey:(nullable NSString *)rawKey
                                  urls:(NSArray<NSString *> *)urls;
+ (void)_ls_startDownload:(NSString *)downloadUrl;
+ (void)_ls_cancelDownloadByKey:(NSString *)key;
@end
@class _TTVideoEnginePreloadTask;
@interface TTVideoEngineLoadProgress (Private)
- (void)setUp:(_TTVideoEnginePreloadTask *)task;
@end

@interface TTVideoEngine (MediaLoaderExperiment)

+ (void)setMDLNetUnReachableStopRetry:(BOOL) stopRetry;

@end

NS_ASSUME_NONNULL_END

