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

- (BOOL)ktvAllowed {
    //ktv不支持蓝牙耳机接入的情况
    AVAudioSessionRouteDescription *route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription *desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortBluetoothA2DP]
            || [[desc portType] isEqualToString:AVAudioSessionPortBluetoothHFP]
            || [[desc portType] isEqualToString:AVAudioSessionPortBluetoothLE])
            return NO;
        }
    
    return YES;
}

#if HAVE_AUDIO_EFFECT
// 播放伴奏
- (void)setupAudioUnitProcess:(UIButton *)sender {
    if (self.audioUnit) {
        [self.audioUnit stopProcess];
        self.audioUnit = nil;
        self.karaokeControllersContainer.hidden = YES;
    } else {
        LSLiveAudioReverb2Format *reverb2Format = [[LSLiveAudioReverb2Format alloc] init];
        reverb2Format.sampleRate  = 44100;
        reverb2Format.oversamplefactor = 2;
        reverb2Format.ertolate = 0.20f;
        reverb2Format.erefwet = -9.0f;
        reverb2Format.dry = -8;
        reverb2Format.ereffactor = 8.5f;
        reverb2Format.erefwidth = 0.7f;
        reverb2Format.width = 1.0f;
        reverb2Format.wet = -8;
        reverb2Format.wander = 0.20f;
        reverb2Format.bassb = 0.20f;
        reverb2Format.spin = 0.5f;
        reverb2Format.inputlpf = 18000;
        reverb2Format.basslpf = 400;
        reverb2Format.damplpf = 5000;
        reverb2Format.outputlpf = 7000;
        reverb2Format.rt60 = 4.2f;
        reverb2Format.delay = 0.018f;
        NSURL *musicURL = [[NSBundle mainBundle] URLForResource:@"doubleTracks.m4a" withExtension:nil];
        LSLiveAudioUnitConfig *config = [[LSLiveAudioUnitConfig alloc] init];
        config.musicURL = musicURL;
        //config.musicStartTime = KTVConfig.musicStartTime;
        config.musicType = LSMusicTypeAccompany;
        config.asbd = [self.liveSession audioStreamBasicDescription];
        if (YES) {
            config.numberOfLoops = NSIntegerMax;
        }
        self.audioUnit = [[LSLiveAudioUnitProcess alloc] initWithConfig:config];
        if (self.capture.isEchoCancellationEnabled) {
           [self.capture setEchoCancellationEnabled:NO];
        }
        [self.audioUnit startProcess];
        self.karaokeControllersContainer.hidden = NO;
    }
}
#endif

//MARK: K歌相關特效, 與LiveCore耦合

//MARK: 音效
- (void)switchAudioEffectButtonClicked:(UIButton *)sender {
#if LIVECORE_ENABLE
  
#endif
}

//MARK: 伴奏
- (void)onMusicTypeButtonClicked:(UIButton *)sender {
#if LIVECORE_ENABLE

#endif
}

- (void)onKaraokeButtonClicked:(UIButton *)sender {
#if LIVECORE_ENABLE

#else
    
#endif
}

- (void)longPressKaraokeAction {
#if HAVE_AUDIO_EFFECT
   
#endif
}

#if LIVECORE_ENABLE
- (void)startKTVWithStartTime:(NSTimeInterval)startTime musicType:(LCKTVMusicType)musicType {
   
}
#endif

- (void)playBgMusicWithConfig:(NSURL *)musicURL completion:(void (^)(void))completionBlock {
   
}


@end

NS_ASSUME_NONNULL_END
