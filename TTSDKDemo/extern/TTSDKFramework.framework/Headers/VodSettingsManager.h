//
//  VodSettingsManager.h
//  VCVodSettings
//
//  Created by 黄清 on 2021/5/23.
//

#import <Foundation/Foundation.h>
#import "VodSettingsNetProtocol.h"
#import "VodSettingsConfigEnv.h"

NS_ASSUME_NONNULL_BEGIN


FOUNDATION_EXPORT const NSNotificationName kVodSettingsUpdateNotification;
FOUNDATION_EXPORT NSString *const kVodSettingsUpdateInfoWhat;/// see VodSettingsUpdateWhat
FOUNDATION_EXPORT NSString *const kVodSettingsUpdateInfoModule; /// see VodSettingsModule


typedef NS_ENUM(NSInteger,VodSettingsUpdateWhat) {
    VodSettingsUpdateWhatIsRefresh = 1000,
};

typedef NS_ENUM(NSInteger,VodSettingsModule) {
    VodSettingsModuleAll = 0, /// placeholder
    VodSettingsModuleVod = 1,
    VodSettingsModuleMDL = 2,
    VodSettingsModuleUpload = 3,
    VodSettingsModuleCommon = 4,
};

@interface VodSettingsManager : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// SDK version
+ (NSString *)versionString;

@property (nonatomic, assign) NSInteger maxRetryTimes;
@property (nonatomic, assign) NSInteger fetchInterval;
@property (nonatomic, assign) NSInteger debug;
@property (nonatomic, strong) id<VodSettingsNetProtocol> netImp;
@property (nonatomic, strong, readonly) VodSettingsConfigEnv *env;


+ (instancetype)shareSettings;

- (void)loadLocal:(BOOL)async;

- (void)refresh;
- (void)refreshWithModule:(NSInteger)module;
- (void)refreshIfNeed:(NSInteger)module;
- (void)refreshWithModule:(NSInteger)module key:(NSString *)configKey;

/// MARK: - Getter

- (nullable NSNumber *)getVodNumber:(NSString *)key dValue:(nullable NSNumber *)dValue;
- (nullable NSString *)getVodString:(NSString *)key dValue:(nullable NSString *)dValue;
- (nullable NSDictionary *)getVodDict:(NSString *)key;

- (nullable NSNumber *)getMDLNumber:(NSString *)key dValue:(nullable NSNumber *)dValue;
- (nullable NSString *)getMDLString:(NSString *)key dValue:(nullable NSString *)dValue;
- (nullable NSDictionary *)getMDLDict:(NSString *)key;

- (nullable NSNumber *)getUploadNumber:(NSString *)key dValue:(nullable NSNumber *)dValue;
- (nullable NSString *)getUploadString:(NSString *)key dValue:(nullable NSString *)dValue;
- (nullable NSDictionary *)getUploadDict:(NSString *)key;


- (nullable NSNumber *)getNumber:(NSInteger) module key:(NSString *)key dValue:(nullable NSNumber *)dValue;
- (nullable NSString *)getString:(NSInteger) module key:(NSString *)key dValue:(nullable NSString *)dValue;
- (nullable NSDictionary *)getDict:(NSInteger) module key:(NSString *)key;

/// Set Key for common module.
- (void)setCommonString:(NSString *)key value:(nullable NSString *)value;
- (void)setCommonNumber:(NSString *)key value:(nullable NSNumber *)value;
- (void)setCommonDict:(NSString *)key value:(nullable NSDictionary *)value;

- (nullable NSNumber *)getCommonNumber:(NSString *)key dValue:(nullable NSNumber *)dValue;
- (nullable NSString *)getCommonString:(NSString *)key dValue:(nullable NSString *)dValue;
- (nullable NSDictionary *)getCommonDict:(NSString *)key;


@end

NS_ASSUME_NONNULL_END
