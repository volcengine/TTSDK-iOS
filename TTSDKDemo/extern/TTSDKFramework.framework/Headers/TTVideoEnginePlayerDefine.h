//
//  TTVideoEnginePublicEnum.h
//  TTVideoEngine
//
//  Created by 黄清 on 2019/7/22.
//

#ifndef TTVideoEnginePublicEnum_h
#define TTVideoEnginePublicEnum_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TTVideoEnginePlayerType) {
    TTVideoEnginePlayerTypeSystem       = 0,
    TTVideoEnginePlayerTypeVanGuard     = 1,
    TTVideoEnginePlayerTypeRearGuard    = 2,
};

typedef NS_ENUM(NSInteger, TTVideoEnginePlaybackState) {
    TTVideoEnginePlaybackStateStopped,
    TTVideoEnginePlaybackStatePlaying,
    TTVideoEnginePlaybackStatePaused,
    TTVideoEnginePlaybackStateError,
};

typedef NS_ENUM(NSUInteger, TTVideoEngineLoadState) {
    TTVideoEngineLoadStateUnknown        = 0,
    TTVideoEngineLoadStatePlayable,
    TTVideoEngineLoadStateStalled,
    TTVideoEngineLoadStateError,
};

typedef NS_ENUM(NSUInteger, TTVideoEngineStallReason) {
    TTVideoEngineStallReasonNone        = 0,
    TTVideoEngineStallReasonNetwork     = 1,
    TTVideoEngineStallReasonDecoder     = 2,
};

typedef NS_ENUM(NSUInteger, TTVideoEngineAVOutsyncType) {
    TTVideoEngineAVOutsyncTypeStart,
    TTVideoEngineAVOutsyncTypeEnd,
};

typedef NS_ENUM(NSUInteger, TTVideoEngineDrmType) {
    TTVideoEngineDrmNone,
    TTVideoEngineDrmIntertrust,
};

typedef NS_ENUM(NSInteger, TTVideoEngineFinishReason) {
    TTVideoEngineFinishReasonUserExited,
    TTVideoEngineFinishReasonRelease,
    TTVideoEngineFinishReasondReleaseAsync,
    TTVideoEngineFinishReasonPlaybackEnded,
    TTVideoEngineFinishReasonPlaybackError,
    TTVideoEngineFinishReasonStatusExcp,
    TTVideoEngineFinishReasonReset,
};

typedef NS_ENUM(NSInteger, TTVideoEngineRotateType) {
    TTVideoEngineRotateTypeNone = 0,
    TTVideoEngineRotateType90   = 1,/// Clockwise 90
    TTVideoEngineRotateType180  = 2,
    TTVideoEngineRotateType270  = 3,
};

typedef NS_ENUM(NSInteger, TTVideoEngineMirrorType) {
    TTVideoEngineMirrorTypeNone = 0,
    TTVideoEngineMirrorTypeVertical = 1,
};

typedef NS_ENUM(NSUInteger, TTVideoEngineTestSpeedMode) {
    TTVideoEngineTestSpeedModeDisable,
    TTVideoEngineTestSpeedModeOnce,
    TTVideoEngineTestSpeedModeContinue,
};

typedef NS_ENUM(NSUInteger, TTVideoEngineImageScaleType) {
    TTVideoEngineImageScaleTypeLinear,
    TTVideoEngineImageScaleTypeLanczos,
    TTVideoEngineImageScaleTypeDefault = TTVideoEngineImageScaleTypeLinear,
};

typedef NS_ENUM(NSUInteger, TTVideoEngineEnhancementType) {
    TTVideoEngineEnhancementTypeNone,
    TTVideoEngineEnhancementTypeContrast,
    TTVideoEngineEnhancementTypeDefault = TTVideoEngineEnhancementTypeNone,
};

typedef NS_ENUM(NSUInteger, TTVideoEngineImageLayoutType) {
    TTVideoEngineLayoutTypeAspectFit,
    TTVideoEngineLayoutTypeToFill,
    TTVideoEngineLayoutTypeAspectFill
};

typedef NS_ENUM(NSInteger, TTVideoEngineScalingMode) {
    TTVideoEngineScalingModeNone,       // No scaling
    TTVideoEngineScalingModeAspectFit,  // Uniform scale until one dimension fits
    TTVideoEngineScalingModeAspectFill, // Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents
    TTVideoEngineScalingModeFill        // Non-uniform scale. Both render dimensions will exactly match the visible bounds
};

