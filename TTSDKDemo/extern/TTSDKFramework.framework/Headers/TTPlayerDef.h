//
//  TTPlayerDef.h
//  bdm
//
//  Created by lzx on 11/6/16.
//
//

#ifndef TTM_DUAL_CORE_TTPLAYER_DEF_H
#define TTM_DUAL_CORE_TTPLAYER_DEF_H

typedef NS_ENUM(NSInteger ,ValuesForKey) {
    KeyIsDuration,
    KeyIsCurrentPosition,
    KeyIsVideoWidth,
    KeyIsVideoHeight,
    KeyIsLooping,
    KeyIsPlaying,
    KeyIsHttpReconnect,
    KeyIsHttpReconnectDelayMax,
    KeyIsHttpTimeOut,
    KeyIsPanoControlModel,
    KeyIsVideoType,
    KeyIsVolumeMute,
    KeyIsSyncMaster,
    KeyIsSaveFileModeType,
    KeyIsCacheFileMode,
    KeyIsHLSCLoadPerPercent,
    KeyIsMediaFileKey,
    KeyIsDecryptionKey,
    KeyIsHurryTime,
    KeyIsPlayType,
    KeyIsSettingCacheMaxSeconds,
    KeyIsDownloadBytes,
    KeyIsPlayBytes,
    KeyIsMediaFileSize,
    KeyIsPlayerDownloadSpeed,
    KeyIsUrlAddress,
    KeyIsImageEnhancementType,
    KeyIsVideoHardwareDecoderState,
    KeyIsImageScaleType,
    KeyIsImageLayout,
    KeyIsSmoothDelayedSec,
    KeyIsIgnorAudioInterruption,
    KeyIsMediaComment,
    KeyIsStartTime,
    KeyIsDecodeSEIInfo,
    KeyIsRenderType,
    KeyIsRenderDevice,
    KeyIsUsedKsyCodec,
    KeyIsPlaySpeed,
    KeyIsSaveHostTime,
    KeyIsTranConnectTime,
    KeyIsTranFirstPacketTime,
    KeyIsReceiveFirstVideoFrameTime,
    KeyIsReceiveFirstAudioFrameTime,
    KeyIsDecodeFirstVideoFrameTime,
    KeyIsDecodeFirstAudioFrameTime,
    KeyIsVideoBufferLength,
    KeyIsAudioBufferLength,
    KeyIsBufferingTimeOut,
    KeyIsPlaySpiltStream,
    KeyIsTestSpeed,
    KeyIsDefaultVideoBitrate,
    KeyIsDefaultAudioBitrate,
    KeyIsDisableAccurateStartTime,
    KeyIsExtraInfoCallBack,
    KeyIsMaxBufferEndTime,
    KeyIsFastOpenLiveStream,
    KeyIsEmbellishVolumeTime,
    KeyIsLoopStartTime,
    KeyIsLoopEndTime,
    KeyIsReuseSocket,
    KeyIsEnableDashABR,
    KeyIsAudioCodecId,
    KeyIsVideoCodecId,
    KeyIsMetaDataInfo,
    KeyIsVideoOutFPS,
    KeyIsCacheFileDir,
    KeyIsVideoId,
    KeyIsDrmType,
    KeyIsTokenUrlTemplate,
    KeyIsVideoBufferMilliSeconds,
    KeyIsAudioBufferMilliSeconds,
    KeyIsVTBOutputRGB,
    KeyIsAudioDevice,
    KeyIsABRProbeCount,
    KeyIsABRSwitchCount,
    KeyIsABRAverageBitrate,
    KeyIsABRAveragePlaySpeed,
    KeyIsABRHurryThreshold,
    KeyIsABRLowThreshold,
    KeyIsABRHighThreshold,
    KeyIsVideoCodecName,
    KeyIsAudioCodecName,
    KeyIsVideoCodecModName,
    KeyIsAudioCodecModName,
    KeyIsVideoBitrate,
    KeyIsMediaBitrate,
    KeyIsLiveStreamMaxCacheSeconds,
    KeyIsFileUrl,
    KeyIsLogInfoCallBack,
    KeyIsHurryType,
    KeyIsCatchupSpeed,
    KeyIsSlowPlayTime,
    KeyIsSlowPlaySpeed,
    KeyIsIgnoreVideoBufferring,
    KeyIsVideoDeviceOpenTime,
    KeyIsVideoDeviceOpenedTime,
    KeyIsAudioDeviceOpenTime,
    KeyIsAudioDeviceOpenedTime,
    KeyIsFirstFrameRenderedTime,
    KeyIsPlayerLogInfo,
    KeyIsKeepDecodingFreezeSize,
    KeyIsContainerFPS,
    KeyIsVideoCheckInfo,
    KeyIsAudioCheckInfo,
    KeyIsHijackCode,
    KeyIsSeekEndEnable,
    KeyIsGetVideoResolutionFromSPS,
    KeyIsByteVC1CodecType,              // deprecated
    KeyIsOutputFramesWaitNum,
    KeyIsFpsProbeSize,
    KeyIsEnableAudioEffect,
    KeyIsAudioEffectPregain,
    KeyIsAudioEffectThreshold,
    KeyIsAudioEffectRatio,
    KeyIsAudioEffectPredelay,
    KeyIsEnableAdaptedWatermark,
    KeyIsStartPlayAudioBufferThreshold,
    KeyIsBufferingEndIgnoreVideo,
    KeyIsVideoDecoderType,
    KeyIsAudioProcessWrapperPTR,
    KeyIsMirrorType,
    KeyIsHijackExit,
    KeyIsTimeBarPercentage,
    KeyIsEnterBufferingDirectly,
    KeyIsEnableIndexCache,
    KeyIsEnableFragRange,
    KeyIsVideoRangeSize,
    KeyIsAudioRangeSize,
    KeyIsSkipFindStreamInfo,
    KeyIsTTHlsDrmToken,
    KeyIsTTHlsDrm,
    KeyIsThreadWaitTimeMS,
    KeyIsAudioEffectPostgain,
    KeyIsVideoClcokDiffAve,
    KeyIsVideoClcokDiffMax,
    KeyIsVideoDecoderOutputFps,
    KeyIsAudioDeviceType,
    KeyIsAudioUnitPoolReachMax,
    KeyIsAVStartSync,
    KeyIsUseAudioPool,
    KeyIsCodecDropSikppedFrame,
    KeyIsEnableAsync,
    KeyIsRangeMode,
    KeyIsVideoRangeTime,
    KeyIsAudioRangeTime,
    KeyIsMediaFormatType,
    KeyIsRadioMode,
    KeyIsVideoSaveHostTime,
    KeyIsVideoTranConnectTime,
    KeyIsVideoTranFirstPacketTime,
    KeyIsAudioSaveHostTime,
    KeyIsAudioTranConnectTime,
    KeyIsAudioTranFirstPacketTime,
    KeyIsVideoSwitchCacheTime,
    KeyIsAudioSwitchCacheTime,
    KeyIsDummyAudioSleep,
    KeyIsReadMode,
    KeyIsVideoCurrentTime,
    KeyIsDefaultBufferEndTime,
    KeyIsMaxFps,
    KeyIsHandleAudioExtradata,
    KeyIsUpdateTimestampMode,
    KeyIsEnableOpenTimeout,
    KeyIsPrepareMaxCacheMs,
    KeyIsMDLCacheMode,
    KeyIsHttpAutoRangeOffset,
    KeyIsEnableVideoSR,
    KeyIsEnableVideoSRFPSThreshold,
    KeyIsVideoSRWidth,
    KeyIsVideoSRHeight,
    KeyIsVideoSRType,
    KeyIsSeekLazyInRead,
    KeyIsEnableRange,
    KeyIsAudioCodecProfile,
    KeyIsVideoCodecProfile,
    KeyIsNormalClockType,
    KeyIsEnableAllResolutionVideoSR,
    KeyIsVideoProcesser,
    KeyIsSkipBufferLimit,
    KeyIsLiveStartIndex,
    KeyIsEnableRefreshByTime,
    KeyIsEnableAVStack,
    KeyIsTerminalAudioUnitPool,
    KeyIsDynAudioLatencyByTime,
    KeyIsSettingVideoEndIsAllEof,
    KeyIsLoopCount,
    KeyIsEnableBufferingMilliSeconds,
    KeyIsDefaultBufferingEndMilliSeconds,
    KeyIsMaxBufferEndMilliSeconds,
    KeyIsDecreaseVtbStackSize,
    KeyIsEnableLoadControlBufferingTimeout,
    KeyIsPostPrepare,
    KeyIsDisableShortSeek,
    KeyIsVideoWrapperPTR,
    KeyIsPreferNearestSample,
    KeyIsPreferNearestMaxPosOffset,
    KeyIsQueueMaxFulled,
    KeyIsFindStreamInfoProbeSize,
    KeyIsFindStreamInfoProbeDuration,
    //notice that KeyIsFindStreamInfoProbeDuration is 199

    KeyIsDrmDowngrade = 200,
    KeyIsEnableFallbackSwDec,

    KeyIsHurryMillisecond,
    KeyIsSlowPlayMillisecond,
    
    KeyIsAVPtsDiffList,
    KeyIsVideoOutletDropCountOnce,
    KeyIsVideoDecoderOutputFpsList,
    KeyIsFrameDropCount,
    KeyIsColorTrc,
    KeyIsPixelFormat,
    
    KeyIsIosNewOutlet = 220,  //only for ios

    //ABR相关 250~299
    KeyIsABRPredictVideoBitrate = 250,
    KeyIsABRDownloadVideoBitrate,
    KeyIsABRAverageBitrateDiff,
    
    KeyIsAdvancedBufferringCheckEnabled = 300,
    KeyIsWaitedTimeAfterFirstFrame,
    KeyIsJXCodecErrorProtection,
    KeyIsEnableTcpFastOpen,
    KeyIsLastVideoRenderTime,
    KeyIsLastAudioRenderTime,
    KeyIsAudioRenderStallThreshold,
    KeyIsVideoRenderStallThreshold,
    KeyIsEnableRenderStall,
    KeyIsVideoCropInfo,
    KeyIsPacketDidReceiveCallback,
    KeyIsFrameDroppingTerminatedDTS,
    KeyIsFrameWillRenderCallback,
    KeyIsFrameDroppingDTSMaxDiff,
    KeyIsEnableCacheSei,
    KeyIsVideoDeviceWaitStartTime,
    KeyIsVideoDeviceWaitEndTime,
    KeyIsCheckSilenceInterval,
    KeyIsStreamFormat,
    KeyIsEnableFLVABR,
    KeyIsStartRenderIgnoreWindowSize,
    KeyIsVideoFrameWillProcessCallback,
    KeyIsPTSSyncedSEINotificationEnabled,
    KeyIsVideoAreaFramePattern,
    KeyIsVideoCropAreaFramePattern,
    KeyIsEnableStallCounter,
    KeyIsStallCounterInfoJson,
    KeyIsShouldSkipNextSRProcess,
    KeyIsPacketDidReceiveWithPacketInfoCallback,
    KeyIsOpenFailToTry,
    KeyIsEnableDecodeMultiSei,
    KeyIsEnableNotifySeiImmediatelyBeforeFirstFrame,
    KeyIsUseAudioGraphPool,
    KeyIsEnableDecodeSeiOnce,
    KeyIsEnableCmafFastMode,
    KeyIsEnableVideoMpdRefresh,
    KeyIsEnableSkipNullTag,     //336
    KeyIsEnableGetTimeOptimize, //337
    KeyIsDroppingDTSRollbackFrameEnabled,
    KeyIsIgnoreBackgroundRenderStallEnabled,
    KeyIsEnableFlushSeek,

    KeyIsGetProtocolType = 350,
    KeyIsQuicConfigCached,
    KeyIsQuicCHLOCount,
    
    KeyIsFormaterCreateTime,
    KeyIsDemuxerBeginTime,
    KeyIsDNSStartTime,
    KeyIsAudioDNSStartTime,
    KeyIsAVFormatOpenTime,
    KeyIsDemuxerCreateTime,
    KeyIsDecCreateTime,
    KeyIsOutletCreateTime,
    KeyIsAudioRendFirstFrameTime,
    KeyIsVideoDecoderStartTime,
    KeyIsVideoDecoderOpenedTime,
    KeyIsAudioDecoderStartTime,
    KeyIsAudioDecoderOpenedTime,
    KeyIsVideoTrackEnable,
    KeyIsAudioTrackEnable,
    KeyIsMoovPosition,
    KeyIsMdatPosition,
    KeyIsMaxAVPosGap,
    KeyIsVideoDecoderBufferLen,
    KeyIsAudioDecoderBufferLen,
    KeyIsVideoBasePlayerBufferLen,
    KeyIsAudioBasePlayerBufferLen,
    KeyIsBufsWhenBufferStart,
    KeyIsQuicSCFGAddress,
    KeyIsQuicCertVerify,
    KeyIsQuicOpenResult,//notice that KeyIsQuicOpenResult is 378
    KeyIsFileFormat,
    KeyIsQuicInitMTU,
    KeyIsQuicMtuDiscovery,
    KeyIsQuicInitRtt,                           // 382
    KeyIsQuicMaxCryptoRetransmissions,
    KeyIsQuicMaxCryptoRetransmissionTimeMs,
    KeyIsQuicMaxRetransmissions,
    KeyIsQuicMaxRetransmissionTimeMs,
    KeyIsQuicMaxAckDelay,
    KeyIsQuicMinReceivedBeforeAckDecimation,
    KeyIsQuicPadHello, // 389
    KeyIsQuicFixWillingAndAbleToWrite,
    KeyIsQuicFixProcessTimer,
    KeyIsQuicReadBlockTimeout,
    KeyIsQuicReadBlockMode,         //393
    KeyIsQuicEnableUnreliable,      //394
    KeyIsForceDecodeSwitch,         //395
    KeyIsForceDecodeMsGaps,         //396
    KeyIsForceRenderMsGaps,         //397
    KeyIsQuicFixStreamFinAndRst,    //398
    KeyIsQuicVersion,               //399
    
    KeyIsReportRequestHeaders = 400,
    KeyIsReportResponseHeaders,

    KeyIsMediaLoaderRegisterNativeHandle = 450,
    keyIsMediaLoaderNativeHandleStatus,
    
    KeyIsSinglePlayDownloadBytes = 470,
    
    //mask sub
    KeyIsBarrageMaskUrl = 500,
    KeyIsBarrageMaskEnable,
    KeyIsSubPathInfo,
    KeyIsSubEnable,
    KeyIsSwitchSubId,
    KeyIsSubFirstLoadTime,
    KeyIsMaskStreamOpenTime,
    KeyIsMaskStreamOpenedTime,
    KeyIsOptSubFirstLoadTime,

    
    //license
    KeyIsModuleName = 510,

    // rts
    KeyIsEnableRtcPlay = 550,
    KeyIsRtcPlayEngineIns,
    KeyIsRtcPlayEngineConfig,
    KeyIsRtcInitedTime,
    KeyIsRtcOfferSendTime,
    KeyIsRtcAnswerRecvTime,
    KeyIsRtcStartTime,
    KeyIsRtcStatInfo,
    KeyIsRtcSessionId,
    KeyIsRtcFallbackThreshold,
    KeyIsRtcEnableHardwareDecode,
    KeyIsRtcMinJitterBufferInMS,
    KeyIsRtcMaxJitterBufferInMS,
    KeyIsRtcEnableEarlyInitRender,
    KeyIsRtcUninitLockFree,
    KeyIsRtcExpectServerIP,
    KeyIsRtcTracePrint = 566,

    // avph
    KeyIsAVPHVideoProbeSize = 600,
    KeyIsAVPHVideoMaxDuration,
    KeyIsAVPHAudioProbeSize,
    KeyIsAVPHAudioMaxDuration,
    KeyIsAVPHOpenVideoFirst,
    KeyIsAVPHMaxAVDiff,
    KeyIsAVPHEnableAutoReopen,
    KeyIsAVPHAutoExit,
    KeyIsAVPHVideoDiffThreshold,
    KeyIsAVPHReadRetryCount,
    KeyIsAVPHReadErrorExit,
    KeyIsAVPHStreamInfo,

    KeyIsEnableSkipFindUnnecessaryStream = 620,
    KeyIsEnableAVPHDnsParse              = 621,
    KeyIsAVPHDnsParseTimeout             = 622,

    //audio climiter
    KeyIsAudioEffectType           = 643,
    KeyIsAESrcLufs                 = 644,
    KeyIsAETarLufs                 = 645,
    KeyIsAESrcPeak                 = 646,

    //quic options
    KeyISQuicTimerVersion          = 700,
    KeyIsQuicConfigOptimize        = 701,
    KeyIsQuicInitSessionWindow     = 702,
    KeyIsQuicInitStreamWindow      = 703,

    KeyIsKeepFormatThreadAlive     = 800,
    KeyIsEnable720PSR              = 801,
    KeyIsStopSourceAsync           = 802,
    KeyIsEnablePrimingWorkAround   = 803,
    KeyIsEnableHDR10               = 804,
    KeyIsPreferSpdlForHDR          = 805,
    KeyIsEnableSeekInterrupt       = 806,
    KeyIsUpdateClockWithOffset     = 807,
    KeyIsChangeVtbSizePicSizeBound = 808,
    KeyIsAudioEffectEnabled        = 809,
    KeyIsEnableLazyVoiceOp         = 810,
    KeyIsHandleBackgroundInAvView  = 811,
    KeyIsVoiceSplitHeaacV2         = 812,
    KeyIsAudioHardwareDecode       = 813,
    KeyIsVoiceBlockDuration        = 814,
    KeyIsKeepVoiceDuration         = 815,
    KeyIsSkipSetSameWindow         = 816,
    KeyIsCacheVoiceId              = 817,
    KeyIsVtbFlushKeepSesssion      = 818,
    KeyIsMaskStopTimeout           = 819,
    KeyIsEnableVtbDropRASL         = 820,
    KeyIsSubtitleStopTimeout       = 821,
    KeyIsCheckVoiceInBufferingStart= 822,
    KeyIsOpenVoiceDuringPrepare    = 823,
    KeyIsAllAVViewHoldBackground   = 824,

    KeyIsEnableDemuxerStall        = 850,
    KeyIsEnableDecoderStall        = 851,
    KeyIsDemuxerStallThreshold     = 852,
    KeyIsDecoderStallThreshold     = 853,

    KeyIsEnableVideoProcessorMultiMode = 900,
    KeyIsVideoProcessorStartMode   = 901,
    KeyIsEnableRangeCacheDuration  = 902,
    KeyIsDelayBufferingUpdate      = 903,
    KeyIsNoBufferingUpdate         = 904,
    KeyIsEnableSRBound             = 905,
    KeyIsSRLongDimensionLowerBound = 906,
    KeyIsSRLongDimensionUpperBound = 907,
    KeyIsSRShortDimensionLowerBound = 908,
    KeyIsSRShortDimensionUpperBound = 909,
    KeyIsFilePlayNoBuffering       = 910,
    KeyIsEnableDisplayP3           = 911,
    KeyIsEnableVideoTimestampMonotonic = 912,
    
    // cmaf
    KeyIsCmafMpdDnsAnalysisEnd          = 950,
    KeyIsCmafMpdConnectTime             = 951,
    KeyIsCmafMpdHttpReqFinishTime       = 952,
    KeyIsCmafMpdTcpFirstPackageEnd      = 953,
    KeyIsCmafMpdHttpResFinishTime       = 954,
    KeyIsCmafMpdTcpConnectTime          = 955,
    KeyIsCmafAudioDnsAnalysisEnd        = 956,
    KeyIsCmafAudioTcpConnectTime        = 957,
    KeyIsCmafAudioHttpReqFinishTime     = 958,
    KeyIsCmafAudioTcpFirstPacketTime    = 959,
    KeyIsCmafAudioHttpResFinishTime     = 960,
    KeyIsCmafAudioFirstsegConnectTime   = 961,
    KeyIsCmafVideoHttpReqFinishTime     = 962,
    KeyIsCmafVideoHttpResFinishTime     = 963,
    KeyIsCmafVideoFirstsegConnectTime   = 964,
    
    // llash
    KeyIsLLASHFastOpenEnabled                   = 1000,
    KeyIsLLASHCheckEnhance                      = 1001,
    KeyIsLLASHCheckInterval                     = 1002,
    KeyIsLLASHMethod                            = 1003,
    KeyIsLLASHNonKeyFrameSwitchBufferThreshold  = 1004,
    KeyIsLLASHSwitchCost                        = 1005,
};

