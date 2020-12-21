//
//  BDImageCache.h
//  BDWebImage
//
//

#import <Foundation/Foundation.h>
#import "BDImageCacheConfig.h"
#import "BDWebImageRequest.h"
#import "BDMemoryCache.h"
#import "BDDiskCache.h"

FOUNDATION_EXTERN NSString * const BDImageCacheSmartCropInfo;
FOUNDATION_EXTERN NSString * const BDImageCacheScaleInfo;
FOUNDATION_EXTERN NSString * const BDImageCacheSizeInfo;

@class YYMemoryCache,YYDiskCache;
typedef NS_OPTIONS(NSUInteger, BDImageCacheType) {
    BDImageCacheTypeNone   = 0,
    BDImageCacheTypeMemory = 1 << 0,
    BDImageCacheTypeDisk   = 1 << 1,
    BDImageCacheTypeAll    = BDImageCacheTypeMemory | BDImageCacheTypeDisk,
};

typedef void (^BDImageCacheCallback)(UIImage *image, NSString *cachePath);

typedef float BDImageCachePriority;
@interface BDImageCache : NSObject
@property (nonatomic, strong) NSString *name; //缓存的名称，全部转换为小写
@property (nonatomic, assign) BDImageCachePriority priority; // 缓存优先级
@property (nonatomic, copy) BDImageCacheConfig *config; // 缓存的配置项，只有setter方法才能够使更改的配置生效，不可为空
@property (nonatomic, strong, readonly) id<BDMemoryCache> memoryCache;
@property (nonatomic, strong, readonly) id<BDDiskCache> diskCache;

/**
 默认缓存，对应sharedManager默认的缓存
 */
+ (instancetype)sharedImageCache;

/**
 默认缓存地址为~/Library/Caches/${name}
 @param name 会全部转换为小写之后，拼接成最后缓存的路径，传nil则使用默认缓存路径
 */
- (instancetype)initWithName:(NSString *)name;

/**
 @param path 缓存文件存放地址
 @param threshold 数据库缓存大小限制，超过此限制存为文件，小于等于此限制直接储存在数据库，默认为20KB
 注意：如果需要直接访问缓存文件保证所有文件直接缓存到磁盘需要设置为0
 */
- (instancetype)initWithStorePath:(NSString *)path inlineThreshold:(NSUInteger)threshold;

/**
 @param memoryCache 支持注入内存缓存对像
 */
- (instancetype)initWithMemoryCache:(id<BDMemoryCache>)memoryCache storePath:(NSString *)path inlineThreshold:(NSUInteger)threshold NS_DESIGNATED_INITIALIZER;

/**
 同步设置缓存，同时缓存到内存和磁盘
 */
- (void)setImage:(UIImage *)image forKey:(NSString *)key;

/**
 同步设置缓存，按照设置type决定缓存位置
 如果缓存到内存没有image则尝试用imageData生成image
 如果缓存到磁盘且没有imageData则尝试用image生成imageData
 */
- (void)setImage:(UIImage *)image
       imageData:(NSData *)imageData
          forKey:(NSString *)key
        withType:(BDImageCacheType)type;

/**
异步设置缓存，按照设置type决定缓存位置
如果缓存到内存没有image则尝试用imageData生成image
如果缓存到磁盘且没有imageData则尝试用image生成imageData
 */
- (void)setImage:(UIImage *)image
imageData:(NSData *)imageData
   forKey:(NSString *)key
 withType:(BDImageCacheType)type
 callBack:(BDImageCacheCallback)callback;


/**
 同步缓存数据到磁盘
 */
- (void)saveImageToDisk:(UIImage *)image data:(NSData *)imageData forKey:(NSString *)key;

/**
 异步缓存数据到磁盘
 回调调用不保证线程
 */
- (void)saveImageToDisk:(UIImage *)image data:(NSData *)data forKey:(NSString *)key callBack:(BDImageCacheCallback)callback;

