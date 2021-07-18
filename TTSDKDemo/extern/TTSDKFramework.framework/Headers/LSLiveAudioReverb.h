//
//  LSMMAudioReverb.h
//  LSVideoEditor
//
//  Created by tangzhixin on 2018/9/16.
//

#import <Foundation/Foundation.h>
#import <CoreAudioKit/CoreAudioKit.h>
@class LSLiveAudioReverbFormat;

@interface LSLiveAudioReverb : NSObject

-(instancetype )initWithSample:(int)samplerate
               channels:(int)channels
              reverbFmt:(LSLiveAudioReverbFormat *)fmt;

/**
 @brief 获取是否使能
 */
-(BOOL )getEnable;

/**
 @brief 更新混响参数信息
 @param fmt 混响参数
 */
- (void )updateFormat:(LSLiveAudioReverbFormat *)fmt;

/**
 @brief 混响处理
 @param output  输出音频数据
 @param input   出入音频数据
 @param needBufferLen    需要分配内存大小
 @param samplesPerChannel  每个通道多少个采样点
 */
-(BOOL )process:(float **)output andInput:(float *)input andLen:(int )needBufferLen andSamplePerChannel:(int)samplesPerChannel;

- (BOOL)processBufferList:(AudioBufferList *)ioData;

@end
