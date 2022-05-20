//
//  BaseContainerViewController.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/13.


#import "BaseContainerViewController.h"
#import "TTVideoTabIndexView.h"

static const NSInteger kScrollviewTag = 8888;

@interface BaseContainerViewController ()
@property(nonatomic, assign) NSInteger index;///< 当前索引
@property(nonatomic, strong) UIScrollView *scrollView;///< 容器
@property(nonatomic,   copy) NSArray<NSString *> *titles;///< titles
@property(nonatomic,   copy) NSArray<BaseViewController *> *viewControllerArray;///< 控制器
@property(nonatomic, strong) TTVideoTabIndexView *indexView;///< 多 tab
@property(nonatomic,   weak) BaseViewController *currentViewController;
@end

@implementation BaseContainerViewController

- (void)dealloc{
    _scrollView.delegate = nil;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _scrollView.frame = self.view.bounds;
    _indexView.frame = CGRectMake(0, 0, _scrollView.width, TT_BASE_375(40));
    _scrollView.contentSize = CGSizeMake(self.view.width * self.viewControllerArray.count,_scrollView.height);
    _currentViewController.view.frame = CGRectMake(self.index * _scrollView.width, 0, _scrollView.width, _scrollView.height);
}

- (void)setUpUI {
    [super setUpUI];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = (id<UIScrollViewDelegate>)self;
    _scrollView.bounces = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:_scrollView];
    
    self.indexView = [[TTVideoTabIndexView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, TT_BASE_375(40))];
    @weakify(self)
    [self.indexView setClickCall:^(NSInteger index) {
        @strongify(self)
        if (!self) {
            return;
        }
        self.index = index;
    }];
    [self.view addSubview:self.indexView];
    self.indexView.hidden = YES;
}

- (void)setTitles:(NSArray<NSString *> *)titles viewControllers:(NSArray<BaseViewController *> *)viewControllers {
    self.titles = titles;
    [self.indexView updateTitles:titles];
    self.indexView.hidden = viewControllers.count <= 1;
    for (UIViewController *vc in viewControllers) {
        [self addChildViewController:vc];
    }
    
    self.viewControllerArray = viewControllers;
}

- (CGFloat)indexViewHeight {
    if (_indexView.hidden) {
        return 0.0f;
    } else {
        return _indexView.height;
    }
}

- (BOOL)hiddenLineView {
    return _indexView.hiddenLineView;
}

- (void)setHiddenLineView:(BOOL)hiddenLineView {
    _indexView.hiddenLineView = hiddenLineView;
}

- (void)setViewControllerArray:(NSArray *)viewControllerArray {
    _viewControllerArray = viewControllerArray;
    
    [_scrollView removeAllSubviews];
    [_scrollView setContentOffset:CGPointZero];
    _scrollView.contentSize = CGSizeMake(self.view.width * self.viewControllerArray.count,_scrollView.height);
    [self scrollViewDidScroll:_scrollView];
    
    self.index = _index;
}

- (void)setIndex:(NSInteger)index {
    if (index < 0 || index >= _viewControllerArray.count) {
        return;
    }
    _index = index;
    self.indexView.selectedIndex = _index;
    if (self.viewControllerArray.count > index) {
        self.currentViewController = self.viewControllerArray[index];
    }
    
    [_scrollView setContentOffset:CGPointMake(self.view.width * index, 0)];
    !self.indexChangeCall ?: self.indexChangeCall(index);
}

/// MARK: - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.width;
    NSInteger lIndex = floor(scrollView.contentOffset.x / pageWidth);
    NSInteger rIndex = ceil(scrollView.contentOffset.x / pageWidth);
    if (self.viewControllerArray.count <= lIndex || self.viewControllerArray.count <= rIndex) {
        return;
    }
    
    BaseViewController *lVc = self.viewControllerArray[lIndex];
    BaseViewController *rVc = self.viewControllerArray[rIndex];
    if (lVc.view.superview == nil) {
        lVc.view.frame = CGRectMake(lIndex * pageWidth, 0, pageWidth, scrollView.height);
        lVc.view.tag = kScrollviewTag + lIndex;
        [scrollView addSubview:lVc.view];
    }
    if (rVc.view.superview == nil) {
        rVc.view.frame = CGRectMake(rIndex * pageWidth, 0, pageWidth, scrollView.height);
        rVc.view.tag = kScrollviewTag + rIndex;
        [scrollView addSubview:rVc.view];
    }
    
    for (UIView *aView in _scrollView.subviews) {
        if ((aView.tag != kScrollviewTag + lIndex) && (aView.tag != kScrollviewTag + rIndex)) {
            [aView removeFromSuperview];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger index = floor((scrollView.contentOffset.x - pageWidth * 0.5) / pageWidth) + 1;
    
    if (_index != index) {
        self.index = index;
    }
}

@end
