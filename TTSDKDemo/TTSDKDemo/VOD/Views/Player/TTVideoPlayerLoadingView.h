//
//  TTVideoPlayerLoadingView.h
//  TTVideoPlayerDemo
//
//  Created by 刘廷勇 on 2016/11/30.
//
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickRetryCall)(void);

@interface TTVideoPlayerLoadingView : BaseView

@property (nonatomic, copy) ClickRetryCall retryCall;

- (void)startLoading;
- (void)stopLoading;
- (void)showRetry;

@end
NS_ASSUME_NONNULL_END
