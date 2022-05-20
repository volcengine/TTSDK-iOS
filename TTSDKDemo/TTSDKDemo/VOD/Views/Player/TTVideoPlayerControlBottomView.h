//
//  TTVideoPlayerControlBottomView.h
//  TTVideoPlayerDemo
//
//  Created by 刘廷勇 on 2016/11/22.
//
//

#import "BaseView.h"
#import "TTVideoPlayerControlView.h"

NS_ASSUME_NONNULL_BEGIN
@interface TTVideoPlayerControlBottomView : BaseView

@property (nonatomic, strong, readonly) TTVideoPlayerControlView *playbackControl;
@property (nonatomic, assign, readonly) CGPoint needShowResolutionPosition;
@property (nonatomic, strong) void(^didClickFullScreenButton)(BOOL toFullScreen);
@property (nonatomic, strong) void(^didClickResolutionButton)(void);

@property (nonatomic, getter=isFullScreen) BOOL fullScreen;
@property (nonatomic, assign) BOOL verticalScreen;
    
@property (nonatomic, assign) BOOL enableResolutionControl;
@property (nonatomic, assign) NSString *resolutionString;

@end
NS_ASSUME_NONNULL_END
