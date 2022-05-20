//
//  TTVideoPlayerControlsController.m
//  TTVideoPlayerDemo
//
//  Created by 刘廷勇 on 2016/11/17.
//
//

#import "TTVideoPlayerControlsController.h"
#import "TTVideoPlayerControlTopView.h"
#import "TTVideoPlayerControlBottomView.h"
#import "TTVideoPlayerLoadingView.h"
#import "TTVideoResolutionOptionsView.h"
#import "TTVideoSettingView.h"

static NSString *const kLoadingViewKeyPath = @"hidden";
static NSString *const kIsDoing = @"正在开发中...";

@interface TTVideoPlayerControlsController ()<TTVideoSettingViewDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) TTVideoPlayerControlTopView *topView;
@property (nonatomic, strong) TTVideoPlayerControlBottomView *bottomView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) TTVideoPlayerLoadingView *loadingView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, readwrite, getter=isInteractive) BOOL interactive;
@property (nonatomic, assign) BOOL needHide;
@property (nonatomic, strong) TTVideoSettingView *settingView;
@property (nonatomic, strong) TTVideoResolutionOptionsView *resolutionOptionsView;
@property (nonatomic,   copy) NSArray *resolutionStrings;

@end

@implementation TTVideoPlayerControlsController
@synthesize needHide = _needHide;

- (void)dealloc {
    [self.view removeGestureRecognizer:_tapGesture];
    [_loadingView removeObserverBlocksForKeyPath:kLoadingViewKeyPath];
}

- (void)setUpUI {
    [super setUpUI];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.containerView];
    [self.view addSubview:self.loadingView];
    [self.containerView addSubview:self.topView];
    [self.containerView addSubview:self.bottomView];
    [self.containerView addSubview:self.playBtn];
    [self.view addSubview:self.settingView];
    [self.view addSubview:self.resolutionOptionsView];
}

- (void)buildUI {
    [super buildUI];
    
    [self.view addGestureRecognizer:self.tapGesture];
    
    @weakify(self)
    [self.loadingView addObserverBlockForKeyPath:kLoadingViewKeyPath block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        @strongify(self)
        if (!self) {
            return;
        }
        
       dispatch_async_on_main_queue(^{
            BOOL hidden = [newVal boolValue];
            self.playBtn.hidden = !hidden;
        });
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.containerView.frame = self.view.bounds;
    self.settingView.frame = self.view.bounds;
    self.resolutionOptionsView.frame = self.view.bounds;
    self.topView.left = 0.0;
    self.topView.top = 0.0;
    self.topView.width = self.containerView.width;
    self.topView.height = TT_BASE_375(40.0) + STATUS_BAR_BOTTOM;
    
    self.bottomView.left = 0.0;
    self.bottomView.height = TT_BASE_375(60.0);
    self.bottomView.top = self.containerView.height - self.bottomView.height - (self.verticalScreen && self.fullScreen ? SAFE_AREA_BOTTOM : 0.0);
    self.bottomView.width = self.containerView.width;
    
    self.playBtn.center = CGPointMake(self.containerView.width * 0.5, self.containerView.height * 0.5);
    
    self.loadingView.center = CGPointMake(self.view.width * 0.5, self.view.height * 0.5);
    self.loadingView.width = self.loadingView.height = TT_BASE_375(140);
    self.debugView.frame = self.view.bounds;
}

- (void)setDebugView:(UIView *)debugView {
    _debugView = debugView;
    
    [self.view insertSubview:debugView atIndex:0];
}

- (void)setShow:(BOOL)show {
    _show = show;
    
    [[UIApplication sharedApplication] setStatusBarHidden:(!show && self.fullScreen) withAnimation:UIStatusBarAnimationFade];
    [self _tryToHidden];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.alpha = show ? 1 : 0;
    }];
}

- (void)setPlay:(BOOL)play {
    _play = play;
    
    [self _tryToHidden];
    
    [self.playBtn setBackgroundImage:[UIImage imageNamed:(play  ? @"tt_video_player_pause" : @"tt_video_player_play")] forState:UIControlStateNormal];
    !play ?: [self stopLoading];
}

- (BOOL)isInteractive {
    _interactive = self.bottomView.playbackControl.interactive;
    return _interactive;
}

- (void)setTimeDuration:(NSTimeInterval)timeDuration {
    _timeDuration = timeDuration;
    
    self.bottomView.playbackControl.timeDuration = timeDuration;
}

- (void)setTitleInfo:(NSString *)titleInfo {
    _titleInfo = titleInfo;
    
    self.topView.titleInfo = titleInfo;
}

- (void)setFullScreen:(BOOL)fullScreen {
    _fullScreen = fullScreen;
    
    self.topView.fullScreen = fullScreen;
    self.bottomView.fullScreen = fullScreen;
    
    [[UIApplication sharedApplication] setStatusBarHidden:(!self.show && self.fullScreen) withAnimation:UIStatusBarAnimationFade];
    [self.view setNeedsLayout];[self.view setNeedsDisplay];
    [self.topView setNeedsLayout];[self.topView setNeedsDisplay];
    [self.bottomView setNeedsLayout];[self.bottomView setNeedsDisplay];
}

