//
//  TTVideoSettingView.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/11.


#import "TTVideoSettingView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TTVideoSwitch.h"

#define kOffset  TT_BASE_375(10.0f)
#define CONTAINER_WIDTH  TT_BASE_375(300.0)
#define LEFT_INSET  TT_BASE_375(30.0)

static const NSInteger kDownloadTag = 666;
static const NSInteger kAirPlayTag  = 888;
static const NSInteger kBarrageTag  = 999;
static NSArray *kSpeedStrings = nil;

@interface TTVideoSettingView()

@property (nonatomic, strong) UIView *containsView;
@property (nonatomic, strong) UIButton *downLoadBtn;
@property (nonatomic, strong) UIButton *airplayBtn;
@property (nonatomic, strong) UIButton *barrageBtn;
@property (nonatomic, strong) UIView *playLineView;
@property (nonatomic, strong) UILabel *speedLab;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *leftVolumeIV;
@property (nonatomic, strong) UISlider *volumeSlider;
@property (nonatomic, strong) UIImageView *rightVolumeIV;
@property (nonatomic, strong) UIImageView *leftBrightIV;
@property (nonatomic, strong) UISlider *brightSlider;
@property (nonatomic, strong) UIImageView *rightBrightIV;
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;
@property (nonatomic, strong) UIGestureRecognizer *tapGesture;
@property (nonatomic, strong) TTVideoSwitch *mutedSwitch;
@property (nonatomic, strong) TTVideoSwitch *mixSwitch;

@end

@implementation TTVideoSettingView 

- (void)setUpUI {
    [super setUpUI];
    kSpeedStrings = @[@"1.0X", @"1.25X", @"1.5X", @"2X"];
    
    self.hidden = YES;
    [self addSubview:self.containsView];
    [self.containsView addSubview:self.downLoadBtn];
    [self.containsView addSubview:self.airplayBtn];
    [self.containsView addSubview:self.barrageBtn];
    [self.containsView addSubview:self.playLineView];
    [self.containsView addSubview:self.speedLab];
    [self.containsView addSubview:self.segmentedControl];
    [self.containsView addSubview:self.lineView];
    [self.containsView addSubview:self.leftVolumeIV];
    [self.containsView addSubview:self.volumeSlider];
    [self.containsView addSubview:self.rightVolumeIV];
    [self.containsView addSubview:self.leftBrightIV];
    [self.containsView addSubview:self.brightSlider];
    [self.containsView addSubview:self.rightBrightIV];
    [self.containsView addSubview:self.mutedSwitch];
    [self.containsView addSubview:self.mixSwitch];
    [self addGestureRecognizer:self.tapGesture];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    if (_containsView.frame.origin.x == width) {
        return;
    }
    if ([self _isPortrait]) {
        self.hidden = YES;
    }
    CGFloat containerWidth = CONTAINER_WIDTH + (self.verticalScreen ? 0.0 : SAFE_AREA_BOTTOM);
    CGFloat buttonWith = TT_BASE_375(60);
    CGFloat imgWith = TT_BASE_375(30);
    
    _containsView.frame = CGRectMake(width - containerWidth, 0.0, containerWidth, height);
    _downLoadBtn.frame = CGRectMake(LEFT_INSET, LEFT_INSET, buttonWith, buttonWith);
    _airplayBtn.frame = CGRectMake((CONTAINER_WIDTH - buttonWith) * 0.5, _downLoadBtn.top, buttonWith, buttonWith);
    _barrageBtn.frame = CGRectMake(CONTAINER_WIDTH - LEFT_INSET - buttonWith, _downLoadBtn.top, buttonWith, buttonWith);
    CGFloat lineTop = (_barrageBtn.hidden ? TT_BASE_375(40) : _barrageBtn.bottom + TT_BASE_375(20)) + (self.verticalScreen ? NAVIGATIONBAR_BOTTOM : 0.0);
    _playLineView.frame = CGRectMake(0,lineTop, CONTAINER_WIDTH, TT_ONE_PIXEL);
    _speedLab.center = _playLineView.center;
    _segmentedControl.frame = CGRectMake(LEFT_INSET, _speedLab.bottom + TT_BASE_375(20), CONTAINER_WIDTH - LEFT_INSET * 2, LEFT_INSET);
    _lineView.frame = CGRectMake(0, _segmentedControl.bottom + TT_BASE_375(20), CONTAINER_WIDTH, TT_ONE_PIXEL);
    
    _leftVolumeIV.frame = CGRectMake(LEFT_INSET, _lineView.bottom + TT_BASE_375(20), imgWith, imgWith);
    _volumeSlider.frame = CGRectMake(_leftVolumeIV.right + TT_BASE_375(10), 0, CONTAINER_WIDTH-2*imgWith-2*TT_BASE_375(10)-2*LEFT_INSET, imgWith);
    _rightVolumeIV.frame = CGRectMake(CONTAINER_WIDTH - LEFT_INSET - imgWith,0,imgWith,imgWith);
    _rightVolumeIV.centerY = _volumeSlider.centerY = _leftVolumeIV.centerY;
    
    _leftBrightIV.frame = CGRectMake(LEFT_INSET, _rightVolumeIV.bottom + TT_BASE_375(20), imgWith, imgWith);
    _brightSlider.frame = CGRectMake(_leftBrightIV.right + TT_BASE_375(10), 0, _volumeSlider.width, imgWith);
    _rightBrightIV.frame = CGRectMake(_rightVolumeIV.left, 0 , imgWith, imgWith);
    _rightBrightIV.centerY = _brightSlider.centerY = _leftBrightIV.centerY;
    
    _mutedSwitch.left = _downLoadBtn.left;
    _mutedSwitch.top = _brightSlider.bottom + TT_BASE_375(20.0);
    _mixSwitch.right = _barrageBtn.right;
    _mixSwitch.top = _mutedSwitch.top;
}

