//
//  BDWebImageManager.h
//  BDWebImage
//
//

#import <Foundation/Foundation.h>
#import "BDWebImageRequest.h"
#import "BDWebImageRequestConfig.h"
#import "BDWebImageRequestBlocks.h"
#import "BDImageCache.h"
#import "BDWebImageURLFilter.h"
#import "BDWebImageURLFactory.h"
#import "BDWebImageDownloader.h"
#import "BDWebImageStartUpConfig.h"

#define ENABLE_LOG ([BDWebImageManager sharedManager].enableLog)

FOUNDATION_EXTERN NSString * _Nonnull const kBDWebImageStartRequestImage;
FOUNDATION_EXTERN NSString * _Nonnull const kBDWebImageDownLoadImageFinish;

@class BDWebImageDecoder;
@class BDDownloadManager;
@class BDBaseTransformer;

/**
 定义根据url获取业务标识规则
*/
typedef NSString * _Nullable(^BDWebImageBizTagURLFilterBlock)(NSURL * _Nullable url);

NS_ASSUME_NONNULL_BEGIN
@interface BDWebImageManager : NSObject

@property (nonatomic, retain, readonly)BDImageCache *imageCache;//默认缓存
@property (nonatomic, retain)BDWebImageDecoder *decoder;
@property (nonatomic, strong)BDWebImageURLFilter *urlFilter;//决定URL如何计算为requestkey,例如多个CND域名或者文件后缀可以映射为相同请求
@property (nonatomic, strong)BDWebImageURLFactory *urlFactory;// 通过解析 url 构造新的 request
@property (nonatomic, retain, nullable)id<BDWebImageDownloader> downloadManager;//下载任务manager
@property (atomic, copy) NSDictionary<NSString *, NSString *> *downloadManagerDefaultHeaders;//http request default headers
@property (nonatomic, assign)BDDownloadImpl downloadImpl;//下载实现，默认用chromium
@property (nonatomic, assign)CFTimeInterval timeoutInterval;//服务器响应的默认超时时间
/**
 资源下载的默认超时时间，只针对 BDImageProgressiveDownload 生效
 */
@property (nonatomic, assign)CFTimeInterval timeoutIntervalForResource;
@property (nonatomic, assign)BOOL insulatedCache;//如果设置为YES各缓存实例之间互不干扰
@property (nonatomic, assign) BOOL isDecoderForDisplay; /// 全局控制预解码，默认为YES，或者可以针对单独的请求使用 BDImageNotDecoderForDisplay 控制。https://docs.bytedance.net/doc/kZWZOhofAtlbTHoG8IGZJd
@property (nonatomic, assign) BOOL enableLog; // Log DEBUG and INFO level, default: YES
@property (nonatomic, assign) BOOL enableMultiThreadHeicDecoder; // default: NO
@property (nonatomic, assign) BOOL enableCacheToMemory; // default: YES
@property (nonatomic, assign) BOOL isSystemHeicDecoderFirst; // default : YES
@property (nonatomic, assign) BOOL isCustomSequenceHeicsDecoderFirst; // heif 动图优先使用软解 default : YES，注意需要引入 HEIC subspec 才能生效，系统解码只支持 iOS 13 以上
@property (nonatomic, assign) BOOL checkMimeType; // 下载内容类型校验，不一致时使用https。default: YES
@property (nonatomic, assign) BOOL checkDataLength; // 下载内容长度校验，不一致时使用https。default: YES
@property (nonatomic, assign) NSInteger maxConcurrentTaskCount;//最大同时下载任务
@property (nonatomic, assign) BOOL isPrefetchLowPriority; // 全局开关，预加载的下载任务低优先级
@property (nonatomic, assign) BOOL isPrefetchIgnoreImage; // 全局开关，预加载跳过解码阶段
@property (nonatomic, assign) BOOL isNoticeLoadImage; // 全局开关，是否开启加载图片通知（发起请求通知1、下载成功通知2）
@property (nonatomic, assign) BOOL enableAllImageDownsample; // 全局开关，所有图片加载开启降采样。default: NO

