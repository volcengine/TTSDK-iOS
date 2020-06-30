//
//  TTVideoContainerController.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/12.


#import "TTVideoContainerController.h"
#import "BaseContainerViewController.h"
#import "TTVideoLogController.h"
#import "TTVideoListController.h"
#import "TTVideoDownloadController.h"
#import <YYCategories/UIView+YYAdd.h>

@interface TTVideoContainerController ()
@property (nonatomic, strong) BaseContainerViewController *container;
@end

@implementation TTVideoContainerController

- (void)setUpUI {
    [super setUpUI];
    
    _container = [BaseContainerViewController new];
    _container.view.frame = self.view.bounds;
    [self.view addSubview:_container.view];
    [self addChildViewController:_container];
    
    @weakify(self)
    [_container setIndexChangeCall:^(NSInteger index) {
        @strongify(self)
        if (!self) {
            return;
        }
        
        [self _containerIndexDidChange];
    }];
}

- (void)buildUI {
    [super buildUI];
    
    NSArray *titles = @[@"视频列表",@"日志信息"];
    NSMutableArray *viewControllers = [NSMutableArray array];
    TTVideoListController *listVC = [TTVideoListController new];
    listVC.delegate = (id<TTVideoListControllerDelegate>)self;
    [viewControllers addObject:listVC];
    //[viewControllers addObject:[TTVideoDownloadController new]];
    [viewControllers addObject:[TTVideoLogController new]];
    [_container setTitles:titles viewControllers:viewControllers];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _container.view.frame = self.view.bounds;
}

/// MARK: - Private method

- (void)_containerIndexDidChange {
    for (BaseTableViewController* vc in _container.viewControllerArray) {
        UITableView *t = vc.tableView;
        t.contentInset = UIEdgeInsetsMake(_container.indexViewHeight, 0, t.contentInset.bottom, 0);
        t.scrollIndicatorInsets = UIEdgeInsetsMake(_container.indexViewHeight, 0, t.contentInset.bottom, 0);
        if (t.contentOffset.y == 0.0) {
            [t setContentOffset:CGPointMake(0, -_container.indexViewHeight) animated:NO];
        }
        
        [self.view setNeedsLayout];
    }
}

/// MARK: - TTVideoListControllerDelegate

- (void)changeSource:(TTVideoListController *)listVC source:(NSDictionary<SourceKey,SourceValue> *)source {
    if (source == nil || source.count == 0) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeSource:source:)]) {
        [self.delegate changeSource:self source:source];
    }
}


@end