// Global static
typedef NS_ENUM(NSInteger, Key4GlobalValue) {
    GSKeyUseBaseThread_BOOL             = 0,
    GSKeyUseThreadPool_BOOL             = 1,
    GSKeyThreadPoolSize_INT             = 2,
};

typedef NS_ENUM(NSInteger, ImageEnhancementType) {
    DefaultEnhancement  = 0,
    ContrastEnhancement = 1,
};
typedef NS_ENUM(NSInteger, ImageScaleType) {
    LinearScale     = 0,
    LanczosScale    = 1,
};

typedef NS_ENUM(NSInteger, ImageLayoutType) {
    ImageScaleAspectFit = 0,
    ImageScaleToFill    = 1,
    ImageScaleAspectFill = 2,
};

typedef NS_ENUM(NSInteger, VideoRenderType) {
    VideoRenderTypePlane = 0,
    VideoRenderTypePano = 1,
    VideoRenderTypeVR = 2,
    VideoRenderTypeNone = 3,
};

typedef NS_ENUM(NSInteger, VideoRenderDevice) {
    VideoRenderDeviceOpengl = 0,
    VideoRenderDeviceNativeWindow = 1,//android type
    VideoRenderDeviceCoreGraphic = 2,
    VideoRenderDeviceMetal = 3,
};

