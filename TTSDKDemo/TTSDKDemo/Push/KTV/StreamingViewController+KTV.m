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
        [self.engine setMusicVolume:slider.value];
    } else if (slider == self.recordVolumeSlider) {
        [self.engine setAudioVolume:slider.value];
    }
#endif
}

#if HAVE_AUDIO_EFFECT
// 播放伴奏
- (void)setupAudioUnitProcess:(UIButton *)sender {
    if (self.engine.musicIsPlaying) {
        [self.engine stopBgMusic];
        self.karaokeControllersContainer.hidden = YES;
    } else {
        NSURL *musicURL = [[NSBundle mainBundle] URLForResource:@"doubleTracks.m4a" withExtension:nil];
        __weak typeof(self) wself = self;
        [self.engine playBgMusicWithURL:musicURL loop:YES volume:20 createPlayerCompletion:^(BOOL success, NSError * _Nonnull error) {
            __strong typeof(wself) sself = wself;
            if (success) {
                sself.karaokeControllersContainer.hidden = NO;
            }
        } completionBlock:^{
            
        }];
    }
}
#endif

@end




NS_ASSUME_NONNULL_END
