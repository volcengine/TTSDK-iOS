//
//  TTVideoEngine.h
//  Pods
//
//  Created by guikunzhi on 16/12/2.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTVideoEngineNetClient.h"
#import "TTVideoEngineModelDef.h"
#import "TTVideoEnginePlayItem.h"
#import "TTVideoEngineVideoInfo.h"
#import "TTVideoEngineModel.h"
#import "TTVideoEngineAVPlayerItemAccessLog.h"
#import "TTVideoEnginePlayerDefine.h"
#import "TTVideoEnginePublicProtocol.h"
#import "TTVideoEngineUtil.h"
#if __has_include(<TTNetworkPredict/IVCNetworkSpeedPredictor.h>)
#import <TTNetworkPredict/IVCNetworkSpeedPredictor.h>
#else
#import "IVCNetworkSpeedPredictor.h"
#endif
#if __has_include(<ABRInterface/IVCABRModule.h>)
#import <ABRInterface/IVCABRModule.h>
#else
#import "IVCABRModule.h"
#endif
#if __has_include(<TTPlayerSDK/TTAVPlayerLoadControlInterface.h>)
#import <TTPlayerSDK/TTAVPlayerLoadControlInterface.h>
#else
#import "TTAVPlayerLoadControlInterface.h"
#endif

NS_ASSUME_NONNULL_BEGIN

extern NSString *kTTVideoEngineUserClickedUI;

typedef void* _Nullable (*DrmCreater)(int drmType);

@protocol TTVideoEngineDataSource <NSObject>

@optional
- (TTVideoEngineNetworkType)networkType;

/// Custom cache file path.
- (NSString *)cacheFilePathUsingMediaDataLoader:(NSString *)videoId infoModel:(TTVideoEngineURLInfo *)infoModel;

/// The key from TTVideoEngineKeys.h
- (nullable NSDictionary<NSString *, id> *)appInfo;

@end



@class TTVideoEngine;
@protocol TTVideoEngineDelegate <NSObject>

@optional

/**
 playback state change callback

 @param videoEngine videoEngine
 @param playbackState playbackState
 */
- (void)videoEngine:(TTVideoEngine *)videoEngine playbackStateDidChanged:(TTVideoEnginePlaybackState)playbackState;


/**
 load state change callback

 @param videoEngine videoEngine
 @param loadState loadState
 */
- (void)videoEngine:(TTVideoEngine *)videoEngine loadStateDidChanged:(TTVideoEngineLoadState)loadState;

/// Engine's load state did changed
/// @param videoEngine the instance of engine
/// @param loadState the load state.
/// @param extraInfo extra info.
/// { /// extra info
///     TTVideoEngineBufferStartAction:@(TTVideoEngineStallActionNone),
///     TTVideoEngineBufferStartReason:@(TTVideoEngineStallReasonNetwork)
/// }
- (void)videoEngine:(TTVideoEngine *)videoEngine
loadStateDidChanged:(TTVideoEngineLoadState)loadState
              extra:(nullable NSDictionary<NSString *,id> *)extraInfo;

/**
 fetched video model
 @param videoEngine videoEngine
 @param videoModel videoModel
 */
- (void)videoEngine:(TTVideoEngine *)videoEngine fetchedVideoModel:(TTVideoEngineModel *)videoModel;

/**
 get urlInfos
 */
- (void)videoEngine:(TTVideoEngine *)videoEngine usingUrlInfos:(NSArray<TTVideoEngineURLInfo *> *)urlInfos;

/**
 Video engine ready to display, show the first frame.

 @param videoEngine engine
 */
- (void)videoEngineReadyToDisPlay:(TTVideoEngine *)videoEngine;

/**
 video engine is prepared
 
 @param videoEngine videoengine
 */
- (void)videoEnginePrepared:(TTVideoEngine *)videoEngine;

/**
 video engine is ready to play

 @param videoEngine videoengine
 */
- (void)videoEngineReadyToPlay:(TTVideoEngine *)videoEngine;

/**
 video engine is showed first audio
 
 @param videoEngine videoengine
 */
- (void)videoEngineAudioRendered:(TTVideoEngine *)videoEngine;

/**
 video engine will retry

 @param videoEngine videoengine
 @param error error info
 */
- (void)videoEngine:(TTVideoEngine *)videoEngine retryForError:(NSError *)error;

/**
 video engine stalled not because of seek
 
 @param videoEngine videoengine
 */