typedef NS_ENUM(NSInteger, AVCodecId) {
    H264CodecId = 0,
    BYTEVC1CodecId = 1,
    AACCodecId  = 2,
    MP3CodecId  = 3,
    PCMS16LECodecId = 4,
};

typedef NS_ENUM(NSInteger, HurryType) {
    NoHurryType = -1,
    IsCatchTime = 0,
    IsSkipTime  = 1,
};

typedef NS_ENUM(NSInteger, TTMediaStreamType) {
    TTMediaStreamTypeVideo = 0,
    TTMediaStreamTypeAudio,
};

typedef NS_ENUM(NSInteger, FastOpenLiveStream) {
    FastOpenLiveStreamDisable = 0,
    FastOpenLiveStreamEnable,
};

typedef NS_ENUM(NSInteger, AudioRenderDevice) {
    AudioRenderDeviceAudioUnit = 0,
    AudioRenderDeviceAudioGraph = 1,
    AudioRenderDeviceAudioQueue = 2,
    AudioRenderDeviceOpenAL = 3,
    AudioRenderDevcieDefault = AudioRenderDeviceAudioUnit,
    AudioRenderDeviceNone = 10,
};

typedef NS_ENUM(NSInteger, CodecType) {
    ByteVC1CodecFFmpeg = 0,
    ByteVC1CodecKSY = 1,
    ByteVC1CodecJX = 2,
};


