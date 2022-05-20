//
//  BaseTableViewController.h
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/12.


#import "BaseViewController.h"

@protocol BaseListModelProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIView *bottomView;
@property (nonatomic, copy  , readonly) NSArray<BaseListModelProtocol> *datas;

- (void)assignDataArray:(NSArray<BaseListModelProtocol> *)data;


@end

NS_ASSUME_NONNULL_END
