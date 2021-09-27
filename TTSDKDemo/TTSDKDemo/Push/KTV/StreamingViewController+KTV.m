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


NS_ASSUME_NONNULL_BEGIN

@implementation StreamingViewController (KTV)

- (void)sliderValueDidChange:(UISlider *)slider {
#if HAVE_AUDIO_EFFECT
    if (slider == self.musicVolumeSlider) {
        [self.audioUnit setMusicVolume:slider.value];
    } else if (slider == self.recordVolumeSlider) {
        [self.audioUnit setRecordVolume:slider.value];
    }
#endif
}

#if HAVE_AUDIO_EFFECT
// 播放伴奏
- (void)setupAudioUnitProcess:(UIButton *)sender {
    if (self.audioUnit) {
        [self.audioUnit stopProcess];
        self.audioUnit = nil;
        self.karaokeControllersContainer.hidden = YES;
    } else {
        NSURL *musicURL = [[NSBundle mainBundle] URLForResource:@"doubleTracks.m4a" withExtension:nil];
        LSLiveAudioUnitConfig *config = [[LSLiveAudioUnitConfig alloc] init];
        config.musicURL = musicURL;
        //config.musicStartTime = KTVConfig.musicStartTime;
        config.musicType = LSMusicTypeAccompany;
        //config.asbd = [self.liveSession audioStreamBasicDescription];
        if (YES) {
            config.numberOfLoops = NSIntegerMax;
        }
        self.audioUnit = [[LSLiveAudioUnitProcess alloc] initWithConfig:config];
//        if (self.capture.isEchoCancellationEnabled) {
//           [self.capture setEchoCancellationEnabled:NO];
//        }
        [self.audioUnit startProcess];
        self.karaokeControllersContainer.hidden = NO;
    }
}
#endif

@end

NS_ASSUME_NONNULL_END
