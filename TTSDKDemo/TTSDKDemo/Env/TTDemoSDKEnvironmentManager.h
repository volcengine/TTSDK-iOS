//
//  TTDemoSDKEnvironment.h
//  TTSDKDemo
//
//  Created by LiTianhao on 2020/10/20.
//  Copyright © 2020 LiTianhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TTDemoSDKEnvironmentDataProvider <NSObject>

/// sdk demo 的appid
@property (nonatomic , copy) NSString *appId;
/// sdk demo 的appName
@property (nonatomic , copy) NSString *appName;
/// sdk demo channel
@property (nonatomic , copy) NSString *channel;
@end

/// TTSDK demo 环境变量集合model
@interface TTDemoSDKEnvironmentManager : NSObject <TTDemoSDKEnvironmentDataProvider>

/// 日志上报地区属性 中国 新加坡 美东  这个属性应该在demo启动时 优先于appId及appName设置 默认 CN 中国
@property (nonatomic , assign) TTSDKServiceVendor serviceVendor;

/// 全局唯一环境类
+ (instancetype)shareEvnironment;

@end

