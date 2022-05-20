//
//  TTVideoPlaySourceController.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/13.


#import "TTVideoPlaySourceController.h"
#import "BaseContainerViewController.h"
#import "TTVideoVidController.h"
#import "TTVideoURLController.h"
#import "TTVideoHistoryController.h"

SourceKey const SourceKeyURL            = @"k_TTVideo_URL";
SourceKey const SourceKeyVid            = @"k_TTVideo_Vid";
SourceKey const SourceKeyAuth           = @"k_TTVideo_Auth";
SourceKey const SourceKeyTitle          = @"k_TTVideo_Title";
SourceKey const SourceKeyPtoken         = @"k_TTVideo_Ptoken";
SourceKey const SourceKeyAuthWithHost   = @"k_TTVideo_Auth_with_host";
SourceKey const SourceKeyDash           = @"k_TTVideo_Dash";
SourceKey const SourceKeyHardWare       = @"k_TTVideo_HardWare";
SourceKey const SourceKeyByteVC1        = @"k_TTVideo_ByteVC1";

@interface TTVideoPlaySourceController ()<HistoryViewControllerDelegate>

@property (nonatomic, strong) BaseContainerViewController *container;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) NSMutableDictionary *params;
@end

@implementation TTVideoPlaySourceController

- (void)setUpUI {
    [super setUpUI];
    
    _container = [BaseContainerViewController new];
    _container.view.frame = self.view.bounds;
    [self.view addSubview:_container.view];
    [self addChildViewController:_container];
    _container.hiddenLineView = YES;
    
    @weakify(self)
    [_container setIndexChangeCall:^(NSInteger index) {
        @strongify(self)
        if (!self) {
            return;
        }
        self.rightItem.enabled = [self _historyDatas].count > 0;
    }];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(_dismissViewController)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.rightItem = [[UIBarButtonItem alloc] initWithTitle:@"历史记录"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(_enterHistoryController)];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    _bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, TT_BASE_375(60))];
    [_bottomBtn addTarget:self action:@selector(_bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBtn setTitle:@"开始播放" forState:UIControlStateNormal];
    [_bottomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _bottomBtn.titleLabel.font = TT_FONT(16);
    [self.view addSubview:_bottomBtn];
}

- (void)buildUI {
    [super buildUI];
    
    self.navigationItem.title = @"自定义数据源";
    NSArray *titles = @[@"Vid",@"URL"];
    NSMutableArray *viewControllers = [NSMutableArray array];
    TTVideoVidController *vidVC = [TTVideoVidController new];
    vidVC.delegate = (id<SourceViewControllerDelegate>) self;
    [viewControllers addObject:vidVC];
    TTVideoURLController *urlVC = [TTVideoURLController new];
    urlVC.delegate = (id<SourceViewControllerDelegate>) self;
    [viewControllers addObject:urlVC];
    [_container setTitles:titles viewControllers:viewControllers];
    
    self.params = [NSMutableDictionary dictionary];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _container.view.top = NAVIGATIONBAR_BOTTOM;
    _container.view.height = SCREEN_HEIGHT - NAVIGATIONBAR_BOTTOM - _bottomBtn.height - SAFE_AREA_BOTTOM;
    _bottomBtn.top = _container.view.bottom;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.rightItem.enabled = [self _historyDatas].count > 0;
}

/// MARK: - Private method

- (void)_dismissViewController {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (NSArray *)_historyDatas {
     id<SourceViewController> curVC = (id<SourceViewController>)_container.currentViewController;
    return [curVC historyInfos];
}

- (void)_enterHistoryController {
    NSArray* temArray = [self _historyDatas];
    if (temArray && temArray.count) {
        TTVideoHistoryController *historyVC = [[TTVideoHistoryController alloc] init];
        historyVC.delegate = self;
        [historyVC assignDataArray:(NSArray<BaseListModelProtocol> *)temArray];
        [self.navigationController pushViewController:historyVC animated:YES];
    } else {
        Log(@"no history data");
    }
}

- (void)_bottomBtnClick {
    id<SourceViewController> curVC = (id<SourceViewController>)_container.currentViewController;
    [curVC willDismiss];
    
    @weakify(self)
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self)
        if (!self) {
            return;
        }
        
        !self.dismissCall ?: self.dismissCall(self.params);
    }];
}

/// MARK: - SourceViewControllerDelegate

- (void)dismiss:(BaseViewController *)vc result:(NSDictionary<SourceKey,SourceValue> *) result {
    [self.params removeAllObjects];
    
    if (result && result.count > 0) {
        [self.params addEntriesFromDictionary:result];
    }
}

/// MARK: - HistoryViewControllerDelegate

- (void)select:(BaseViewController *)vc result:(NSDictionary<SourceKey,SourceValue> *)result {
    if (result && result.count > 0) {
        id<SourceViewController> curVC = (id<SourceViewController>)_container.currentViewController;
        [curVC setSources:result];
    }
}

- (void)deleteAllDatas:(BaseViewController *)vc {
    id<SourceViewController> curVC = (id<SourceViewController>)_container.currentViewController;
    [curVC deleteHistoryInfos];
}

@end
