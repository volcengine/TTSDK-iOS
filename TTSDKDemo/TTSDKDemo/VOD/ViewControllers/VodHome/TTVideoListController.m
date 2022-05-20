//
//  TTVideoListController.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/12.


#import "TTVideoListController.h"
#import "BaseListModelProtocol.h"
#import "TTVideoListModel.h"
#import "NavigationViewController.h"
#import "TTVideoPlaySourceController.h"
#import "TTVideoFetchDataHelper.h"
#import "TTVideoPreloaderHelper.h"

@interface TTVideoListController ()

@property (nonatomic,   copy) NSArray *dataArray;
@property (nonatomic, strong) UIButton *bottomBtn;

@end

@implementation TTVideoListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _fetchData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _bottomBtn.frame = self.bottomView.bounds;
}

- (void)setUpUI {
    [super setUpUI];
    
    _bottomBtn = [[UIButton alloc] initWithFrame:self.bottomView.frame];
    _bottomBtn.origin = CGPointZero;
    [_bottomBtn addTarget:self action:@selector(_bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBtn setTitle:@"使用vid或者url播放" forState:UIControlStateNormal];
    [_bottomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _bottomBtn.titleLabel.font = TT_FONT(16);
    [self.bottomView addSubview:_bottomBtn];
}

/// MARK: - Private method

- (void)_fetchData {
    [[TTVideoFetchDataHelper helper] getTestListData:^(NSArray<TTVideoListModel *> * _Nullable listData, NSError * _Nullable error) {
        if (error) {
            Log(@"fetch test list data error, error = %@",error);
            return;
        }
        //
        self.dataArray = (NSArray *)listData;
        [self assignDataArray:(NSArray<BaseListModelProtocol> *)self.dataArray];
    }];
}

- (void)_bottomBtnClick {
    TTVideoPlaySourceController * sourceVC = [[TTVideoPlaySourceController alloc] init];
    @weakify(self)
    [sourceVC setDismissCall:^(NSDictionary<SourceKey,SourceValue> * _Nonnull params) {
        @strongify(self)
        if (!self) {
            return;
        }
        if (params && params.count > 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(changeSource:source:)]) {
                [self.delegate changeSource:self source:params];
            }
        }
    }];
    
    NavigationViewController *naviVC = [[NavigationViewController alloc] initWithRootViewController:sourceVC];
    [self presentViewController:naviVC animated:YES completion:^{
        
    }];
}

/// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    TTVideoListModel *temModel = self.datas[indexPath.section];
    if (![temModel isKindOfClass:[TTVideoListModel class]]) {
        return;
    }
    
    /// 取消之前的预加载任务
    [TTVideoPreloaderHelper cancelAllPreloadItems];
    
    NSDictionary<SourceKey,SourceValue> *params = @{
                                                    SourceKeyVid:temModel.vid?:@"",
                                                    SourceKeyTitle:temModel.title?:@"",
                                                    SourceKeyPtoken:temModel.pToken?:@"",
                                                    SourceKeyAuth:temModel.playAuthToken?:@"",
                                                    SourceKeyAuthWithHost:temModel.playAuthTokenWithHost?:@""
                                                    };
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeSource:source:)]) {
        [self.delegate changeSource:self source:params];
    }
    
    NSMutableArray *temArray = [NSMutableArray array];
    for (NSInteger i = 1; i <= 2; i++) { // 简单的预加载逻辑，向下预加载两个视频
        NSInteger index = indexPath.section + i;
        if (index < self.datas.count) {
            TTVideoListModel *temModel = self.datas[index];
            if (![temModel isKindOfClass:[TTVideoListModel class]]) {
                return;
            }
            
            NSDictionary *param = @{
                                    SourceKeyVid:temModel.vid?:@"",
                                    SourceKeyTitle:temModel.title?:@"",
                                    SourceKeyPtoken:temModel.pToken?:@"",
                                    SourceKeyAuth:temModel.playAuthToken?:@"",
                                    SourceKeyAuthWithHost:temModel.playAuthTokenWithHost?:@""
                                    };
            [temArray addObject:param];
        }
    }
    
    /// 3s 之后预加载
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [TTVideoPreloaderHelper preloadItems:temArray];
    });
}

@end
