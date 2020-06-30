//
//  TTVideoEngine+Preload.h
//  TTVideoEngine
//
//  Created by 黄清 on 2018/11/28.
//

#import "TTVideoEngine.h"

#if TT_VIDEO_ENGINE_LOCAL_SERVER

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TTVideoEngineDataLoaderTaskType) {
    TTVideoEngineDataLoaderTaskTypePreload,
    TTVideoEngineDataLoaderTaskTypePlay,
};

@class AVMDLDataLoaderConfigure;
@class TTVideoEngineLocalServerTaskInfo;
@class TTVideoEngineLocalServerConfigure;
@class TTVideoEngineLocalServerCacheInfo;
@protocol TTVideoEnginePreloadDelegate <NSObject>

@optional
/// Local server, An error occurred
- (void)preloaderErrorForVid:(nullable NSString *)vid errorType:(TTVideoEngineDataLoaderErrorType)errorType error:(NSError *)error;

/// Local server, Log update.
- (void)localServerLogUpdate:(NSDictionary *)logInfo;
/// Local server, Test speed.
- (void)localServerTestSpeedInfo:(NSTimeInterval)timeInternalMs size:(NSInteger)sizeByte;
/// Local server, task progress.
- (void)localServerTaskProgress:(TTVideoEngineLocalServerTaskInfo *)taskInfo;

@end

@interface TTVideoEngine()

/// Local server switch.
@property(nonatomic, assign) BOOL proxyServerEnable;

@end

@class TTVideoEnginePreloaderVidItem;
@interface TTVideoEngine (Preload)

/**
 Play media with url,through a local proxy server
 About key, if can get media's fileHash, it's the best key.
 
 @param url The source link of media.
 @param key The unique identity of meida.
 */
- (void)ls_setDirectURL:(NSString *)url key:(NSString *)key;
/** Set a set of urls. */
- (void)ls_setDirectURLs:(NSArray<NSString *> *)urls key:(NSString *)key;

/// MARK: - Module Manager

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
// - - - - - - - - - - - - - - -  Module   - - - - - - - - - - - - - - - //
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

/**
 Local server configure.
 Custom configure before call ls_start.
 
 @return configure object.
 */
+ (AVMDLDataLoaderConfigure *)ls_loaderConfigure DEPRECATED_MSG_ATTRIBUTE("use ls_localServerConfigure");

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
+ (void)ls_setPreloadDelegate:(id<TTVideoEnginePreloadDelegate>)delegate;

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
+ (void)ls_addTask:(NSString *)key vidItem:(TTVideoEnginePreloaderVidItem *)vidItem;
/// Generate key by vidItem.
+ (void)ls_addTaskWithVidItem:(TTVideoEnginePreloaderVidItem *)vidItem;

/// preload videoModle, key is filehash field.
+ (void)ls_addTask:(TTVideoEngineModel *)infoModel resolution:(TTVideoEngineResolutionType)type preloadSize:(NSInteger)preloadSize;

/**
 Use url to preload data or use url to play video through a local proxy server,
 internally, ls_startTaskByKey: is called.
 
 @param key The unique identity of media. filehash is a good choice.
 @param videoId video-id
 @param preSize pre-load size, like 5*1024*1024(5M)
 @param url url of media.
 */
+ (void)ls_addTask:(NSString *)key vid:(nullable NSString *)videoId preSize:(NSInteger)preSize url:(NSString *)url;
/** Preload a set of urls. */
+ (void)ls_addTask:(NSString *)key vid:(nullable NSString *)videoId preSize:(NSInteger)preSize urls:(NSArray<NSString *> *)urls;

/**
 Start a task by key.

 @param key The unique identity of media. Before you use it for addTask:...
 */
//+ (void)ls_startTaskByKey:(NSString *)key;

/**
 Start all tasks.
 */
//+ (void)ls_startAllTasks;

/**
 Cancel task by key.

 @param key key The unique identity of media. Before you use it for addTask:...
 */