- (void)setVerticalScreen:(BOOL)verticalScreen {
    _verticalScreen = verticalScreen;
    //
    self.topView.verticalScreen = verticalScreen;
    self.bottomView.verticalScreen = verticalScreen;
    self.resolutionOptionsView.verticalScreen = verticalScreen;
    self.settingView.verticalScreen = verticalScreen;
}
    
- (void)setCurrentPlayingTime:(NSTimeInterval)currentPlayingTime {
    _currentPlayingTime = currentPlayingTime;
    
    CGFloat progress = self.timeDuration > 0 ? (currentPlayingTime  / self.timeDuration) : 0;
    [self.bottomView.playbackControl setProgress:progress animated:NO];
}

- (void)setNeedHide:(BOOL)needHide {
    _needHide = needHide;
    
    [self _hideIfNeeded];
}

- (void)setCacheProgress:(CGFloat)progress animated:(BOOL)animated {
    [self.bottomView.playbackControl setCacheProgress:progress animated:animated];
}

- (void)startLoading {
    [self.loadingView startLoading];
}

- (void)stopLoading {
    [self.loadingView stopLoading];
}

- (void)showRetry {
    [self.loadingView showRetry];
}

- (void)setResolutionIndex:(NSInteger)resolutionIndex {
    _resolutionIndex = resolutionIndex;
    
    NSArray *temArray = tt_resolution_strings();
    if (resolutionIndex >= 0 && resolutionIndex < temArray.count) {
        self.bottomView.resolutionString = temArray[resolutionIndex];
    }
}

- (NSArray *)resolutionStrings {
    NSArray *temArray = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(resolutionsForControls:)]) {
        temArray = [self.dataSource resolutionsForControls:self];
    }
    _resolutionStrings = temArray;
    return _resolutionStrings;
}

/// MARK: - Private Method

- (void)_tryToHidden {
    self.needHide = self.isShowing && self.isPlaying && !self.bottomView.playbackControl.isInteractive && self.resolutionOptionsView.hidden;
}

- (void)_showMoreSettingView {
    [self.settingView show];
}

- (void)_tap:(UITapGestureRecognizer *)tap {
    self.show = !self.isShowing;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlsViewController:showStatus:)]) {
        [self.delegate controlsViewController:self showStatus:self.show];
    }
}

- (void)_playButtonClicked:(UIButton *)sender {
    self.play = !self.isPlaying;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlsViewController:playStatus:)]) {
        [self.delegate controlsViewController:self playStatus:self.play];
    }
}

- (void)_hideIfNeeded {
    if (self.needHide) {
        //3s后自动消失
        [self performSelector:@selector(setShow:) withObject:nil afterDelay:3];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setShow:) object:nil];
    }
}

- (void)_showResolutionOptions {
    if (self.resolutionStrings && self.resolutionStrings.count > 0) {
        self.resolutionOptionsView.titles = self.resolutionStrings;
        self.resolutionOptionsView.selectedIndex = self.resolutionIndex;
        [self.resolutionOptionsView showAtPoint:self.bottomView.needShowResolutionPosition];
        [self _tryToHidden];
    }
}

- (void)_showTips:(NSString *)tips finished:(void(^)(BOOL finished))end {
    if (tips == nil || tips.length < 1) {
        return;
    }
    [self.containerView addSubview:self.tipLab];
    
    self.tipLab.text = tips;
    CGFloat width = [self.tipLab.text widthForFont:self.tipLab.font] + TT_BASE_375(20);
    self.tipLab.frame = CGRectMake((self.containerView.width - width) * 0.5, self.containerView.height - TT_BASE_375(75.0), width, TT_BASE_375(40));
    self.tipLab.hidden = NO;
    [UIView animateWithDuration:2 animations:^{
        self.tipLab.alpha = 0.0;
    } completion:^(BOOL finished) {
        !end ?: end(finished);
    }];
}

/// MARK: - TTVideoSettingViewDelegate

- (void)settingView:(TTVideoSettingView *)moreView downloadBtn:(UIButton *)downloadBtn {
    [self _showTips:kIsDoing finished:^(BOOL finished) {
        [self.tipLab removeFromSuperview];
        self.tipLab.alpha = 1.0;
    }];
}

- (void)settingView:(TTVideoSettingView *)moreView airPlayBtn:(UIButton *)airPlayBtn {
    [self _showTips:kIsDoing finished:^(BOOL finished) {
        [self.tipLab removeFromSuperview];
        self.tipLab.alpha = 1.0;
    }];
}

