//
//  TTVideoPlayerFullScreenManager.h
//  TTVideoPlayerDemo
//
//  Created by 刘廷勇 on 2016/12/2.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TTVideoPlayerFullScreenManager : NSObject

@property (nonatomic, getter=isFullScreen, readonly) BOOL fullScreen;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithPlayerView:(UIView *)playerView NS_DESIGNATED_INITIALIZER;

//parentViewController must return NO in -(BOOL)shouldAutorotate
- (void)beginMonitor;

//called in dealloc
- (void)endMonitor;

/// Vertical screen.
@property (nonatomic, assign) BOOL verticalScreen;
    
- (void)setFullScreen:(BOOL)fullScreen animated:(BOOL)animated;

@end