@property (nonatomic, assign) BOOL enableSensibleMonitorWithService; // 用户感知监控开关，通过 slardar 事件上报
@property (nonatomic, assign) BOOL enableSensibleMonitorWithLogType; // 用户感知监控开关，通过 slardar logType上报，会分流到 ImageX 平台展示
@property (nonatomic, assign) NSInteger sensibleMonitorSamplingIndex; // 用户感知监控开关数据量过大，间隔xx条上报一次

/*! 设置ttnet回调是否并发处理，默认为串行。必须在发送图片请求之前设置，设置是针对所有ttnet回包
 @discussion 必须在发送图片请求之前设置，在一次App生命周期内只能设置一次
 */
@property (nonatomic, assign) BOOL isCocurrentCallback; // default : NO

@property (nonatomic, copy, nullable) BDWebImageBizTagURLFilterBlock bizTagURLFilterBlock;    // 根据url获取业务标识,数据上报"biz_tag"用到

+ (instancetype )sharedManager;

/**
 通过 config 初始化图片 SDK
 */
- (void)startUpWithConfig:(BDWebImageStartUpConfig *)config;

/**
 根据指定的业务类型初始化一个Manager实例，存储，优先级调度等配置，与默认实例隔离
 
 @param category 业务类型，传空的话仍然返回新实例，但是存储与默认实例相同
 @return Manager实例
 */
- (instancetype )initWithCategory:(nullable NSString *)category NS_DESIGNATED_INITIALIZER;

/**
 注册不同的缓存实例，可以有独立不同的缓存策略，具体请求根据"cacheName"决定如何使用缓存，如果多个同时命中则以priority决定，同一张图保证只存在一个cache实例里
 */
- (void)registCache:(BDImageCache *)cache forKey:(NSString *)key;
- (BDImageCache *)cacheForKey:(NSString *)key;

- (void)requestImage:(BDWebImageRequest *)request;

/**
 根据request的category返回指定请求
 */
- (NSArray<BDWebImageRequest *> *)requestsWithCategory:(NSString *)category;

/**
 预加载指定图片
 */
- (NSArray<BDWebImageRequest *> *)prefetchImagesWithURLs:(NSArray<NSURL *> *)urls
                                                category:(nullable NSString *)category
                                                 options:(BDImageRequestOptions)options;

- (NSArray<BDWebImageRequest *> *)prefetchImagesWithURLs:(NSArray<NSURL *> *)urls
                                               cacheName:(nullable NSString *)cacheName
                                                category:(nullable NSString *)category
                                                 options:(BDImageRequestOptions)options;

- (BDWebImageRequest *)prefetchImageWithURL:(NSURL *)url
                                   category:(nullable NSString *)category
                                    options:(BDImageRequestOptions)options;

- (BDWebImageRequest *)prefetchImageWithURL:(NSURL *)url
                                  cacheName:(nullable NSString *)cacheName
                                   category:(nullable NSString *)category
                                    options:(BDImageRequestOptions)options;

/**
 返回所有预加载请求
 */
- (NSArray<BDWebImageRequest *> *)allPrefetchs;

/**
 取消所有预加载请求
 */
- (void)cancelAllPrefetchs;

/**
 取消所有请求
 */
- (void)cancelAll;

/**
 获取一个URL对应的requestkey,例如多个CND域名或者文件后缀可以映射为相同请求
 
 @param url 图片地址
 @return requestkey
 */
- (NSString *)requestKeyWithURL:(nullable NSURL *)url;

/**
获取一个智能裁剪URL对应的requestkey

@param url 图片地址
@return requestkey
*/
- (NSString *)requestKeyWithSmartCropURL:(nullable NSURL *)url;

