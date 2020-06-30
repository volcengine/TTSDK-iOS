//
//  TTVideoListController.h
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/12.


#import "BaseTableViewController.h"
#import "SourceViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class TTVideoListController;
@protocol TTVideoListControllerDelegate <NSObject>

@required
- (void)changeSource:(TTVideoListController *)listVC source:(NSDictionary<SourceKey,SourceValue> *)source;

@end

@interface TTVideoListController : BaseTableViewController

@property (nonatomic, weak) id<TTVideoListControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
