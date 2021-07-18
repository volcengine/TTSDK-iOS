//
//  TTVideoEnginePreloadMedia.h
//  TTVideoEngine
//
//  Created by 黄清 on 2020/6/21.
//

#import <Foundation/Foundation.h>
#import "TTVideoEngineModelDef.h"

NS_ASSUME_NONNULL_BEGIN

@class TTVideoEngineLocalServerTaskInfo;
@interface TTVideoEnginePreloadMedia : NSObject

@property (nonatomic, copy, null_resettable) NSString *cacheKey;
@property (nonatomic, copy, nullable) NSString *videoId;
@property (nonatomic, assign) NSInteger preloadSize;

@property (nonatomic, copy, nullable) void(^preloadEnd)(TTVideoEngineLocalServerTaskInfo *_Nullable info, NSError *_Nullable error);
@property (nonatomic, copy, nullable) void(^preloadCanceled)(void);

/// preload task started
/// info @{@"index": @(index), @"url": url}
@property (nonatomic, copy, nullable) void(^preloadDidStart)(NSDictionary *_Nullable info);

@end

@interface TTVideoEnginePreloadURLMedia : TTVideoEnginePreloadMedia

@property (nonatomic, copy, nullable) NSArray<NSString *> *urls;

/// Custom header
@property (nonatomic, strong, nullable) NSMutableDictionary<NSString *, NSString *> *customHeaders;

/// Set custom header
- (void)setCustomHeaderValue:(NSString *)value forKey:(NSString *)key;

+ (nullable instancetype)urlMediaWithKey:(NSString *)cacheKey
                                 videoId:(nullable NSString *)videoId
                                    urls:(NSArray<NSString *> *)urls
                             preloadSize:(NSInteger)preloadSize;

@end


@class TTVideoEngineModel;
@interface TTVideoEnginePreloadModelMedia : TTVideoEnginePreloadMedia

@property (nonatomic, strong, nullable) TTVideoEngineModel *videoModel;

@property (nonatomic, assign) TTVideoEngineResolutionType resolution;

+ (nullable instancetype)modelMedia:(TTVideoEngineModel *)videoModel
                         resolution:(TTVideoEngineResolutionType)resolution
                        preloadSize:(NSInteger)preloadSize;

@end

NS_ASSUME_NONNULL_END
