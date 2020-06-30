//
//  TTLicenseManager.h
//  TTLicense
//
//  Created by 陈昭杰 on 2020/5/9.
//  Copyright © 2020 ByteDance. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString * const TTLicenseNotificationStatusDidCheck;
FOUNDATION_EXTERN NSString * const TTLicenseNotificationUserInfoModuleKey;
FOUNDATION_EXTERN NSString * const TTLicenseNotificationUserInfoStatusKey;
FOUNDATION_EXTERN NSString * const TTLicenseNotificationUserInfoIgnoreExpirationKey;

@class TTLicenseManager;

typedef NS_ENUM(NSUInteger, TTLicenseStatus) {
    TTLicenseStatusInvalid      = 0,
    TTLicenseStatusOK           = 1,
    TTLicenseStatusExpired      = 2,
    TTLicenseStatusTBD          = 3,
    TTLicenseStatusParamError   = 4,
};

typedef NS_ENUM(NSUInteger, TTLicenseModule) {
    TTLicenseModuleVOD          = 0,
    TTLicenseModuleUpload       = 1,
    TTLicenseModuleLivePush     = 2,
    TTLicenseModuleLivePull     = 3,
    TTLicenseModuleEditor       = 4,
};

@interface TTLicenseManager : NSObject

@property (class, nonatomic, strong, readonly) TTLicenseManager *defaultManager;

- (void)updateWithAppID:(NSString *)appID bundleID:(NSString *)bundleID licenseFile:(NSString *)filePath error:(NSError **)error;

- (TTLicenseStatus)checkStatusWithModule:(TTLicenseModule)module enableExpired:(BOOL)enableExpired;

@end