- (void)videoEngineStalledExcludeSeek:(TTVideoEngine *)videoEngine;

/// Using media loader,the size of hit cache.
/// @param videoEngine Engine instance
/// @param key The task key of using media loader
/// @param cacheSize hit cache size.
- (void)videoEngine:(TTVideoEngine *)videoEngine mdlKey:(NSString *)key hitCacheSze:(NSInteger)cacheSize;

/**
video engine play device opened

@param videoEngine videoengine
@param streamType  stream type 0 for video 1 for audio
*/
- (void)videoEngineDeviceOpened:(TTVideoEngine *)videoEngine streamType:(TTVideoEngineStreamType)streamType;


/**
 This will be called before videoEngine remove the old view. After view removed, the screen shows black.
 @param videoEngine videoengine
 */
- (void)videoEngineBeforeViewRemove:(TTVideoEngine *)videoEngine;

/**
 outlet paused
 
 @param videoEngine videoengine
 @param streamType  stream type 0 for video 1 for audio
 */
- (void)videoEngineOutleterPaused:(TTVideoEngine *)videoEngine streamType:(TTVideoEngineStreamType)streamType;

/**
  video engine AV outsync state change
 */
- (void)videoEngine:(TTVideoEngine *)videoEngine avOutsyncStateDidChanged:(TTVideoEngineAVOutsyncType)type extraInfo:(nullable NSDictionary *)extraInfo;

@required

/**
 user stopped

 @param videoEngine videoengine
 */
- (void)videoEngineUserStopped:(TTVideoEngine *)videoEngine;

/**
 video engine finished

 @param videoEngine videoengine
 @param error error info
 */
- (void)videoEngineDidFinish:(TTVideoEngine *)videoEngine error:(nullable NSError *)error;


/**
 video engine finished because of bad video status

 @param videoEngine videoengine
 @param status video status code
 */
- (void)videoEngineDidFinish:(TTVideoEngine *)videoEngine videoStatusException:(NSInteger)status;

/**
video engine close async complete

@param videoEngine videoengine
*/
- (void)videoEngineCloseAysncFinish:(TTVideoEngine *)videoEngine;

@end

@protocol TTVideoEngineResolutionDelegate <NSObject>

@optional
- (void)suggestReduceResolution:(TTVideoEngine *)videoEngine;

- (void)videoBitrateDidChange:(TTVideoEngine *)videoEngine resolution:(TTVideoEngineResolutionType)resolution bitrate:(NSInteger)bitrate;

- (void)videoSizeDidChange:(TTVideoEngine *)videoEngine videoWidth:(NSInteger)videoWidth videoHeight:(NSInteger)videoHeight;

@end

@protocol TTVideoEngineABRDelegate <NSObject>

@optional
- (void)videoEnginePredictNextBitrate:(TTVideoEngine *)videoEngine bitrate:(NSInteger)bitrate;

@end

@interface TTVideoEngine : NSObject

@property (nonatomic, nullable, weak) id<TTVideoEngineDataSource> dataSource;
@property (nonatomic, nullable, weak) id<TTVideoEngineDelegate> delegate;
@property (nonatomic, nullable, weak) id<TTVideoEngineResolutionDelegate> resolutionDelegate;
@property (nonatomic, nullable, weak) id<TTVideoEngineABRDelegate> dashABRDelegate;


/** Playback speed */
@property (nonatomic, assign) CGFloat playbackSpeed;
/** Playback volume */
@property (nonatomic, assign) CGFloat volume;
/** Muted if true */
@property (nonatomic, assign) BOOL muted;

// radio mode
@property (nonatomic, assign) BOOL radioMode;

/** HardwareDecode switch */
@property (nonatomic, assign) BOOL hardwareDecode;
/** Loop play mode */
@property (nonatomic, assign) BOOL looping;
/** Cache Switch,if use the default cache dir,
 cache data will remove automatically when engine dealloc. */
