//
//  TTVideoEnginePlayerDefine.h
//  Article
//
//  Created by guikunzhi on 16/12/2.
//
//

#if 0
#define TTVideoPlayerLog(fmt, ...) NSLog(fmt, ##__VA_ARGS__);
#else
#define TTVideoPlayerLog(...)
#endif

#if __has_include(<MDLMediaDataLoader/AVMDLDataLoader.h>)
#define TT_VIDEO_ENGINE_LOCAL_SERVER 1
#elif __has_include("AVMDLDataLoader.h")
#define TT_VIDEO_ENGINE_LOCAL_SERVER 1
#else
#define TT_VIDEO_ENGINE_LOCAL_SERVER 1
#endif

static NSString *const kTTVideoErrorDomainOwnPlayer = @"kTTVideoErrorDomainOwnPlayer";
static NSString *const kTTVideoErrorDomainSysPlayer = @"kTTVideoErrorDomainSysPlayer";

inline static BOOL TTVideoIsNullObject(id value)
{
    if (!value) return YES;
    if ([value isKindOfClass:[NSNull class]]) return YES;

    return NO;
}

// avoid float equal compare
inline static BOOL TTVideoIsFloatZero(float value)
{
    return fabsf(value) <= 0.00001f;
}

inline static BOOL TTVideoIsFloatEqual(float value1, float value2)
{
    return fabsf(value1 - value2) <= 0.00001f;
}

typedef NS_ENUM(NSInteger, TTVideoEngineScalingMode) {
    TTVideoEngineScalingModeNone,       // No scaling
    TTVideoEngineScalingModeAspectFit,  // Uniform scale until one dimension fits
    TTVideoEngineScalingModeAspectFill, // Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents
    TTVideoEngineScalingModeFill        // Non-uniform scale. Both render dimensions will exactly match the visible bounds
};

typedef NS_ENUM(NSInteger, TTVideoEnginePlaybackState) {
    TTVideoEnginePlaybackStateStopped,
    TTVideoEnginePlaybackStatePlaying,
    TTVideoEnginePlaybackStatePaused,
    TTVideoEnginePlaybackStateError,
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

typedef NS_ENUM(NSInteger, TTVideoEngineRotateType) {
    TTVideoEngineRotateTypeNone = 0,
    TTVideoEngineRotateType90   = 1,/// Clockwise 90
    TTVideoEngineRotateType180  = 2,
    TTVideoEngineRotateType270  = 3,
};

static inline NSString *RenderEngineGetName(TTVideoEngineRenderEngine engine) {
    switch (engine) {
        case TTVideoEngineRenderEngineOpenGLES:
            return @"OpenGLES";
            break;
        case TTVideoEngineRenderEngineMetal:
            return @"Metal";
            break;
        case TTVideoEngineRenderEngineOutput:
            return @"Output";
            break;
        default:
            break;
    }
    return @"";
}

typedef NS_ENUM(NSUInteger, TTVideoEngineDrmType) {
    TTVideoEngineDrmNone,
    TTVideoEngineDrmIntertrust,
};

typedef NS_ENUM(NSUInteger, TTVideoEngineAudioDeviceType) {
    TTVideoEngineDeviceAudioUnit,
    TTVideoEngineDeviceAudioGraph,
    TTVideoEngineDeviceDefault = TTVideoEngineDeviceAudioUnit,
    TTVideoEngineDeviceDummyAudio = 10,
} ;

inline static const char *playbackStateGetName(TTVideoEnginePlaybackState state) {
    switch (state) {
        case TTVideoEnginePlaybackStateStopped:
            return "TTVideoEnginePlaybackStateStopped";
        case TTVideoEnginePlaybackStatePlaying:
            return "TTVideoEnginePlaybackStatePlaying";
        case TTVideoEnginePlaybackStatePaused:
            return "TTVideoEnginePlaybackStatePaused";
        case TTVideoEnginePlaybackStateError:
            return "TTVideoEnginePlaybackStateError";
            
        default:
            break;
    }
    return "";
}

typedef NS_ENUM(NSUInteger, TTVideoEngineLoadState) {
    TTVideoEngineLoadStateUnknown        = 0,
    TTVideoEngineLoadStatePlayable,
    TTVideoEngineLoadStateStalled,
    TTVideoEngineLoadStateError,
};

typedef NS_ENUM(NSUInteger, TTVideoEngineStallReason) {
    TTVideoEngineStallReasonNone,
    TTVideoEngineStallReasonNetwork,
    TTVideoEngineStallReasonDecoder,
};

inline static const char *loadStateGetName(TTVideoEngineLoadState state) {
    switch (state) {
        case TTVideoEngineLoadStateUnknown:
            return "TTVideoEngineLoadStateUnknown";
        case TTVideoEngineLoadStatePlayable:
            return "TTVideoEngineLoadStatePlayable";
        case TTVideoEngineLoadStateStalled:
            return "TTVideoEngineLoadStateStalled";
        case TTVideoEngineLoadStateError:
            return "TTVideoEngineLoadStateError";
            
        default:
            break;
    }
    return "";
}

inline static const char *stallReasonGetName(TTVideoEngineStallReason reason) {
    switch (reason) {
        case TTVideoEngineStallReasonNone:
            return "TTVideoEngineStallReasonNone";
        case TTVideoEngineStallReasonNetwork:
            return "TTVideoEngineStallReasonNetwork";
        case TTVideoEngineStallReasonDecoder:
            return "TTVideoEngineStallReasonDecoder";
            
        default:
            break;
    }
    return "";
}

typedef NS_ENUM(NSInteger, TTVideoEngineFinishReason) {
    TTVideoEngineFinishReasonPlaybackEnded,
    TTVideoEngineFinishReasonPlaybackError,
    TTVideoEngineFinishReasonUserExited
};

typedef NS_ENUM(NSUInteger, TTVideoEngineVideoSource) {
    TTVideoEngineVideoSourceNone,
    TTVideoEngineVideoSourceVid,
    TTVideoEngineVideoSourceLocalURL,
    TTVideoEngineVideoSourceDirectURL,
    TTVideoEngineVideoSourcePreload,
    TTVideoEngineVideoSourcePlayItem,
    TTVideoEngineVideoSourceVideoInfo,
    TTVideoEngineVideoSourceAVPlayerItem,
};

// NSNumber (MPMovieFinishReason)
extern NSString *const TTVideoEnginePlaybackDidFinishReasonUserInfoKey;

