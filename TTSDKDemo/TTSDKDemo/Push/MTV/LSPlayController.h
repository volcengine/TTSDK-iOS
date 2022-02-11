//
//  LSPlayController.h
//  TTSDKDemo
//
//  Created by guojieyuan on 2022/1/28.
//  Copyright © 2022 ByteDance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TTSDK/LCKaraokeMovie.h>

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
