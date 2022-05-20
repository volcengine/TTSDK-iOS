//
//  LSPlayController.h
//  TTSDKDemo
//
//  Created by guojieyuan on 2022/1/28.
//  Copyright © 2022 ByteDance. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<TTSDKFramework/TTSDKFramework.h>)
#import <TTSDKFramework/LCKaraokeMovie.h>
#define USE_FRAMEWORK 1
#else
#import <TTSDK/LCKaraokeMovie.h>
#define USE_FRAMEWORK 0
#endif

NS_ASSUME_NONNULL_BEGIN

@interface LSPlayController : NSObject <LCPlayerProtocol>

- (instancetype)initWithURL:(NSURL *)url;

- (void)play;

/** 停止 */
- (void)stop;

- (void)close;

/** 从头开始播放 */
- (void)restart;

/** 暂停 */
- (void)pause;

/** 恢复 */
- (void)resume;

/** 拖动视频进度 */
- (void)seekPlayerTimeTo:(NSTimeInterval)time;


/** 是否正在播放 */
- (BOOL)isPlaying;

- (float)getTotalPlayTime;

- (float)getCurrentPlayTime;

/**
 音量

 @param volume 音量大小
 */
- (void)setVolume:(float)volume;
- (float)getVolume;

- (NSURL *)getPlayURL;

@end

NS_ASSUME_NONNULL_END