- (void)volumeSliderChangeValue:(UISlider *)sender {
    self.musicPlayer.volume = sender.value;
}

- (void)brightSliderChangeValue:(UISlider *)sender {
    [UIScreen mainScreen].brightness = sender.value;
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        if ([self _isPortrait]) {//竖屏
            self.hidden = YES;
        }else{//横屏
            self.hidden = NO;
            CGRect frame = self.containsView.frame;
            frame.origin.x = self.frame.size.width - self.containsView.width;
            self.containsView.frame = frame;
        }
    } completion:^(BOOL finished) {
    }];
}

/// MARK: - Private method

- (void)_btnClicked:(UIButton *)btn {
    [self _hiddenShow:^(BOOL finished) {
        self.hidden = YES;
    }];
    
    if (btn.tag == kDownloadTag) {
        if ([self.delegate respondsToSelector:@selector(settingView:downloadBtn:)]) {
            [self.delegate settingView:self downloadBtn:btn];
        }
    } else if (btn.tag == kAirPlayTag) {
        if ([self.delegate respondsToSelector:@selector(settingView:airPlayBtn:)]) {
            [self.delegate settingView:self airPlayBtn:btn];
        }
    } else if (btn.tag == kBarrageTag) {
        if ([self.delegate respondsToSelector:@selector(settingView:barrageBtn:)]) {
            [self.delegate settingView:self barrageBtn:btn];
        }
    }
}

- (void)_segmentedControlClicked:(UISegmentedControl *)sender {
    [self _hiddenShow:^(BOOL finished) {
        self.hidden = YES;
    }];
    
    if ([self.delegate respondsToSelector:@selector(settingView:speed:)]) {
        float speedValue = sender.selectedSegmentIndex * 0.25 + 1;
        if (sender.selectedSegmentIndex == 3) {
            speedValue = 2.0;
        }
        
        [self.delegate settingView:self speed:speedValue];
    }
}

- (BOOL)_isPortrait {
    return self.width < SCREEN_HEIGHT && !self.verticalScreen;
}

- (void)_hiddenShow:(void(^)(BOOL finished))end {
    if (!self.hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            if ([self _isPortrait]) {
                self.hidden = YES;
            }else{
                CGRect frame = self.containsView.frame;
                frame.origin.x = self.width;
                self.containsView.frame = frame;
            }
        } completion:^(BOOL finished) {
            !end ?: end(finished);
        }];
    }
}

- (void)_tapEvent:(UIGestureRecognizer *)gesture {
    [self _hiddenShow:^(BOOL finished) {
        self.hidden = YES;
    }];
}

/// MARK: - Getter

- (UIView *)containsView {
    if (!_containsView) {
        _containsView = [[UIView alloc] init];
        _containsView.backgroundColor = TT_COLOR(28, 31, 33, 0.9);
    }
    return _containsView;
}

- (UIButton *)downLoadBtn {
    if (!_downLoadBtn) {
        _downLoadBtn = [self _getBtn:@"下载" img:@"tt_video_setting_download" tag:kDownloadTag];
    }
    return _downLoadBtn;
}

- (UIButton *)airplayBtn {
    if (!_airplayBtn) {
        _airplayBtn = [self _getBtn:@"投屏" img:@"tt_video_setting_airport" tag:kAirPlayTag];
    }
    return _airplayBtn;
}

- (UIButton *)barrageBtn {
    if (!_barrageBtn) {
        _barrageBtn = [self _getBtn:@"弹幕设置" img:@"tt_video_setting_barrage" tag:kBarrageTag];
    }
    return _barrageBtn;
}

