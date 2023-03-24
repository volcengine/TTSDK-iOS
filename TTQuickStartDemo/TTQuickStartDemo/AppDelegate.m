//
//  AppDelegate.m
//  TTQuickStartDemo
//
//  Created by ByteDance on 2022/10/18.
//

#import "AppDelegate.h"
#import "Constant.h"
#import "ViewController.h"
#import <TTSDK/TTSDKManager.h>
@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    window.backgroundColor = UIColor.whiteColor;
    UIViewController *rootVC = [[ViewController alloc] init];
    window.rootViewController = [[UINavigationController alloc] initWithRootViewController:rootVC];
    self.window = window;
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    [self initTTSDK];
    return YES;
}

- (void)initTTSDK {
    TTSDKConfiguration *cfg = [TTSDKConfiguration defaultConfigurationWithAppID:TTSDK_APP_ID licenseName:TTSDK_LICENSE_NAME];
    cfg.channel = @"iOS";
    cfg.serviceVendor = TTSDKServiceVendorCN;
    cfg.appName = @"TTQuickStartDemo";
    cfg.appVersion = @"1.0.0";
    cfg.shouldInitAppLog = YES;
    [TTSDKManager setShouldReportToAppLog:YES];
    [TTSDKManager startWithConfiguration:cfg];
}

@end
