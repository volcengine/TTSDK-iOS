//
//  AppInfoViewController.m
//  TTSDKDemo
//
//  Created by chenzhaojie on 2021/2/28.
//  Copyright © 2021 ByteDance. All rights reserved.
//

#import "AppInfoViewController.h"
#import <Masonry.h>
#import <TTSDK/TTSDKManager.h>

@interface AppInfoViewController ()

@property (nonatomic, strong) UITextView *appInfoTextView;

@end

@implementation AppInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    NSMutableString *appInfoText = [NSMutableString string];
    [appInfoText appendFormat:@"SDKVersion: %@", TTSDKManager.SDKVersionString];
    [appInfoText appendFormat:@"\nbuildBranch: %@", [NSBundle.mainBundle.infoDictionary objectForKey:@"buildBranch"]];
    [appInfoText appendFormat:@"\ncommitID: %@", [NSBundle.mainBundle.infoDictionary objectForKey:@"commitID"]];
#if __has_include(<TTSDKFramework/TTSDKFramework.h>)
    [appInfoText appendFormat:@"\nuseDynamicLibrary: YES"];
#else
    [appInfoText appendFormat:@"\nuseDynamicLibrary: NO"];
#endif
    
    UITextView *appInfoTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    appInfoTextView.textAlignment = NSTextAlignmentCenter;
    appInfoTextView.backgroundColor = UIColor.clearColor;
    appInfoTextView.textColor = UIColor.whiteColor;
    appInfoTextView.text = appInfoText;
    [self.view addSubview:appInfoTextView];
    self.appInfoTextView = appInfoTextView;
}

- (void)viewWillLayoutSubviews {
    [self.appInfoTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

@end
