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
    VEKKeyPlayer          = 1,
    /* HardwareDecode switch. */
    VEKKeyPlayerHardwareDecode_BOOL             = 2,
    /* Ksyh265Decode switch. */
    VEKKeyPlayerKsyh265Decode_BOOL           = 3,
    /* h265 switch. */
    VEKKeyPlayerh265Enabled_BOOL             = 4,
    /* Whether to support dash. */
    VEKKeyPlayerDashEnabled_BOOL                = 5,
    VEKKeyPlayerSmoothlySwitching_BOOL          = 6,
    /* Loop sswitch. */
    VEKKeyPlayerLooping_BOOL                    = 7,
    /* Async init player switch. */
    VEKKeyPlayerAsyncInit_BOOL                  = 8,
    /* Async prepare player switch. */
    VEKKeyPlayerAsyncPrepare_BOOL               = 9,
    /* Muted switch. */
    VEKKeyPlayerMuted_BOOL                      = 10,
    /* Volume. */
    VEKKeyPlayerVolume_CGFloat                  = 11,
    /* Begin play time.*/
    VEKKeyPlayerStartTime_CGFloat               = 12,
    /* Loop start time. */
    VEKKeyPlayerLoopStartTime_CGFloat           = 13,
    /* Loop end time. */
    VEKKeyPlayerLoopEndTime_CGFloat             = 14,
    /* Play speed. */
    VEKKeyPlayerPlaybackSpeed_CGFloat           = 15,
    /* Embellish volume milliseconds.
     The max value is 1000, default 0 */
    VEKKeyPlayerEmbellishVolumeMilliseconds_NSInteger = 16,
    /* Player network timeout. */
    VEKKeyPlayerOpenTimeOut_NSInteger           = 17,
    /* Smoothly switch delayed seconds. */
    VEKKeyPlayerSmoothDelayedSeconds_NSInteger  = 18,
    /* Test speed model. only vod
     Value type is TTVideoEngineTestSpeedMode. */
    VEKKeyPlayerTestSpeedMode_ENUM              = 19,
    /** Whether to reuse socket */
    VEKKeyPlayerReuseSocket_BOOL                = 20,
    /** Disable accurate start time, used in dash video */
    VEKKeyPlayerDisableAccurateStart_BOOL       = 21,
    /* Audio Device
     Value type is TTVideoEngineAudioDeviceType. */
    VEKKeyPlayerAudioDevice_ENUM                = 22,
    /* Maximum number of seconds to cache local resources */
    VEKKeyPlayerCacheMaxSeconds_NSInteger       = 23,
    /* Buffering  timeout*/
    VEKKeyPlayerBufferingTimeOut_NSInteger      = 24,
    /* Buffering  endtime*/
    VEKKeyPlayerMaxBufferEndTime_NSInteger      = 25,
    /* Loop way: 0,Engine;1,Kernel*/
    VEKKeyPlayerLoopWay_NSInteger               = 26,
    /** Whether to use boe*/
    VEKKeyPlayerBoeEnabled_BOOL                 = 27,
    /* Whether to support bash. */
    VEKKeyPlayerBashEnabled_BOOL                = 28,
    /* Whether to support https. */
    VEKKeyPlayerHttpsEnabled_BOOL               = 29,
    /* Whether to check hijack. */
    VEKKeyPlayerCheckHijack_BOOL                = 30,
    /* Whether enable hijack retry. */
    VEKKeyPlayerHijackRetryEnable_BOOL          = 31,
    /* Whether to seek end. */
    VEKKeyPlayerSeekEndEnabled_BOOL             = 32,
    /* Whether to report request headers. */
    VEKKeyPlayerReportRequestHeaders_BOOL       = 33,
    /* Whether to report response headers. */
    VEKKeyPlayerReportResponseHeaders_BOOL      = 34,
    /* Whether to use cache duration calc buffer percentage*/
    VEKKeyPlayerTimeBarPercentage_BOOL          = 35,
    /* Whether to enable dash abr */
    VEKKeyPlayerEnableDashAbr_BOOL              = 36,
    /* Whether to enable index cache */
    VEKKeyPlayerEnableIndexCache_BOOL           = 37,
    /* Whether to enable frag range */
    VEKKeyPlayerEnableFragRange_BOOL            = 38,
    /* Whether to enable async */
    VEKKeyPlayerEnableAsync_BOOL                = 39,
    /* Range mode */
    VEKKeyPlayerRangeMode_ENUM                  = 40,
    /* Video range size */
    VEKKeyPlayerVideoRangeSize_NSInteger        = 41,
    /* Audio range size */
    VEKKeyPlayerAudioRangeSize_NSInteger        = 42,
    /* Video range time */
    VEKKeyPlayerVideoRangeTime_NSInteger        = 43,
    /* Audio range time */
    VEKKeyPlayerAudioRangeTime_NSInteger        = 44,
    /* skip find stream info */
    VEKKeyPlayerSkipFindStreamInfo_BOOL         = 45,
    /* Whether to enable tt hls drm */
    VEKKeyPlayerTTHLSDrm_BOOL                   = 46,
    /* tt hls drm token */
    VEKKeyPlayerTTHLSDrmToken_NSString          = 47,
    /* idle timer controller by engine */
    VEKKeyPlayerIdleTimerAuto_NSInteger         = 48,
    /* Whether to enter buffering directly to ease playstall */
    VEKKeyEnterBufferingDirectly_BOOL           = 49,
    /* OutputFrames  wait*/
    VEKKeyPlayerOutputFramesWaitNum_NSInteger   = 50,
    /* Audio Buffer Threshold to start play */
    VEKKeyPlayerStartPlayAudioBufferThreshold_NSInteger = 51,
    /* Audio Effect */
    VEKKeyPlayerAudioEffectEnable_BOOL          = 52,
    /* Auidio Effect Parameter for pre gain*/
    VEKKeyPlayerAudioEffectPregain_CGFloat      = 53,
    /* Auidio Effect Parameter for threshold*/
    VEKKeyPlayerAudioEffectThreshold_CGFloat    = 54,
    /* Auidio Effect Parameter for ratio*/
    VEKKeyPlayerAudioEffectRatio_CGFloat        = 55,
    /* Auidio Effect Parameter for pre delay*/
    VEKKeyPlayerAudioEffectPredelay_CGFloat     = 56,
    /* Memory Optimize */
    VEKKeyPlayerMemoryOptimize_BOOL             = 57,
    /* Use Audio Unit Pool*/
    VEKKeyPlayerAudioUnitPoolEnable_BOOL        = 58,
    /* Audio Video start render in sync mode.
     First frame audio rendering waiting for video decode and video render open */
    VEKKeyPlayerAVSyncStartEnable_BOOL          = 59,
    /* Thread wait time ms */
    VEKKeyThreadWaitTimeMS_NSInteger            = 60,
    /* Drop skipped frame to accelerate video decode during seek*/
    VEKKeyCodecDropSkippedFrame_BOOL            = 61,
    /* Auidio Effect Parameter for post gain*/
    VEKKeyPlayerAudioEffectPostgain_CGFloat     = 62,
    /* ABR timer interval */
    VEKKeyPlayerABRTimerIntervalMilliseconds_NSInteger = 63,
    /* add option for disable dummy audio sleep  */
    VEKKeyPlayerDummyAudioSleep_BOOL            = 64,
    /* An Engine uses a serial queue */
    VEKKeyPlayerUseEngineQueue_BOOL             = 65,
    /* Read mode */
    VEKKeyPlayerReadMode_ENUM                   = 66,
    /* Default Buffering  endtime*/
    VEKKeyPlayerDefaultBufferEndTime_NSInteger  = 67,
    /* enable sr */
    VEKKeyPlayerEnableNNSR_BOOL                 = 68,
    /* Read mode */
    VEKKeyPlayerNNSRFPSThreshold_NSInteger      = 69,
    /* Update timestamp mode */
    VEKKeyPlayerUpdateTimestampMode_ENUM        = 70,
    /* Open timeout */
    VEKKeyPlayerEnableOpenTimeout_BOOL          = 71,
    /* Decoder Output Buffer Type*/
    VEKKeyPlayerDecoderOutputBufferType_ENUM    = 72,
    /* Prepare Max Cache Ms*/
    VEKKeyPlayerPrepareMaxCacheMs_NSInteger     = 73,
    /* MDL Cache Mode*/
    VEKKeyPlayerMDLCacheMode_NSInteger          = 74,
    /* Http AutoRange Offset*/
    VEKKeyPlayerHttpAutoRangeOffset_NSInteger   = 75,
    /* move seek in demuxer read */
    VEKKeyPlayerLazySeek_BOOL                   = 76,
    /*abr 4G maxResolution*/
    VEKKeyPlayerABR4GMaxResolution              = 77,
    /**abr switch mode*/
    VEKKeyPlayerDashABRSwitchMode               = 78,
    /* enable range */
    VEKKeyPlayerEnableRange_BOOL                = 79,
    /* Whether to support barrage mask. */
    VEKKeyPlayerBarrageMaskEnabled_BOOL         = 80,
    /**mp4 segment format flag eg: dash format*/
    VEKeyPlayerSegmentFormatFlag                = 81,
    /**enable barrage mask thread*/
    VEKeyPlayerEnableBarrageMaskThread_BOOL     = 82,
    /* Auidio Effect Parameter for ratio*/
    VEKKeyPlayerAudioEffectTargetLoudness_CGFloat = 83,
    /* Auidio Effect Parameter for pre delay*/
    VEKKeyPlayerAudioEffectType_NSInteger         = 84,
    VEKKeyPlayerAudioEffectSrcLoudness_CGFloat    = 85,
    VEKKeyPlayerAudioEffectSrcPeak_CGFloat        = 86,
    VEKKeyPlayerNormalClockType_NSInteger = 87,
    /* All resolution sr */
    VEKKeyPlayerEnableAllResolutionSR_BOOL      = 88,
    /** Skip buffer limit. */
    VEKKeyPlayerSkipBufferLimit_NSInteger       = 89,
    /** Report All  Buffer Update*/
    VEKKeyPlayerReportAllBufferUpdate_BOOL      = 90,
    /** Ignore buffer start before first frame */
    VEKKeyPlayerNotifyBufferBeforeFirstFrame_BOOL = 91,
    /** set use server decoding mode hw or sw*/
    VEKKeyPlayerServerDecodingModePriority_BOOL = 92,
    /** Enable av stack */
    VEKKeyPlayerEnableAVStack_BOOL              = 93,
    /** Terminal AudioUnit Pool */
    VEKKeyPlayerTerminalAudioUnitPool_BOOL      = 94,
    /** Set Audio Output queue by Audio Duration Time*/
    VEKKeyAudioLatencyQueueByTime_BOOL          = 95,
    VEKKeyVideoEndIsAllEof_BOOL                 = 96,
    /** Enable ms buffering*/
    VEKKeyPlayerEnableBufferingMilliSeconds_BOOL = 97,
    /** Default ms buffering time */
    VEKKeyPlayersDefaultBufferingEndMilliSeconds_NSInteger = 98,
    /** Max ms buffering time */
    VEKKeyPlayersMaxBufferEndMilliSeconds_NSInteger = 99,
    /** Whether to support subtitle. */
    VEKKeyPlayerSubEnabled_BOOL                 = 100,
    /** enable sub thread*/
    VEKeyPlayerEnableSubThread_BOOL             = 101,
    VEKKeyDecreaseVtbStaskSize_NSInteger         = 102,
    /**post prepare message*/
    VEKKeyPlayerPostPrepareMsg                  = 103,
    /** Disable short seek */
    VEKKeyDisableShortSeek_BOOL                 = 104,
    /*demuxer prefer nearst sample*/
    VEKKeyPlayerPreferNearestSampleEnable       = 105,
    /*demuxer prefer nearst sample maxpos offset*/
    VEKKeyPlayerPreferNearestMaxPosOffset       = 106,
    VEKKeyPlayerEnable720pSP_BOOL               = 107,
    /* Keep player formater thread alive */
    VEKKEYPlayerKeepFormatAlive_BOOL            = 108,
    /** Find stream info probe size */
    VEKKeyPlayerFindStreamInfoProbeSize_NSInteger     = 109,
    /** Find stream info probe duration */
    VEKKeyPlayerFindStreamInfoProbeDuration_NSInteger = 110,
    /* Codec Type */
    VEKKeyPlayerCodecType_ENUM                  = 111,
    VEKKeyPlayerMaxAccumulatedErrCount_NSInteger = 112,
    VEKKeyPlayerFFCodecerHeaacV2Compat_BOOL = 113,
    /** enable hdr10*/
    VEKKeyPlayerHDR10VideoModelLowBound_NSInteger = 114,
    VEKKeyPlayerHDR10VideoModelHighBound_NSInteger = 115,
    VEKKeyPlayerPreferSpdlForHDR_BOOL             = 116,
    VEKKeyPlayerStopSourceAsync_BOOL             = 117,
    VEKKeyPlayerSeekInterrupt_BOOL               = 118,
    VEKKeyPlayerBackGroundPlay_BOOL              = 119,
    VEKKeyPlayerEnableRefreshByTime_BOOL         = 120,
    VEKKeyPlayerEnableFallbackSWDecode_BOOL      = 121,
    VEKKeyPlayerAudioEffectForbidCompressor_BOOL = 122,
    VEKKeyPlayerUpdateClockWithOffset_BOOL       = 123,
    VEKKeyPlayerChangeVtbSizePicSizeBound_NSInteger = 124,
    VEKKeyPlayerHandleBackgroundInAVView_BOOL    = 125,
    VEKKeyPlayerLazyAudioUnitOp_BOOL             = 126,
    VEKKeyPlayerEnableRangeCacheDuration_BOOL    = 127,
    VEKKeyPlayerEnableVoiceSplitHeaacV2_BOOL     = 128,
    VEKKeyPlayerEnableAudioHardwareDecode_BOOL   = 129,
    VEKKeyPlayerDelayBufferingUpdate_BOOL        = 130,
    VEKKeyPlayerNoBufferingUpdate_BOOL           = 131,
    VEKKeyPlayerKeepVoiceDuration_BOOL           = 132,
    VEKKeyPlayerVoiceBlockDuration_NSInteger     = 133,
    VEKeyPlayerCheckInfo_NSString                = 134,
    VEKKeyPlayerSetSpdlForHDRUrl_BOOL            = 135,
    VEKKeyPlayerEnableSRBound_BOOL               = 136,
    VEKKeyPlayerSRLongDimensionLowerBound_NSInteger = 137,
    VEKKeyPlayerSRLongDimensionUpperBound_NSInteger = 138,
    VEKKeyPlayerSRShortDimensionLowerBound_NSInteger = 139,
    VEKKeyPlayerSRShortDimensionUpperBound_NSInteger = 140,
    VEKKeyPlayerLiveStartIndex_NSInteger             = 141,
    VEKKeyPlayerFilePlayNoBuffering_BOOL             = 142,
    VEKKeyPlayerEnableAVStack_NSInteger              = 143,
    VEKKeyPlayerMaskStopTimeout_NSInteger            = 144,
    VEKKeyPlayerSkipSetSameWindow_BOOL               = 145,
    VEKKeyPlayerCacheVoiceId_BOOL                    = 146,
    VEKKeyVtbFlushKeepSesssion_BOOL                  = 147,
    VEKKeyPlayerSubtitleStopTimeout_NSInteger        = 148,
    VEKKeyCurrentVideoQualityType_NSInteger          = 149,
    VEKKeyPlayerEnableVtbDropRASL_BOOL               = 150,
    VEKKeyPlayerCheckVoiceInBufferingStart_BOOL      = 151,
    VEKKeyPlayerOpenVoiceInPrepare                   = 152,
    VEKKeyPlayerAllAVViewHoldBackground              = 153,
    VEKKeyPlayerEnableNewOutlet_BOOL                 = 154,
    VEKKeyPlayerSubtitleOptEnable_BOOL               = 155,
    VEKKeyPlayerEnableDisplayP3_BOOL                 = 156,
    VEKKeyPlayerEnableVideoTimestampMonotonic_BOOL   = 157,
    VEKKeyPlayerEnableFlushSeek_BOOL                 = 158,
    VEKKeyPlayerEncryptionEnabled_BOOL               = 159,
    /* enable hls playing */
    VEKKeyPlayerHLSEnabled_BOOL                      = 160,
    /* enable vtb drop rasl */
    VEKeyIsEnableVtbDropRASL                         = 161,

    /// View
    VEKKeyView              =   1<<8,
    /* Image scale type.
     Value type isTTVideoEngineImageScaleType */
    VEKKeyViewImageScaleType_ENUM               = 257,
    /* Picture enhancement type. only vod
     Value type is TTVideoEngineEnhancementType */
    VEKKeyViewEnhancementType_ENUM              = 258,
    /* Image layout type.
     Value type is TTVideoEngineImageLayoutType */
    VEKKeyViewImageLayoutType_ENUM              = 259,
    /* Content scale mode.
     Value type is TTVideoEngineScalingMode */
    VEKKeyViewScaleMode_ENUM                    = 260,
    /* Render type.
     Value type is TTVideoEngineRenderType */
    VEKKeyViewRenderType_ENUM                   = 261,
    /* Render engine.
     Value type is TTVideoEngineRenderEngine */
    VEKKeyViewRenderEngine_ENUM                 = 262,
    /* Rotate type.
     Value type is TTVideoEngineRotateType */
    VEKKeyViewRotateType_ENUM                   = 263,
    /* Mirror type.
     Value type is TTVideoEngineMirrorType */
    VEKKeyViewMirrorType_ENUM                   = 264,
    /* switch subtitle language */
    VEKeyPlayerSwitchSubLanguageId_NSInteger    = 265,
    /* language query of subtitle request */
    VEKeyPlayerSubLanguageQuery_NSString        = 266,
    /* switch subtitle id */
    VEKeyPlayerSwitchSubtitleId_NSInteger    = 267,
    
    /// Model
    VEKKeyModel             =   1<<9,
    VEKKeyModelResolutionServerControlEnabled_BOOL = 513,
    /** Cache video info, Defut NO */
    VEKKeyModelCacheVideoInfoEnable_BOOL        = 514,
    /** Support for setting expired VideoModel. */
    VEKKeyModelSupportExpired_BOOL              = 515,
    /** Use fallbackapi to retry after the url expires. */
    VEKKeyModelUseFallbackApi_BOOL              = 516,
    /** NSURLSession use ephemeral config.*/
    VEKKeyModelURLSessionUseEphemeral_BOOL      = 517,
    /** Use fallbackapi to retry after the url expires by MDL */
    VEKKeyModelFallbackApiMDLRetry_BOOL         = 518,
    /// DNS
    VEKKeyDNS               =   1<<10,
    /* Use player DNS resolver switch. */
    VEKKeyDNSIsUsingAVResolver_BOOL             = 1025,
    /** Whether to use dns cache*/
    VEKKeyPlayerDnsCacheEnabled_BOOL            = 1026,
    /* dns expired time*/
    VEKKeyPlayerDnsCacheSecond_NSInteger        = 1027,
    /* hijack retry main dns type */
    VEKKeyPlayerHijackRetryMainDnsType_ENUM     = 1028,
    /* hijack retry backup dns type */
    VEKKeyPlayerHijackRetryBackupDnsType_ENUM   = 1029,
    
    /// Cache
    VEKKeyCache             =   1<<11,
    /* Cache playing data switch.
     Can save network traffic if loop */
    VEKKeyCacheCacheEnable_BOOL                 = (1<<11) + 1,
    /* User extern directory switch. */
    VEKKeyCacheUseExternDirEnable_BOOL          = (1<<11) + 2,
    /* The directory of cache data.
     Play video use vid, and need cache video data when play finished
     Set cache data directory. */
    VEKKeyCacheExternCacheDir_NSString          = (1<<11) + 3,
    /* Limit a media resource cache size when using dataloader.*/
    VEKKeyCacheLimitSingleMediaCacheSize_NSInteger = (1<<11) + 4,
    VEKKeyPreloadUpperBufferMS_NSInteger           = (1<<11) + 5,
    VEKKeyPreloadLowerBufferMS_NSInteger           = (1<<11) + 6,
    
    /// Log
    VEKKeyLog               = 1<<12,
    /* Log tag. */
    VEKKeyLogTag_NSString                       = (1<<12) + 1,
    /* Log SubTag. */
    VEKKeyLogSubTag_NSString                    = (1<<12) + 2,
    /* Performance log switch. */
    VEKKeyLogPerformanceSwitch_BOOL             = (1<<12) + 3,
    /* custom str log. */
    VEKKeyLogCustomStr_NSString                 = (1<<12) + 4,
    /// Decrypt
    VEKKeyDecrypt           = 1<<13,
    /* The key of decryption. */
    VEKKeyDecryptDecryptionKey_NSString         = (1<<13) + 1,
    /* The encrypted key of decryption. */
    VEKKeyDecryptEncryptedDecryptionKey_NSString = (1<<13) + 2,
    /// Key of medialoader
    VEKKeyMedialoader        =  1<<14,
    /// enable medialoader switch.
    VEKKeyMedialoaderEnable_BOOL                = (1<<14) + 1,
    /// native mode of medialoader switch
    VEKKeyMedialoaderNativeEnable_BOOL          = (1<<14) + 2,
    /// Proxy server
    VEKKeyProxyServer = VEKKeyMedialoader,
    /// proxy server switch.
    VEKKeyProxyServerEnable_BOOL = VEKKeyMedialoaderEnable_BOOL,

    /// Drm
    /* Drm type */
    VEKKeyDrmType_ENUM       =  1<<15,
    /* Drm downgrade */
    VEKKeyDrmDowngrade_NSInteger                = (1<<15) + 1,
    /* Drm retry */
    VEKKeyDrmRetry_BOOL                         = (1<<15) + 2,
    /* Drm token url template */
    VEKKeyDrmTokenUrlTemplate_NSString          = (1<<15) + 3,
};/// The max value is (1<<20 - 1)