/**
 同步移除缓存
 */
- (void)removeImageForKey:(NSString *)key;
- (void)removeImageForKey:(NSString *)key withType:(BDImageCacheType)type;

/**
 异步移除磁盘缓存
 */
- (void)removeImageFromDiskForKey:(NSString *)key callBack:(void(^)(NSString *key))callback;

/**
 判断缓存是否存在，不具体取缓存，如果返回BDImageCacheTypeNone则不存在缓存
 */
- (BDImageCacheType)containsImageForKey:(NSString *)key;
- (BDImageCacheType)containsImageForKey:(NSString *)key type:(BDImageCacheType)type;

/**
 同步取缓存，优先尝试内存缓存
 */
- (UIImage *)imageForKey:(NSString *)key;

/**
 * Query the memory cache synchronously.
 *
 * @param key The unique key used to store the image
 */
- (UIImage *)imageFromMemoryCacheForKey:(NSString *)key;

/**
 * Query the disk cache synchronously.
 *
 * @param key The unique key used to store the image
 */
- (UIImage *)imageFromDiskCacheForKey:(NSString *)key;
- (UIImage *)imageFromDiskCacheForKey:(NSString *)key options:(BDImageRequestOptions)options;

/**
 同步取缓存，按照*type尝试缓存方式，优先尝试内存缓存，执行后*type为具体取到的缓存类型
 */
- (UIImage *)imageForKey:(NSString *)key withType:(BDImageCacheType *)type;
- (UIImage *)imageForKey:(NSString *)key withType:(BDImageCacheType *)type options:(BDImageRequestOptions)options size:(CGSize)size;

/**
 异步按照设置取缓存，优先尝试内存缓存
 回调在主线程
 */
- (void)imageForKey:(NSString *)key withType:(BDImageCacheType)type withBlock:(void(^)(UIImage * image, BDImageCacheType type))block;
- (void)imageForKey:(NSString *)key withType:(BDImageCacheType)type options:(BDImageRequestOptions)options size:(CGSize)size withBlock:(void(^)(UIImage * image, BDImageCacheType type))block;

/**
 同步取磁盘缓存原始数据
 */
- (NSData *)imageDataForKey:(NSString *)key;

/**
 异步取磁盘缓存原始数据，回调在主线程
 */
- (void)imageDataForKey:(NSString *)key withBlock:(void(^)(NSData *imageData))block;

/**
 获取 key 对应图片的相关附加信息，存储在 UserDefaults 中
 */
- (id)imageInfoForkey:(NSString *)key withInfoType:(NSString *)type;

/**
 存储图片相关附加信息到UserDefaults，e.g 智能裁剪 rect、scale、size
 */
- (void)setImageInfo:(id)info forKey:(NSString *)key withInfoType:(NSString *)type;

/**
 获取智能裁剪的 rect 比例信息，可设置 ImageView.layer.contentsRect 实现智能裁剪
 */
- (CGRect)smartCropRateRectForkey:(NSString *)key;

/**
 同步取磁盘缓存文件地址，注意：只要判断缓存存在则返回具体地址，不保证文件存在，业务自己保证inlineThreshold和判断结果
 */
- (NSString *)cachePathForKey:(NSString *)key;

/**
 清除内存缓存中的所有数据
 */
- (void)clearMemory;

/**
 清除磁盘缓存中的所有数据，回调在 YYDiskCache内部的子线程上
 这里BDImageCache不回调到主线程，原因是没有找到需要回到主线程的理由，后续有需求可以考虑扩展
 */
- (void)clearDiskWithBlock:(void(^)(void))block;

/**
 同步根据设置的最大磁盘大小，对象数量和过期时间，清除过期的缓存
 */
- (void)trimDiskCache;

/**
 同步获取磁盘缓存的所有数据的字节数
 */
- (NSUInteger)totalDiskSize;

@end
