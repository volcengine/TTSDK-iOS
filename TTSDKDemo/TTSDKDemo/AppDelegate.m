//
//  AppDelegate.m
//  TTSDKDemo
//
//  Created by 陈昭杰 on 2020/1/7.
//  Copyright © 2020 ByteDance. All rights reserved.
//

#import "AppDelegate.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "NavigationViewController.h"
#import "HomeViewController.h"
#import <RangersAppLog/RangersAppLogCore.h>
#import "TTDemoSDKEnvironmentManager.h"
#import "LicenseAssociatedConst.h"

FOUNDATION_EXTERN NSString * const TTLicenseNotificationLicenseDidAdd;
FOUNDATION_EXTERN NSString * const TTLicenseNotificationLicenseInfoDidUpdate;;
FOUNDATION_EXTERN NSString * const TTLicenseNotificationIdKey;
FOUNDATION_EXTERN NSString * const TTLicenseNotificationLicenseResultKey;

void uncaughtExceptionHandler(NSException*exception){
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@",[exception callStackSymbols]);
}

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [self addLicenseObserver];
    
    NSLog(@"TTSDK version: %@", TTSDKManager.SDKVersionString);
    [TTDemoSDKEnvironmentManager shareEvnironment].serviceVendor = TTSDKServiceVendorCN;
    [self initAppLog];
    [self initBDImageManager];

    [self initTTSDK];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIViewController *rootVC = [[HomeViewController alloc] init];
    NavigationViewController* naviVC = [[NavigationViewController alloc] initWithRootViewController:rootVC];
    self.window.rootViewController = naviVC;
    [self.window makeKeyAndVisible];
    
    [TTVideoEngine tracker_start:^(NSString * _Nullable deviceID, NSString * _Nullable installID, NSString * _Nullable ssID) {
        NSLog(@"deviceID = %@, installID = %@, ssID = %@",deviceID,installID,ssID);
    }];
    
    // 启动播放器的localserver.
    [self startVideoServer];
    
    // Keyboard manager
    [IQKeyboardManager sharedManager].enable = YES;

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [TTVideoEngine stopOpenGLESActivity];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [TTVideoEngine startOpenGLESActivity];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // 关闭播放器的localServer
    [self stopVideoServer];
}

- (void)initTTSDK {
    TTSDKConfiguration *configuration = [TTSDKConfiguration defaultConfigurationWithAppID:[[TTDemoSDKEnvironmentManager shareEvnironment] appId]];
    configuration.appName = [[TTDemoSDKEnvironmentManager shareEvnironment] appName];
    configuration.channel = [[TTDemoSDKEnvironmentManager shareEvnironment] channel];
    configuration.bundleID = @"com.bytedance.videoarch.pandora.demo";
    // Add Runtime Update License Path
    NSString* lastPath = [NSUserDefaults.standardUserDefaults stringForKey:LastLicenseDocumentPathUserDefaultsKey];
    if (lastPath && [[NSFileManager defaultManager] fileExistsAtPath:lastPath]) {
        configuration.licenseFilePath = lastPath;
    } else {
        configuration.licenseFilePath = [NSBundle.mainBundle pathForResource:LicenseBundleName ofType:nil];
    }
    [TTSDKManager setCurrentUserUniqueID:@"10352432926"];
    [TTSDKManager startWithConfiguration:configuration];
}


- (void)initAppLog {
#if __has_include(<RangersAppLog/RangersAppLogCore.h>)
    BDAutoTrackConfig *config = [BDAutoTrackConfig new];
    // 必须配置
    config.appID = [[TTDemoSDKEnvironmentManager shareEvnironment] appId];
    config.appName = [[TTDemoSDKEnvironmentManager shareEvnironment] appName];
    config.channel = [[TTDemoSDKEnvironmentManager shareEvnironment] channel];
    config.serviceVendor = TTSDKServiceVendorCN == [[TTDemoSDKEnvironmentManager shareEvnironment] serviceVendor] ? BDAutoTrackServiceVendorCN : BDAutoTrackServiceVendorVA;
    config.autoTrackEnabled = NO;
#if DEBUG
    config.showDebugLog = YES;      // YES则会在控制台输出日志，仅仅调试使用，release版本请勿设置为YES
    config.logNeedEncrypt = NO;     // 日志上报是否加密，默认加密，release版本请勿设置为NO
#else
    config.showDebugLog = NO;       // YES则会在控制台输出日志，仅仅调试使用，release版本请勿设置为YES
    config.logNeedEncrypt = YES;    // 日志上报是否加密，默认加密，release版本请勿设置为NO
#endif
    config.logger = ^(NSString * _Nullable log) {
        NSLog(@"report log: %@", log);
    };
    config.gameModeEnable = NO;     // 游戏模式，会开始playSession上报
    [BDAutoTrack setCurrentUserUniqueID:@"10352432926"];
    [BDAutoTrack startTrackWithConfig:config];
#endif
}

- (void)initBDImageManager
{
    // 配置图片库AppID 是否是海外产品
    BDWebImageStartUpConfig * imageConfig = [BDWebImageStartUpConfig new];
    imageConfig.appID = [[TTDemoSDKEnvironmentManager shareEvnironment] appId];
    imageConfig.serviceVendor = BDAutoTrackServiceVendorCN;
    [[BDWebImageManager sharedManager] startUpWithConfig:imageConfig];
}

- (void)startVideoServer {
    // 启动 local server 服务；
    // 1. 配置
    TTVideoEngine.ls_localServerConfigure.maxCacheSize = 300 * 1024 * 1024;// 300M
    NSString *cacheDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"com.video.cache"];
    TTVideoEngine.ls_localServerConfigure.cachDirectory = cacheDir;
    //2. 启动
    [TTVideoEngine ls_start];
}

- (void)stopVideoServer {
    if (TTVideoEngine.ls_isStarted) {
        [TTVideoEngine ls_close];
    }
}


- (void)addLicenseObserver {
    [[NSNotificationCenter defaultCenter] addObserverForName:TTLicenseNotificationLicenseDidAdd object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        NSNumber *success = [note userInfo][TTLicenseNotificationLicenseResultKey];
        BOOL isSuccess = [success boolValue];
        if (isSuccess) {
            NSLog(@"TTSDKLicense: add license successfully");
            NSString *lid = [note userInfo][TTLicenseNotificationIdKey];
            if (lid) {
                NSDictionary *info = [TTSDKManager getCurrentLicenseInfo:lid];
                NSLog(@"TTSDKLicense: license info: %@", info);
            }
        } else {
            NSLog(@"TTSDKLicense: failed to add license");
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:TTLicenseNotificationLicenseInfoDidUpdate object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        NSNumber *success = [note userInfo][TTLicenseNotificationLicenseResultKey];
        BOOL isSuccess = [success boolValue];
        if (isSuccess) {
            NSLog(@"TTSDKLicense:  update license successfully");
            NSString *lid = [note userInfo][TTLicenseNotificationIdKey];
            if (lid) {
                NSDictionary *info = [TTSDKManager getCurrentLicenseInfo:lid];
                NSLog(@"TTSDKLicense:  license info: %@", info);
            }
        } else {
            NSLog(@"TTSDKLicense:  failed to update license");
        }
    }];
}

@end