@property (nonatomic, assign) BOOL cacheEnable;
/** Support barrage mask */
@property (nonatomic, assign) BOOL supportBarrageMask;
/** Set net client, use for fetch videoModel, dns parser. */
@property (nonatomic, nullable, strong) id<TTVideoEngineNetClient> netClient;
/// Readonly
/** Self-developed player */
@property (nonatomic, assign, readonly) BOOL isOwnPlayer;
/** Player view */
@property (nonatomic, strong, readonly) UIView *playerView;
/** Current playback time */
@property (nonatomic, assign, readonly) NSTimeInterval currentPlaybackTime;
/** The video duration */
@property (nonatomic, assign, readonly) NSTimeInterval duration;
//
@property (nonatomic, assign, readonly) NSTimeInterval playableDuration;
/** Accumulated watched duration */
@property (nonatomic, assign, readonly) NSTimeInterval durationWatched;
/** Engine status */
@property (nonatomic, assign, readonly) TTVideoEngineState state;
/** Current playback state, play or pause */
@property (nonatomic, assign, readonly) TTVideoEnginePlaybackState playbackState;
/** Current load state, stall or playable */
@property (nonatomic, assign, readonly) TTVideoEngineLoadState loadState;
//
@property (nonatomic, assign, readonly) TTVideoEngineStallReason stallReason;
//
@property (nonatomic, strong, readonly) TTVideoEngineAVPlayerItemAccessLog *accessLog;
/** If pause called return NO */
@property (nonatomic, assign, readonly) BOOL shouldPlay;

/*if enable resolution will gained from service recommendation**/
@property (nonatomic, assign, readonly) BOOL autoModeEnabled;

/** It's used to get whether current video resolution is TTVideoEngineResolutionTypeABRAuto
 enabled if YES, it will enable smoothly switching at the same time */
//@property (nonatomic, assign, readonly) BOOL autoModeEnabled;
/** Current resolution */
@property (nonatomic, assign, readonly) TTVideoEngineResolutionType currentResolution;
/** Current qualityDesc */
@property (nonatomic, copy, nullable) NSString *currentQualityDesc;
/** Debug view, need add to superView and set frame. */
@property (nonatomic, strong, nullable, readonly) UIView *debugInfoView;
/* load control interface*/
@property (nonatomic, strong, nullable) id<TTAVPlayerLoadControlInterface> loadControl;
/**
 warning: this feature only support on sys ver > iOS 14.0
 default is NO , if your player will on a  PictureInPicture wrapper  at sometime , you can set this YES
 if set this YES , playerView will check if itSelf  on a PictureInPicture wrapper or not , if the result is true , the player can still play on background  app mode ,
 so this prop is just a config that determin if  playerView should check or not , this prop cannot determin if the player can still play on background  app mode
 Only condition
 */
@property (nonatomic, assign) BOOL supportPictureInPictureMode API_AVAILABLE(ios(14.0));

/** Custom resolution map.
 @{
    @"360p":@(TTVideoEngineResolutionTypeSD),
    @"480p":@(TTVideoEngineResolutionTypeHD),
    @"720p":@(TTVideoEngineResolutionTypeFullHD),
    @"1080p":@(TTVideoEngineResolutionType1080P),
    @"2k":@(TTVideoEngineResolutionType2K),
    @"4k":@(TTVideoEngineResolutionType4K),
    @"hdr":@(TTVideoEngineResolutionTypeHDR),
 };
 */
@property (nonatomic, nullable, strong) NSDictionary<NSString *, NSNumber *> *resolutionMap;

/**
 This method is used to activate the render
 You should call this method in app delegate's applicationDidBecomeActive: method, or it may result
 in black screen bug
 */
+ (void)startOpenGLESActivity;

/**
 enable speed predict
 */
+ (void)startSpeedPredictor:(NetworkPredictAlgoType)type interval:(int)intervalMs;

/**
 set default abr algorithm
*/
+ (void)setDefaultABRAlgorithm:(ABRPredictAlgoType)algoType;

/**
 This method is used to deactive the render
 You should call this method in app delegate's applicationWillResignActive: method, or it may leads
 to crash
 */
+ (void)stopOpenGLESActivity;

+ (void)sendCustomMessage:(nullable NSDictionary *)message;

/**
 This method is used to enable or disable log

 @param enabled YES to enable log
 */
+ (void)setLogEnabled:(BOOL)enabled DEPRECATED_MSG_ATTRIBUTE("Please use setLogFlag:");

/// Log flag, see enum TTVideoEngineLogFlag
/// @param flag log falg
+ (void)setLogFlag:(TTVideoEngineLogFlag)flag;
/**
 Get the log information callback of the console

 @param logDelegate confirm protocol TTVideoEngineLogDelegate
 */
+ (void)setLogDelegate:(nullable id<TTVideoEngineLogDelegate>)logDelegate;

/**
 @return whether device && OS version supports Metal
 */
+ (BOOL)isSupportMetal;

/**
 Ignore Audio Interruption
 
 @param ignore  YES to handle audio interruption yourself
 */