typedef NS_ENUM(NSInteger, PlayerLogLevel) {
    PlayerLogVerbose = 0,
    PlayerLogDebug = 1,
    PlayerLogInfo = 2,
    PlayerLogTrack = 3,
    PlayerLogKill = 4,
    PlayerLogPtr = 5,
    PlayerLogWarn= 6,
    PlayerLogError = 7,
};

static NSString *const kTTPlayerRecordDir = @"ttplayer-record";
static NSString *const kTTPlayerLogDir = @"media-player-log";
static NSString *const kTTPlayerAudioFile = @"audio.pcm";
static NSString *const kTTPlayerVideoFile = @"video.yuv";
static NSString *const kTTPlayerMP4File = @"result.mp4";

#define TTPlayerVideoSizeChangeNotification @"TTPlayerVideoSizeChangeNotification"
#define TTPlayerVideoMetaInfoNotification   @"TTPlayerVideoMetaInfoNotification"
#define TTPlayerRtcTraceInfoDidReceiveNotification   @"TTPlayerRtcTraceInfoDidReceiveNotification"
#define TTPlayerRtcEventDidReceiveNotification   @"TTPlayerRtcEventDidReceiveNotification"
#define TTPlayerDidReceiveVideoCodecParameterSet @"TTPlayerDidReceiveVideoCodecParameterSet"
#define TTPlayerResponseHeadersDidGetNotification @"TTPlayerResponseHeadersDidGetNotification"
#define TTPlayerPlayspeedDidChangeNotification   @"TTPlayerPlayspeedDidChangeNotification"
#define TTPlayerVideoBitrateChangedNotification @"TTPlayerVideoBitrateChangedNotification"
#define TTPlayerAudioRenderStartNotification @"TTPlayerAudioRenderStartNotification"
#define TTPlayerRenderStallNotification @"TTPlayerRenderStallNotification"
#define TTPlayerDemuxStallNotification @"TTPlayerDemuxStallNotification"
#define TTPlayerDecodeStallNotification @"TTPlayerDecodeStallNotification"
#define TTPlayerAudioSilenceDetected @"TTPlayerAudioSilenceDetected"
#define TTPlayerDeviceOpenedNotification @"TTPlayerDeviceOpenedNotification"
#define TTPlayerPreBufferingNotification @"TTPlayerPreBufferingNotification"
#define TTPlayerOutleterPausedNotification @"TTPlayerOutleterPausedNotification"
#define TTPlayerBarrageMaskInfoNotification @"TTPlayerBarrageMaskInfoNotification"
#define TTPlayerAVOutsyncStartNotification @"TTPlayerAVOutsyncStartNotification"
#define TTPlayerAVOutsyncEndNotification @"TTPlayerAVOutsyncEndNotification"

