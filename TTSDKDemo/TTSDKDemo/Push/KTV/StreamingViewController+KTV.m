//
//  SteamingViewController+SteamingViewController_KTV.h
//  TTSDKDemo
//
//  Created by guojieyuan on 2021/4/9.
//  Copyright © 2021 ByteDance. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "StreamingViewController+KTV.h"

@interface LiveCore (KTV)

@property (nonatomic, strong)LSLiveAudioUnitProcess *audioUnit;

@end

@implementation LiveCore (KTV)

- (LSLiveAudioUnitProcess *)audioUnit {
    return objc_getAssociatedObject(self, @"LiveCoreKTVKey");
}

- (void)setAudioUnit:(LSLiveAudioUnitProcess *)audioUnit{
    objc_setAssociatedObject(self, @"LiveCoreKTVKey", audioUnit, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)original_ktv_processAudioBufferList:(void *)ioData
                             inNumberFrames:(UInt32)inNumberFrames
                              processedData:(void *)processedData
                   headphonesMonitoringData:(void *)headphonesMonitoringData
                                   channels:(int)channels
                                   dataSize:(UInt32)dataSize
                                 sampleRate:(int)sampleRate
                              onlyLocalPlay:(bool)onlyLocalPlay {
    if (self.audioUnit) {
        [self.audioUnit processAudioData:(int16_t *)ioData dataSize:dataSize inNumberFrames:inNumberFrames];
        memcpy(processedData, ioData, dataSize);
    }
}

@end

NS_ASSUME_NONNULL_BEGIN

@implementation StreamingViewController (KTV)

- (void)sliderValueDidChange:(UISlider *)slider {
#if HAVE_AUDIO_EFFECT
    if (slider == self.musicVolumeSlider) {
        [self.engine.audioUnit setMusicVolume:slider.value];
    } else if (slider == self.recordVolumeSlider) {
        [self.engine.audioUnit setRecordVolume:slider.value];
    }
#endif
}

#if HAVE_AUDIO_EFFECT
// 播放伴奏
- (void)setupAudioUnitProcess:(UIButton *)sender {
    if (self.engine.audioUnit) {
        [self.engine.audioUnit stopProcess];
        self.engine.audioUnit = nil;
        self.karaokeControllersContainer.hidden = YES;
    } else {
        NSURL *musicURL = [[NSBundle mainBundle] URLForResource:@"doubleTracks.m4a" withExtension:nil];
        LSLiveAudioUnitConfig *config = [[LSLiveAudioUnitConfig alloc] init];
        config.musicURL = musicURL;
        config.musicStartTime = 0;
        config.musicType = LSMusicTypeAccompany;
        config.asbd = [self.engine.liveSession audioStreamBasicDescription];
        config.newPlayerMode = NO;
        if (YES) {
            config.numberOfLoops = NSIntegerMax;
        }
        self.engine.audioUnit = [[LSLiveAudioUnitProcess alloc] initWithConfig:config];
        [self.engine.audioUnit startProcess];
        self.karaokeControllersContainer.hidden = NO;
    }
}
#endif

@end




NS_ASSUME_NONNULL_END
