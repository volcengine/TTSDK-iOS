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
#import "TTVideoEngineModelCache.h"

@interface TTVideoEngineModel : NSObject<TTVideoEngineSource,TTVideoEngineModelCacheItem>

@property (nonatomic, strong) TTVideoEngineInfoModel *videoInfo;

- (NSString *)codecType;

- (NSArray *)codecTypes;

- (NSString *)videoType;

/// build unique cache key
+ (NSString* )buildCacheKey:(NSString* )vid
                     params:(NSDictionary* )params
                     ptoken:(NSString* )ptoken;

@end
