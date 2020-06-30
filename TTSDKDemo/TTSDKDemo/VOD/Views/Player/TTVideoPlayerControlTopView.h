//
//  TTVideoPlayerControlTopView.h
//  TTVideoPlayerDemo
//
//  Created by 刘廷勇 on 2016/11/18.
//
//

#import "BaseView.h"
NS_ASSUME_NONNULL_BEGIN
@interface TTVideoPlayerControlTopView : BaseView

@property (nonatomic, getter=isFullScreen) BOOL fullScreen;
@property (nonatomic, assign) BOOL verticalScreen;
@property (nonatomic, copy) ButtonClick clickCall;
@property (nonatomic, copy) NSString *titleInfo;

@end

NS_ASSUME_NONNULL_END

