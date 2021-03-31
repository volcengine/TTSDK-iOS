//
//  LicenseDemoViewController.m
//  TTSDKDemo
//
//  Created by guojieyuan on 2021/3/31.
//  Copyright © 2021 ByteDance. All rights reserved.
//

#import "LicenseDemoViewController.h"
#import "TTDemoSDKEnvironmentManager.h"
#import <UIView+Toast.h>
#import <Masonry.h>


@interface LicenseDemoViewController ()
@property (nonatomic, strong) UITextField  *textfiled;
@property (nonatomic, strong) UIButton  *remoteBtn;
@property (nonatomic, strong) UIButton  *contnetBtn;
@end

@implementation LicenseDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:UIColor.whiteColor];
}

- (void)setUpUI {
    [super setUpUI];
    //
    _textfiled = [[UITextField alloc] init];
    [self.textfiled setPlaceholder:@"远端地址或要替換得內容"];
    [self.textfiled setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:self.textfiled];
    [self.textfiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset((NAVIGATIONBAR_BOTTOM + 16));
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view).offset(-32);
        make.height.equalTo(@(50));
    }];
    
    _remoteBtn = [self createButtonWithTitle:@"设置远端地址"];
    [self.view addSubview:_remoteBtn];
    [_remoteBtn addTarget:self action:@selector(handleRemoteLicense) forControlEvents:UIControlEventTouchUpInside];
    [_remoteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textfiled.mas_bottom).offset(16);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.textfiled).offset(-32);
        make.height.equalTo(@(50));
    }];
    
    _contnetBtn = [self createButtonWithTitle:@"替換內容"];
    [_contnetBtn addTarget:self action:@selector(handleLicenseContent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_contnetBtn];
    [_contnetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_remoteBtn.mas_bottom).offset(16);
        make.centerX.width.height.equalTo(_remoteBtn);
    }];
}

- (void)makeToast:(NSString *)msg {
    [UIApplication.sharedApplication.keyWindow makeToast:msg duration:1 position:@(self.view.center)];
}

- (void)handleRemoteLicense {
    NSString *content = self.textfiled.text;
    if (!content.length) {
        [self makeToast:@"empty content"];
        return;
    }
    NSURL *url = [NSURL URLWithString:content];
    if (!url) {
        [self makeToast:@"invalied url"];
        return;
    }
    [self addRemoteLicense:content];
}

- (void)handleLicenseContent {
    NSString *content = self.textfiled.text;
    if (!content.length) {
        [self makeToast:@"empty content"];
        return;
    }
    NSString *path = [NSBundle.mainBundle pathForResource:@"ttsdkdemo.license" ofType:nil];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
        if (data) {
            BOOL rc = [data writeToFile:path atomically:YES];
            if (rc) {
                exit(0);
            }
        }
    }
}

- (void)addRemoteLicense:(NSString *)urlStr {
    TTSDKConfiguration *configuration = [TTSDKConfiguration defaultConfigurationWithAppID:[[TTDemoSDKEnvironmentManager shareEvnironment] appId]];
    configuration.appName = [[TTDemoSDKEnvironmentManager shareEvnironment] appName];
    configuration.channel = [[TTDemoSDKEnvironmentManager shareEvnironment] channel];
    configuration.bundleID = @"com.bytedance.videoarch.pandora.demo";
    configuration.licenseFilePath = urlStr;
    [TTSDKManager setCurrentUserUniqueID:@"10352432926"];
    [TTSDKManager startWithConfiguration:configuration];
}

- (NSString *)getLicenseInfoJSONStr {
    
}

@end
