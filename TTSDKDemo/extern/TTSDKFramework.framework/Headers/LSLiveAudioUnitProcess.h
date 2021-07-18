//
//  LSLiveAudioUnitProcess.h
//  AudioMixer
//
//  Created by tianzhuo on 2018/5/16.
//  Copyright © 2018年 tianzhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LSLiveAudioEffect.h"
#import "LSLiveAudioConverter.h"

@interface LSLiveAudioUnitConfig : NSObject

@property (nonatomic) NSURL *musicURL;
@property (nonatomic) AudioStreamBasicDescription asbd;
@property (nonatomic) NSTimeInterval musicStartTime;
@property (nonatomic) LSMusicType musicType;
@property NSInteger numberOfLoops;

@end

@interface LSLiveAudioUnitProcess : NSObject

/**
    是否允许蓝牙播放，如果NO，切换到蓝牙时会停止播放，默认YES
 */
@property (nonatomic,assign)BOOL blueToothPlayAllowed;
// 专门处理音效的类
@property (nonatomic) LSLiveAudioEffect *audioEffect;
@property (nonatomic,copy) void(^musicPlayEndBlock)(BOOL success);
@property (nonatomic,assign) BOOL closeProcess;
@property (nonatomic, copy) void (^loopEndBlock)(void);
- (instancetype)initWithConfig:(LSLiveAudioUnitConfig *)config;

- (void)startProcess;
- (void)pauseProcess;
- (void)stopProcess;
- (void)restart;
- (void)processAudioBufferList:(AudioBufferList *)ioData inNumberFrames:(UInt32)inNumberFrames;
- (BOOL)isPlaying;

- (NSInteger)getCurLoop;

- (NSInteger)numberOfLoop;

/**
 设置mix之前人声的音量

 @param recordVolume 音量，一般是0~1.0，但如果需要有一定的增幅可以*scale;
 */
- (void)setRecordVolume:(CGFloat)recordVolume;

- (CGFloat)getRecordVolume;
/**
 设置mix之前伴奏的音量，伴奏播放和合成的时候都会生效

 @param musicVolume 音量，一般是0~1.0，但如果需要有一定的增幅可以*scale;
 */
- (void)setMusicVolume:(CGFloat)musicVolume;

- (CGFloat)getMusicVolume;

/**
    获取 音乐播放时长 单位 秒
 */
- (NSTimeInterval)getMusicDuration;
/**
    获取当前播放进度时长 单位 秒
 */
- (NSTimeInterval)getCurrentPlayTime;

- (void)replacePlayerItem:(NSString *)path;
@end
