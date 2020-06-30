//
//  TTVideoPlayerControlBottomView.m
//  TTVideoPlayerDemo
//
//  Created by 刘廷勇 on 2016/11/22.
//
//

#import "TTVideoPlayerControlBottomView.h"

static const CGFloat kGradientHeight = 80.0f;

@interface TTVideoPlayerControlBottomView ()

@property (nonatomic, strong) TTVideoPlayerControlView *playbackControl;
@property (nonatomic, strong) UIButton *fullScreenBtn;
@property (nonatomic, strong) UIButton *resolutionBtn;
@property (nonatomic, strong) CAGradientLayer *gradientMaskLayer;

/// 通过isFullScreen和enableResolutionControl共同控制
@property (nonatomic) BOOL realEnableResolution;;

@end

@implementation TTVideoPlayerControlBottomView

- (void)setUpUI {
    [super setUpUI];
    
    self.fullScreen = NO;
    
    [self.layer addSublayer:self.gradientMaskLayer];
    [self addSubview:self.playbackControl];
    [self addSubview:self.fullScreenBtn];
    [self addSubview:self.resolutionBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect layerFrame = CGRectMake(0, 0, self.frame.size.width, kGradientHeight);
    layerFrame.origin.y = self.frame.size.height - layerFrame.size.height;
    self.gradientMaskLayer.frame = layerFrame;
    
    self.fullScreenBtn.centerY = self.height * 0.5;
    if (self.fullScreen && !self.verticalScreen) {
        self.fullScreenBtn.right = self.width - TT_EDGE - SAFE_AREA_BOTTOM;
    } else {
        self.fullScreenBtn.right = self.width - TT_EDGE;
    }
    
    [self.resolutionBtn sizeToFit];
    self.resolutionBtn.centerY = self.fullScreenBtn.centerY;
    self.resolutionBtn.right = self.fullScreenBtn.left - TT_EDGE;
    
    if (self.fullScreen && !self.verticalScreen) {
        self.playbackControl.left = SAFE_AREA_BOTTOM;
    } else {
        self.playbackControl.left = 0.0f;
    }
    self.playbackControl.top = 0.0f;
    self.playbackControl.height = self.height;
    UIView *view = self.realEnableResolution ? self.resolutionBtn : self.fullScreenBtn;
    self.playbackControl.width = view.left - self.playbackControl.left;
}

- (void)setFullScreen:(BOOL)fullScreen {
    _fullScreen = fullScreen;
    
    [self.fullScreenBtn setBackgroundImage:[UIImage imageNamed:(fullScreen ? @"tt_video_smallscreen":@"tt_video_fullscreen")] forState:UIControlStateNormal];
    
    self.realEnableResolution = fullScreen || self.enableResolutionControl;
}

- (void)setEnableResolutionControl:(BOOL)enableResolutionControl {
    _enableResolutionControl = enableResolutionControl;
    
    self.realEnableResolution = self.fullScreen || enableResolutionControl;
}

- (void)setRealEnableResolution:(BOOL)realEnableResolution {
    _realEnableResolution = realEnableResolution;
    
    self.resolutionBtn.hidden = !realEnableResolution;
}

- (CGPoint)needShowResolutionPosition {
    CGPoint point = CGPointMake(self.resolutionBtn.left + self.resolutionBtn.width * 0.5, self.resolutionBtn.top + TT_BASE_375(2.0));
    return [self convertPoint:point toViewOrWindow:self.superview];
}

- (void)setResolutionString:(NSString *)resolutionString {
    _resolutionString = resolutionString;
    
    [_resolutionBtn setTitle:resolutionString?:@"画质" forState:UIControlStateNormal];
    [self setNeedsLayout];
}

/// MARK: - Private method

- (void)_fullScreenBtnClicked:(UIButton *)sender {
    if (self.didClickFullScreenButton) {
        self.didClickFullScreenButton(!self.isFullScreen);
    }
}

- (void)_resolutionBtnClicked:(UIButton *)sender {
    if (self.didClickResolutionButton) {
        self.didClickResolutionButton();
    }
}

/// MARK: - Getter

- (TTVideoPlayerControlView *)playbackControl {
    if (!_playbackControl) {
        _playbackControl = [[TTVideoPlayerControlView alloc] init];
        _playbackControl.backgroundColor = [UIColor clearColor];
    }
    return _playbackControl;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [[UIButton alloc] init];
        [_fullScreenBtn setTintColor:TT_COLOR(255, 255, 255, 1.0)];
        _fullScreenBtn.size = CGSizeMake(TT_BASE_375(30), TT_BASE_375(30));
        _fullScreenBtn.tt_hitTestEdgeInsets = UIEdgeInsetsMake(-20, -30, -20, -30);
        [_fullScreenBtn addTarget:self action:@selector(_fullScreenBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}

- (UIButton *)resolutionBtn {
    if (!_resolutionBtn) {
        _resolutionBtn = [[UIButton alloc] init];
        _resolutionBtn.size = CGSizeMake(TT_BASE_375(40), TT_BASE_375(30));
        _resolutionBtn.tt_hitTestEdgeInsets = UIEdgeInsetsMake(-20, -20, -20, -20);
        [_resolutionBtn setTitle:@"画质" forState:UIControlStateNormal];
        _resolutionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_resolutionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_resolutionBtn addTarget:self action:@selector(_resolutionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resolutionBtn;
}

- (CAGradientLayer *)gradientMaskLayer {
    if (!_gradientMaskLayer) {
        _gradientMaskLayer = [CAGradientLayer layer];
        _gradientMaskLayer.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:0.00].CGColor,
                                      (__bridge id)[UIColor colorWithWhite:0 alpha:0.06].CGColor,
                                      (__bridge id)[UIColor colorWithWhite:0 alpha:0.13].CGColor,
                                      (__bridge id)[UIColor colorWithWhite:0 alpha:0.25].CGColor,
                                      (__bridge id)[UIColor colorWithWhite:0 alpha:0.38].CGColor,
                                      (__bridge id)[UIColor colorWithWhite:0 alpha:0.44].CGColor,
                                      (__bridge id)[UIColor colorWithWhite:0 alpha:0.50].CGColor];
        _gradientMaskLayer.locations = @[@0.00,
                                         @0.35,
                                         @0.50,
                                         @0.70,
                                         @0.85,
                                         @0.95,
                                         @1.00];
    }
    return _gradientMaskLayer;
}

@end
