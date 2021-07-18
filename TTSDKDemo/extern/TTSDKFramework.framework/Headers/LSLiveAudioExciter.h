//
//  LSMMAudioExciter.h
//  LSVideoEditor
//
//  Created by baohonglai on 2018/11/20.
//

#import "LSLiveAudioEffectFormat.h"
#import <CoreAudioKit/CoreAudioKit.h>

@interface LSLiveAudioExciter : NSObject

/**
 初始化谐波器

 @param gain 谐波增益
 @param highpassfreq 默认1000
 @param sampleRate 音频的采样率
 */
- (instancetype _Nonnull )initWithGain:(CGFloat)gain highpassfreq:(NSInteger)highpassfreq sampleRate:(NSInteger)sampleRate;


/**
 处理float类型的buffer

 @param inOutPut 输入buffer,也是输出buffer
 @param samples 样本数
 */
- (void)processAudio:(float * _Nonnull)input output:(float * _Nonnull )output samples:(int)samples channel:(int)channel;

- (BOOL)processBufferList:(AudioBufferList *)ioData outputL:(float *)outputL outputR:(float *)outputR;
/**
 更新exciter的参数

 @param format exciter的参数
 */
- (void)updateFormat:(LSLiveAudioExciterFormat *_Nullable)format;
@end