/// VEKGetKey
/// Use these keys, only get info
/// Please use marco VEKKEY(key), example: VEKKEY(VEKGetKeyPlayerVideoWidth_NSInteger)
typedef NS_ENUM(NSInteger, VEKGetKey) {
    /// PLayer
    VEKGetKeyPlayer          =    1<<20,
    /* Video picture width, from video metadata. */
    VEKGetKeyPlayerVideoWidth_NSInteger         = (1<<20) + 1,
    /* Video picture height, from video metadata. */
    VEKGetKeyPlayerVideoHeight_NSInteger        = (1<<20) + 2,
    /* Size of Media data, from video metadata. only vod
     Use owner player*/
    VEKGetKeyPlayerMediaSize_LongLong           = (1<<20) + 3,
    /* metadata of player. valid for own player */
    VEKGetKeyPlayerMetadata_NSDictionary        = (1<<20) + 4,
    /* bitrate from player */
    VEKGetKeyPlayerBitrate_LongLong             = (1<<20) + 5,
    /* Rendering frame rate */
    VEKGetKeyPlayerVideoOutputFPS_CGFloat       = (1<<20) + 6,
    /* Video coded frame rate */
    VEKGetKeyPlayerContainerFPS_CGFloat         = (1<<20) + 7,
    /* Bytes read by the player */
    VEKGetKeyPlayerPlayBytes_int64_t            = (1<<20) + 8,
    /* Timstamp of the first frame. */
    VEKGetKeyFirstFrameTimestamp_NSDictionary   = (1<<20) + 9,
    /* Video current pts in milliseconds */
    VEKGetKeyPlayerVideoCurrentTime_NSInteger   = (1<<20) + 10,
    /* Video sr width */
    VEKGetKeyPlayerVideoSRWidth_NSInteger        = (1<<20) + 11,
    /* Video sr height */
    VEKGetKeyPlayerVideoSRHeight_NSInteger       = (1<<20) + 12,
    /* Get file format */
    VEKGetKeyFileFormat_NSString                 = (1<<20) + 13,
    /* Get Audio Codec Id */
    VEKGetKeyPlayerAudioCodecId_NSInteger        = (1<<20) + 14,
    /* Get Video Codec Id */
    VEKGetKeyPlayerVideoCodecId_NSInteger        = (1<<20) + 15,
    /* Get Audio Codec Profile */
    VEKGetKeyPlayerAudioCodecProfile_NSInteger   = (1<<20) + 16,
    /* Get Video Codec Profile */
    VEKGetKeyPlayerVideoCodecProfile_NSInteger   = (1<<20) + 17,
    /* Get whether audio effect is enabled  */
    VEKGetKeyPlayerAudioEffectOpened_BOOL       = (1<<20) + 18,

    /// Model
    VEKGetKeyModel             =    1<<21,
    /* Size of video data, from model info. */
    VEKGetKeyModelVideoSize_NSInteger           = (1<<21) + 1,
    /// Metrics
    VEKGetKeyMetrics           =    1<<22,
    /// First frame metrics.
    VEKGetKeyMetricsFirstFrame_NSDictionary     = (1<<22) + 1,
    /// Error
    VEKGetKeyError             =    1<<23,
    /// Player error info.
    VEKGetKeyErrorPlayerInfo_NSString           = (1<<23) + 1,
};/// The min value is (1<<20),and max value is (1 << 31);

/// @interface  option check end
/// TTVideoEngine Key about global static settings
typedef NS_ENUM(NSInteger, VEKGSKey) {
    VEGSKeyUseBaseThread_BOOL             = 0,
    VEGSKeyUseThreadPool_BOOL             = 1,
    VEGSKeyThreadPoolSize_INT             = 2,
};

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

+ (void)setGlobalForKey:(VEKGSKey)key value:(id)value;

@end


NS_ASSUME_NONNULL_END
