//
//  TTVideoPlayerControlView.m
//  TTVideoPlayerDemo
//
//  Created by 刘廷勇 on 2016/11/22.
//
//

#import "TTVideoPlayerControlView.h"
#import "TTVideoPlayerSliderView.h"
#import <CoreText/CoreText.h>

@interface TTVideoPlayerControlView ()

@property (nonatomic, strong) TTVideoPlayerSliderView *sliderView;
@property (nonatomic, strong) UILabel *currentTimeLab;
@property (nonatomic, strong) UILabel *totalDurationLab;
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign, getter=isInteractive) BOOL interactive;

@end

@implementation TTVideoPlayerControlView

- (void)setUpUI {
    [super setUpUI];
    
    [self addSubview:self.sliderView];
    [self addSubview:self.currentTimeLab];
    [self addSubview:self.totalDurationLab];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.sliderView.top = 0.0f;
    self.sliderView.height = self.height;
    self.sliderView.left = TT_BASE_375(65.0);
    self.sliderView.width = self.width - 2 * self.sliderView.left;
    
    [self.currentTimeLab sizeToFit];
    self.currentTimeLab.right = self.sliderView.left - TT_EDGE;
    self.currentTimeLab.centerY = self.sliderView.centerY;
    
    [self.totalDurationLab sizeToFit];
    self.totalDurationLab.left = self.sliderView.right + TT_EDGE;
    self.totalDurationLab.centerY = self.sliderView.centerY;
}

- (void)setTimeDuration:(NSTimeInterval)timeDuration {
    _timeDuration = timeDuration;
    
    self.totalDurationLab.text = [self _transformProgressToTime:1];
}

- (BOOL)isInteractive {
    _interactive = self.sliderView.isInteractive;
    return _interactive;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    self.currentTimeLab.text = [self _transformProgressToTime:progress];
    [self.sliderView setProgress:progress animated:animated];
}

- (void)setCacheProgress:(CGFloat)progress animated:(BOOL)animated {
    [self.sliderView setCacheProgress:progress animated:animated];
}

/// MARK: - Private method

- (NSString *)_transformProgressToTime:(CGFloat)progress {
    self.currentTime = self.timeDuration * progress;
    int minute = (int)self.currentTime / 60;
    int second = (int)self.currentTime % 60;
    return [NSString stringWithFormat:@"%02i:%02i", minute, second];
}

/// MARK: - Getter

- (TTVideoPlayerSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[TTVideoPlayerSliderView alloc] init];
        
        @weakify(self)
        [_sliderView setDidSeekToProgress:^(CGFloat progress) {
            @strongify(self)
            if (!self) {
                return;
            }
            
            self.currentTimeLab.text = [self _transformProgressToTime:progress];
            if (self.seekCall) {
                self.seekCall(progress);
            }
        }];
    }
    return _sliderView;
}

- (UILabel *)currentTimeLab {
    if (!_currentTimeLab) {
        _currentTimeLab = [[UILabel alloc] init];
        _currentTimeLab.textColor = [UIColor whiteColor];
        _currentTimeLab.textAlignment = NSTextAlignmentRight;
        _currentTimeLab.font = [UIFont fontWithDescriptor:self.fontDescriptor size:13];
        _currentTimeLab.text = @"00:00";
    }
    return _currentTimeLab;
}

- (UILabel *)totalDurationLab {
    if (!_totalDurationLab) {
        _totalDurationLab = [[UILabel alloc] init];
        _totalDurationLab.textColor = [UIColor whiteColor];
        _totalDurationLab.textAlignment = NSTextAlignmentLeft;
        _totalDurationLab.font = [UIFont fontWithDescriptor:self.fontDescriptor size:13];
        _totalDurationLab.text = @"00:00";
    }
    return _totalDurationLab;
}

//固定timeLabel的字符宽度，防止抖动
- (UIFontDescriptor *)fontDescriptor {
    NSArray *monospacedSetting = @[@{UIFontFeatureTypeIdentifierKey :  @(kNumberSpacingType),
                                     UIFontFeatureSelectorIdentifierKey :  @(kMonospacedNumbersSelector)}];
    UIFont *font = [UIFont systemFontOfSize:0];
    UIFontDescriptor *newDescriptor = [[font fontDescriptor] fontDescriptorByAddingAttributes:@{UIFontDescriptorFeatureSettingsAttribute : monospacedSetting}];
    return newDescriptor;
}

@end  