+ (void)setIgnoreAudioInterruption:(BOOL)ignore;

/**
 set the priority of http dns and local dns, default http dns first

 @param isFirst httpdns is first
 */
+ (void)setHTTPDNSFirst:(BOOL)isFirst;
+ (BOOL)getHTTPDNSFirst;

/**
 set the quality infos

 @param qualityInfos  all qualityInfo
 */

+ (void)setQualityInfos:(NSArray *)qualityInfos;

+ (NSArray *)getQualityInfos;

/**
 set the main dns and backup dns

 @param mainDns  backupDns
 */
+ (void)setDNSType:(TTVideoEngineDnsType)mainDns backupDns:(TTVideoEngineDnsType)backupDns;

+ (NSArray *)getDNSType;
/**
 set global http dns server IP address
 @param serverIP is the http dns server IP of alicloud
 */
+ (void)setHTTPDNSServerIP:(NSString *)serverIP;

/**
 set global delegate to get extrainfo form player
 @param protocol is the delegate
 */

+ (void)configExtraInfoProtocol:(nullable id<TTVideoEngineExtraInfoProtocol>)protocol;

/**
 for set Config

 @param config is NSDictionary,
        key                   value          Description
 eg.    TTVideoEngineAID      NSNumber         appId
 eg.    TTVideoEngineAppName  NString          appName
 eg.    ....                  ....             ...
 
 such as config = @{TTVideoEngineAppId:@(13),TTVideoEngineAppName:@"news_article"}
 */
+ (void)configureAppInfo:(NSDictionary<NSString *, id>*)config;

/**
 set YES to enable stack size optimize
 */
+ (void)setStackSizeOptimized:(BOOL)optimized;

/**
 config thread wait timeout, such as 1000ms, default is 0(wait forever)
 */
+ (void)configThreadWaitMilliSeconds:(int)timeout;

/**
 init method

 @param isOwnPlayer use own player pass YES, otherwise NO
 @return TTVideoEngine Object
 */
- (instancetype)initWithOwnPlayer:(BOOL)isOwnPlayer;

- (instancetype)initWithType:(TTVideoEnginePlayerType)type NS_DESIGNATED_INITIALIZER;

/**
 set play authorization
 
 @param auth Authorization
 */
- (void)setPlayAuthToken:(NSString *)auth;

/**
 set Subtitle authorization
 
 @param auth Authorization
 */
- (void)setSubtitleAuthToken:(NSString *)auth;

/**
 set custom header
 @param value custom header value
 @param key custom header key
 */
- (void)setCustomHeaderValue:(NSString *)value forKey:(NSString *)key;

/**
 set videoID to play remote video
 You must call this method before play

 @param videoID the ID of video
 */
- (void)setVideoID:(NSString *)videoID;

- (void)setLiveID:(NSString *)liveID;

- (void)setPlayItem:(TTVideoEnginePlayItem *)playItem;

/**
 set feed model to play

 @param videoInfo contains vid, resolution, feed model ...
 */
- (void)setVideoInfo:(TTVideoEngineVideoInfo *)videoInfo;

/**
 Set videoModel to play.

 @param videoModel instance of TTVideoEngineModel.
 */
- (void)setVideoModel:(TTVideoEngineModel *)videoModel;

/**
 set preloaderItem to play with preloaded in local disk video

 @param preloaderItem the preloaded item whitch contains local url
 */
- (void)setPreloaderItem:(TTAVPreloaderItem *)preloaderItem;

/**
 set local url to play local file

 @param url local url
 */
- (void)setLocalURL:(NSString *)url;

/**
 set remote url to play network video
 
 @param url remote url
 
 @discuss DON'T config resolution if use direct url to play
 */
- (void)setDirectPlayURL:(NSString *)url;

/**
 You want to use the cahe when play again, need set a valid file path.
 
 @note: You should manage these cache files by cachePath,
        Because the user's phone storage is limited

 @param url directPlayURLString
 @param cacheFilePath cache file Path
 */
- (void)setDirectPlayURL:(NSString *)url cacheFile:(nullable NSString* )cacheFilePath;


- (void)setAVPlayerItem:(AVPlayerItem *)playerItem;//WARNING: only support system AVPlayer currently

/** Set a set of urls. */
- (void)setDirectPlayURLs:(NSArray<NSString *> *)urls;

/** Preload data and render the first frame */
- (void)prepareToPlay;

