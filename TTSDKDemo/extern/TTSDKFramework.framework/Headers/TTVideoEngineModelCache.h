//
//  TTVideoEngineModelCache.h
//  TTVideoEngine
//
//  Created by 黄清 on 2018/10/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTVideoEngineModelCacheItem <NSObject>

@required
/// estimate cache item valid
/// TTVideoEngineModelCache will auto remove item when return YES.
- (BOOL)hasExpired;

@end

@interface TTVideoEngineModelCache : NSObject

/**
 Single instance method

 @return single instance
 */
+ (instancetype)shareCache;

/**
 Add item to cache

 @param item cache item
 @param cacheKey the cache key
 */
- (void)addItem:(id<TTVideoEngineModelCacheItem> _Nonnull)item forKey:(NSString *)cacheKey;

/**
 Remove item by key

 @param cacheKey the cache key
 */
- (void)removeItemForKey:(NSString *)cacheKey;

/**
 Get cacheItem by cacheKey

 @param cacheKey the cacheKey
 @return nullable cacheItem
 */
- (nullable id<TTVideoEngineModelCacheItem>)getItemForKey:(NSString *)cacheKey;

/**
 Clear all items
 */
- (void)clearAllItems;

@end

NS_ASSUME_NONNULL_END
