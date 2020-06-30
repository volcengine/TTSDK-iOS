//
//  TTVideoPlayerControlsController.h
//  TTVideoPlayerDemo
//
//  Created by 刘廷勇 on 2016/11/17.
//
//

#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@class TTVideoPlayerControlsController;
@protocol ControlsViewControllerDelegate <NSObject>

@required
- (void)controlsViewController:(TTVideoPlayerControlsController *)controller showStatus:(BOOL)isShowing;
- (void)controlsViewController:(TTVideoPlayerControlsController *)controller playStatus:(BOOL)isPlay;
- (void)controlsViewController:(TTVideoPlayerControlsController *)controller changeProgress:(CGFloat)progress;
- (void)controlsViewController:(TTVideoPlayerControlsController *)controller fullScreen:(BOOL)toFullScreen;
- (void)controlsViewController:(TTVideoPlayerControlsController *)controller changeResolution:(NSInteger)resolution;
- (void)controlsViewController:(TTVideoPlayerControlsController *)controller retry:(NSInteger)times;
- (void)controlsViewController:(TTVideoPlayerControlsController *)controller playBackSpeed:(CGFloat)speed;
- (void)controlsViewController:(TTVideoPlayerControlsController *)controller muted:(BOOL)isMuted;
- (void)controlsViewController:(TTVideoPlayerControlsController *)controller mixWithOther:(BOOL)isOn;

@end

@protocol ControlsViewControllerDataSource <NSObject>
- (NSArray<NSString *> *)resolutionsForControls:(TTVideoPlayerControlsController *)controls;
@required

@end

@class TTVideoPlayerController;
@interface TTVideoPlayerControlsController : BaseViewController

@property (nonatomic, weak) id<ControlsViewControllerDelegate> delegate;
@property (nonatomic, weak) id<ControlsViewControllerDataSource> dataSource;

@property (nonatomic,   copy) NSString *titleInfo;
@property (nonatomic,   weak) UIView *debugView;
@property (nonatomic, assign) NSTimeInterval currentPlayingTime;
@property (nonatomic, assign) NSTimeInterval timeDuration;
@property (nonatomic, assign) NSInteger resolutionIndex;
@property (nonatomic, getter=isShowing) BOOL show;
@property (nonatomic, getter=isPlaying) BOOL play;
@property (nonatomic, getter=isFullScreen) BOOL fullScreen;
@property (nonatomic, readonly, getter=isInteractive) BOOL interactive;

- (void)setCacheProgress:(CGFloat)progress animated:(BOOL)animated;

///
@property (nonatomic, assign) BOOL verticalScreen;
    
- (void)startLoading;
- (void)stopLoading;
- (void)showRetry;

@end

NS_ASSUME_NONNULL_END
