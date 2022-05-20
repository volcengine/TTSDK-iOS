//
//  TTVideoContainerController.h
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/12.


#import "BaseViewController.h"
#import "SourceViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class TTVideoContainerController;
@protocol TTVideoContainerControllerDelegate <NSObject>

@required
- (void)changeSource:(TTVideoContainerController *)listVC source:(NSDictionary<SourceKey,SourceValue> *)source;

@end

@interface TTVideoContainerController : BaseViewController

@property (nonatomic, weak) id<TTVideoContainerControllerDelegate> delegate;

@end


NS_ASSUME_NONNULL_END
