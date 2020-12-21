//
//  TTVideoEngine+Private.h
//  TTVideoEngine
//
//  Created by 黄清 on 2019/1/9.
//

#import "TTVideoEngine.h"
#import "TTVideoEngineInfoFetcher.h"
#import "TTVideoEngineDNSParser.h"
#import "TTVideoNetUtils.h"
#import "TTVideoEngine+Preload.h"
#import "TTVideoEngineEventLogger.h"

FOUNDATION_EXTERN UInt64 const kTTVideoEngineHardwareDecodMask;
FOUNDATION_EXTERN UInt64 const kTTVideoEngineRenderEngineMask;
FOUNDATION_EXTERN UInt64 const kTTVideoEngineNetworkTimeOutMask;
FOUNDATION_EXTERN UInt64 const kTTVideoEngineCacheMaxSecondsMask;
FOUNDATION_EXTERN UInt64 const kTTVideoEngineBufferingTimeOutMask;
FOUNDATION_EXTERN UInt64 const kTTVideoEngineReuseSocketMask;
FOUNDATION_EXTERN UInt64 const kTTVideoEngineCacheVideoModelMask;
FOUNDATION_EXTERN UInt64 const kTTVideoEngineUploadAppLogMask;
FOUNDATION_EXTERN UInt64 const kTTVideoEngineHTTPDNSFirstMask;

NS_ASSUME_NONNULL_BEGIN

#ifndef __TTVIDEOENGINE_PUT_METHOD__
#define __TTVIDEOENGINE_PUT_METHOD__
#ifdef DEBUG
#define TTVIDEOENGINE_PUT_METHOD do\
{NSString *key = [NSString stringWithFormat:@"Engine-%p",self];\
NSString *method = [NSString stringWithFormat:@"time = %f. %@",CACurrentMediaTime(),NSStringFromSelector(_cmd)];\
[TTVideoEngine _putWithKey:key method:method];\
} while(NO);
#else
#define TTVIDEOENGINE_PUT_METHOD
#endif
//
#ifdef DEBUG
#define TTVIDEOENGINE_PRINT_METHOD [TTVideoEngine _printAllMethod];
#else
#define TTVIDEOENGINE_PRINT_METHOD
#endif
#endif

/// Private @property
@interface TTVideoEngine ()
@property (nonatomic, assign) NSInteger cacheMaxSeconds;
@property (nonatomic, assign) TTVideoEngineRotateType rotateType;
@property (nonatomic, assign) NSInteger bufferingTimeOut;
@property (nonatomic, assign) NSInteger maxBufferEndTime;
/// Assaign value when local server task finish.
@property (nonatomic, assign) NSTimeInterval playableDurationFromLocalServer;
/// The key of current play task.
@property (nonatomic, nullable, copy) NSString *localServerTaskKey;
@property (nonatomic, assign) NSInteger loopWay;
/** Set boe enanle. */
@property (nonatomic, assign) BOOL boeEnable;
/** Set dns cache enanle. */
@property (nonatomic, assign) BOOL dnsCacheEnable;
/** Set dns expired time. */
@property (nonatomic, assign) NSInteger dnsExpiredTime;
/** net work status. */
@property (nonatomic, assign) TTVideoEngineNetWorkStatus isNetworkType;
/// Default: 0
@property (nonatomic, assign) UInt64 settingMask;
@property (nonatomic, assign, readonly) long long bitrate;
/// ...
@property (nonatomic, strong) TTVideoEngineEventLogger *eventLogger;

/**
 default 0, max value: 1000
 */
@property (nonatomic, assign) NSInteger embellishVolumeMilliseconds;

/**
 enable ksyHevcDecode
 */
@property (nonatomic, assign) BOOL ksyHevcDecode;

/**
 enable h265
 */
@property (nonatomic, assign) BOOL h265Enabled;

/**
 smoothly switching resolution
 */
@property (nonatomic, assign) BOOL smoothlySwitching;

/**
 set init ttplayer in async mode,default is false
 */
@property (nonatomic, assign) BOOL asyncInit;

/**
 set start play time
 */
@property (nonatomic, assign) NSTimeInterval startTime;

/**
 set loop start time
 */
@property (nonatomic, assign) NSTimeInterval loopStartTime;

/**
 set loop end time
 */
@property (nonatomic, assign) NSTimeInterval loopEndTime;

/**
 smoothly switch delayed seconds, default is -1
 */
@property (nonatomic, assign) NSInteger smoothDelayedSeconds;

/**
 set using avresolver or not
 */
