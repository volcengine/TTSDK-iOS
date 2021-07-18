//
//  LSMMAudioStereoWiden.h
//  LSVideoEditor
//
//  Created by tangzhixin on 2018/9/17.
//

#import <Foundation/Foundation.h>
#import <CoreAudioKit/CoreAudioKit.h>
//@class LSMMAudioStereoWiden;

@interface LSLiveAudioStereoWiden : NSObject


-(instancetype)initWithChannel:(int)channels;

/**
 @brief 更新立体声参数信息
 @param format 立体声参数
 */
- (void )updateFormat:(int )weightId;

/**
 @brief 获取是否使能
 */
-(BOOL )getEnable;

/**
 @brief 混响处理
 @param output  输出音频数据
 @param input   出入音频数据
 @param needBufferLen    需要分配内存大小
 @param channels    声道数
 @param samplesPerChannel  每个通道多少个采样点
 */
-(BOOL )process:(float **)output
      andInput:(float *)input
        andLen:(int )needBufferLen
andSamplePerChannel:(int)samplesPerChannel;

- (BOOL)processBufferList:(AudioBufferList *)ioData;
@end
