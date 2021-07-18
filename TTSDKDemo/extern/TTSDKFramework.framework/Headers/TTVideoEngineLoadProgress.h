//
//  TTVideoEngineLoadProgress.h
//  TTVideoEngine
//
//  Created by 黄清 on 2020/7/17.
//

#import <Foundation/Foundation.h>
#import "TTVideoEngineModelDef.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TTVideoEngineDataLoaderTaskType) {
    TTVideoEngineDataLoaderTaskTypePreload,
    TTVideoEngineDataLoaderTaskTypePlay,
};

typedef NS_ENUM(NSInteger, TTVideoEngineCacheState) {
    TTVideoEngineCacheStateWirte      = 1,
    TTVideoEngineCacheStateDone       = 2,
};

@interface TTVideoEngineCacheRange : NSObject <NSCopying>
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger size;
@end

@interface TTVideoEngineLoadCacheInfo : NSObject <NSCopying>
@property (nonatomic,   copy) NSString *cacheKey;
@property (nonatomic, assign) NSInteger mediaSize;
@property (nonatomic, assign) NSInteger preloadHeaderSize;
@property (nonatomic, assign) NSInteger preloadOffset;
@property (nonatomic, assign) NSInteger preloadSize;
@property (nonatomic, assign) TTVideoEngineCacheState cacheState;
@property (nonatomic, assign) TTVideoEngineResolutionType resolution;
@property (nonatomic,   copy) NSArray<TTVideoEngineCacheRange *> *cacheRanges;
@property (nonatomic,   copy) NSString *localFilePath;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign, readonly) NSInteger maxCacheEnd;


- (void)setCacheSize:(NSInteger)cacheSize;
- (BOOL)isFinished;

@end

@interface TTVideoEngineLoadProgress : NSObject <NSCopying>
@property (nonatomic,   copy, nullable) NSString *videoId;
@property (nonatomic, assign) TTVideoEngineDataLoaderTaskType taskType;
@property (nonatomic,   copy) NSArray<TTVideoEngineLoadCacheInfo *> *cacheInfos;

@property (nonatomic, assign, readonly) TTVideoEngineCacheState cacheState;
@property (nonatomic, assign, readonly, getter=isPreloadComplete) BOOL preloadComplete;
@property (nonatomic, assign, readonly, getter=isCacheEnd) BOOL cacheEnd;

- (NSInteger)getTotalCacheSize; /// all file cache size.
- (NSInteger)getTotalMediaSize; /// all file media size.


- (TTVideoEngineLoadCacheInfo *)getCahceInfo:(NSString *)key;
- (void)receiveError:(NSString *)key error:(NSError *)error;

@end


NS_ASSUME_NONNULL_END
