//
//  BDWebImageRequest.h
//  BDWebImage
//
//

#import <Foundation/Foundation.h>

//图片请求相关设置，如果多个请求设置有交叉，以逻辑或的方式生效
typedef NS_OPTIONS(NSInteger, BDImageRequestOptions)
{
    BDImageRequestDefaultPriority = 0,///<如果在等待队列中，任务会以优先级排序，下载中的任务优先级对应operationPriority
    BDImageRequestLowPriority = 1<<0,
    BDImageRequestHighPriority = 1<<1,
    
    BDImageRequestIgnoreMemoryCache = 1<<2,///<是否忽略内存缓存，默认使用，优先查找内存缓存
    BDImageRequestIgnoreDiskCache = 1<<3,///<是否忽略磁盘缓存，默认使用
    BDImageRequestNotCacheToMemery = 1<<4,///<下载后是否忽略缓存到内存，默认缓存
    BDImageRequestNotCacheToDisk = 1<<5,///<下载后是否忽略缓存到磁盘，默认缓存
    
    BDImageRequestIgnoreCache = BDImageRequestIgnoreMemoryCache|BDImageRequestIgnoreDiskCache,
    
    BDImageRequestNeedCachePath = 1<<7,///<结果中文件缓存路径是否为必须
    BDImageRequestIgnoreImage = 1<<8,///<结果是否忽略image,可以跳过解码过程，节省性能
    
    BDImageRequestContinueInBackground = 1<<9,///<退到后台是否继续下载
    BDImageRequestIgnoreQueue = 1<<10,///<是否忽略队列，直接开始请求
    
    BDImageRequestSetDelaySetImage = 1 << 11,///<控件请求image完成后不自动设置image
    
    BDImageProgressiveDownload = 1 << 12,
    
    BDImageNoRetry= 1 << 13,
    BDImageNotDecoderForDisplay = 1 << 14, /// 关闭预解码。https://docs.bytedance.net/doc/kZWZOhofAtlbTHoG8IGZJd
    BDImageScaleDownLargeImages = 1 << 15, /// 针对大图会进行缩小优化，1.BDImageProgressiveDownload生效时此选项失效;2.关闭预解码时此选项失效
    
    BDImageRequestSetAnimationDefault = 0 << 16,
    BDImageRequestSetAnimationFade = 1 << 16,///<设置图片时加上默认渐隐动画
    
    BDImageRequestCallbackNotInMainThread = 1 << 17, ///设置下载完成回调时是否从主线程回调，默认从主线程回调
    BDImageAnimatedImageProgressiveDownload = 1 << 18, ///针对动图开启渐进式下载
    
    BDImageNotDownsample = 1 << 19, ///关闭该请求的下采样
    BDImageRequestNotVerifyData = 1 << 20, ///下载后不校验 Data 长度、格式
    
    BDImageRequestSmartCorp = 1 << 21, /// 使用智能裁剪，需要服务端支持，在的 header 中返回智能裁剪的区域

    BDImageRequestPreloadAllFrames = 1 << 22, /// 对动图提前解码并缓存所有帧，支持 UIImageView 播放动图

    BDImageRequestDefaultOptions = BDImageRequestDefaultPriority
};

//判断结果来源
typedef NS_ENUM(NSInteger, BDWebImageResultFrom)
{
    BDWebImageResultFromNone = -1,
    BDWebImageResultFromDownloading = 0,///<网络下载
    BDWebImageResultFromMemoryCache = 1,///<内存缓存
    BDWebImageResultFromDiskCache = 2,///<磁盘缓存
};

extern NSString *const BDWebImageSetAnimationKey;

@class BDWebImageRequest;
@class BDImagePerformanceRecoder;
@class BDBaseTransformer;

/*
 进度回调
 */
typedef void(^BDImageRequestProgressBlock)(BDWebImageRequest *request, NSInteger receivedSize, NSInteger expectedSize);

/*
 请求结果回调，成功与否均会回调，取消不回调，通过判断是否有error决定请求结果，内部错误都有对应错误，具体错误码参见 BDWebImageError.h
 */
typedef void(^BDImageRequestCompletedBlock)(BDWebImageRequest *request, UIImage *image, NSData *data, NSError *error, BDWebImageResultFrom from);

