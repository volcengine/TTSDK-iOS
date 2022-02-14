//
//  LSPlayController.m
//  TTSDKDemo
//
//  Created by guojieyuan on 2022/1/28.
//  Copyright © 2022 ByteDance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSPlayController.h"
#import <TTSDK/TTVideoEngine+Audio.h>
#import <TTSDK/TTVideoEngine+Video.h>

#import <Masonry/Masonry.h>

@interface LSPlayController ()
@property(nonatomic, strong) TTVideoEngine *player;
@property(nonatomic, strong) NSTimer *controlTimer;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) NSURL *playUrl;
@property(nonatomic) BOOL playingBeforeInterruption;


@end

@implementation LSPlayController

@synthesize delegate = _delegate;

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        _playUrl = url;
        [self p_addApplicationObserver];
    }
    return self;
}

- (void)dealloc {
    [self p_removeApplicationObserver];
    if (self->_player) {
        [self->_player stop];
        [self->_player close];
    }
    self->_player = nil;
}

- (void) playNextURL:(NSURL *)url
{
    [self.player setDirectPlayURL:[url absoluteString]];
}

- (TTVideoEngine *)player {
    if (!_player) {
        NSURL *playURL = [self getPlayURL];
        NSAssert(playURL, @"NO play URL");
        if (_player == nil) {
            self.player = [[TTVideoEngine alloc] initWithOwnPlayer:YES];
        }
        [self.player setLocalURL:[playURL absoluteString]];
        [self setVolume:1.0];
        [self.player setLooping:YES];
        [self.player setMuted:NO];
        _player.hardwareDecode = YES;
    }
    return _player;
}

- (void) setAudioWrapper:(void *)audioWrapper
{
    [self.player setAudioProcessor:audioWrapper];
}

- (void) setVideoWrapper:(void*)videoWrapper
{
    [self.player setVideoWrapper:videoWrapper];
}

- (NSURL *)getPlayURL {
    NSURL *playURL = nil;
    if (self.playUrl) {
        playURL = self.playUrl;
    }

    NSLog(@"play URL %@", playURL);
    return playURL;
}

- (void)play {
    [self.player play];
}

- (void)pause {
    [self.player pause];
}

- (void)stop
{
    [self.player stop];
}

- (void) close
{
    [self.player close];
}

- (void)restart
{
   // [self.player];
}

- (void) resume
{
    if (self.player) {
        [self.player play];
    }
}


/** 拖动视频进度 */
- (void)seekPlayerTimeTo:(NSTimeInterval)time
{
    NSLog(@"----------->seek time:%f", time);
    CMTime time_value = CMTimeMakeWithSeconds(time, 1);
    [self.player setCurrentPlaybackTime:time complete:^(BOOL success) {

    }];
}


/** 是否正在播放 */
- (BOOL)isPlaying
{
    return self.player.playbackState == TTVideoEnginePlaybackStatePlaying;
}

- (float)getTotalPlayTime
{
    return self.player.currentPlaybackTime;
}

- (float)getCurrentPlayTime
{
    return self.player.currentPlaybackTime;
}

/**
 音量

 @param volume 音量大小
 */
- (void)setVolume:(float)volume
{
    [self.player setVolume:volume];
}

- (float)getVolume
{
    return self.player.volume;
}

- (void)mute:(BOOL)enable {
    self.player.muted = enable;
}

- (BOOL)switchLooping {
    BOOL isLooping = [[(NSObject*)self.player valueForKey:@"looping"] boolValue];
    [self.player setLooping:!isLooping];
    return !isLooping;
}

- (void)exitPlay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
          [self.player pause];
          [self.player close];
        });
}

- (void)seek:(int)value {
    NSLog(@"----------->seek time:%d", value);
    [self.player setCurrentPlaybackTime:value complete:^(BOOL success) {

    }];
}

- (void)playSpeed:(float)speed {
    if (speed < 0.1) {
        return;
    }
    speed = roundf(speed * 10) / 10;
    NSLog(@"speed:%f", speed);
    [self.player setPlaybackSpeed:speed];
}

- (NSTimeInterval)currentPlaybackTime {
    return self.player.currentPlaybackTime;
}

- (NSTimeInterval)endPlaybackTime {
    return self.player.duration;
}

- (void) p_addApplicationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void) p_removeApplicationObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}


- (void)willResignActive:(NSNotification *)notification
{
//    [TTAVPlayerOpenGLActivity stop];
    [self pause];
}

- (void) didBecomeActive:(NSNotification *) notification
{
//    [TTAVPlayerOpenGLActivity start];
    [self play];
}


@end
