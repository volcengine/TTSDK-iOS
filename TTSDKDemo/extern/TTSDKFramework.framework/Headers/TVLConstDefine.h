//
//  TVLConstDefine.h
//  Pods
//
//  Created by zhongshaofen on 2017/7/19.
//
//

#pragma once

// TODO: Divide into related modules.

OBJC_EXTERN const NSInteger kInvalidTimeShiftLowerBound;

typedef NS_ENUM(NSInteger, TVLStreamType) {
    TVLStreamTypeUnknown = -1,
    TVLStreamTypeAudio,
    TVLStreamTypeVideo,
};

typedef NSDictionary *(^TVLOptimumNodeInfoRequest)(NSString *playURL);

typedef void(^TVLHTTPAdaptiveStreamingSwitchCompletion)(BOOL succeeded, NSError *error, NSDictionary *userInfo);

typedef void(^TVLNetworkRequestCompletion)(NSError *error, id jsonObj);

typedef NSDictionary *(^TVLStrategyInfoRequest)(NSString *command, NSDictionary *strategyRequestInfo);

typedef NS_ENUM(NSUInteger, TVLPictureType) {
    TVLPictureTypeNone = 0,   ///< Undefined
    TVLPictureTypeI,          ///< Intra
    TVLPictureTypeP,          ///< Predicted
    TVLPictureTypeB,          ///< Bi-dir predicted
    TVLPictureTypeS,          ///< S(GMC)-VOP MPEG-4
    TVLPictureTypeSI,         ///< Switching Intra
    TVLPictureTypeSP,         ///< Switching Predicted
    TVLPictureTypeBI,         ///< BI type
};

typedef NS_ENUM(NSUInteger, TVLLogLevel) {
    TVLLogLevelVerbose,
    TVLLogLevelDebug,
    TVLLogLevelInfo,
    TVLLogLevelTrack,
    TVLLogLevelKill,
    TVLLogLevelPtr,
    TVLLogLevelWarn,
    TVLLogLevelError,
};

typedef void(^TVLLogCallback)(TVLLogLevel level, NSString *tag, NSString *log);

typedef NS_ENUM(NSInteger, TVLPlayerLoadState) {
    TVLPlayerLoadStateUnknown,
    TVLPlayerLoadStateStalled,
    TVLPlayerLoadStatePlayable,
    TVLPlayerLoadStateError,
};

typedef NS_ENUM(NSInteger, TVLPlayerStallReason) {
    TVLPlayerStallNone = -1,
    TVLPlayerStallNetwork,
    TVLPlayerStallDecoder,
    TVLPlayerStallReasonSDKBase = 1000,
    TVLPlayerStallWhenRetry,
};

typedef NS_ENUM(NSInteger, TVLStallEndReason) {
    TVLStallEndReasonInvalidValue,
    TVLStallEndReasonInterrupted = 0,
    TVLStallEndReasonBufferringEnd,
    TVLStallEndReasonRetrySuccess,
};

typedef NS_ENUM(NSInteger, TVLPlayerViewRenderType) {
    TVLPlayerViewRenderTypeInvalid                  = -1,
    TVLPlayerViewRenderTypeOpenGLES                 = 0,
    TVLPlayerViewRenderTypeMetal                    = 1,
    TVLPlayerViewRenderTypeSampleBufferDisplayLayer = 2,
    TVLPlayerViewRenderTypeOutput                   = 100,
};

typedef NS_ENUM(NSInteger, TVLPlayerPlaybackState) {
    TVLPlayerPlaybackStateUnknown,
    TVLPlayerPlaybackStateStopped,
    TVLPlayerPlaybackStatePlaying,
    TVLPlayerPlaybackStatePaused,
    TVLPlayerPlaybackStateError,
};

typedef NS_ENUM(NSInteger, TVLRetryReason) {
    TVLRetryReasonUnknown = -1000,
    TVLRetryReasonStall = -1001,
    TVLRetryReasonError = -1002,
    TVLRetryReasonBackgroundSwitch = -1003,
};

typedef NS_ENUM(NSUInteger, TVLImageLayoutType) {
    TVLLayoutTypeAspectFit,
    TVLLayoutTypeToFill,
    TVLLayoutTypeAspectFill
};

typedef NS_ENUM(NSInteger, TVLViewScalingMode) {
    TVLViewScalingModeNone,       // No scaling
    TVLViewScalingModeAspectFit,  // Uniform scale until one dimension fits
    TVLViewScalingModeAspectFill, // Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents
    TVLViewScalingModeFill        // Non-uniform scale. Both render dimensions will exactly match the visible bounds
};

typedef NS_ENUM(NSInteger, TVLPlayerViewAlignMode) {
    TVLPlayerViewAlignModeCenter = 0,
    TVLPlayerViewAlignModeLeftTop = 1,
    TVLPlayerViewAlignModeLeftCenter = 2,
    TVLPlayerViewAlignModeLeftBottom = 3,
    TVLPlayerViewAlignModeTopCenter = 4,
    TVLPlayerViewAlignModeBottomCenter = 5,
    TVLPlayerViewAlignModeRightTop = 6,
    TVLPlayerViewAlignModeRightCenter = 7,
    TVLPlayerViewAlignModeRightBottom = 8,
};

typedef NS_ENUM(NSUInteger, TVLPlayerType) {
    TVLPlayerTypeSystem       = 0, // system player
    TVLPlayerTypeVanGuard     = 1, // TTPlayerSDK
    TVLPlayerTypeRearGuard    = 2, // TTPlayerRearSDK backup version , need subspec DualCore In podfile
};

typedef NS_ENUM(NSInteger, TVLStreamAbnormalType) {
    TVLStreamAbnormalTypeNoError                = -1,
    TVLStreamAbnormalTypeDataDropped            = 0,
    TVLStreamAbnormalTypeDataRepeating          = 1,
    TVLStreamAbnormalTypeSEIUnavailable         = 2,
    TVLStreamAbnormalTypeSEIMayLost             = 3,
    TVLStreamAbnormalTypeSEIIndexRollback       = 4,
};

typedef struct TVLAudioWrapper {
    void (*open)(void *context, int samplerate, int channels, int duration);
    void (*process)(void *context, float **inout, int samples, int64_t timestamp);
    void (*close)(void *context);
    void (*release)(void *context);
    void *context;
} TVLAudioWrapper;

extern NSString *const kLiveErrorMessageKey;
extern NSErrorDomain const kLiveErrorDomain;

