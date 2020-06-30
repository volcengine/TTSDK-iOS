//
//  TTVideoCacheManager.h
//  FLEX
//
//  Created by thq on 2018/8/21.
//

#import <Foundation/Foundation.h>

@interface TTVideoEngineCacheInfo : NSObject
@property (nonatomic, readonly) NSString *filePath;
@property (nonatomic, readonly) NSString *fileName;
@property (nonatomic, readonly) NSString *fileKey;
@property (nonatomic, readonly) NSString *spadeaKey;
@property (nonatomic, readonly) unsigned long long fileSize;
@end

@interface TTVideoCacheManager : NSObject
@property (nonatomic, readonly) unsigned long long videoCacheSize;

+ (instancetype)shared;

/**
 get cacheinfo by key
 */
- (TTVideoEngineCacheInfo*) getCacheInfo:(NSString*)key;

/**
 add cache info
 */
- (void) addCacheInfo:(NSString*)fileName filePath:(NSString*)filePath;

- (void) addProtectKey:(NSString *)key;

- (void) removeProtectKey:(NSString *)key;

- (void) setCacheParameter:(NSString*)dir maxSize:(unsigned long long)maxSize;

- (void) start;

- (void) compact;


/// Splicing file path
+ (nullable NSString *)cacheFilePath:(NSString *)fileName dir:(NSString *)cacheDir;

/**
 Use TTVideoEngine to play the video. After the playback ends, the resource will be cached.
 You can use this method to verify the integrity of the resource.
 
 @param cacheFilePath local path to the resource、
 */
- (BOOL)checkCacheFileComplete:(NSString* )cacheFilePath;

/**
 Check the integrity of the cache file.
 
 @param filePath The local file path.
 @param fileHash File hash, md5 value.
 @param fileSize The origin size of file.
 @return BOOL value.
 */
- (BOOL)checkCacheFileIntegrity:(NSString *)filePath fileHash:(NSString *)fileHash fileSize:(uint64_t)fileSize;

@end