/**
 It's used to play video. You can use it to start or resume the player.
 Make sure you've already called setVideoID: method
 */
- (void)play;

/**
 It's used to pause the video playing.
 */
- (void)pause;

/**
 It's used to pause the video playing.
 @param async if YES，async execute
 */
- (void)pause:(BOOL)async;

/**
 It's used to pause the video playing aync.
 */
- (void)pauseAsync NS_DEPRECATED(2_0,2_0,2_0,2_0,"use pause:");

/**
 It's used to stop the video and it will reset the internal player.
 */
- (void)stop;
    
/**
 It's used to close player process but not release
 */
- (void)close;

/**
 It's used to close the video async.
 */
-(void)closeAysnc;

/**
 It's used to seek to a given time.

 @param currentPlaybackTime the time to seek to, in seconds.
 @param finised the completion handler
 */
- (void)setCurrentPlaybackTime:(NSTimeInterval)currentPlaybackTime
                      complete:(void(^)(BOOL success))finised;

/**
 It's used to seek to a given time.

 @param currentPlaybackTime the time to seek to, in seconds.
 @param finised the completion handler
 @param renderComplete called when seek complate and target time video or audio rendered
 */
- (void)setCurrentPlaybackTime:(NSTimeInterval)currentPlaybackTime
                      complete:(void(^)(BOOL success))finised
                renderComplete:(void(^)(void)) renderComplete;

/**
 It's used to periodicly get something from the player,
 such as current currentPlaybackTime, playableDuration...

 @param interval the time interval in seconds
 @param queue target queue to perform action
 @param block periodic work to do
 */
- (void)addPeriodicTimeObserverForInterval:(NSTimeInterval)interval
                                     queue:(dispatch_queue_t)queue
                                usingBlock:(void (^)(void))block;

/**
 remove the observer
 */
- (void)removeTimeObserver;

/**
 It's used to periodicly get downloadspeed from the player
 
 @param interval the time interval in seconds
 @param queue target queue to perform action
 @param block periodic work to do
 */
- (void)addSpeedTimeObserverForInterval:(NSTimeInterval)interval
                                  queue:(dispatch_queue_t)queue
                             usingBlock:(void (^)(long long speed))block;

/**
 remove the speedtimer observer
 */
- (void)removeSpeedTimeObserver;

/**
 It's used to get the supported resolutions for the video

 @return an Array of numbers(TTVideoEngineResolutionType)
 */
- (nullable NSArray<NSNumber *> *)supportedResolutionTypes;

- (nullable NSArray<NSString *> *)supportedQualityInfos;

/**
 It's used to set the default resolution and it can also used to switch resolution

 @param resolution the default resolution, or the resolution to switch
 @return success or not (It just means the task was submitted successfully)
 */
- (BOOL)configResolution:(TTVideoEngineResolutionType)resolution;
- (BOOL)configResolution:(TTVideoEngineResolutionType)resolution params:(nullable NSDictionary *)map;
/**
 It's used to set the default resolution and it can also used to switch resolution

 @param resolution the default resolution, or the resolution to switch
 @param completion completion call back
 */
- (void)configResolution:(TTVideoEngineResolutionType)resolution
              completion:(void(^)(BOOL success, TTVideoEngineResolutionType completeResolution))completion;
- (void)configResolution:(TTVideoEngineResolutionType)resolution params:(NSDictionary *)map
completion:(void(^)(BOOL success, TTVideoEngineResolutionType completeResolution))completion;
/**
 It's used to get current preloaderItem
 @return preloaderItem engine used
 */
- (nullable TTAVPreloaderItem*)getCurPreloaderItem;

- (NSInteger)videoSizeForType:(TTVideoEngineResolutionType)type;

/**
 clear screen, call it after playback complete
 */
- (void)clearScreen NS_DEPRECATED(2_0,2_0,2_0,2_0,"Don't use it, not supportted any more!");

/**
 used only when render engine is TTVideoEngineRenderEngineOutput and decoder type is hardware decode(Support Only TTPlayer currently)
 You should setHardwareDecode to YES and set render engine to TTVideoEngineRenderEngineOutput.
 */
- (nullable CVPixelBufferRef)copyPixelBuffer;

- (void)setDrmCreater:(nullable DrmCreater)drmCreater;

/**
 @return whether playsource is Dash
 */
- (BOOL)isDashSource;

/** return support bash*/
- (BOOL)isBashSource;

@end

NS_ASSUME_NONNULL_END
