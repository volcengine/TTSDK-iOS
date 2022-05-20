//
//  TTVideoCellFactory.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/12.


#import "TTVideoCellFactory.h"

static NSString *const kTTVideoListModel = @"TTVideoListModel";
static NSString *const kTTVideoLogModel = @"TTVideoLogModel";
static NSString *const kTTVideoDownloadModel = @"TTVideoDownloadModel";
static NSString *const kTTVideoHistoryVidModel = @"TTVideoHistoryVidModel";
static NSString *const kTTVideoHistoryURLModel = @"TTVideoHistoryURLModel";

@implementation TTVideoCellFactory

+ (BaseTableViewCell *)createCell:(NSString *)modelType tableView:(UITableView *)tableView {
    BaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:modelType];
    if (!cell){
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:modelType];
    }
    return cell;
}

+ (void)registerCellTypeForTableView:(UITableView *)tableView {
    [tableView registerClass:NSClassFromString(@"TTVideoListCell") forCellReuseIdentifier:kTTVideoListModel];
    [tableView registerClass:NSClassFromString(@"TTVideoLogCell") forCellReuseIdentifier:kTTVideoLogModel];
    [tableView registerClass:NSClassFromString(@"TTVideoDownloadCell") forCellReuseIdentifier:kTTVideoDownloadModel];
    [tableView registerClass:NSClassFromString(@"TTVideoHistoryVidCell") forCellReuseIdentifier:kTTVideoHistoryVidModel];
    [tableView registerClass:NSClassFromString(@"TTVideoHistoryURLCell") forCellReuseIdentifier:kTTVideoHistoryURLModel];
}

@end
