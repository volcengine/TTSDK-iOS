//
//  LiveStreamConfiguration.h
//  TTLiveSDK
//
//  Created by zhaokai on 17/1/16.
//  Copyright © 2017年 zhaokai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  推流采用的声音源
 */
typedef NS_ENUM(NSUInteger, LiveStreamAudioSource) {
    LiveStreamAudioSourceMic = 0, // mic音源
    LiveStreamAudioSourceMix = 1, // 混音处理的声音源，推荐使用
};

typedef NS_ENUM(NSInteger, LiveStreamMode)
{
    LiveStreamModeAudioAndVideo  = 0, // 音频 + 视频
    LiveStreamModeAudioOnly          = 1, // 纯音频推流
    LiveStreamModeVideoOnly          = 2, // 纯视频推流(静音)
    LiveStreamModeAudioANDBlackFrame = 3, //音频 + 黑帧 （用于音频直播）
};

typedef NS_ENUM(NSUInteger, LiveStreamVideoCodec) {
    LiveStreamVideoCodec_VT_264 = 0, // 硬编 264
    LiveStreamVideoCodec_VT_265 = 1, // 硬编 265
};

typedef NS_ENUM(NSInteger, LiveStreamAudioCodec) {
	LiveStreamAudioCodec_AT_AAC			= 0,
	LiveStreamAudioCodec_FAAC_LC        = 1,
	LiveStreamAudioCodec_FAAC_HE        = 3,
	LiveStreamAudioCodec_FAAC_HE_V2     = 4,
};

typedef NS_ENUM(NSInteger, LiveProfileLevelType)
{
    // H264
    LiveEnCodecBaseline30       = 130,
    LiveEnCodecBaseline31       = 131,
    LiveEnCodecBaseline32       = 132,
    LiveEnCodecBaseAutoLevel    = 159,
    LiveEnCodecMainProfile30    = 230,
    LiveEnCodecMainProfile31    = 231,
    LiveEnCodecMainProfile32    = 232,
    LiveEnCodecMainAutoLevel    = 259,
    LiveEnCodecHighProfile30    = 330,
    LiveEnCodecHighProfile31    = 331,
    LiveEnCodecHighProfile32    = 332,
    LiveEnCodecHighAutoLevel    = 359,
    
    // HEVC
    LiveEnCodecHEVCMainAutoLevel    = 901,
    LiveEnCodecHEVCMain10AutoLevel  = 902,
};

/* Bitrate Adaptation Strategy */
typedef NS_ENUM(NSInteger, LiveStreamBitrateAdaptationStrategy) {
    LiveStreamBitrateAdaptationStrategy_NORMAL = 0,
    LiveStreamBitrateAdaptationStrategy_SENSITIVE,
    LiveStreamBitrateAdaptationStrategy_MORE_SENSITIVE,
};

@interface LiveStreamConfiguration : NSObject

/**
 创建默认参数模型

 @return 参数模型
 */
+ (instancetype)defaultConfiguration;

/**
 推流地址
 */
@property (nonatomic, copy) NSString *rtmpURL;

/**
 多推流地址，按默认内部策略进行调度
 */
@property (nonatomic, copy) NSArray<NSString *> *URLs;

/**
 调度参数
 */
@property (nonatomic, copy) NSDictionary *sdkParams;

/**
 app 标志符，用于区分推流日志
 */
@property (nonatomic, copy) NSString *project_key;

/**
 推流模式 （纯音频推流、音视频推流、静音推流）,默认音视频
 */
@property (nonatomic, assign) LiveStreamMode streamMode;

/**
 音源选择，默认使用LiveAudioSourceMix
 */
@property (nonatomic, assign) LiveStreamAudioSource audioSource;


/**
 采集分辨率，仅对内置camera 生效，外置请单独配置。
 默认值为 AVCaptureSessionPreset1280x720
 */
@property (nonatomic, copy) NSString *capturePreset;

/**
 输出分辨率，默认会根据屏幕提供一个适配默认值
 */
@property (nonatomic, assign) CGSize outputSize;

/**
 视频初始码率 默认为 800 * 1000
 */
@property (nonatomic, assign) NSUInteger bitrate;

/**
 视频最大上调码率 默认为 1024 * 1000
 */
@property (nonatomic, assign) NSUInteger maxBitrate;

/**
 视频最小下调码率 默认为 512 * 1000
 */
@property (nonatomic, assign) NSUInteger minBitrate;

/**
 音频编码码率 默认为 64 * 1000
 */
@property (nonatomic, assign) NSUInteger audioBitrate;

/**
 视频帧率, 默认18
 */
@property (nonatomic, assign) NSUInteger videoFPS;

/**
 关键帧间隔, 默认2s
 */
@property (nonatomic, assign) NSInteger gopSec;

/**
 是否开启B帧，默认为 NO
 */
@property (nonatomic, assign) BOOL enableBFrame;

/**
 是否开启NTP，默认为 NO
 */
@property (nonatomic, assign) BOOL enableNTP;

/**
 码率自适应策略类型(default is Normal)
 */
@property (nonatomic, assign) LiveStreamBitrateAdaptationStrategy bitrateAdaptStrategy;

/**
 是否开启OpenGop，默认为 NO
 */
@property (nonatomic, assign) BOOL enableOpenGOP;

/**
 音频声道数，默认为 1
 */
@property (nonatomic, assign) NSUInteger audioChannelCount;
/**
 音频采样, 默认为 44100
 */
@property (nonatomic, assign) NSUInteger audioSampleRate;

/**
  设置默认是否支持耳返，默认NO
 */
@property (nonatomic, assign) BOOL enableInEarMonitoring;

/**
  设置是否支持蓝牙耳返，默认NO，支持蓝牙耳返的前提是enableInEarMonitoring =YES
 */
@property (nonatomic, assign) BOOL enableBlueToothEarMonitoring;
/**
 日志上报间隔, 默认为0
   > 0 周期性上报
  <= 0 不上报
 */
@property (nonatomic, assign) NSInteger streamLogTimeInterval;

/**
 实时获取音频音强控制,默认NO
 */
@property (nonatomic, assign) BOOL allowsRealTimeVoicePowerLevel;

/**
 音频编码类型
 默认为 LiveStreamAudioCodec_AT_AAC
 */
@property (nonatomic, assign) LiveStreamAudioCodec aCodec;

/**
 图像编码类型
 默认为 LiveStreamVideoCodec_VT_264
 */
@property (nonatomic, assign) LiveStreamVideoCodec vCodec;

/**
 编码性能等级
 264 默认为 LiveEnCodecMainAutoLevel
 265 默认为 LiveEnCodecHEVCMainAutoLevel
 */
@property (nonatomic, assign) LiveProfileLevelType profileLevel;

/**
 是否开启后台模式, 默认为关闭
 */
@property (nonatomic, assign) BOOL enableBackgroundMode;

/**
 后台推流图像数据
 */
@property (nonatomic, strong) UIImage *backgroundImage;

/**
 是否开启自定义 SEI
 */
@property (nonatomic, assign) BOOL useCustomizedSEI;

@end
