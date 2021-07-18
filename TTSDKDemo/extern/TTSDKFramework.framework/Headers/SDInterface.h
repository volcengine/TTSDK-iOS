//
//  SDInterface.h
//  BDWebImage
//
//

#import <Foundation/Foundation.h>
#import "BDWebImage.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SDInterfaceExternalCompletionBlock)(UIImage * _Nullable image, NSError * _Nullable error, BDImageCacheType cacheType, NSURL * _Nullable imageURL);

typedef void(^SDInterfaceInternalCompletionBlock)(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL);

typedef void(^SDInterfaceDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL);

typedef void(^SDInterfaceDownloaderCompletedBlock)(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished);

typedef void(^SDInterfacePrefetcherProgressBlock)(NSUInteger noOfFinishedUrls, NSUInteger noOfTotalUrls);

typedef void(^SDInterfacePrefetcherCompletionBlock)(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls);

typedef void(^SDInterfaceNoParamsBlock)(void);

typedef void(^SDInterfaceCacheQueryCompletedBlock)(UIImage * _Nullable image, NSData * _Nullable data, BDImageCacheType cacheType);

typedef void(^SDInterfaceCheckCacheCompletionBlock)(BOOL isInCache);

@interface SDInterface : NSObject

- (nonnull instancetype)init NS_UNAVAILABLE;

/**
 获取共享的Adapter实例，内部也使用了共享的Manager

 @return 共享的实例
 */
+ (nonnull instancetype)sharedInterface;

@end

#pragma mark - Manager

@interface SDInterface (Manager)

- (BDWebImageRequest *)loadImageWithURL:(nullable NSURL *)url
                                options:(BDImageRequestOptions)options
                               progress:(nullable SDInterfaceDownloaderProgressBlock)progressBlock
                              completed:(nullable SDInterfaceInternalCompletionBlock)completedBlock;

- (void)cancelAll;

- (nullable NSString *)cacheKeyForURL:(nullable NSURL *)url;

@end

#pragma mark - Downloader

@interface SDInterface (Downloader)

- (BDWebImageRequest *)downloadImageWithURL:(nullable NSURL *)url
                                    options:(BDImageRequestOptions)options
                                   progress:(nullable SDInterfaceDownloaderProgressBlock)progressBlock
                                  completed:(nullable SDInterfaceDownloaderCompletedBlock)completedBlock;

- (void)cancel:(nullable BDWebImageRequest *)token;

- (void)cancelAllDownloads;

@end

#pragma mark - Prefetcher

@interface SDInterface (Prefetcher)

- (void)prefetchURLs:(nullable NSArray<NSURL *> *)urls;

- (void)prefetchURLs:(nullable NSArray<NSURL *> *)urls
            progress:(nullable SDInterfacePrefetcherProgressBlock)progressBlock
           completed:(nullable SDInterfacePrefetcherCompletionBlock)completionBlock;

- (void)cancelPrefetching;

@end

#pragma mark - Cache


@interface SDInterface (Cache)

- (void)storeImage:(nullable UIImage *)image
            forKey:(nullable NSString *)key
            toDisk:(BOOL)toDisk
        completion:(nullable SDInterfaceNoParamsBlock)completionBlock;

- (void)storeImage:(nullable UIImage *)image
         imageData:(nullable NSData *)imageData
            forKey:(nullable NSString *)key
            toDisk:(BOOL)toDisk
        completion:(nullable SDInterfaceNoParamsBlock)completionBlock;

- (void)storeImageDataToDisk:(nullable NSData *)imageData forKey:(nullable NSString *)key;

/**
 缓存图片到*硬盘*，此接口不会缓存到内存。要注意：
 1. 如果业务方设置了urlFilter，那url会被urlFilter转化成cacheKey，再使用这个cacheKey来缓存。
 2. 使用这个接口缓存的图片，要使用`imageFromCacheForURL:`来获取，或者先使用`cacheKeyForURL:`把url转化为cacheKey之后再使用其他接口。

 @param image j要缓存的图片
 @param url 要生成cacheKey的链接
 */
- (void)saveImageToCache:(nullable UIImage *)image forURL:(nullable NSURL *)url;

- (BOOL)diskImageExistsWithKey:(nullable NSString *)key;

- (void)diskImageExistsWithKey:(nullable NSString *)key completion:(nullable SDInterfaceCheckCacheCompletionBlock)completionBlock;

- (nullable NSOperation *)queryCacheOperationForKey:(nullable NSString *)key done:(nullable SDInterfaceCacheQueryCompletedBlock)doneBlock;

- (nullable UIImage *)imageFromMemoryCacheForKey:(nullable NSString *)key;

- (nullable UIImage *)imageFromDiskCacheForKey:(nullable NSString *)key;

- (nullable UIImage *)imageFromCacheForKey:(nullable NSString *)key;

/**
 获取缓存图片，会把url转化成cacheKey，这个过程中如果业务指定了urlFilter则会使用它来转化。

 @param url 要生成cacheKey的链接
 @return 图片
 */
- (nullable UIImage *)imageFromCacheForURL:(nonnull NSURL *)url;

- (void)removeImageForKey:(nullable NSString *)key fromDisk:(BOOL)fromDisk withCompletion:(nullable SDInterfaceNoParamsBlock)completion;

- (nullable NSString *)defaultCachePathForKey:(nullable NSString *)key;

- (void)clearMemory;

- (void)clearDiskOnCompletion:(nullable SDInterfaceNoParamsBlock)completion;

- (NSUInteger)getSize;

@end


NS_ASSUME_NONNULL_END
