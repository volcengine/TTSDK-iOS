//
//  HomeViewController.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/11.


#import "HomeViewController.h"
#import "VodDemoViewController.h"
#import "TTVideoFetchDataHelper.h"
#import "SettingsViewController.h"
#import "LivePlaySettingsViewController.h"
#import "BDRootViewController.h"
#import <TTSDK/TTVideoEngineHeader.h>

@interface HomeViewController ()
@property (nonatomic, strong) UIButton  *vodBtn;
@property (nonatomic, strong) UIButton  *pushBtn;
@property (nonatomic, strong) UIButton  *pullBtn;
@property (nonatomic, strong) UIButton  *imageBtn;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setUpUI {
    [super setUpUI];
    
    self.view.backgroundColor = TT_THEME_COLOR;
    _vodBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TT_BASE_375(100), TT_BASE_375(60))];
    _vodBtn.backgroundColor = TT_COLOR(0, 0, 0, 0.5);
    _vodBtn.titleLabel.font = TT_FONT(15);
    [_vodBtn setTitle:@"视频播放" forState:UIControlStateNormal];
    [_vodBtn setTitleColor:TT_COLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
    [_vodBtn addTarget:self action:@selector(_enterVodDemoViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_vodBtn];
    
    _pushBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TT_BASE_375(100), TT_BASE_375(60))];
    _pushBtn.backgroundColor = TT_COLOR(0, 0, 0, 0.5);
    _pushBtn.titleLabel.font = TT_FONT(15);
    [_pushBtn setTitle:@"直播推流" forState:UIControlStateNormal];
    [_pushBtn setTitleColor:TT_COLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
    [_pushBtn addTarget:self action:@selector(_enterLivePushDemoViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pushBtn];
    
    _pullBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TT_BASE_375(100), TT_BASE_375(60))];
    _pullBtn.backgroundColor = TT_COLOR(0, 0, 0, 0.5);
    _pullBtn.titleLabel.font = TT_FONT(15);
    [_pullBtn setTitle:@"直播拉流" forState:UIControlStateNormal];
    [_pullBtn setTitleColor:TT_COLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
    [_pullBtn addTarget:self action:@selector(_enterLivePlayDemoViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pullBtn];
    
    _imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TT_BASE_375(100), TT_BASE_375(60))];
    _imageBtn.backgroundColor = TT_COLOR(0, 0, 0, 0.5);
    _imageBtn.titleLabel.font = TT_FONT(15);
    [_imageBtn setTitle:@"WebImage" forState:UIControlStateNormal];
    [_imageBtn setTitleColor:TT_COLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
    [_imageBtn addTarget:self action:@selector(_enterImageDemoViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_imageBtn];
}

- (void)buildUI {
    [super buildUI];
    
    self.navigationItem.title = @"Pandora";
    //
    [[TTVideoFetchDataHelper helper] startFetchTestListData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _vodBtn.centerX = self.view.centerX;
    _vodBtn.top = TT_BASE_375(60) + NAVIGATIONBAR_BOTTOM;
    
    _pushBtn.left = _vodBtn.left;
    _pushBtn.top = TT_BASE_375(30) + _vodBtn.bottom;
    
    _pullBtn.left = _vodBtn.left;
    _pullBtn.top = TT_BASE_375(30) + _pushBtn.bottom;
    
    _imageBtn.left = _vodBtn.left;
    _imageBtn.top = TT_BASE_375(30) + _pullBtn.bottom;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

/// MARK: - Private method

- (void)_enterImageDemoViewController {
    BDRootViewController *vc = [[BDRootViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)_enterVodDemoViewController {
    VodDemoViewController *vodDemoVC = [[VodDemoViewController alloc] init];
    [self.navigationController pushViewController:vodDemoVC animated:YES];
}

- (void)_enterLivePushDemoViewController {
    SettingsViewController *vc = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)_enterLivePlayDemoViewController {
    LivePlaySettingsViewController *vc = [[LivePlaySettingsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
