//
//  LiveStreamDefines.h
//  LiveStreamFramework
//
//  Created by 王可成 on 2018/8/24.
//  Copyright © 2018 wangkecheng. All rights reserved.
//

#pragma - mark LiveStreamInfoKeys
/********************************************************************************/
/*                              LiveStreamInfoKeys                              */
/********************************************************************************/
/*------------------ Common Info ------------------*/
/// SDK版本 (NSString)
static NSString *const LiveStreamInfo_SDKVersion = @"sdk_version";
/// 推流类型 (NSString)
static NSString *const LiveStreamInfo_StreamType = @"push_type";
/// 推流时间 (NSNumber)
static NSString *const LiveStreamInfo_StreamDuration = @"duration";
/// 推流地址 (NSString)
static NSString *const LiveStreamInfo_PublishURL = @"url";
/// cdn ip address (NSString)
static NSString *const LiveStreamInfo_RemoteIpAddress = @"cdn_ip";
/// local ip address (NSString)
static NSString *const LiveStreamInfo_LocalIpAddress = @"local_ip";
/// 项目标识符 (务必配置唯一标识，用于日志区分) (NSString)
static NSString *const LiveStreamInfo_ProjectKey = @"project_key";

/*------------------ Codec ------------------*/
/// 视频编码类型 (NSString)
static NSString *const LiveStreamInfo_VideoCodec = @"video_codec";
/// 音频编码类型 (NSString)
static NSString *const LiveStreamInfo_AudioCodec = @"audio_codec";

/*------------------ Bitrate ------------------*/
/// 视频编码理论码率 (NSNumber)
static NSString *const LiveStreamInfo_VideoBitrate = @"meta_video_bitrate";
/// 视频码率自适应的最低码率 (NSNumber)
static NSString *const LiveStreamInfo_MinVideoBitrate = @"meta_min_video_bitrate";
/// 视频码率自适应的最高码率 (NSNumber)
static NSString *const LiveStreamInfo_MaxVideoBitrate = @"meta_max_video_bitrate";
/// 视频编码当前码率 (码率自适应调整后的值，初始值与默认码率一致) (NSNumber)
static NSString *const LiveStreamInfo_CurrentVideoBitrate = @"current_video_bitrate";
/// 视频实时编码码率 (最近单位时间的编码平均比特率) (NSNumber)
static NSString *const LiveStreamInfo_RealEncodeBitrate = @"encode_bitrate";

/// 音频编码理论码率 (NSNumber)
static NSString *const LiveStreamInfo_AudioBitrate = @"meta_audio_bitrate";
/// 实际发送码率 (NSNumber)
static NSString *const LiveStreamInfo_RealTransportBitrate = @"real_bitrate";

/*------------------ FPS ------------------*/
/// 设置的编码理论帧率 (NSNumber)
static NSString *const LiveStreamInfo_VideoFPS = @"meta_video_framerate";
/// 预览帧率 (NSNumber)
static NSString *const LiveStreamInfo_PreviewFPS = @"preview_fps";
/// 编码编码实时帧率 (NSNumber)
static NSString *const LiveStreamInfo_EncodeFPS = @"encode_fps";
/// 实际帧率 (NSNumber)
static NSString *const LiveStreamInfo_RealFPS = @"real_video_framerate";

/*------------------ Others Options ------------------*/
/// 视频输出分辨率 (NSValue<CGSize>)
static NSString *const LiveStreamInfo_VideoSize = @"video_size";
/// 音频声道数 (NSNumber)
static NSString *const LiveStreamInfo_AudioChannelCount = @"audio_channel";
/// 音频采样 (NSNumber)
static NSString *const LiveStreamInfo_AudioSampleRate = @"audio_sample_rate";

#define LS_EXPORT extern __attribute__((visibility("default")))

#if defined(__cplusplus)
#define LS_EXTERN "C" LS_EXPORT
#else
#define LS_EXTERN LS_EXPORT
#endif

#pragma -
// MARK: LiveStreamSessionState
typedef NS_ENUM(NSInteger, LiveStreamSessionState)
{
    LiveStreamSessionStateNone,
    LiveStreamSessionStateStarting,
    LiveStreamSessionStateStarted,
    LiveStreamSessionStateReconnecting,
    LiveStreamSessionStateEnded,
    LiveStreamSessionStateError,
    LiveStreamSessionStateUrlerr,
};

// MARK: LiveStreamErrorCode
typedef NS_ENUM(NSInteger, LiveStreamErrorCode)
{
    LiveStreamErrorCode_UNKNOWN                    = -10000,
    LiveStreamErrorCode_RTMP_ConfiguraitonError    = -10001,
    LiveStreamErrorCode_RTMP_CONNECT_FAILED        = -10002,
    LiveStreamErrorCode_INTERLEAVE_ERROR           = -10003,
    LiveStreamErrorCode_AVSYNC_ERROR               = -10004,
    LiveStreamErrorCode_RTMP_SEND_PACKET_FAIL      = -10005,
    
    // Error Codes For LiveStreamExtension
    LiveStreamErrorCode_REQUEST_STREAM_INFO_ERROR  = -10210,  // request stream info fail (only use in LiveSessionExtension, unsed)
    LiveStreamErrorCode_NEED_UPDATE_STREAM_INFO    = -10211,  // neet to update stream info (only use in LiveSessionExtension)
};

/*  rotate mode */
typedef NS_ENUM(NSUInteger, LiveStreamRotateMode) {
    LSRotateModeNoRotation,
    LSRotateModeRotateLeft,
    LSRotateModeRotateRight,
    LSRotateModeFlipVertical,
    LSRotateModeFlipHorizonal,
    LSRotateModeRotateRightFlipVertical,
    LSRotateModeRotateRightFlipHorizontal,
    LSRotateModeRotate180
};

/* ---------------------- LogLevel ---------------------- */
typedef NS_ENUM(NSUInteger, LiveStreamLogLevel) {
    LiveStreamLogLevelVerbose = 2,
    LiveStreamLogLevelDebug = 3,
    LiveStreamLogLevelInfo = 4,
    LiveStreamLogLevelWarning = 5,
    LiveStreamLogLevelError = 6,
};

typedef NS_ENUM(NSUInteger, LSRenderMode) {
    LSRenderModeScaleToFill     = 0,
    LSRenderModeScaleAspectFit  = 1,
    LSRenderModeScaleAspectFill = 2
};
