//
//  VodSettingsStorage.h
//  VCVodSettings
//
//  Created by 黄清 on 2021/5/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger,VodSettingsCacheType){
    VodSettingsCacheMemory = 1<<0,
    VodSettingsCacheFile = 1<<1,
};

@interface VodSettingsStorage : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;

- (instancetype)initWithName:(NSString *)name type:(NSInteger)type NS_DESIGNATED_INITIALIZER;

- (void)tryToLoadLocal;

- (void)removeAllCache;

- (void)storeInfo:(NSDictionary *)info;

- (nullable NSDictionary *)getInfo;

- (void)setString:(NSString *)key value:(NSString *)strValue;

- (nullable NSString *)getString:(NSString *)key dValue:(nullable NSString *)dValue;

- (void)setNumber:(NSString *)key value:(NSNumber *)numValue;

- (nullable NSNumber *)getNumber:(NSString *)key dValue:(nullable NSNumber *)number;

- (void)setDict:(NSString *)key value:(NSDictionary *)dictValue;

- (nullable NSDictionary *)getDict:(NSString *)key dValue:(nullable NSDictionary *)dValue;


@end

NS_ASSUME_NONNULL_END
