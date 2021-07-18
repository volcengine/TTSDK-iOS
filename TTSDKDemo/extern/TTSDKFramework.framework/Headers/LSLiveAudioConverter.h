//
//  LSLiveAudioConverter.h
//  AudioMixer
//
//  Created by tianzhuo on 2018/5/9.
//  Copyright © 2018年 tianzhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudioKit/CoreAudioKit.h>
#import "LSRecorderDefine.h"

extern SInt32 const LiveOSStatusNoMoreData;
extern SInt32 const LiveOSStatusConvertError;
extern SInt32 const LiveOSStatusIncorrectBus;

@interface LSLiveAudioConverter : NSObject

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, readonly, assign) AudioStreamBasicDescription destinationFormat;
@property (nonatomic, assign, readonly) LSAudioConverterStatus status;
@property (nonatomic, strong, readonly) NSURL *audioURL;
@property (nonatomic, readonly) LSMusicType musicType;


/**
 初始化

 @param asbd 必须指定一种stream格式
 @return
 */
- (instancetype)initWithFormat:(AudioStreamBasicDescription)asbd;

- (void)convertNewFile:(NSURL *)audioURL
              fromTime:(NSTimeInterval)startTime;

- (void)convertNewFile:(NSURL *)audioURL
              fromTime:(NSTimeInterval)startTime
             musicType:(LSMusicType)musicType;

- (void)switchMusicType:(LSMusicType)musicType;

- (OSStatus)renderIOData:(AudioBufferList *)ioData outputPacketSize:(UInt32 *)outputPacketSize;

- (void)adjustTimeOffset:(NSTimeInterval)timeOffset;
- (void)seekToTime:(NSTimeInterval)time;
- (void)resetConverter;

- (void)destory;



@end
