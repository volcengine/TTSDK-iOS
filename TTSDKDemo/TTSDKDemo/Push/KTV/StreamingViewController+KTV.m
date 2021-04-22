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
    static int stickerCount = 0;
    stickerCount = stickerCount % 8;
    
    NSString *stickerPath = nil;
    LSLiveEffectType effectType = LSLiveEffectGroup;
    NSString *audioEffectBundlePath = [[NSBundle mainBundle] pathForResource:@"AudioEffectResource" ofType:@"bundle"];
    switch (stickerCount) {
        case 0:
            stickerPath = [audioEffectBundlePath stringByAppendingPathComponent:@"echo"];
            [sender setTitle:@"回音" forState:UIControlStateNormal];
            break;
        case 1:
            stickerPath = [audioEffectBundlePath stringByAppendingPathComponent:@"amplifier"];
            [sender setTitle:@"扩音器" forState:UIControlStateNormal];
            break;
        case 2:
            stickerPath = [audioEffectBundlePath stringByAppendingPathComponent:@"micKing"];
            [sender setTitle:@"麦霸" forState:UIControlStateNormal];
            break;
        case 3:
            stickerPath = [audioEffectBundlePath stringByAppendingPathComponent:@"powerOut"];
            [sender setTitle:@"没电了" forState:UIControlStateNormal];
            break;
        case 4:
            stickerPath = [audioEffectBundlePath stringByAppendingPathComponent:@"robot"];
            [sender setTitle:@"机器人" forState:UIControlStateNormal];
            break;
        case 5:
            stickerPath = [audioEffectBundlePath stringByAppendingPathComponent:@"male"];
            [sender setTitle:@"male" forState:UIControlStateNormal];
            break;
        case 6:
            stickerPath = [audioEffectBundlePath stringByAppendingPathComponent:@"female"];
            [sender setTitle:@"female" forState:UIControlStateNormal];
            break;
        case 7:
            stickerPath = nil;
        default:
            break;
    }
    if (stickerPath) {
        [self.capture setEffectAudioConfig:stickerPath];
        [self.capture setAudioEffectSpeakerEnable:YES];
        [self.capture setEchoCancellationEnabled:YES];
        [self.capture setEnableAudioEffect:YES];
        ++stickerCount;
    } else {
        [self.capture setEnableAudioEffect:NO];
        [self.capture setAudioEffectSpeakerEnable:NO];
        [self.capture setEchoCancellationEnabled:NO];
        [self.capture removeEffectAudioConfig];
        [sender setTitle:@"音效" forState:UIControlStateNormal];
        stickerCount = 0;
    }
#endif
}

//MARK: 伴奏
- (void)onMusicTypeButtonClicked:(UIButton *)sender {
#if LIVECORE_ENABLE
    if (!self.audioUnit.isPlaying) {
        return;
    }
    NSTimeInterval startTime = [self.audioUnit getCurrentPlayTime];
    LCKTVMusicType musicType = LCKTVMusicTypeAccompany;
    if ([sender.titleLabel.text isEqualToString:@"伴奏"]) {
        [sender setTitle:@"原唱" forState:UIControlStateNormal];
        musicType = LCKTVMusicTypeOriginalSing;
    } else if ([sender.titleLabel.text isEqualToString:@"原唱"]) {
        [sender setTitle:@"伴奏" forState:UIControlStateNormal];
        musicType = LCKTVMusicTypeAccompany;
    }
    [self startKTVWithStartTime:startTime musicType:musicType];
#endif
}

- (void)onKaraokeButtonClicked:(UIButton *)sender {
#if LIVECORE_ENABLE
    if (!self.audioUnit.isPlaying) {
        if (!self.effect) {
            self.effect = [[LCAudioKTVEffect alloc] init];
        }
        [self.engine setKtvEffectEngine:self.effect];
        [self.effect startEffect];
        self.recordVolumeSlider.value = 0.5;
        self.musicVolumeSlider.value = 0.5;
        [self.musicTypeButton setTitle:@"伴奏" forState:UIControlStateNormal];
        self.musicTypeButton.hidden = NO;
        [self startKTVWithStartTime:0 musicType:LCKTVMusicTypeAccompany];
    }
    NSString *effectPath = nil;
    NSString *effectName = nil;
    int index = self.mKTVEffectIndex++ % 7;
    switch (index) {
        case 0: {
            effectName = @"emotion";
            effectPath = [[NSBundle mainBundle] pathForResource:@"emotion_vocal_filter_v2_music_dsp_graph" ofType:@"json"];
            [self.effect switchKtvEffectWithSourcePath:effectPath];
        }
            break;
        case 1: {
            effectName = @"energy";
            effectPath = [[NSBundle mainBundle] pathForResource:@"energy_vocal_filter_v1_music_dsp_graph" ofType:@"json"];
            [self.effect switchKtvEffectWithSourcePath:effectPath];
        }
            break;
        case 2: {
            effectName = @"phono";
            effectPath = [[NSBundle mainBundle] pathForResource:@"phono_vocal_filter_v3_music_dsp_graph" ofType:@"json"];
            [self.effect switchKtvEffectWithSourcePath:effectPath];
        }
            break;
        case 3: {
            effectName = @"pop";
            effectPath = [[NSBundle mainBundle] pathForResource:@"pop_vocal_filter_v2_music_dsp_graph" ofType:@"json"];
            [self.effect switchKtvEffectWithSourcePath:effectPath];
        }
            break;
        case 4: {
            effectName = @"rock";
            effectPath = [[NSBundle mainBundle] pathForResource:@"rock_vocal_filter_v2_music_dsp_graph" ofType:@"json"];
            [self.effect switchKtvEffectWithSourcePath:effectPath];
        }
            break;
        case 5: {
            effectName = @"warm";
            effectPath = [[NSBundle mainBundle] pathForResource:@"warm_vocal_filter_v3_music_dsp_graph" ofType:@"json"];
            [self.effect switchKtvEffectWithSourcePath:effectPath];
        }
            break;
        case 6: {
            effectName = @"wide";
            effectPath = [[NSBundle mainBundle] pathForResource:@"wide_vocal_filter_v3_music_dsp_graph" ofType:@"json"];
            [self.effect switchKtvEffectWithSourcePath:effectPath];
        }
            break;
            
        default:
            break;
    }
    NSString *buttonText = [NSString stringWithFormat:@"K歌: %@", effectName];
    [sender setTitle:buttonText forState:UIControlStateNormal];
#else
    
#endif
}

