//
//  TTVideoPlayerControlTopView.m
//  TTVideoPlayerDemo
//
//  Created by 刘廷勇 on 2016/11/18.
//
//

#import "TTVideoPlayerControlTopView.h"

static const CGFloat kGradientHeight = 136.0f;
static const NSInteger kMoreTag = 666;
static const NSInteger kBackTag = 888;

static NSString *const kBackButtonViewKeyPath = @"hidden";

@interface TTVideoPlayerControlTopView ()

@property (nonatomic, strong) CAGradientLayer *gradientMaskLayer;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *moreBtn;

@end

@implementation TTVideoPlayerControlTopView

- (void)dealloc {
    [_backBtn removeObserverBlocksForKeyPath:kBackButtonViewKeyPath];
}

- (void)setUpUI {
    [super setUpUI];
    
    [self.layer addSublayer:self.gradientMaskLayer];
    [self addSubview:self.backBtn];
    [self addSubview:self.titleLab];
    [self addSubview:self.moreBtn];
    
    @weakify(self)
    [self.backBtn addObserverBlockForKeyPath:kBackButtonViewKeyPath block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        @strongify(self)
        if (!self) {
            return;
        }
        
        BOOL result = [newVal boolValue];
        if (result) {
            self.titleLab.numberOfLines = 2;
            self.titleLab.height = MAX([self.titleLab.text heightForFont:self.titleLab.font width:self.titleLab.width], TT_BASE_375(20));
        } else {
            self.titleLab.numberOfLines = 2;
            self.titleLab.height = TT_BASE_375(20);
        }
        [self setNeedsLayout];
        Log(@"result: %@ titleLab:%@",@(result),self.titleLab);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    frame.size.height = kGradientHeight;
    self.gradientMaskLayer.frame = frame;
    
    self.backBtn.top = !self.verticalScreen ? TT_BASE_375(20.0) : STATUS_BAR_BOTTOM;
    self.backBtn.left = self.isFullScreen && !self.verticalScreen ? (TT_EDGE + SAFE_AREA_BOTTOM) : TT_EDGE;
    self.moreBtn.centerY = self.backBtn.centerY;
    self.moreBtn.right = self.width - (self.isFullScreen && !self.verticalScreen ? (TT_BASE_375(20.0f) + SAFE_AREA_BOTTOM) : TT_BASE_375(20.0f));
    
    if (self.backBtn.hidden == NO) {
        self.titleLab.left = self.backBtn.right + TT_EDGE;
        self.titleLab.centerY = self.backBtn.centerY;
        self.titleLab.width = self.moreBtn.left - self.titleLab.left - TT_EDGE;
    } else {
        self.titleLab.left = TT_EDGE;
        self.titleLab.top = TT_EDGE;
        self.titleLab.width = self.width - self.titleLab.left - TT_EDGE;
    }
}

- (void)setFullScreen:(BOOL)fullScreen {
    _fullScreen = fullScreen;
    
    self.backBtn.hidden = !fullScreen;
    self.moreBtn.hidden = self.backBtn.hidden;
}

- (void)setTitleInfo:(NSString *)titleInfo {
    _titleInfo = titleInfo;
    
    self.titleLab.text = titleInfo;
    [self setNeedsLayout];
}

/// MARK: - Private method

- (BOOL)_isBackButtonVisible {
    return !self.backBtn.hidden;
}

- (void)_btnClickedEvent:(UIButton *)btn {
    if (btn.tag == kMoreTag) {
        !self.clickCall ?: self.clickCall(ButtonClickTypeMore);
    } else if (btn.tag == kBackTag) {
        !self.clickCall ?: self.clickCall(ButtonClickTypeBack);
    }
}

/// MARK: - Getter

- (CAGradientLayer *)gradientMaskLayer {
    if (!_gradientMaskLayer) {
        _gradientMaskLayer = [CAGradientLayer layer];
        _gradientMaskLayer.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:0.50].CGColor,
                                      (__bridge id)[UIColor colorWithWhite:0 alpha:0.44].CGColor,
                                      (__bridge id)[UIColor colorWithWhite:0 alpha:0.38].CGColor,
                                      (__bridge id)[UIColor colorWithWhite:0 alpha:0.25].CGColor,
                                      (__bridge id)[UIColor colorWithWhite:0 alpha:0.13].CGColor,
                                      (__bridge id)[UIColor colorWithWhite:0 alpha:0.06].CGColor,
                                      (__bridge id)[UIColor colorWithWhite:0 alpha:0.00].CGColor];
        _gradientMaskLayer.locations = @[@0.00,
                                         @0.05,
                                         @0.15,
                                         @0.30,
                                         @0.50,
                                         @0.65,
                                         @1.00];
    }
    return _gradientMaskLayer;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.font = TT_FONT(16.0f);
        _titleLab.textColor = TT_COLOR_HEX(@"#FFFFFF");
        _titleLab.numberOfLines = 2;
        _titleLab.height = TT_BASE_375(20.0);
    }
    return _titleLab;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.tag = kBackTag;
        _backBtn.tt_hitTestEdgeInsets = UIEdgeInsetsMake(-20, -20, -20, -20);
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"tt_video_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(_btnClickedEvent:)forControlEvents:UIControlEventTouchUpInside];
        _backBtn.size = CGSizeMake(TT_BASE_375(40), TT_BASE_375(40));
    }
    return _backBtn;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _moreBtn.tag = kMoreTag;
        _moreBtn.tt_hitTestEdgeInsets = UIEdgeInsetsMake(-20, -20, -20, -20);
        [_moreBtn setImage:[UIImage imageNamed:@"tt_video_top_more"] forState:UIControlStateNormal];
        _moreBtn.size = CGSizeMake(TT_BASE_375(30), TT_BASE_375(30));
        [_moreBtn addTarget:self action:@selector(_btnClickedEvent:)forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

@end
