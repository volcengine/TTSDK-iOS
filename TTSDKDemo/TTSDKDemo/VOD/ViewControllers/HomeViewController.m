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
#import "TTFileUploadDemoUtil.h"
#import "uploadController.h"
#import "AppInfoViewController.h"
#import "LicenseDemoViewController.h"
#import <Masonry/Masonry.h>

@interface HomeViewController ()
@property (nonatomic, strong) UIButton  *vodBtn;
@property (nonatomic, strong) UIButton  *pushBtn;
@property (nonatomic, strong) UIButton  *pullBtn;
@property (nonatomic, strong) UIButton  *imageBtn;
@property (nonatomic, strong) UIButton  *uploadBtn;
@property (nonatomic, strong) UIButton  *licenseBtn;
@property (nonatomic, strong) UIButton  *appInfoBtn;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setUpUI {
    [super setUpUI];
    self.view.backgroundColor = TT_THEME_COLOR;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_BOTTOM);
        make.bottom.left.right.equalTo(self.view);
    }];
    scrollView.clipsToBounds = YES;
    scrollView.scrollEnabled = YES;
    //
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    [scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.height.equalTo(scrollView);
        make.width.equalTo(scrollView);
        make.width.equalTo(@(self.view.width));
    }];

    _vodBtn = [self createButtonWithTitle:@"视频播放"];
    [_vodBtn addTarget:self action:@selector(_enterVodDemoViewController) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_vodBtn];
    [_vodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(contentView);
        make.width.equalTo(@(TT_BASE_375(100)));
        make.height.equalTo(@(TT_BASE_375(60)));
    }];

    _pushBtn = [self createButtonWithTitle:@"直播推流"];
    [_pushBtn addTarget:self action:@selector(_enterLivePushDemoViewController) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_pushBtn];
    [_pushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_vodBtn.mas_bottom).offset(TT_BASE_375(30));
        make.width.height.centerX.equalTo(_vodBtn);
    }];

    _pullBtn = [self createButtonWithTitle:@"直播拉流"];
    [_pullBtn addTarget:self action:@selector(_enterLivePlayDemoViewController) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_pullBtn];
    [_pullBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pushBtn.mas_bottom).offset(TT_BASE_375(30));
        make.width.height.centerX.equalTo(_vodBtn);
    }];

    _imageBtn = [self createButtonWithTitle:@"WebImage"];
    [_imageBtn addTarget:self action:@selector(_enterImageDemoViewController) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_imageBtn];
    [_imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pullBtn.mas_bottom).offset(TT_BASE_375(30));
        make.width.height.centerX.equalTo(_vodBtn);
    }];

    _uploadBtn = [self createButtonWithTitle:@"上传测试"];
    [_uploadBtn addTarget:self action:@selector(_uploadDemoViewController) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_uploadBtn];
    [_uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageBtn.mas_bottom).offset(TT_BASE_375(30));
        make.width.height.centerX.equalTo(_vodBtn);
    }];
    
    _licenseBtn = [self createButtonWithTitle:@"配置License"];
    [_licenseBtn addTarget:self action:@selector(_enterLicenseDemoViewController) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_licenseBtn];
    [_licenseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_uploadBtn.mas_bottom).offset(TT_BASE_375(30));
        make.width.height.centerX.equalTo(_vodBtn);
    }];
    
    _appInfoBtn = [self createButtonWithTitle:@"Demo信息"];
    [_appInfoBtn addTarget:self action:@selector(_enterAppInfoViewController) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_appInfoBtn];
    [_appInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_licenseBtn.mas_bottom).offset(TT_BASE_375(30));
        make.width.height.centerX.equalTo(_vodBtn);
        make.bottom.equalTo(contentView);
    }];
}

- (void)buildUI {
    [super buildUI];
    
    self.navigationItem.title = @"Pandora";
    //
    [[TTVideoFetchDataHelper helper] startFetchTestListData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

/// MARK: - Private method

- (void)_enterAppInfoViewController {
    AppInfoViewController *vc = [[AppInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

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

- (void)_enterLicenseDemoViewController {
    LicenseDemoViewController *vc = [[LicenseDemoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)_uploadDemoViewController {
    uploadController *uploadvc = [[uploadController alloc] init];
    [self.navigationController pushViewController:uploadvc animated:YES];
}

- (void)uploadDidFinish:(TTUploadImageInfoTop *)imageInfo error:(NSError *)error{
    NSLog(@"uploadDidFinish:OK");
}

@end
