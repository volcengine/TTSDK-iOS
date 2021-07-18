//
//  LSMMAudioCleaner.h
//  LSVideoEditor
//
//  Created by tangzhixin on 2018/9/16.
//

#import <Foundation/Foundation.h>
#import <CoreAudioKit/CoreAudioKit.h>
@class LSLiveAudioCleanerFormat;

@interface LSLiveAudioCleaner : NSObject

-(instancetype) initWithSampleRate:(Float64)sampleRate;
/**
 @brief 更新参数信息
 @param format 参数
 */
- (void )updateFormat:(LSLiveAudioCleanerFormat *)format;

/**
 @brief 处理音频
 @param output  输出音频数据
 @param input   出入音频数据
 @param needBufferLen    需要分配内存大小
 @param samplesPerChannel  每个通道多少个采样点
 */
-(BOOL )process:(float **)output andInput:(float *)input andLen:(int )needBufferLen andSamplePerChannel:(int)samplesPerChannel;

-(BOOL)processBufferList:(AudioBufferList *)ioData;

-(void)setEnable:(BOOL)enable;

@end
