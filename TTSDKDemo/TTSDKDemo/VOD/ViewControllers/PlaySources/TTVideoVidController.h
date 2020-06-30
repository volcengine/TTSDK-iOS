//
//  TTVideoVidController.h
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/13.


#import "BaseViewController.h"
#import "SourceViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoVidController : BaseViewController <SourceViewController>

@property (nonatomic, weak) id<SourceViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
