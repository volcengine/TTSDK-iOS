//
//  VELiveConfig.h
//  TTQuickStartDemo
//
//  Created by ByteDance on 2023/3/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VeLiveConfig : NSObject
/// 采集宽度
@property (nonatomic, assign) int captureWidth;
/// 采集高度
@property (nonatomic, assign) int captureHeight;
/// 采集帧率
@property (nonatomic, assign) int captureFps;
/// 音频采样率
@property (nonatomic, assign) int audioCaptureSampleRate;
/// 音频通道数
@property (nonatomic, assign) int audioCaptureChannel;
/// 视频编码宽
@property (nonatomic, assign) int videoEncoderWith;
/// 视频编码高
@property (nonatomic, assign) int videoEncoderHeight;
/// 视频编码帧率
@property (nonatomic, assign) int videoEncoderFps;
/// 视频编码比特率
@property (nonatomic, assign) int videoEncoderKBitrate;
/// 是否开启硬件编码
@property (nonatomic, assign) BOOL videoHardwareEncoder;
/// 音频编码采样率
@property (nonatomic, assign) int audioEncoderSampleRate;
/// 音频编码通道数
@property (nonatomic, assign) int audioEncoderChannel;
/// 音频编码比特率
@property (nonatomic, assign) int audioEncoderKBitrate;
@end
NS_ASSUME_NONNULL_END
