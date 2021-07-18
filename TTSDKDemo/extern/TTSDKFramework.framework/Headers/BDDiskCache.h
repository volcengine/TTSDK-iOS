//
//  BDDiskCache.h
//  BDWebImage
//
//

#ifndef BDDiskCache_h
#define BDDiskCache_h

#import <Foundation/Foundation.h>
#import "BDImageCacheConfig.h"

typedef void(^BDImageDiskTrimBlock)(NSString * _Nonnull key);

@protocol BDDiskCache <NSObject>

@property (nonatomic, assign, readonly) BOOL trimDiskInBG;

@property (nonatomic, strong, readonly) NSString * _Nonnull path;

@property (nonatomic, copy) BDImageDiskTrimBlock _Nullable trimBlock;

@required
/**
 创建指定 path 的磁盘缓存， 可以给磁盘缓存设置 `maxDiskSize` 和 `maxDiskAge`
 
 @param cachePath 磁盘缓存用于保存缓存对象的缓存路径
 
 @return 返回一个磁盘缓存实例, 发生错误时返回 nil
 */
- (nullable instancetype)initWithCachePath:(nonnull NSString *)cachePath;

/**
 磁盘缓存的设置

 @param config 用于设置磁盘缓存
 */
- (void)setConfig:(nonnull BDImageCacheConfig *)config;

/**
 如果指定的 key 报存在缓存中，返回 YES；否则返回 NO
 这个方法同步读取文件过程中会阻塞线程
 
 @param key 标识缓存对象的一个字符串，如果传入 nil 则返回 NO
 @return 指定 key 是否存在缓存中
 */
- (BOOL)containsDataForKey:(nonnull NSString *)key;

/**
 异步判断指定的 key 是否保存在缓存中

 @param key 缓存指定的 key
 @param block 判断 key 是否保存在缓存后的回调
 */
- (void)containsDataForKey:(nonnull NSString *)key withBlock:(nullable void(^)(NSString * _Nonnull key, BOOL contains))block;

/**
 返回缓存中指定 key 对应的缓存对象
 这个方法同步读取文件过程中会阻塞线程
 
 @param key 标识缓存对象的一个字符串，如果传入 nil 则返回 nil
 @return 指定 key 对应的缓存对象，如果不存在返回 nil
 */
- (nullable NSData *)dataForKey:(nonnull NSString *)key;

/**
 异步返回缓存中指定 key 对应的缓存对象

 @param key 标识缓存对象的一个字符串值，如果传入 nil 则返回 nil
 @param block 读取文件后取得的缓存对象或 nil 通过 block 进行回调
 */
- (void)dataForKey:(nonnull NSString *)key withBlock:(nullable void(^)(NSString * _Nonnull key, NSData * _Nullable data))block;

/**
 将缓存对象和指定的 key 设置到缓存中
 这个方法同步写文件的过程中会阻塞线程
 
 @param data 存储到缓存中的缓存对象
 @param key  缓存对象对应标识的 key，如果是 nil，这个方法不会有任何操作
 */
- (void)setData:(nullable NSData *)data forKey:(nonnull NSString *)key;

/**
 异步将缓存对象和指定的 key 设置到缓存中

 @param data 存储到缓存中的缓存对象
 @param key 缓存对象对应标识的 key，如果是 nil，这个方法不会有任何操作
 @param block 将缓存对象写入缓存成功后，通过 block 进行回调
 */
- (void)setData:(nullable NSData *)data forKey:(nonnull NSString *)key withBlock:(nullable void(^)(void))block;

/**
 删除缓存中指定 key 对应的缓存对象
 这个方法在同步删除文件的过程中会阻塞线程
 
 @param key 标识缓存对象的一个字符串值，如果传入 nil 则返回 nil
 */
- (void)removeDataForKey:(nonnull NSString *)key;

/**
 异步删除缓存中指定 key 对应的缓存对象

 @param key 标识缓存对象的一个字符串值，如果传入 nil 则返回 nil
 @param block 删除指定 key 对应的缓存对象后，通过 block 进行回调
 */
- (void)removeDataForKey:(nonnull NSString *)key withBlock:(nullable void(^)(NSString * _Nonnull key))block;

/**
 清空缓存
 这个方法在同步删除文件的时候会阻塞线程
 */
- (void)removeAllData;

/**
 清空缓存

 @param block 删除文件清空缓存后通过 block 进行回调
 */
- (void)removeAllDataWithBlock:(nullable void(^)(void))block;

/**
 删除缓存中废弃的缓存对象，根据 config 中设置的过期时间和缓存大小来决定缓存对象是否废弃
 */
- (void)removeExpiredData;

/**
 指定 key 对应的缓存路径
 @param key 标识缓存对象的一个字符串值
 @return 指定 key 对应的缓存路径，如果 key 不可接受d返回 nil
 */
- (nullable NSString *)cachePathForKey:(nonnull NSString *)key;

/**
 返回缓存中所有缓存对象的数量
 这个方法在同步读取文件是会阻塞线程
 
 @return 所有缓存对象的数量
 */
- (NSUInteger)totalCount;

/**
 返回缓存中所有缓存对象所占的大小（单位 bytes）
 这个方法在同步读取文件是会阻塞线程
 
 @return 所有缓存对象的数量所占的大小
 */
- (NSUInteger)totalSize;

@end

#endif /* BDDiskCache_h */