/*
 请求完成时回调，返回对象记录请求相关性能日志和信息
 */
typedef void(^BDImageRequestPerformanceBlock)(BDImagePerformanceRecoder *recorder);

typedef NSData *(^BDImageRequestDecryptBlock)(NSData *data, NSError **error);

@interface BDWebImageRequest : NSObject
@property (nonatomic, retain) NSString *requestKey;//当前是使用 [BDWebImageManager requestKeyWithURL:] 赋值的，在保留缓存和获取缓存时会拼接上transformKey
@property (nonatomic, strong) NSString *category;//分类标识，可以根据分类标识对请求分组
@property (nonatomic, strong) NSString *cacheName;//对应的缓存实例的名字，manager会根据cacheName分组缓存，使用前确保向BDWebImageManager注册对应缓存实例
@property (nonatomic, strong) NSString *bizTag; //业务类型，先优先使用此设置，其次是BDWebImageManger.bizTagURLFilterBlock()的返回值

@property (nonatomic, retain, readonly) NSURL *currentRequestURL;//当前请求的URL
@property (nonatomic, strong) NSArray<NSURL *> *alternativeURLs;//备选URLs,下载失败后会自动重试其中的URL
@property (nonatomic, assign, readonly) NSUInteger currentIndex;

@property (nonatomic, assign)BOOL isPrefetchRequest;//标识是否是预加载请求，预加载请求如果查询到缓存则不会继续处理，如果取消某个正常请求，和他标识相同的预加载也将被取消

@property (nonatomic, assign)CFTimeInterval timeoutInterval;
@property (nonatomic, assign)BDImageRequestOptions option;//请求设置
@property (nonatomic, assign)CGSize downsampleSize;
@property (nonatomic, assign)CGRect smartCropRect;

@property (atomic, copy)BDImageRequestProgressBlock progressBlock;
@property (atomic, copy)BDImageRequestCompletedBlock completedBlock;
@property (atomic, copy)BDImageRequestPerformanceBlock performanceBlock;
@property (atomic, copy)BDImageRequestDecryptBlock decryptBlock;

/*
 results
 */
@property (atomic, retain)UIImage *image;//返回图，如果支持BDImage默认为BDImage，如果支持BDImage则已经decode
@property (nonatomic, retain)NSData *data;//原始data
@property (nonatomic, retain)NSError *error;//请求错误，可能为网络错误，解码错误和内部逻辑错误
@property (nonatomic, strong)NSString *cachePath;//最终缓存路径，未设置BDImageRequestNeedCachePath默认为空
@property (nonatomic, assign)double progress;//当前进度|0-1|
@property (nonatomic, assign)int64_t receivedSize;//当前已经接收到的Byte数
@property (nonatomic, assign)int64_t expectedSize;//预期接收到的总Byte数
@property (nonatomic, assign)double minNotifiProgressInterval;//最小进度变化通知，避免频繁回调影响性能|0-1|，默认为0.05

@property (nonatomic, assign)NSInteger maxRetryCount;//最大重试次数
@property (atomic, strong)BDBaseTransformer *transformer;//图片加工器

@property (nonatomic, readonly, getter=isCancelled)BOOL cancelled;
@property (nonatomic, readonly, getter=isFailed)BOOL failed;
@property (nonatomic, readonly, getter=isFinished)BOOL finished;

//recorder
@property (nonatomic, strong, readonly) BDImagePerformanceRecoder *recorder;//相关性能记录

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithURL:(NSURL *)url alternativeURLs:(NSArray<NSURL *> *)alternativeURLs NS_DESIGNATED_INITIALIZER;

- (void)cancel;//取消当前请求，如果有其他相同requestKey的请求存在不会取消其他请求

//仅作为BDWebImageManager回调接口
- (void)failedWithError:(NSError *)error;
- (void)finishWithImage:(UIImage *)image data:(NSData *)data savePath:(NSString *)savePath url:(NSURL *)url from:(BDWebImageResultFrom)from;

// 可以进行重试的错误码
+ (void)addRetryErrorCode:(NSInteger)code;
+ (void)removeRetryErrorCode:(NSInteger)code;
@end