- (void)longPressKaraokeAction {
#if HAVE_AUDIO_EFFECT
    if (self.audioUnit.isPlaying) {
        self.karaokeControllersContainer.hidden = YES;
        [self.audioUnit stopProcess];
        self.audioUnit = nil;
        [self.capture setEchoCancellationEnabled:NO];
    #if LIVECORE_ENABLE
        [self.effect stopEffect];
        self.effect = nil;
        [self.engine setKtvEffectEngine:self.effect];
        self.musicTypeButton.hidden = YES;
    }
    self.mKTVEffectIndex = 0;
    #else
    }
    #endif
    [self.karaokeButton setTitle:@"K歌:关" forState:UIControlStateNormal];
#endif
}

#if LIVECORE_ENABLE
- (void)startKTVWithStartTime:(NSTimeInterval)startTime musicType:(LCKTVMusicType)musicType {
    if (!self.ktvAllowed) {
        return;
    }

    if ([self.audioUnit isPlaying]) {
        [self.audioUnit stopProcess];
        self.audioUnit = nil;
    }

    NSURL *URL = [NSURL URLWithString:[NSBundle.mainBundle pathForResource:@"doubleTracks.m4a" ofType:nil]];
    void (^createPlayerCompletion)(BOOL success, NSError * _Nonnull error) = ^(BOOL success, NSError * _Nonnull error) {
        
    };
    void (^completionBlock)(void) = ^ {
        
    };

    LCKTVConfig *config = [LCKTVConfig defaultConfigWithMusicURL:URL];
    config.loop = YES;
    config.musicStartTime = startTime;
    config.musicType = musicType;
    [self.engine playBgMusicWithConfig:config createPlayerCompletion:createPlayerCompletion completionBlock:completionBlock];
    self.karaokeControllersContainer.hidden = NO;

    [self playBgMusicWithConfig:URL completion:completionBlock];
    //[self.audioUnit setAudioVolume:self.recordVolumeSlider.value];
    [self.audioUnit setMusicVolume:self.musicVolumeSlider.value];

    /*z目前k歌打分有影响，暂时关闭k歌打分
     NSString *bundelPath = [[NSBundle mainBundle] pathForResource:@"KTVDemoRes" ofType:@"bundle"];
     NSString *midiPath = [bundelPath stringByAppendingPathComponent:@"midi/mo_fix.mid"];
     NSString *lyricPath = [bundelPath stringByAppendingPathComponent:@"lyric/01117_默.txt"];
     LCAudioScore *scoreEngine = [[LCAudioScore alloc] initWithMidiFileName:midiPath.UTF8String lyricFileName:lyricPath.UTF8String];
     [self.engine setAudioScoreEngine:scoreEngine];
     [scoreEngine startScore];
     */
}
#endif

- (void)playBgMusicWithConfig:(NSURL *)musicURL completion:(void (^)(void))completionBlock {
    LSLiveAudioUnitConfig *config = [[LSLiveAudioUnitConfig alloc] init];
    config.musicURL = musicURL;
 //   config.musicStartTime = KTVConfig.musicStartTime;
    config.musicType = LSMusicTypeAccompany;
    //config.asbd = @"";
    if (YES) {
        config.numberOfLoops = NSIntegerMax;
    }
    self.audioUnit = [[LSLiveAudioUnitProcess alloc] initWithConfig:config];
    if (self.capture.isEchoCancellationEnabled) {
       [self.capture setEchoCancellationEnabled:NO];
    }
    [self.audioUnit startProcess];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.capture.isEchoCancellationEnabled) {
           [self.capture setEchoCancellationEnabled:YES];
        }
    });
    if (NO) {
        __weak typeof(self)weakSelf = self;
        self.audioUnit.musicPlayEndBlock = ^(BOOL success) {
            if (completionBlock) {
                completionBlock();
            }
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                if (strongSelf) {
                  //  [strongSelf stopBgMusic];
                }
            });
        };
    }
}


@end

NS_ASSUME_NONNULL_END
