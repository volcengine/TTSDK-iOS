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

@interface StreamingKTVControllBox ()

@property (strong, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UISlider *recordVolumeSlider;
@property (weak, nonatomic) IBOutlet UISlider *musicVolumeSlider;
@property (weak, nonatomic) IBOutlet UISlider *timeSeekSlider;

@property (weak, nonatomic) IBOutlet UIButton *pauseMusic;
@property (weak, nonatomic) IBOutlet UIButton *continueMusic;

-(void)resetUI;

@end

@implementation StreamingKTVControllBox

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViewWithNib];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initSubViewWithNib];
    }
    return self;
}

-(void)initSubViewWithNib {
    [[NSBundle mainBundle] loadNibNamed:@"StreamingKTVControllBox" owner:self options:NULL];
    [self addSubview:self.rootView];
    [self.rootView setFrame:self.bounds];
}

- (void)resetUI {
    self.recordVolumeSlider.value = 0.5;
    self.musicVolumeSlider.value = 0.5;
    self.timeSeekSlider.value = 0;
}

@end

NS_ASSUME_NONNULL_BEGIN

@implementation StreamingViewController (KTV)

-(UISlider *)recordVolumeSlider {
    return self.karaokeControllersContainer.recordVolumeSlider;
}

-(UISlider *)musicVolumeSlider {
    return self.karaokeControllersContainer.musicVolumeSlider;
}

-(UISlider *)timeSeekSlider {
    return self.karaokeControllersContainer.timeSeekSlider;
}

-(UIButton *)pauseMusicBtn {
    return self.karaokeControllersContainer.pauseMusic;
}

-(UIButton *)continueMusicBtn {
    return self.karaokeControllersContainer.continueMusic;
}

- (void)initKTVView {
    //MARK: K歌相关
    CGSize karaokeControllersContainerSize = CGSizeMake(self.view.bounds.size.width, 240);
    StreamingKTVControllBox *karaokeControllersContainer = [[StreamingKTVControllBox alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - karaokeControllersContainerSize.height, karaokeControllersContainerSize.width, karaokeControllersContainerSize.height)];
    karaokeControllersContainer.backgroundColor = UIColor.whiteColor;
    karaokeControllersContainer.alpha = .7;
    [self.view addSubview:karaokeControllersContainer];
    self.karaokeControllersContainer = karaokeControllersContainer;
    
    [self.recordVolumeSlider addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.musicVolumeSlider addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.timeSeekSlider addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    //
    [self.pauseMusicBtn addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.continueMusicBtn addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    karaokeControllersContainer.hidden = YES;
}

- (void)buttonDidClick:(UIButton *)buttn {
//    if (buttn == self.pauseMusicBtn) {
//        [self.engine pauseBgMusic];
//    } else if (buttn == self.continueMusicBtn) {
//        [self.engine resumeBgMusic];
//    }
}

- (void)sliderValueDidChange:(UISlider *)slider {
#if HAVE_AUDIO_EFFECT
    if (slider == self.musicVolumeSlider) {
        [self.engine setMusicVolume:slider.value];
    } else if (slider == self.recordVolumeSlider) {
        [self.engine setAudioVolume:slider.value];
    } else if (slider == self.timeSeekSlider) {
        NSTimeInterval musicD = [self.engine musicDuration];
        NSTimeInterval expectD = musicD * slider.value;
        [self.engine seekToTime:expectD];
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
                [sself.karaokeControllersContainer resetUI];
                [sself.engine setAudioVolume:0.5];
                [sself.engine setMusicVolume:0.5];
                [sself.timeSeekSlider setValue:0];
            }
        } completionBlock:^{
            
        }];
    }
}
#endif

@end

NS_ASSUME_NONNULL_END
//
//@implementation LSLiveAudioUnitConfig (TTSDK)
//
//- (BOOL)newPlayerMode {
//    return YES;
//}

//@end
