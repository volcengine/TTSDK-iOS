//
//  TTVideoEngine+Options.h
//  TTVideoEngine
//
//  Created by 黄清 on 2019/1/4.
//

#import "TTVideoEngine.h"

typedef NSNumber*  VEKKeyType;
#ifndef VEKKEY
#define VEKKEY(key)  @(key)
#endif

/// VEKKey
/// Use these keys, set value correspond the key, also get value correspod the key.
/// Please use marco VEKKEY(key), example: VEKKEY(VEKKeyPlayerHardwareDecode_BOOL)
typedef NS_ENUM(NSInteger,VEKKey) {
    /// Player
    VEKKeyPlayer            =   1,
    /* HardwareDecode switch. */
    VEKKeyPlayerHardwareDecode_BOOL,
    /* KsyHevcDecode switch. */
    VEKKeyPlayerKsyHevcDecode_BOOL,
    /* H265 switch. */
    VEKKeyPlayerH265Enabled_BOOL,
    /* Whether to support dash. */
    VEKKeyPlayerDashEnabled_BOOL,
    VEKKeyPlayerSmoothlySwitching_BOOL,
    /* Loop sswitch. */
    VEKKeyPlayerLooping_BOOL,
    /* Async init player switch. */
    VEKKeyPlayerAsyncInit_BOOL,
    /* Muted switch. */
    VEKKeyPlayerMuted_BOOL,
    /* Volume. */
    VEKKeyPlayerVolume_CGFloat,
    /* Begin play time.*/
    VEKKeyPlayerStartTime_CGFloat,
    /* Loop start time. */
    VEKKeyPlayerLoopStartTime_CGFloat,
    /* Loop end time. */
    VEKKeyPlayerLoopEndTime_CGFloat,
    /* Play speed. */
    VEKKeyPlayerPlaybackSpeed_CGFloat,
    /* Embellish volume milliseconds.
     The max value is 1000, default 0 */
    VEKKeyPlayerEmbellishVolumeMilliseconds_NSInteger,
    /* Player network timeout. */
    VEKKeyPlayerOpenTimeOut_NSInteger,
    /* Smoothly switch delayed seconds. */
    VEKKeyPlayerSmoothDelayedSeconds_NSInteger,
    /* Test speed model. only vod
     Value type is TTVideoEngineTestSpeedMode. */
    VEKKeyPlayerTestSpeedMode_ENUM,
    /** Whether to reuse socket */
    VEKKeyPlayerReuseSocket_BOOL,
    /** Disable accurate start time, used in dash video */
    VEKKeyPlayerDisableAccurateStart_BOOL,
    /* Audio Device
     Value type is TTVideoEngineAudioDeviceType. */
    VEKKeyPlayerAudioDevice_ENUM,
    /* Maximum number of seconds to cache local resources */
    VEKKeyPlayerCacheMaxSeconds_NSInteger,
    /* Buffering  timeout*/
    VEKKeyPlayerBufferingTimeOut_NSInteger,
    /* Buffering  endtime*/
    VEKKeyPlayerMaxBufferEndTime_NSInteger,
    /* Loop way: 0,Engine;1,Kernel*/
    VEKKeyPlayerLoopWay_NSInteger,
    /** Whether to use boe*/
    VEKKeyPlayerBoeEnabled_BOOL,
    /// View
    VEKKeyView              =   1<<8,
    /* Image scale type.
     Value type isTTVideoEngineImageScaleType */
    VEKKeyViewImageScaleType_ENUM,
    /* Picture enhancement type. only vod
     Value type is TTVideoEngineEnhancementType */
    VEKKeyViewEnhancementType_ENUM,
    /* Image layout type.
     Value type is TTVideoEngineImageLayoutType */
    VEKKeyViewImageLayoutType_ENUM,
    /* Content scale mode.
     Value type is TTVideoEngineScalingMode */
    VEKKeyViewScaleMode_ENUM,
    /* Render type.
     Value type is TTVideoEngineRenderType */
    VEKKeyViewRenderType_ENUM,
    /* Render engine.
     Value type is TTVideoEngineRenderEngine */
    VEKKeyViewRenderEngine_ENUM,
    /* Rotate type.
     Value type is TTVideoEngineRotateType */
    VEKKeyViewRotateType_ENUM,
    
    /// Model
    VEKKeyModel             =   1<<9,
    VEKKeyModelResolutionServerControlEnabled_BOOL,
    /** Cache video info, Defut NO */
    VEKKeyModelCacheVideoInfoEnable_BOOL,
    
    /// DNS
    VEKKeyDNS               =   1<<10,
    /* Use player DNS resolver switch. */
    VEKKeyDNSIsUsingAVResolver_BOOL,
    /** Whether to use dns cache*/
    VEKKeyPlayerDnsCacheEnabled_BOOL,
    /* dns expired time*/
    VEKKeyPlayerDnsCacheSecond_NSInteger,
    
    /// Cache
    VEKKeyCache             =   1<<11,
    /* Cache playing data switch.
     Can save network traffic if loop */
    VEKKeyCacheCacheEnable_BOOL,
    /* User extern directory switch. */
    VEKKeyCacheUseExternDirEnable_BOOL,
    /* The directory of cache data.
     Play video use vid, and need cache video data when play finished
     Set cache data directory. */
    VEKKeyCacheExternCacheDir_NSString,
    
    /// Log
    VEKKeyLog               =   1<<12,
    /* Log tag. */
    VEKKeyLogTag_NSString,
    /* Log SubTag. */
    VEKKeyLogSubTag_NSString,
    /// Decrypt
    VEKKeyDecrypt           =   1<<13,
    /* The key of decryption. */
    VEKKeyDecryptDecryptionKey_NSString,
    /* The encrypted key of decryption. */
    VEKKeyDecryptEncryptedDecryptionKey_NSString,
#if TT_VIDEO_ENGINE_LOCAL_SERVER
    /// Proxy server
    VEKKeyProxyServer        =  1<<14,
    /// proxy server switch.
    VEKKeyProxyServerEnable_BOOL,
#endif
    
};/// The max value is (1<<20 - 1)

