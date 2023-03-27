//
//  VELiveConfig.m
//  TTQuickStartDemo
//
//  Created by ByteDance on 2023/3/2.
//

#import "VeLiveConfig.h"

@implementation VeLiveConfig

- (instancetype)init {
    if (self = [super init]) {
        /// 以下默认值，仅供参考
        self.captureWidth = 720;
        self.captureHeight = 1280;
        self.captureFps = 15;
        self.audioCaptureSampleRate = 44100;
        self.audioCaptureChannel = 2;
        
        self.videoEncoderWith = 720;
        self.videoEncoderHeight = 1280;
        self.videoEncoderFps = 15;
        
        self.videoEncoderKBitrate = 1600;
        self.videoHardwareEncoder = YES;
        self.audioEncoderSampleRate = 44100;
        self.audioEncoderChannel = 2;
        self.audioEncoderKBitrate = 64;
    }
    return self;
}

@end