#define kTTPlayerMetaInfoKey    @"meta"
#define kTTPlayerInfoDataKey    @"info"
#define kTTPlayerRtcTraceInfoKey    @"trace"
#define kTTPlayerRtcEventKey        @"rtc_event"
#define kTTPlayerVideoSizeWidthKey  @"width"
#define kTTPlayerVideoSizeHeightKey @"height"
#define kTTPlayerBitrateKey @"bitrate"
#define kTTPlayerStreamTypeKey @"stream_type"
#define kTTPlayerPacketInfoContainsKeyframeKey    @"contains_keyframe"
#define kTTPlayerVideoCodecParameterSetKey    @"parameter_set"
#define kTTPlayerPreBufferingChangeTypeKey   @"buffer_change_type"
#define kTTPlayerBarrageMaskInfoErrorCodeKey   @"barrage_mask_info_error_code"
#define kTTPlayerTimestamp    @"timestamp"

#define kReplaceFileMode  0
#define kOpenFileMode     1
#define kDirMode          2

#define kNotSaveFile 0
#define kSaveFile    1

#define kNotCacheFile 0
#define kCacheFile   1

#define kIsHttpLoader     0
#define kIsNHttpLoader    1
#define kIsCacheLoader    4

#define kDisableVideoHardwareDecoder    0
#define kEnableVideoHardwareDecoder     1

#endif /* TTM_DUAL_CORE_TTPLAYER_DEF_H */