/// VEKGetKey
/// Use these keys, only get info
/// Please use marco VEKKEY(key), example: VEKKEY(VEKGetKeyPlayerVideoWidth_NSInteger)
typedef NS_ENUM(NSInteger, VEKGetKey) {
    /// PLayer
    VEKGetKeyPlayer            =    1<<20,
    /* Video picture width, from video metadata. */
    VEKGetKeyPlayerVideoWidth_NSInteger,
    /* Video picture height, from video metadata. */
    VEKGetKeyPlayerVideoHeight_NSInteger,
    /* Size of Media data, from video metadata. only vod
     Use owner player*/
    VEKGetKeyPlayerMediaSize_LongLong,
    /* metadata of player. valid for own player */
    VEKGetKeyPlayerMetadata_NSDictionary,
    /* bitrate from player */
    VEKGetKeyPlayerBitrate_LongLong,
    
    /// Model
    VEKGetKeyModel             =    1<<21,
    /* Size of video data, from model info. */
    VEKGetKeyModelVideoSize_NSInteger,
    
};/// The min value is (1<<20),and max value is (1 << 31);

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoEngine (Options)

/**
 Get option that you care about.
 Example: get video width.
 NSInteger videoWidth = [[self getOptionBykey:VEKKEY(VEKGetKeyPlayerVideoWidth_NSInteger)] integerValue];
              |                                  |                    |           |
            value                             Gen key               Field      valueType
 @param key Please use VEKKEY(key) to prodect a valid key.
 @return Value correspod the key. The key include value type.
 */
- (id)getOptionBykey:(VEKKeyType)key;

/**
 Set options by VEKKey
 Example:
 [self setOptions:@{VEKKEY(VEKKeyPlayerTestSpeedMode_ENUM),@(TTVideoEngineTestSpeedModeContinue)}];
                      |                   |          |                          |
                Generate key            Field     valueType                   value
 @param options key is one of VEKKeys, value defined id type.
 */
- (void)setOptions:(NSDictionary<VEKKeyType, id> *)options;

/// key is a type of VEKKey or VEKGetKey.
- (void)setOptionForKey:(NSInteger)key value:(id)value;

@end

NS_ASSUME_NONNULL_END