- (UIButton *)_getBtn:(NSString *)title img:(NSString *)imgName tag:(NSInteger)tag{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = tag;
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.titleLabel.font = TT_FONT(12.0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, - btn.imageView.width, -btn.imageView.height -kOffset * 0.5, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(-btn.titleLabel.intrinsicContentSize.height - kOffset * 0.5, 0, 0, -btn.titleLabel.intrinsicContentSize.width);
    [btn addTarget:self action:@selector(_btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn.hidden = YES; // doing
    return btn;
}


- (UIView *)playLineView {
    if (!_playLineView) {
        _playLineView = [[UIView alloc] init];
        _playLineView.backgroundColor = [UIColor grayColor];
    }
    return _playLineView;
}

- (UILabel *)speedLab {
    if (!_speedLab) {
        _speedLab = [[UILabel alloc] init];
        _speedLab.backgroundColor = TT_COLOR(28, 31, 33, 0.9);
        _speedLab.textAlignment = NSTextAlignmentCenter;
        _speedLab.text = @"倍速播放";
        _speedLab.textColor = TT_COLOR_HEX(@"#FFFFFF");
        _speedLab.font = TT_FONT(12.0);
        _speedLab.frame = CGRectMake(0, 0, TT_BASE_375(70), TT_BASE_375(15));
        
    }
    return _speedLab;
}

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:kSpeedStrings];
        _segmentedControl.backgroundColor = [UIColor clearColor];
        _segmentedControl.selectedSegmentIndex = 0;
        _segmentedControl.tintColor = [UIColor clearColor];
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:TT_FONT_BLOD(14.0),
                                                 NSForegroundColorAttributeName: TT_THEME_COLOR};
        [_segmentedControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                                                   NSForegroundColorAttributeName: [UIColor whiteColor]};
        [_segmentedControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
        [_segmentedControl addTarget:self action:@selector(_segmentedControlClicked:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _segmentedControl;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor grayColor];
    }
    return _lineView;
}

- (UIImageView *)leftVolumeIV {
    if (!_leftVolumeIV) {
        _leftVolumeIV = [[UIImageView alloc] init];
        _leftVolumeIV.image = [UIImage imageNamed:@"tt_video_sound"];
    }
    return _leftVolumeIV;
}

- (UISlider *)volumeSlider {
    if (!_volumeSlider) {
        _volumeSlider = [[UISlider alloc] init];
        [_volumeSlider setThumbImage:[UIImage imageNamed:@"tt_video_slider_dot"] forState:UIControlStateNormal];
        [_volumeSlider setThumbImage:[UIImage imageNamed:@"tt_video_slider_dot"] forState:UIControlStateHighlighted];
        [_volumeSlider setValue:self.musicPlayer.volume];
        [_volumeSlider setMinimumTrackTintColor:TT_THEME_COLOR];
        [_volumeSlider addTarget:self action:@selector(volumeSliderChangeValue:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _volumeSlider;
}

- (UIImageView *)rightVolumeIV {
    if (!_rightVolumeIV) {
        _rightVolumeIV = [[UIImageView alloc] init];
        _rightVolumeIV.image = [UIImage imageNamed:@"tt_video_big_sound"];
    }
    return _rightVolumeIV;
}

- (UIImageView *)leftBrightIV {
    if (!_leftBrightIV) {
        _leftBrightIV = [[UIImageView alloc] init];
        _leftBrightIV.image = [UIImage imageNamed:@"tt_video_small_brightness"];
    }
    return _leftBrightIV;
}

- (UISlider *)brightSlider {
    if (!_brightSlider) {
        _brightSlider = [[UISlider alloc] init];
        [_brightSlider setThumbImage:[UIImage imageNamed:@"tt_video_slider_dot"] forState:UIControlStateNormal];
        [_brightSlider setThumbImage:[UIImage imageNamed:@"tt_video_slider_dot"] forState:UIControlStateHighlighted];
        [_brightSlider setValue:[UIScreen mainScreen].brightness];
        [_brightSlider setMinimumTrackTintColor:TT_THEME_COLOR];
        [_brightSlider addTarget:self action:@selector(brightSliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _brightSlider;
}

- (UIImageView *)rightBrightIV {
    if (!_rightBrightIV) {
        _rightBrightIV = [[UIImageView alloc] init];
        _rightBrightIV.image = [UIImage imageNamed:@"tt_video_big_brightness"];
    }
    return _rightBrightIV;
}


- (MPMusicPlayerController *)musicPlayer {
    if (!_musicPlayer) {
        _musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    }
    return _musicPlayer;
}

- (UIGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapEvent:)];
    }
    return _tapGesture;
}

- (TTVideoSwitch *)mutedSwitch {
    if (_mutedSwitch == nil) {
        _mutedSwitch = [TTVideoSwitch switchWithTitle:@"静音"];
        [_mutedSwitch sizeToFit];
        @weakify(self)
        [_mutedSwitch setSwitchCall:^(ButtonClickType clickType) {
           @strongify(self)
            if (!self) {
                return;
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(settingView:muted:)]) {
                [self.delegate settingView:self muted:clickType == ButtonClickTypeOn];
            }
        }];
    }
    return _mutedSwitch;
}

- (TTVideoSwitch *)mixSwitch {
    if (_mixSwitch == nil) {
        _mixSwitch = [TTVideoSwitch switchWithTitle:@"混播"];
        [_mixSwitch sizeToFit];
        @weakify(self)
        [_mixSwitch setSwitchCall:^(ButtonClickType clickType) {
            @strongify(self)
            if (!self) {
                return;
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(settingView:mixWithOther:)]) {
                [self.delegate settingView:self mixWithOther:clickType == ButtonClickTypeOn];
            }
        }];
    }
    return _mixSwitch;
}

@end
