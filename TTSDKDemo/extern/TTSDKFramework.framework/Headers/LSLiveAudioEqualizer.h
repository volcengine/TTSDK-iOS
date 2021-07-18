//
//  LSMMAudioEqualizer.h
//  LSVideoEditor
//
//  Created by tangzhixin on 2018/9/16.
//

#import <Foundation/Foundation.h>
#import <CoreAudioKit/CoreAudioKit.h>
@class LSLiveAudioEqualizerFormat;

@interface LSLiveAudioEqualizer : NSObject

/**
 @brief 构造一个音频均衡器对象
 @param samplerate 音频采样率
 @param channels 音频声道数
 */
-(instancetype )initWithSample:(int)samplerate
                 channels:(int)channels;

/**
 @brief 获取是否使能
 */
-(BOOL )getEnable;

/**
 @brief 更新EQ参数信息
 @param format EQ参数
 */
- (void )updateFormat:(LSLiveAudioEqualizerFormat *)format;

/**
 @brief 混响处理
 @param output  输出音频数据
 @param input   出入音频数据
 @param needBufferLen    需要分配内存大小
 @param samplesPerChannel  每个通道多少个采样点
 */
-(BOOL )process:(float **)output
      andInput:(float *)input
        andLen:(int )needBufferLen
andSamplePerChannel:(int)samplesPerChannel;

- (BOOL)processBufferList:(AudioBufferList *)ioData;

@end
