//
//  TTPlayerDef.h
//  bdm
//
//  Created by lzx on 11/6/16.
//
//

#ifndef TTPlayerDef_h
#define TTPlayerDef_h
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
    KeyIsPlayerLogInfo,
    KeyIsKeepDecodingFreezeSize,
    KeyIsContainerFPS,
    KeyIsVideoCheckInfo,
    KeyIsAudioCheckInfo,
    KeyIsHijackCode,
    KeyIsSeekEndEnable,
    KeyIsGetVideoResolutionFromSPS,
    KeyIsH265CodecType,
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
    KeyIsEnterBufferingDirectly,
    KeyIsDrmDowngrade = 200,
    KeyIsAdvancedBufferringCheckEnabled = 300,
    KeyIsReportRequestHeaders = 400,
    KeyIsReportResponseHeaders,
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
    H265CodecId = 1,
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

typedef NS_ENUM(NSInteger, H265CodecType) {
    H265CodecFFmpeg = 0,
    H265CodecKSY = 1,
    H265CodecJX = 2,
};

static NSString *const kTTPlayerRecordDir = @"ttplayer-record";
static NSString *const kTTPlayerLogDir = @"media-player-log";
static NSString *const kTTPlayerAudioFile = @"audio.pcm";
static NSString *const kTTPlayerVideoFile = @"video.yuv";
static NSString *const kTTPlayerMP4File = @"result.mp4";

#define TTPlayerVideoSizeChangeNotification @"TTPlayerVideoSizeChangeNotification"
#define TTPlayerVideoMetaInfoNotification   @"TTPlayerVideoMetaInfoNotification"
#define TTPlayerPlayspeedDidChangeNotification   @"TTPlayerPlayspeedDidChangeNotification"

#define kTTPlayerMetaInfoKey    @"meta"
#define kTTPlayerVideoSizeWidthKey  @"width"
#define kTTPlayerVideoSizeHeightKey @"height"

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
#endif /* TTPlayerDef_h */
