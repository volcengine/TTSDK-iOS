//
//  TTSDKManager.h
//  TTSDK
//
//  Created by 陈昭杰 on 2020/2/4.
//  Copyright © 2020 ByteDance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TTSDKLogger)(NSString * _Nullable log);

typedef NS_ENUM(NSInteger, TTSDKServiceVendor) {
    TTSDKServiceVendorCN = 0x010, // 国内 中国
    TTSDKServiceVendorSG,         // 新加坡
    TTSDKServiceVendorVA,         // 美东
};

@interface TTSDKConfiguration : NSObject

/// AppID，非空，必须设置
@property (nonatomic, copy, nonnull, readonly) NSString *appID;

/// 申请appID时候填写的英文名称
@property (nonatomic, copy) NSString *appName;

/// 默认 @"App Store", Release版本只有 @"App Store"， debug版本可以任意设置
@property (nonatomic, copy) NSString *channel;

/// 请勿擅自选择，需要与申请服务的地区一致，或者咨询接口人确认
@property (nonatomic, assign) TTSDKServiceVendor serviceVendor;

/// license文件路径
@property (nonatomic, copy) NSString *licenseFilePath;

/// bundle ID
@property (nonatomic, copy) NSString *bundleID;

/// 用指定appID获取默认配置
/// @param appID appID
+ (instancetype)defaultConfigurationWithAppID:(NSString *)appID;

@end

@interface TTSDKManager : NSObject

/// TTSDK版本号
@property (class, nonatomic, copy, nonnull, readonly) NSString *SDKVersionString;

/// 使用给定的配置启动TTSDK相关任务，启动app时调用
/// @param configuration TTSDK相关配置信息
+ (void)startWithConfiguration:(TTSDKConfiguration *)configuration;

/// 设置当前UserUniqueID，UserUniqueID发生变化时使用
/// @param uniqueID 用户id，如无特殊需求，请勿传 空字符串 或者 全是空格的字符串
+ (void)setCurrentUserUniqueID:(nullable NSString *)uniqueID;

/// 清除当前UserUniqueID
+ (void)clearUserUniqueID;

@end

NS_ASSUME_NONNULL_END
