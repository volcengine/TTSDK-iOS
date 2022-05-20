//
//  TTVideoPlayerSliderView.m
//  TTVideoPlayerDemo
//
//  Created by 刘廷勇 on 2016/11/22.
//
//

#import "TTVideoPlayerSliderView.h"

static const CGFloat kSliderHeight = 3.0f;
static const CGFloat kThumbViewWidth = 14.0f;

@interface TTVideoPlayerSliderView ()

@property (nonatomic, strong) UIView *thumbView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *trackProgressView;
@property (nonatomic, strong) UIView *cacheProgressView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat cacheProgress;
@property (nonatomic, assign, getter=isInteractive) BOOL interactive;

@end

@implementation TTVideoPlayerSliderView {
    CGFloat _progressBeforeDragging;
}

- (void)setUpUI {
    [super setUpUI];
    
    [self addSubview:self.backgroundView];
    [self addSubview:self.thumbView];
    [self.backgroundView addSubview:self.cacheProgressView];
    [self.backgroundView addSubview:self.trackProgressView];
    
    [self addGestureRecognizer:self.panGesture];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self _updateLayout];
    [self _updateCacheProgress];
    [self _updateTrackProgress];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    progress = MIN(1, MAX(0, progress));
    self.progress = progress;
    
    [UIView animateWithDuration:animated ? 0.3 : 0.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self _updateTrackProgress];
    } completion:nil];
}

- (void)setCacheProgress:(CGFloat)progress animated:(BOOL)animated {
    progress = MIN(1, MAX(0, progress));
    self.cacheProgress = progress;
    
    [self _updateCacheProgress];
}

/// MARK: - Private method

- (void)_updateLayout {
    CGRect frame;
    frame.size.width = self.frame.size.width;
    frame.size.height = kSliderHeight;
    frame.origin.x = self.frame.size.width/2 - frame.size.width/2;
    frame.origin.y = self.frame.size.height/2 - frame.size.height/2;
    self.backgroundView.frame = frame;
    
    self.trackProgressView.height = self.backgroundView.height;
    self.cacheProgressView.height = self.backgroundView.height;
    
    self.thumbView.centerY = self.backgroundView.centerY;
}

- (void)_updateCacheProgress {
    self.cacheProgressView.width = self.backgroundView.frame.size.width * self.cacheProgress;
}

- (void)_updateTrackProgress {
    self.trackProgressView.width = self.backgroundView.width * self.progress;
    [self _updateThumbPosition];
}

- (void)_updateThumbPosition {
    CGFloat minCenterX = kThumbViewWidth * 0.5;
    CGFloat maxCenterX = self.backgroundView.width - kThumbViewWidth * 0.5;
    self.thumbView.centerX = [self _maxProgressWidth] * self.progress + minCenterX;
    self.thumbView.centerX = MIN(maxCenterX, MAX(minCenterX, self.thumbView.centerX));
}

- (CGFloat)_maxProgressWidth {
    return self.backgroundView.width - kThumbViewWidth;
}

- (void)_pan:(UIPanGestureRecognizer *)pan {
    UIGestureRecognizerState state = pan.state;
    CGPoint translate = [pan translationInView:self];
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            self.interactive = YES;
            _progressBeforeDragging = self.progress;
            [UIView animateWithDuration:0.3 animations:^{
                self.thumbView.transform = CGAffineTransformMakeScale(1.3, 1.3);
            }];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat progressDelta = translate.x / [self _maxProgressWidth];
            CGFloat newProgress = _progressBeforeDragging + progressDelta;
            [self setProgress:newProgress animated:NO];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed: {
            [UIView animateWithDuration:0.3 animations:^{
                self.thumbView.transform = CGAffineTransformIdentity;
            }];
            if (self.didSeekToProgress) {
                self.didSeekToProgress(self.progress);
            }
            self.interactive = NO;
        }
            break;
        default:
            break;
    }
}

/// MARK: - Getter

- (UIView *)thumbView {
    if (!_thumbView) {
        _thumbView = [[UIView alloc] init];
        _thumbView.layer.cornerRadius = kThumbViewWidth * 0.5;
        _thumbView.backgroundColor = TT_COLOR(255, 255, 255, 1.0);
        _thumbView.width = kThumbViewWidth;
        _thumbView.height = kThumbViewWidth;
        _thumbView.layer.shadowOffset = CGSizeMake(0, 2);
        _thumbView.layer.shadowOpacity = 0.4;
        _thumbView.layer.shadowRadius = 1;
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithOvalInRect:_thumbView.bounds];
        _thumbView.layer.shadowPath = shadowPath.CGPath;
        _thumbView.userInteractionEnabled = NO;
    }
    return _thumbView;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.layer.cornerRadius = kSliderHeight * 0.5;
        _backgroundView.backgroundColor = TT_COLOR(255, 255, 255, 1.0);
    }
    return _backgroundView;
}

- (UIView *)trackProgressView {
    if (!_trackProgressView) {
        _trackProgressView = [[UIView alloc] init];
        _trackProgressView.backgroundColor = TT_COLOR(255, 0, 0, 1.0);
        _trackProgressView.layer.cornerRadius = kSliderHeight * 0.5;
    }
    return _trackProgressView;
}

- (UIView *)cacheProgressView {
    if (!_cacheProgressView) {
        _cacheProgressView = [[UIView alloc] init];
        _cacheProgressView.backgroundColor = TT_COLOR(255, 255, 255, 0.5);
        _cacheProgressView.layer.cornerRadius = kSliderHeight * 0.5;
    }
    return _cacheProgressView;
}

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_pan:)];
    }
    return _panGesture;
}

@end
