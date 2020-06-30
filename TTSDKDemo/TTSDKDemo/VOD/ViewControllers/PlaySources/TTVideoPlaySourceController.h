//
//  TTVideoPlaySourceController.h
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/13.


#import "BaseViewController.h"
#import "SourceViewController.h"

NS_ASSUME_NONNULL_BEGIN


typedef void(^DismissWithParams)(NSDictionary<SourceKey,SourceValue> *params);

@interface TTVideoPlaySourceController : BaseViewController

@property (nonatomic, copy) DismissWithParams dismissCall;

@end

NS_ASSUME_NONNULL_END