typedef NS_ENUM(NSUInteger, TTVideoEngineRenderType) {
    TTVideoEngineRenderTypePlane,
    TTVideoEngineRenderTypePano,
    TTVideoEngineRenderTypeVR,
    TTVideoEngineRenderTypeDefault,
};

typedef NS_ENUM(NSUInteger, TTVideoEngineRenderEngine) {
    TTVideoEngineRenderEngineOpenGLES,
    TTVideoEngineRenderEngineMetal,
    TTVideoEngineRenderEngineOutput,    // render not in player, will output buffer
};

typedef NS_ENUM(NSUInteger, TTVideoEngineAudioDeviceType) {
    TTVideoEngineDeviceAudioUnit,
    TTVideoEngineDeviceAudioGraph,
    TTVideoEngineDeviceDefault = TTVideoEngineDeviceAudioUnit,
    TTVideoEngineDeviceDummyAudio = 10,
};

typedef NS_ENUM(NSUInteger, TTVideoEngineState) {
    TTVideoEngineStateUnknown = 0,
    TTVideoEngineStateFetchingInfo,
    TTVideoEngineStateParsingDNS,
    TTVideoEngineStatePlayerRunning,
    TTVideoEngineStateError,
};

typedef NS_ENUM(NSUInteger, TTVideoEngineNetworkType) {
    TTVideoEngineNetworkTypeWifi,
    TTVideoEngineNetworkTypeNotWifi,
    TTVideoEngineNetworkTypeNone,
};

/**
 TTVideoEnginePlayAPIVersion2:PlayAuthToken
 TTVideoEnginePlayAPIVersion3:STS
 */
typedef NS_ENUM(NSUInteger, TTVideoEnginePlayAPIVersion) {
    TTVideoEnginePlayAPIVersion0 = 0,
    TTVideoEnginePlayAPIVersion1 = 1,
    TTVideoEnginePlayAPIVersion2 = 2,//open api 1.0
    TTVideoEnginePlayAPIVersion3 = 3,//STS
    TTVideoEnginePlayAPIVersion4 = 4,//open api 2.0
};

typedef NS_ENUM(NSUInteger, TTVideoEngineVideoModelVersion) {
    TTVideoEngineVideoModelVersion0 = 0,
    TTVideoEngineVideoModelVersion1 = 1,
    TTVideoEngineVideoModelVersion2 = 2,
    TTVideoEngineVideoModelVersion3 = 3,
    TTVideoEngineVideoModelVersion4 = 4,
};


typedef NS_ENUM(NSInteger, TTVideoEnginePlaySourceType) {
    TTVideoEnginePlaySourceTypeUnknown      = -1,
    TTVideoEnginePlaySourceTypeLocalUrl     = 0,
    TTVideoEnginePlaySourceTypeDirectUrl    = 1,
    TTVideoEnginePlaySourceTypePlayitem     = 2,
    TTVideoEnginePlaySourceTypePreloaditem  = 3,
    TTVideoEnginePlaySourceTypeFeed         = 4,
    TTVideoEnginePlaySourceTypeVid          = 5,
    TTVideoEnginePlaySourceTypeModel        = 6,
};

typedef NS_ENUM(NSInteger, TTVideoEnginePrelaodStrategy) {
    TTVideoEnginePrelaodAllowPreload                = 0, /// Default
    TTVideoEnginePrelaodNotAllowPlayKeyPrelaod      = 1,
    TTVideoEnginePrelaodNotAllowPreload             = 2,
    TTVideoEnginePrelaodNewStrategy                 = 100,
};

typedef NS_ENUM(NSUInteger, TTVideoEngineDataLoaderErrorType) {
    TTVideoEngineDataLoaderErrorNone,
    TTVideoEngineDataLoaderErrorFetchVideoInfo, /// Fetch videoInfo error.
    TTVideoEngineDataLoaderErrorStart,          /// Start local server error.
    TTVideoEngineDataLoaderErrorFetchData,      /// Download data error.
    TTVideoEngineDataLoaderErrorWriteFile,      /// Write file error.
};

typedef NS_ENUM(NSUInteger, TTVideoEngineDecoderOutputType) {
    TTVideoEngineDecoderOutputYUV,
    TTVideoEngineDecoderOutputRGB,
};

