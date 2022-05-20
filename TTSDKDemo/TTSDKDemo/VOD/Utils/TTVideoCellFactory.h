//
//  TTVideoCellFactory.h
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/12.


#import <Foundation/Foundation.h>
#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoCellFactory : NSObject

+ (BaseTableViewCell *)createCell:(NSString *)modelType tableView:(UITableView *)tableView;

+ (void)registerCellTypeForTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
