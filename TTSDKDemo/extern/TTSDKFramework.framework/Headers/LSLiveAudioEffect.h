/**
 LSLiveAudioEffect.h
 LSVideoEditor
 
 Created by tangzhixin on 2018/9/18.
 */

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class LSLiveAudioReverbFormat;
@class LSLiveAudioEqualizerFormat;
@class LSLiveAudioReverb2Format;
@class LSLiveAudioCleanerFormat;
@class LSLiveAudioExciterFormat;
@class LSLiveAudioCompressorFormat;

@interface LSLiveAudioEffect : NSObject

/**
 @brief 构造函数
 @param samplerate 音频采样率
 @param channels 音频声道数
 @return 返回实例对象
 */
- (instancetype)initWithSampleRate:(Float64)sampleRate
                          channels:(int)channels
                          useFloat:(BOOL)useFloat;


/**
 单独处理打分的逻辑，用于外放的时候调用

 @param buffer 需要2个声道交叉格式的int16数据
 @param samplePerCh 每个声道的样本数
 */
- (void)processSingScoreBuffer:(AudioBuffer)buffer samplePerCh:(int)samplePerCh;

/**
 @brief 处理音频
 @param buffer 音频数据
 @param samplePerCh 每个通道采样点数
 */
- (void)processBuffer:(AudioBuffer)buffer samplePerCh:(int)samplePerCh;

- (void)processBufferList:(AudioBufferList *)ioData;

/**
 @brief 检查是否需要音频处理
 @return YES, 需要处理; NO,不需要处理
 */
- (BOOL)needProcess;

#pragma mark - StereoWiden
/**
 * @brief update StereoWiden weightID
 * @param weightId
 *                  0  -> A Bit
 *                  1  -> Slight
 *                  2  -> Moderate
 *                  3  -> High
 *                  4  -> Super
 */
- (void)updateStereoWiden:(int)weightId;

#pragma mark - reverb params
/**
 * @brief update reverb params
 */
- (void)updateReverbFormat:(LSLiveAudioReverbFormat *)format;

#pragma mark - equalizer params
/**
 * @brief update reverb params
 */
- (void)updateEqualizerFormat:(LSLiveAudioEqualizerFormat *)format;

#pragma mark - reverb2 params
/**
 * @brief update reverb2 params
 */
- (void)updateReverb2Format:(LSLiveAudioReverb2Format *)format;

#pragma mark - audio cleaner params
/**
 * @brief update audio cleaner params
 */
- (void)updateAudioCleanerFormat:(LSLiveAudioCleanerFormat *)format;

- (void)updateExciterFormat:(LSLiveAudioExciterFormat *)format;

- (void)updateCompressFormat:(LSLiveAudioCompressorFormat *)format;

- (void)enableCleaner:(BOOL)enableCleaner;

- (void)enableExciter:(BOOL)enableExciter;

- (void)enableCompressor:(BOOL)enableCompressor;

@end