+ (void)ls_cancelTaskByKey:(NSString *)key;

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
 Get all cache data size.
 */
+ (int64_t)ls_getAllCacheSize;

/**
 Get cache size by a valid key.
 */
+ (int64_t)ls_getCacheSizeByKey:(NSString *)key;

/**
 Get cache info by a valid key.
 */
+ (nullable TTVideoEngineLocalServerCacheInfo *)ls_getCacheFileInfoByKey:(NSString *)key;

@end

/// Task rawItem for vid.
@interface TTVideoEnginePreloaderVidItem : NSObject

@property (nonatomic,   copy) NSString *videoId;
@property (nonatomic,   copy) NSString *playAuthToken;
@property (nonatomic, assign) BOOL h265Enable;
@property (nonatomic, assign) BOOL dashEnable;

/// Whether it is a test environment.
@property (nonatomic, assign) BOOL boeEnable;
@property (nonatomic, assign) TTVideoEngineResolutionType resolution;
/// example: 800 * 1024;  800k
@property (nonatomic, assign) NSInteger preloadSize;

/// Default: NO
@property (nonatomic, assign) BOOL onlyFetchVideoModel;

@property (nonatomic, strong) NSDictionary<NSString *, NSNumber *> *resolutionMap;



/**
 Create a preload vid-item.

 @param vid videoId
 @param playAuthToken playAuthToken
 @param resolution preload resolution
 @param preloaderSize preloader size
 @param isH265 isH265
 @return return value descriptio
 */
+ (instancetype)preloaderVidItem:(NSString *)vid
                           token:(NSString *)playAuthToken
                       reslution:(TTVideoEngineResolutionType)resolution
                     preloadSize:(NSInteger)preloaderSize
                          isH265:(BOOL)isH265;

// For fetch video-model.
+ (instancetype)preloaderVidItem:(NSString *)vid token:(NSString *)playAuthToken onlyFetchVideoModel:(BOOL)only;

@end

@interface TTVideoEngineLocalServerTaskInfo : NSObject
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
/// 
@property (nonatomic, assign) TTVideoEngineDataLoaderTaskType taskType;

@end

@interface TTVideoEngineLocalServerCacheInfo : NSObject

@property(nonatomic, assign) int64_t mediaSize;
@property(nonatomic, assign) int64_t cacheSizeFromZero;
@property(nonatomic,   copy) NSString *localFilePath;

@end

@interface TTVideoEngineLocalServerConfigure : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// The max cache data size.
@property(nonatomic, assign) NSInteger maxCacheSize;
/// TCP establishment time.
@property(nonatomic, assign) NSInteger openTimeOut;
/// TCP read write time.
@property(nonatomic, assign) NSInteger rwTimeOut;
/// Error occurred, number of retries.
@property(nonatomic, assign) NSInteger tryCount;
/// The Cache data folder.
@property(nonatomic,   copy) NSString *cachDirectory;

@end



/// MARK: - Private Method

@protocol TTVideoEngineLocalServerToEngineProtocol <NSObject>

- (void)updateCacheProgress:(NSString *)key observer:(id)observer progress:(CGFloat)progress;

@end

@interface TTVideoEngine(PreloadPrivate)
- (NSString*)_ls_proxyUrl:(NSString *)key rawKey:(NSString *)rawKey urls:(NSArray<NSString *> *)urls extraInfo:(nullable NSString *)extra;
- (void)_ls_logProxyUrl:(NSString *)proxyUrl;
- (void)_ls_addTask:(nullable NSString *)videoId
                key:(NSString *)key
         resolution:(TTVideoEngineResolutionType)type
           proxyUrl:(NSString *)proxyUrl
      decryptionKey:(nullable NSString *)decryptionKey;
+ (void)_ls_addObserver:(__weak id)observer forKey:(NSString *)key;
+ (void)_ls_removeObserver:(__weak id)observer forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END

#endif
