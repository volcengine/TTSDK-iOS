//
//  TTVideoPlayerSliderView.h
//  TTVideoPlayerDemo
//
//  Created by 刘廷勇 on 2016/11/22.
//
//

#import "BaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTVideoPlayerSliderView : BaseView

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
@property (nonatomic, readonly) CGFloat progress;

- (void)setCacheProgress:(CGFloat)progress animated:(BOOL)animated;
@property (nonatomic, readonly) CGFloat cacheProgress;

@property (nonatomic, strong) void(^didSeekToProgress)(CGFloat progress);

@property (nonatomic, readonly, getter=isInteractive) BOOL interactive;

@end

NS_ASSUME_NONNULL_END

