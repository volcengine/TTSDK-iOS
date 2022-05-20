//
//  BaseTableViewController.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/12.


#import "BaseTableViewController.h"
#import "TTVideoCellFactory.h"
#import "BaseListModel.h"

static NSString *const kTTVideoTableViewFooter = @"TTVideoTableViewFooter";

@interface BaseTableViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic,   copy) NSArray<BaseListModelProtocol> *datas;

@end

@implementation BaseTableViewController

- (void)dealloc {
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _tableView.frame = self.view.bounds;
    _bottomView.bottom = self.view.height;
    _bottomView.width = self.view.width;
}

- (void)assignDataArray:(NSArray<BaseListModelProtocol> *)data {
    _datas = data;
    
    [_tableView reloadData];
}

- (UITableView *)tableView {
    return _tableView;
}

- (UIView *)bottomView {
    return _bottomView;
}

- (void)setUpUI {
    [super setUpUI];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = (id<UITableViewDelegate>)self;
    _tableView.dataSource = (id<UITableViewDataSource>)self;
    _tableView.backgroundView = nil;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.estimatedRowHeight = 0.0f;
    _tableView.estimatedSectionFooterHeight = 0.0f;
    _tableView.estimatedSectionHeaderHeight = 0.0f;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:_tableView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, TT_BASE_375(44))];
    _bottomView.backgroundColor = TT_THEME_COLOR;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, _bottomView.height, 0);
    [self.view addSubview:_bottomView];
    
    [TTVideoCellFactory registerCellTypeForTableView:_tableView];
}

/// MARK: - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *obj = _datas[indexPath.section];
    NSString *cellIdentifier = NSStringFromClass([obj class]);
    
    BaseTableViewCell *cell = [TTVideoCellFactory createCell:cellIdentifier tableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<BaseListModelProtocol> contentModel = _datas[indexPath.section];
    if ([contentModel respondsToSelector:@selector(cellHeight)]) {
        return [contentModel cellHeight];
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == _datas.count - 1) {
        return [UIView new];
    }
    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kTTVideoTableViewFooter];
    if (!footer) {
        footer = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kTTVideoTableViewFooter];
        footer.backgroundView = nil;
        footer.contentView.backgroundColor = TT_THEME_COLOR;
    }
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == _datas.count - 1) {
        return 0.01f;
    }
    return TT_BASE_375(5.0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BaseListModel *temModel = _datas[indexPath.section];
    BaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell refreshView:temModel];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *obj = _datas[indexPath.section];
    
    [(BaseTableViewCell*)cell assignValue:obj];
    
    if ([(BaseTableViewCell *)cell respondsToSelector:@selector(willDisplay)]) {
        [(BaseTableViewCell *)cell willDisplay];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    
    if ([(BaseTableViewCell *)cell respondsToSelector:@selector(endDisplay)]) {
        [(BaseTableViewCell *)cell endDisplay];
    }
}


@end
