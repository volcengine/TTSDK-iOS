//
//  LSMMAudioReverbV2.h
//  LSVideoEditor
//
//  Created by tangzhixin on 2018/9/16.
//

#import <Foundation/Foundation.h>
#import <CoreAudioKit/CoreAudioKit.h>
@class LSLiveAudioReverb2Format;

@interface LSLiveAudioReverbV2 : NSObject

/**
 @brief 获取是否使能
 */
-(BOOL )getEnable;

/**
 @brief 更新混响2参数信息
 @param format 混响2参数
 */
- (void )updateFormat:(LSLiveAudioReverb2Format *)format;

/**
 @brief 混响处理，只处理交叉的int16类型的数据
 @param output  输出音频数据
 @param input   出入音频数据
 @param needBufferLen    需要分配内存大小
 @param channels    声道数
 @param samplesPerChannel  每个通道多少个采样点
 */
-(BOOL )process:(float **)output
      andInput:(float *)input
        andLen:(int )needBufferLen
    andChannel:(int )channels
andSamplePerChannel:(int)samplesPerChannel;


/**
 只处理处理非交叉的float类型的数据

 @param ioData bufferlist
 @return 
 */
- (BOOL)processBufferList:(AudioBufferList *)ioData;
@end
