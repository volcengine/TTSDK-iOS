//
//  TTVideoPlayerControlView.h
//  TTVideoPlayerDemo
//
//  Created by 刘廷勇 on 2016/11/22.
//
//

#import "BaseView.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^SeekFinished)(CGFloat progress);

/// slider currentTime totalDuration
@interface TTVideoPlayerControlView : BaseView

@property (nonatomic, assign) NSTimeInterval timeDuration;
@property (nonatomic, copy) SeekFinished seekCall;
@property (nonatomic, readonly, getter=isInteractive) BOOL interactive;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
- (void)setCacheProgress:(CGFloat)progress animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