typedef NS_OPTIONS(NSInteger, TTVideoEngineLogFlag) {
    TTVideoEngineLogFlagNone           = 0,
    TTVideoEngineLogFlagEngine         = 1 << 0, /// Print engine log
    TTVideoEngineLogFlagPlayer         = 1 << 1, /// Print player log
    TTVideoEngineLogFlagMDL            = 1 << 2, /// Print MDL log
    TTVideoEngineLogFlagAlogEngine     = 1 << 3, /// Write engine log to alog
    TTVideoEngineLogFlagAlogPlayer     = 1 << 4, /// Write player log to alog
    TTVideoEngineLogFlagAlogMDL        = 1 << 5, /// Write MDL log to alog
    TTVideoEngineLogFlagAlogPlayerAll  = 1 << 6,
    
    TTVideoEngineLogFlagDefault        = (TTVideoEngineLogFlagAlogEngine |
                                          TTVideoEngineLogFlagAlogMDL |
                                          TTVideoEngineLogFlagAlogPlayer),/// Default
    TTVideoEngineLogFlagPrint          = (TTVideoEngineLogFlagEngine |
                                          TTVideoEngineLogFlagPlayer |
                                          TTVideoEngineLogFlagMDL), /// Print all log.
    TTVideoEngineLogFlagAlog           = (TTVideoEngineLogFlagAlogEngine |
                                          TTVideoEngineLogFlagAlogPlayer |
                                          TTVideoEngineLogFlagAlogMDL |
                                          TTVideoEngineLogFlagAlogPlayerAll),/// Write all log to alog.
    TTVideoEngineLogFlagAll            = (TTVideoEngineLogFlagEngine |
                                          TTVideoEngineLogFlagPlayer |
                                          TTVideoEngineLogFlagMDL |
                                          TTVideoEngineLogFlagAlogEngine |
                                          TTVideoEngineLogFlagAlogPlayer |
                                          TTVideoEngineLogFlagAlogMDL |
                                          TTVideoEngineLogFlagAlogPlayerAll),
    
};

/**
* 控制 mp4 / dash 是否允许使用 bash 协议 eg:
* 允许 dash 使用 bash: TTVideoEngineDashSegmentFlagFormatFMP4
* 允许 mp4 使用 bash: TTVideoEngineDashSegmentFlagFormatMp4
*/
typedef NS_OPTIONS(NSInteger, TTVideoEngineDashSegmentFlag) {
    TTVideoEngineDashSegmentFlagUnkown = 0,
    TTVideoEngineDashSegmentFlagFormatFMP4 = 1 << 0,
    TTVideoEngineDashSegmentFlagFormatMp4 = 1 << 1,
    
    
    TTVideoEngineDashSegmentFlagFormatAll = (TTVideoEngineDashSegmentFlagFormatMp4 | TTVideoEngineDashSegmentFlagFormatFMP4),
};

typedef NS_ENUM(NSInteger, TTVideoEngineDashABRSwitchMode) {
    TTVideoEngineDashABRSwitchAuto = 0,
    TTVideoEngineDashABRSwitchUser = 1
};

typedef NS_ENUM(NSInteger, TTVideoEngineNormalClockType) {
    TTVideoEngineClockTypeDefault = 1,
    TTVideoEngineClockTypePrevFallback = 2,
    TTVideoEngineClockTypeFFPlay = 3
};

typedef NS_ENUM(NSInteger, TTVideoEngineStallAction) {
    TTVideoEngineStallActionNone        = 0,
    TTVideoEngineStallActionSeek        = 1, /// seek operation
    TTVideoEngineStallActionSwitch      = 2, /// switch resolution
};

typedef NS_ENUM(NSInteger, TTVideoEngineStreamType) {
    TTVideoEngineVideoStream = 0,
    TTVideoEngineAudioStream = 1,
};

typedef NS_ENUM(NSInteger, TTVideoEngineEncodeType) {
    TTVideoEngineH264    =  0,
    TTVideoEngineh265 =  3,
    TTVideoEngineByteVC2 =  4,
};

typedef NS_ENUM(NSInteger, TTVideoEngineCodecStrategy) {
    TTVideoEngineCodecStrategyUnspecified = 0, /// Default value.
    TTVideoEngineCodecStrategyHardwareDecodeFirst = 1, /// Prefer hardware decode.
    TTVideoEngineCodecStrategyLowDataCostFirst = 2, /// Prefer hevc source if support multi encoding, so that can save data flow charge.
};

FOUNDATION_EXPORT NSString *const TTVideoEngineBufferStartAction;
FOUNDATION_EXPORT NSString *const TTVideoEngineBufferStartReason;

#endif /* TTVideoEnginePublicEnum_h */
