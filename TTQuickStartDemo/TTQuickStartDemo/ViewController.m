//
//  ViewController.m
//  TTQuickStartDemo
//
//  Created by ByteDance on 2022/10/18.
//

#import "ViewController.h"
#import "VeLivePullViewController.h"
#import "VeLivePushViewController.h"
#import "VeLiveAnchorViewController.h"
#import "VeLiveAudienceViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)goPullViewController {
    [self.navigationController pushViewController:[[VeLivePullViewController alloc] init] animated:YES];
}

- (void)goPushViewController {
    [self.navigationController pushViewController:[[VeLivePushViewController alloc] init] animated:YES];
}

- (void)goInteractAnchorViewController {
    [self.navigationController pushViewController:[[VeLiveAnchorViewController alloc] init] animated:YES];
}

- (void)goInteractAudienceViewController {
    [self.navigationController pushViewController:[[VeLiveAudienceViewController alloc] init] animated:YES];
}

- (void)setupUI {
    UIButton *pullBtn = [[UIButton alloc] init];
    [pullBtn setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
    [pullBtn setTitle:@"观众拉流" forState:(UIControlStateNormal)];
    [pullBtn addTarget:self action:@selector(goPullViewController) forControlEvents:(UIControlEventTouchUpInside)];
    pullBtn.frame = CGRectMake(80, 150, 200, 45);
    [self.view addSubview:pullBtn];
    
    UIButton *pushBtn = [[UIButton alloc] init];
    [pushBtn setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
    [pushBtn setTitle:@"主播推流" forState:(UIControlStateNormal)];
    [pushBtn addTarget:self action:@selector(goPushViewController) forControlEvents:(UIControlEventTouchUpInside)];
    pushBtn.frame = CGRectMake(80, 220, 200, 45);
    [self.view addSubview:pushBtn];
    
    UIButton *anchorBtn = [[UIButton alloc] init];
    [anchorBtn setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
    [anchorBtn setTitle:@"主播推流+连麦" forState:(UIControlStateNormal)];
    [anchorBtn addTarget:self action:@selector(goInteractAnchorViewController) forControlEvents:(UIControlEventTouchUpInside)];
    anchorBtn.frame = CGRectMake(80, 290, 200, 45);
    [self.view addSubview:anchorBtn];
    
    UIButton *audienceBtn = [[UIButton alloc] init];
    [audienceBtn setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
    [audienceBtn setTitle:@"观众拉流+连麦" forState:(UIControlStateNormal)];
    [audienceBtn addTarget:self action:@selector(goInteractAudienceViewController) forControlEvents:(UIControlEventTouchUpInside)];
    audienceBtn.frame = CGRectMake(50, 360, 260, 45);
    [self.view addSubview:audienceBtn];
}

@end