@property (nonatomic, assign, readwrite) BOOL isUsingAVResolver;

/**
subtag
*/
@property (nonatomic, copy) NSString *subtag;

/**
 decryptionKey
 */
@property (nonatomic, copy) NSString *decryptionKey;

/**
 encoded decryption key
 */
@property (nonatomic, copy) NSString *encryptedDecryptionKey;

/**
 resolution server control enabled
 */
@property (nonatomic, assign) BOOL resolutionServerControlEnabled;

@property (nonatomic, assign) TTVideoEngineTestSpeedMode testSpeedMode;

/**
 image scale model, default linear
 */
@property (nonatomic, assign) TTVideoEngineImageScaleType imageScaleType;

/**
 image enhancement, default none
 */
@property (nonatomic, assign) TTVideoEngineEnhancementType enhancementType;

/**
 image layout. set into openGLES
 */
@property (nonatomic, assign) TTVideoEngineImageLayoutType imageLayoutType;

/**
 view contentMode. not set into openGLES
 */
@property (nonatomic, assign) TTVideoEngineScalingMode scaleMode;

/**
 render type, plane, pano ...
 */
@property (nonatomic, assign) TTVideoEngineRenderType renderType;

/**
 render engine type: openGL, Metal. Metal only support iPhone 5s above && A7 chip above.
 Simulator not support Metal engine type.
 */
@property (nonatomic, assign) TTVideoEngineRenderEngine renderEngine;

/**
 get from response of play API server. setVid && preloadItem can get a value.
 */
@property (nonatomic, assign, readonly) NSInteger videoSize;

/**
 get from video metadata, all video source can get the size if use own player
 */
@property (nonatomic, assign, readonly) long long mediaSize;

/**
 Cache video info, Defut NO
 */
@property (nonatomic, assign) BOOL cacheVideoInfoEnable;

/**
 enable extern dir
 */
@property (nonatomic, assign) BOOL useExternDirEnable;

/**
 enable extern dir
 */
@property (nonatomic, copy) NSString *externCacheDir;

/**
 reuse socket
 */
@property (nonatomic, assign) BOOL reuseSocket;

/**
 enable dash
 */
@property (nonatomic, assign) BOOL dashEnabled;

/**
 disable accurate start time, used in dash video
 */
@property (nonatomic, assign) BOOL disableAccurateStart;

/**
 open network timeout
 */
@property (nonatomic, assign) NSInteger openTimeOut;

- (void)setTag:(NSString *)tag;

- (void)setSubTag:(NSString *)subTag;

/**
 get video width
 @return video display width
 */
- (NSInteger)getVideoWidth;

/**
 get video height
 @return video display height
 */
- (NSInteger)getVideoHeight;


@end

/// Private
@class TTVideoEnginePlayer;
@interface TTVideoEngine (Private)

+ (NSString *)_engineVersionString;
-(void)_settingCongureWithPlayer:(TTVideoEnginePlayer *)player;
+ (nullable NSDictionary *)_settingAppInfo;
+ (void)_settingSetAppInfo:(NSDictionary *)appinfo;
@end


/// Private Method.
@interface TTVideoEngine (PrivateTracker)

/// Add logdata
+ (void)_tracker_traceWithLogData:(id (^)(void))logdata;

+ (void)_tracker_removeCustomerData;

/// ToB , for start tracker module.
/// Must call this before use TTVideoEngine, if you want to collect logs.
+ (void)_tracker_setTrackerInfoWithId:(NSString *)appId
                                 name:(NSString *)appName
                              channel:(NSString *)channel
                               userId:(NSString *)userId
                               vendor:(NSInteger)vendor;

// Debug
+ (void)_putWithKey:(NSString *)key method:(NSString *)method;
+ (void)_printAllMethod;

+ (NSString *)_generateApiString:(NSString *)auth dash:(BOOL)dashEnabled h265:(BOOL)h265Enabled;
+ (id)setting_valueForKey:(NSString *)key defaultValue:(id)defaultValue;
+ (void)setting_assignConfigInfo:(NSDictionary *)info;
+ (NSDictionary *)setting_configInfo;
+ (nullable NSString *)_tracker_getDeviceId;

@end


@interface TTVideoEngineCopy : NSObject

/// Copy engine
+ (void)copyEngine:(TTVideoEngine *)engine;

/// Assign engine
+ (void)assignEngine:(TTVideoEngine *)engine;

/// Reset
+ (void)reset;

@end



NS_ASSUME_NONNULL_END
