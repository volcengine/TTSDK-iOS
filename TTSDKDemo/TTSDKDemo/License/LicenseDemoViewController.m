//
//  LicenseDemoViewController.m
//  TTSDKDemo
//
//  Created by guojieyuan on 2021/3/31.
//  Copyright © 2021 ByteDance. All rights reserved.
//

#import "LicenseDemoViewController.h"
#import "TTDemoSDKEnvironmentManager.h"
#import "LicenseAssociatedConst.h"
#import <Masonry.h>

@interface LicenseDemoViewController ()
@property (nonatomic, strong) UITextField  *textfiled;
@property (nonatomic, strong) UIButton  *remoteBtn;
@property (nonatomic, strong) UIButton  *contentBtn;
@property (nonatomic, strong) UIButton  *checkLicenseBtn;
@property (nonatomic, strong) UIButton  *cleanCacheBtn;
@property (nonatomic, strong) UIButton  *regionButton;

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
    [self.textfiled setPlaceholder:@"远端地址 || 替換內容 || 要查询的LicenseID"];
    [self.textfiled setBorderStyle:UITextBorderStyleRoundedRect];
    [self.textfiled setClearButtonMode:UITextFieldViewModeWhileEditing];
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
    
    _contentBtn = [self createButtonWithTitle:@"替换证书内容"];
    [_contentBtn addTarget:self action:@selector(handleLicenseContent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_contentBtn];
    [_contentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_remoteBtn.mas_bottom).offset(16);
        make.centerX.width.height.equalTo(_remoteBtn);
    }];

    _checkLicenseBtn = [self createButtonWithTitle:@"使用LicenseID查询对应证书"];
    [_checkLicenseBtn addTarget:self action:@selector(getLicenseInfoJSONStr) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_checkLicenseBtn];
    [_checkLicenseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentBtn.mas_bottom).offset(16);
        make.centerX.width.height.equalTo(_contentBtn);
    }];
    
    _cleanCacheBtn = [self createButtonWithTitle:@"清除已設置的證書並退出"];
    [_cleanCacheBtn addTarget:self action:@selector(cleanLicenseCache) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cleanCacheBtn];
    [_cleanCacheBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_checkLicenseBtn.mas_bottom).offset(16);
        make.centerX.width.height.equalTo(_checkLicenseBtn);
    }];
    
    _regionButton = [self createButtonWithTitle:@"切换上报区域"];
    [_regionButton addTarget:self action:@selector(changeRegion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_regionButton];
    [_regionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cleanCacheBtn.mas_bottom).offset(16);
        make.centerX.width.height.equalTo(_cleanCacheBtn);
    }];
    
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
    [self updateLicenseWith:content];
}

- (void)handleLicenseContent {
    NSString *content = self.textfiled.text;
    if (!content.length) {
        [self makeToast:@"empty content"];
        return;
    }
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    // Use md5 to avoid same content redundant
    NSString *contentMD5Path = [NSString stringWithFormat:@"/%@.text", [content md5String]];
    NSString *userDefineLicensePath = [docPath stringByAppendingString:contentMD5Path];
    if (![[NSFileManager defaultManager] fileExistsAtPath:userDefineLicensePath]) {
        BOOL created = [[NSFileManager defaultManager] createFileAtPath:userDefineLicensePath contents:[[NSData alloc] init] attributes:nil];
        if (!created) {
            [self makeToast:@"license create fail."];
            return;
        }
    }
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        BOOL rc = [data writeToFile:userDefineLicensePath atomically:YES];
        if (rc) {
            [NSUserDefaults.standardUserDefaults setValue:userDefineLicensePath forKey:LastLicenseDocumentPathUserDefaultsKey];
            [self updateLicenseWith:userDefineLicensePath];
        } else {
            [self makeToast:@"写入失败"];
        }
    }
}

- (void)updateLicenseWith:(NSString *)urlStr {
    TTSDKConfiguration *configuration = [TTSDKConfiguration defaultConfigurationWithAppID:[[TTDemoSDKEnvironmentManager shareEvnironment] appId]];
    configuration.appName = [[TTDemoSDKEnvironmentManager shareEvnironment] appName];
    configuration.channel = [[TTDemoSDKEnvironmentManager shareEvnironment] channel];
    configuration.bundleID = @"com.bytedance.videoarch.pandora.demo";
    configuration.licenseFilePath = urlStr;
    [TTSDKManager setCurrentUserUniqueID:@"10352432926"];
    [TTSDKManager startWithConfiguration:configuration];
    [self makeToast:@"已触发更新"];
}

- (void)cleanLicenseCache {
    [NSUserDefaults.standardUserDefaults removeObjectForKey:LastLicenseDocumentPathUserDefaultsKey];
    exit(0);
}

- (void)getLicenseInfoJSONStr {
    NSString *content = self.textfiled.text;
    if (!content.length) {
        [self makeToast:@"empty content"];
        return;
    }
    NSDictionary* license = [TTSDKManager getCurrentLicenseInfo:content];
    if (!license || (license.count == 0)) {
        [self makeToast:@"查无有效License"];
        return;
    }
    NSString* jsonStr = [license mj_JSONString];
    //
    UIViewController *vc = [[UIViewController alloc] init];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 32, 375, 700)];
    label.numberOfLines = 0;
    [label setText:jsonStr];
    [vc.view addSubview:label];
    [vc.view setBackgroundColor:UIColor.whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

static NSString *const service_vendor_key = @"TTSDK-Service-Vendor";

- (void)changeRegion {
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSString *region = [pref stringForKey:service_vendor_key];
    if ([region isEqualToString:@"SG"]) {
        [pref setObject:@"CN" forKey:service_vendor_key];
        [self makeToast:@"已切换到CN,重启App生效"];
    } else {
        [pref setObject:@"SG" forKey:service_vendor_key];
        [self makeToast:@"已切换到SG,重启App生效"];
    }
}

@end
