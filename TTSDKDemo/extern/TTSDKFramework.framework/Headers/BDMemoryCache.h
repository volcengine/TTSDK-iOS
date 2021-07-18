//
//  BDMemoryCache.h
//  BDWebImage
//
//

#ifndef BDMemoryCache_h
#define BDMemoryCache_h

#import <Foundation/Foundation.h>
#import "BDImageCacheConfig.h"

@protocol BDMemoryCache <NSObject>

@required
/**
 通过指定的内存 config 创建内存缓存实例。config 中内存相关的属性将在内存缓存中生效。
 Create a new memory cache instance with the specify cache config. You can check `maxMemoryCost` and `maxMemoryCount` used for memory cache.

 @param config The cache config to be used to create the cache.
 @return The new memory cache instance.
 */
- (nonnull instancetype)initWithConfig:(nonnull BDImageCacheConfig *)config;

/**
 将指定的内存 config 设置到内存缓存实例中，重复调用会覆盖内存缓存实例中的 config。config 中内存相关的属性将在内存缓存中生效。
 
 @param config The cache config to be used to create the cache.
 */
- (void)setConfig:(nonnull BDImageCacheConfig *)config;

/**
 返回给定 key 关联的对象 value
 
 @param key An object identifying the value. If nil, just return nil.
 @return The value associated with key, or nil if no value is associated with key.
 */
- (nullable id)objectForKey:(nonnull id)key;

/**
 将指定的 key 及其对应的对象 value 保存到缓存中 (0 cost).
 
 @param object The object to be stored in the cache. If nil, it calls `removeObjectForKey:`.
 @param key    The key with which to associate the value. If nil, this method has no effect.
 @discussion Unlike an NSMutableDictionary object, a cache does not copy the key
 objects that are put into it.
 */
- (void)setObject:(nullable id)object forKey:(nonnull id)key;

/**
 将指定的 key 及其对应的对象 value 保存到缓存中，并将键值对与指定的内存占用相关联
 
 @param object The object to store in the cache. If nil, it calls `removeObjectForKey`.
 @param key    The key with which to associate the value. If nil, this method has no effect.
 @param cost   The cost with which to associate the key-value pair.
 @discussion Unlike an NSMutableDictionary object, a cache does not copy the key
 objects that are put into it.
 */
- (void)setObject:(nullable id)object forKey:(nonnull id)key cost:(NSUInteger)cost;

/**
 判断指定 key 对应的对象 value 是否存在缓存中
 @param key The key identifying the value that exists in the cache. If nil, this method has no effect.
 */
- (BOOL)containsObjectForKey:(nonnull id)key;

/**
 删除缓存中指定 key 对应的对象 value
 @param key The key identifying the value to be removed. If nil, this method has no effect.
 */
- (void)removeObjectForKey:(nonnull id)key;

/**
 立即清空缓存
 */
- (void)removeAllObjects;

@end

#endif /* BDMemoryCache_h */
