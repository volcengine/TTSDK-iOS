//
//  ExploreLeTVVideoModel.h
//  Article
//
//  Created by Zhang Leonardo on 15-3-5.
//
//

#import <Foundation/Foundation.h>
#import "TTVideoEngineInfoModel.h"
#import "TTVideoEngineSource.h"


NS_ASSUME_NONNULL_BEGIN

@interface TTVideoEngineModel : NSObject<TTVideoEngineSource, NSSecureCoding>

@property (nonatomic, nullable, strong) TTVideoEngineInfoModel *videoInfo;
+ (nullable instancetype)videoModelWithPb:(NSData *)data;

+ (nullable instancetype)videoModelWithDict:(NSDictionary *)info;

+ (nullable instancetype)videoModelWithDict:(NSDictionary *)info encrypted:(BOOL)encrypted;

- (nullable NSDictionary *)dictInfo;

- (NSString *)codecType;

- (nullable NSArray *)codecTypes;

- (NSString *)videoType;

- (BOOL)hasExpired;

- (BOOL)supportBash;

- (BOOL)supportDash;

/// build unique cache key
+ (nullable NSString *)buildCacheKey:(NSString *)vid
                              params:(NSDictionary *)params
                              ptoken:(NSString *)ptoken;

@end

NS_ASSUME_NONNULL_END