- (void)settingView:(TTVideoSettingView *)moreView barrageBtn:(UIButton *)barrageBtn {
    [self _showTips:kIsDoing finished:^(BOOL finished) {
        [self.tipLab removeFromSuperview];
        self.tipLab.alpha = 1.0;
    }];
}

- (void)settingView:(TTVideoSettingView *)moreView speed:(CGFloat)speedValue {
    if (speedValue < 0.5 || speedValue > 2.0) {
        return;
    }
    
    NSString *tip = [NSString stringWithFormat:@"切换到 %.2fx 倍速",speedValue];
    [self _showTips:tip finished:^(BOOL finished) {
        [self.tipLab removeFromSuperview];
        self.tipLab.alpha = 1.0;
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlsViewController:playBackSpeed:)]) {
        [self.delegate controlsViewController:self playBackSpeed:speedValue];
    }
}

- (void)settingView:(TTVideoSettingView *)moreView muted:(BOOL)isMuted {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlsViewController:muted:)]) {
        [self.delegate controlsViewController:self muted:isMuted];
    }
}

- (void)settingView:(TTVideoSettingView *)moreView mixWithOther:(BOOL)isOn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlsViewController:mixWithOther:)]) {
        [self.delegate controlsViewController:self mixWithOther:isOn];
    }
}
    
- (BOOL)prefersStatusBarHidden {
    return self.fullScreen && !self.show;
}

/// MARK: - Getter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.alpha = 0;
    }
    return _containerView;
}

- (TTVideoPlayerControlTopView *)topView {
    if (!_topView) {
        _topView = [[TTVideoPlayerControlTopView alloc] init];
        @weakify(self)
        [_topView setClickCall:^(ButtonClickType clickType) {
            @strongify(self)
            if (!self) {
                return;
            }
            if (clickType == ButtonClickTypeBack) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(controlsViewController:fullScreen:)]) {
                    [self.delegate controlsViewController:self fullScreen:NO];
                }
            } else if (clickType == ButtonClickTypeMore) {
                [self _showMoreSettingView];
            }
        }];
    }
    return _topView;
}

- (TTVideoPlayerControlBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[TTVideoPlayerControlBottomView alloc] init];
        @weakify(self)
        [_bottomView.playbackControl setSeekCall:^(CGFloat progress) {
            @strongify(self)
            if (!self) {
                return;
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(controlsViewController:changeProgress:)]) {
                [self.delegate controlsViewController:self changeProgress:progress];
            }
        }];
        [_bottomView setDidClickFullScreenButton:^(BOOL toFullScreen) {
            @strongify(self)
            if (!self) {
                return;
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(controlsViewController:fullScreen:)]) {
                [self.delegate controlsViewController:self fullScreen:toFullScreen];
            }
        }];
        [_bottomView setDidClickResolutionButton:^{
            @strongify(self)
            if (!self) {
                return;
            }
            
            [self _showResolutionOptions];
        }];
    }
    return _bottomView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        _playBtn.size = CGSizeMake(TT_BASE_375(78), TT_BASE_375(72));
        [_playBtn addTarget:self action:@selector(_playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (TTVideoPlayerLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[TTVideoPlayerLoadingView alloc] init];
        
        @weakify(self)
        [_loadingView setRetryCall:^{
            @strongify(self)
            if (!self) {
                return;
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(controlsViewController:retry:)]) {
                [self.delegate controlsViewController:self retry:0];
            }
        }];
    }
    return _loadingView;
}

- (TTVideoSettingView *)settingView {
    if (_settingView == nil) {
        _settingView = [[TTVideoSettingView alloc] initWithFrame:self.view.bounds];
        _settingView.delegate = self;
    }
    return _settingView;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tap:)];
    }
    return _tapGesture;
}

- (TTVideoResolutionOptionsView *)resolutionOptionsView {
    if (_resolutionOptionsView == nil) {
        _resolutionOptionsView = [[TTVideoResolutionOptionsView alloc] initWithFrame:self.view.bounds];
        
        @weakify(self)
        [_resolutionOptionsView setClickCall:^(NSInteger index) {
            @strongify(self)
            if (!self) {
                return;
            }
            
            NSString *tips = [NSString stringWithFormat:@"正在切换到 %@",self.resolutionStrings[index]];
            [self _showTips:tips finished:^(BOOL finished) {
                [self.tipLab removeFromSuperview];
                self.tipLab.alpha = 1.0;
            }];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(controlsViewController:changeResolution:)]) {
                [self.delegate controlsViewController:self changeResolution:index];
            }
        }];
    }
    return _resolutionOptionsView;
}

- (UILabel *)tipLab {
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] init];
        _tipLab.font = TT_FONT(14);
        _tipLab.backgroundColor = TT_COLOR(0, 0, 0, 0.9);
        _tipLab.textColor = TT_COLOR_HEX(@"#FFFFFF");
        _tipLab.layer.cornerRadius = TT_BASE_375(5.0);
        _tipLab.layer.masksToBounds = YES;
        _tipLab.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLab;
}

@end