/**
 立即发起请求，并返回请求实例，具体参数说明参见BDWebImageRequest.h
 Note:如果命中内存图片默认不会提供data，需要提供data请加上BDImageRequestNeedCachePath
 */
- (BDWebImageRequest *)requestImage:(NSURL *)url
                            options:(BDImageRequestOptions)options
                           complete:(nullable BDImageRequestCompletedBlock)complete;

- (BDWebImageRequest *)requestImage:(NSURL *)url
                           progress:(nullable BDImageRequestProgressBlock)progress
                           complete:(nullable BDImageRequestCompletedBlock)complete;

- (BDWebImageRequest *)requestImage:(NSURL *)url
                    alternativeURLs:(nullable NSArray<NSURL *> *)alternativeURLs
                            options:(BDImageRequestOptions)options
                          cacheName:(nullable NSString *)cacheName
                           progress:(nullable BDImageRequestProgressBlock)progress
                           complete:(nullable BDImageRequestCompletedBlock)complete;

- (BDWebImageRequest *)requestImage:(NSURL *)url
                    alternativeURLs:(nullable NSArray<NSURL *> *)alternativeURLs
                            options:(BDImageRequestOptions)options
                          cacheName:(nullable NSString *)cacheName
                        transformer:(nullable BDBaseTransformer *)transformer
                           progress:(nullable BDImageRequestProgressBlock)progress
                           complete:(nullable BDImageRequestCompletedBlock)complete;

- (nullable BDWebImageRequest *)requestImage:(nullable NSURL *)url
                    alternativeURLs:(nullable NSArray<NSURL *> *)alternativeURLs
                            options:(BDImageRequestOptions)options
                    timeoutInterval:(CFTimeInterval)timeoutInterval
                          cacheName:(nullable NSString *)cacheName
                        transformer:(nullable BDBaseTransformer *)transformer
                           progress:(nullable BDImageRequestProgressBlock)progress
                           complete:(nullable BDImageRequestCompletedBlock)complete;

- (nullable BDWebImageRequest *)requestImage:(NSURL *)url
                    alternativeURLs:(nullable NSArray<NSURL *> *)alternativeURLs
                            options:(BDImageRequestOptions)options
                    timeoutInterval:(CFTimeInterval)timeoutInterval
                          cacheName:(nullable NSString *)cacheName
                        transformer:(nullable BDBaseTransformer *)transformer
                       decryptBlock:(nullable BDImageRequestDecryptBlock)decryptBlock
                           progress:(nullable BDImageRequestProgressBlock)progress
                           complete:(nullable BDImageRequestCompletedBlock)complete;

- (nullable BDWebImageRequest *)requestImage:(NSURL *)url
                            options:(BDImageRequestOptions)options
                               size:(CGSize)size
                           complete:(nullable BDImageRequestCompletedBlock)complete;

- (nullable BDWebImageRequest *)requestImage:(nullable NSURL *)url
                             alternativeURLs:(nullable NSArray<NSURL *> *)alternativeURLs
                                     options:(BDImageRequestOptions)options
                                        size:(CGSize)size
                             timeoutInterval:(CFTimeInterval)timeoutInterval
                                   cacheName:(nullable NSString *)cacheName
                                 transformer:(nullable BDBaseTransformer *)transformer
                                decryptBlock:(nullable BDImageRequestDecryptBlock)decryptBlock
                                    progress:(nullable BDImageRequestProgressBlock)progress
                                    complete:(nullable BDImageRequestCompletedBlock)complete;

- (nullable BDWebImageRequest *)requestImage:(nullable NSURL *)url
                             alternativeURLs:(nullable NSArray<NSURL *> *)alternativeURLs
                                     options:(BDImageRequestOptions)options
                                      config:(nullable BDWebImageRequestConfig *)config
                                      blocks:(nullable BDWebImageRequestBlocks *)blocks;

NS_ASSUME_NONNULL_END

@end
