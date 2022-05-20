//
//  TTVideoPlayerFullScreenManager.m
//  TTVideoPlayerDemo
//
//  Created by 刘廷勇 on 2016/12/2.
//
//

#import "TTVideoPlayerFullScreenManager.h"

@interface TTVideoPlayerFullScreenManager ()

@property (nonatomic, weak) UIView *playerView;
@property (nonatomic, weak) UIView *playerSuperview;
@property (nonatomic, strong) UIView *backgroundView; //_flipUpsideDown时，避免露出后面背景，做个黑色遮盖
@property (nonatomic, readwrite, getter=isFullScreen) BOOL fullScreen;
@property (nonatomic) CGRect originalFrame;
@property (nonatomic) UIDeviceOrientation lastDeviceOrientation;

@end

@implementation TTVideoPlayerFullScreenManager

- (void)dealloc {
    [self endMonitor];
}

- (instancetype)initWithPlayerView:(UIView *)playerView {
    self = [super init];
    if (self) {
        self.playerView = playerView;
        _fullScreen = NO;
    }
    return self;
}

- (void)beginMonitor {
    [self _beginMonitorDeviceOrientationChange];
}

- (void)endMonitor {
    [self _endMonitorDeviceOrientationChange];
}

- (void)setFullScreen:(BOOL)fullScreen animated:(BOOL)animated {
    if (self.verticalScreen && fullScreen) {
        [self _verticalScreenUseAnimated:animated];
    } else {
        if (fullScreen) {
            [self _rotateToDeviceOrientation:UIDeviceOrientationLandscapeLeft animated:animated];
        } else {
            [self _rotateToDeviceOrientation:UIDeviceOrientationPortrait animated:animated];
        }
    }
}

/// MARK: - Private method

- (void)_beginMonitorDeviceOrientationChange {
    UIDevice *device = [UIDevice currentDevice];
    [device beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)_endMonitorDeviceOrientationChange {
    UIDevice *device = [UIDevice currentDevice];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [device endGeneratingDeviceOrientationNotifications];
}

- (void)_orientationChanged:(NSNotification *)notification {
    if (self.verticalScreen) {
        return;
    }
    //
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown ||
        deviceOrientation == UIDeviceOrientationFaceUp ||
        deviceOrientation == UIDeviceOrientationFaceDown ||
        deviceOrientation == self.lastDeviceOrientation) {
        return;
    }
    [self _rotateToDeviceOrientation:deviceOrientation animated:YES];
}

- (void)_rotateToDeviceOrientation:(UIDeviceOrientation)deviceOrientation animated:(BOOL)animated {
    [self _rotateStatusBarToDeviceOrientation:deviceOrientation animated:animated];
    [self _rotatePlayerToDeviceOrientation:deviceOrientation animated:animated];
    self.lastDeviceOrientation = deviceOrientation;
}

- (void)_rotateStatusBarToDeviceOrientation:(UIDeviceOrientation)deviceOrientation animated:(BOOL)animated {
    UIInterfaceOrientation interfaceOrientation = UIInterfaceOrientationPortrait;
    switch (deviceOrientation) {
        case UIDeviceOrientationLandscapeLeft:
            interfaceOrientation = UIInterfaceOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            interfaceOrientation = UIInterfaceOrientationLandscapeLeft;
            break;
        default:
            break;
    }
    [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation animated:animated];
}

- (void)_verticalScreenUseAnimated:(BOOL)animated {
    if (CGRectEqualToRect(self.originalFrame, CGRectZero)) {
        self.originalFrame = self.playerView.frame;
    }
    UIWindow *backgroundWindow = [self mainWindow];
    self.playerSuperview = self.playerView.superview;
    if (!self.playerSuperview || self.playerSuperview == backgroundWindow) {
        return;
    }
    
    if (self.isFullScreen) return;
    self.fullScreen = YES;
    
    [backgroundWindow addSubview:self.playerView];
    [UIView animateWithDuration:animated ? 0.3 : 0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //设置顺序(必须)：frame->center->transform
        self.playerView.frame = [self fullScreenBounds];
        self.playerView.center = backgroundWindow.center;
        [self.playerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.backgroundView.frame = backgroundWindow.bounds;
        [backgroundWindow insertSubview:self.backgroundView belowSubview:self.playerView];
    }];
}
    
- (void)_rotatePlayerToDeviceOrientation:(UIDeviceOrientation)orientation animated:(BOOL)animated {
    if (CGRectEqualToRect(self.originalFrame, CGRectZero)) {
        self.originalFrame = self.playerView.frame;
    }
    
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
            if (self.lastDeviceOrientation == UIDeviceOrientationLandscapeRight) {
                [self _flipUpsideDown];
            } else {
                [self _enterFullScreenWithAngle:M_PI_2 animted:animated];
            }
            break;
        case UIDeviceOrientationLandscapeRight:
            if (self.lastDeviceOrientation == UIDeviceOrientationLandscapeLeft) {
                [self _flipUpsideDown];
            } else {
                [self _enterFullScreenWithAngle:-M_PI_2 animted:animated];
            }
            break;
        default:
            [self _exitFullScreenAnimated:animated];
            break;
    }
}

- (void)_enterFullScreenWithAngle:(CGFloat)angle animted:(BOOL)animated {
    UIWindow *backgroundWindow = [self mainWindow];
    self.playerSuperview = self.playerView.superview;
    if (!self.playerSuperview || self.playerSuperview == backgroundWindow) {
        return;
    }
    
    if (self.isFullScreen) return;
    self.fullScreen = YES;
    
    [backgroundWindow addSubview:self.playerView];
    [UIView animateWithDuration:animated ? 0.3 : 0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //设置顺序(必须)：frame->center->transform
        self.playerView.frame = [self fullScreenBounds];
        self.playerView.center = backgroundWindow.center;
        self.playerView.transform = CGAffineTransformMakeRotation(angle);
        [self.playerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.backgroundView.frame = backgroundWindow.bounds;
        [backgroundWindow insertSubview:self.backgroundView belowSubview:self.playerView];
    }];
}

- (void)_exitFullScreenAnimated:(BOOL)aniamted {
    if (!self.isFullScreen) return;
    self.fullScreen = NO;
    
    [self.backgroundView removeFromSuperview];
    [UIView animateWithDuration:aniamted ? 0.3 : 0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //设置顺序(必须)：transform->frame
        self.playerView.transform = CGAffineTransformIdentity;
        self.playerView.frame = self.originalFrame;
        [self.playerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.playerSuperview addSubview:self.playerView];
        self.originalFrame = CGRectZero;
    }];
}

- (void)_flipUpsideDown {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.playerView.transform = CGAffineTransformRotate(self.playerView.transform, M_PI);
    } completion:nil];
}

/// MARK: - Getter

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor blackColor];
    }
    return _backgroundView;
}

//全屏必须加在window上，避免被其他view遮盖的情况
- (UIWindow *)mainWindow {
    UIWindow *window = nil;
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
        window = [UIApplication sharedApplication].delegate.window;
    }
    if (!window) {
        window = [UIApplication sharedApplication].keyWindow;
    }
    return window;
}

- (CGRect)fullScreenBounds {
    CGRect bounds = [UIScreen mainScreen].bounds;
    if (!self.verticalScreen) {
        if (bounds.size.width < bounds.size.height) {
            CGFloat height = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = height;
        }
    }
    return bounds;
}

@end
