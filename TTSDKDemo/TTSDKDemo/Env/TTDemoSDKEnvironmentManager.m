//
//  TTDemoSDKEnvironment.m
//  TTSDKDemo
//
//  Created by LiTianhao on 2020/10/20.
//  Copyright © 2020 LiTianhao. All rights reserved.
//

#import "TTDemoSDKEnvironmentManager.h"

/// sdk demo 日志上报 AppLog的 默认 channel
static NSString *const kDefaultAppChannel = @"test_channel";
/// sdk demo 默认的应用名称
static NSString *const kDefaultAppName = @"TTSDKDemo";

static NSInteger const kDefaultEnvironmentKey = 0;

/// 环境变量model
@interface TTDemoSDKEnvironmentModel : NSObject <TTDemoSDKEnvironmentDataProvider>

/// 国内的环境变量
+ (instancetype)environmentModelForCN;
/// 国外的环境变量
+ (instancetype)environmentModelForOversea;

@end

@interface TTDemoSDKEnvironmentManager()

@property (nonatomic , strong) NSDictionary<id<NSCopying>, id<TTDemoSDKEnvironmentDataProvider>> *environmentMap;

@end

@implementation TTDemoSDKEnvironmentManager
@synthesize appName=_appName , appId=_appId , channel=_channel;

+ (instancetype)shareEvnironment
{
    static TTDemoSDKEnvironmentManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (instancetype)init
{
    if (self = [super init]) {
        TTDemoSDKEnvironmentModel *env_for_cn = [TTDemoSDKEnvironmentModel environmentModelForCN];
        TTDemoSDKEnvironmentModel *env_for_oversea = [TTDemoSDKEnvironmentModel environmentModelForOversea];

        self.environmentMap = @{
            @(kDefaultEnvironmentKey) : env_for_cn,
#if __has_include(<RangersAppLog/RangersAppLogCore.h>)
            @(TTSDKServiceVendorCN) : env_for_cn,
            @(TTSDKServiceVendorSG) : env_for_oversea,
            @(TTSDKServiceVendorVA) : env_for_oversea
#endif
        };
    }
    return self;
}

- (id<NSCopying>)environmentModelKey
{
    NSNumber *environmentKey = @(kDefaultEnvironmentKey);
    /// 如果引入了 RangersAppLogCore 就使用serviceVendor的值做key ， 否则就使用默认值0作为key
#if __has_include(<RangersAppLog/RangersAppLogCore.h>)
    if ([self.environmentMap.allKeys containsObject:@(self.serviceVendor)]) {
        environmentKey = @(self.serviceVendor);
    }else
    {
        NSLog(@"bad serviceVendor that could not find environmentModel , now use default environment");
    }
#endif
    return environmentKey;
}

- (NSString *)appName
{
    return self.environmentMap[self.environmentModelKey].appName;
}

- (NSString *)appId
{
    return self.environmentMap[self.environmentModelKey].appId;
}

- (NSString *)channel
{
    return self.environmentMap[self.environmentModelKey].channel;
}

@end


@implementation TTDemoSDKEnvironmentModel

@synthesize appName=_appName , appId=_appId , channel=_channel;

/// 国内的环境变量
+ (instancetype)environmentModelForCN
{
    TTDemoSDKEnvironmentModel *instance = [[self alloc] init];
    /// 测试逻辑： 海外上报appid 189189 国内使用179132
    instance.appId = @"179132";
    instance.appName = kDefaultAppName;
    instance.channel = kDefaultAppChannel;
    return instance;
}

/// 国外的环境变量
+ (instancetype)environmentModelForOversea
{
    TTDemoSDKEnvironmentModel *instance = [[self alloc] init];
    /// 测试逻辑： 海外上报appid 189189 国内使用179132
    instance.appId = @"189189";
    instance.appName = kDefaultAppName;
    instance.channel = kDefaultAppChannel;
    return instance;
}

@end
