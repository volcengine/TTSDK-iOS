//
//  TTVideoPlayerController.h
//  TTVideoPlayerDemo
//
//  Created by 刘廷勇 on 2016/11/17.
//
//

#import <TTVideoEngineHeader.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface TTVideoPlayerController : BaseViewController

@property (nonatomic, strong) NSDictionary *params;

- (void)updateDebugViewStatus:(BOOL)hiden;

@end
NS_ASSUME_NONNULL_END
