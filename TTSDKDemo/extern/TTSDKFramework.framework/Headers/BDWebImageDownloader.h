//
//  BDWebImageDownloader.h
//  AFgzipRequestSerializer
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BDDownloadImpl) {
    BDDownloadImplURLSession = 0,
    BDDownloadImplChromium,
    BDDownloadImplURLConnection,
};

/*
 实现此协议则可作为BDWebImageManager的下载模块
 */

@protocol BDWebImageDownloader;
@protocol BDWebImageDownloadTask;
@protocol BDWebImageDownloaderDelegate
- (void)downloader:(id<BDWebImageDownloader>)downloader task:(id<BDWebImageDownloadTask>)task failedWithError:(NSError *)error;
- (void)downloader:(id<BDWebImageDownloader>)downloader task:(id<BDWebImageDownloadTask>)task finishedWithData:(NSData *)data savePath:(NSString *)savePath;

@optional
- (void)downloader:(id<BDWebImageDownloader>)downloader task:(id<BDWebImageDownloadTask>)task receivedSize:(NSInteger)receivedSize expectedSize:(NSInteger)expectedSize;
- (void)downloader:(id<BDWebImageDownloader>)downloader task:(id<BDWebImageDownloadTask>)task didReceiveData:(NSData *)data;
@end

@protocol BDWebImageDownloadTask <NSObject>
@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSString *identifier;//和BDWebImageRequest的requestKey为对应关系
@property (nonatomic, assign) CFTimeInterval timeoutInterval;

@property (nonatomic, assign) CGRect smartCropRect;

@property (nonatomic, assign, readonly) double startTime;
@property (nonatomic, assign, readonly) double finishTime;
@property (nonatomic, assign) long long receivedSize;
@property (nonatomic, assign) long long expectedSize;

@property (nonatomic, strong) NSNumber *DNSDuration;/** DNS耗时 单位ms */
@property (nonatomic, strong) NSNumber *connetDuration;/** 建立连接耗时 单位ms */
@property (nonatomic, strong) NSNumber *sslDuration;/** SSL建连耗时 单位ms */
@property (nonatomic, strong) NSNumber *sendDuration;/** 发送耗时 单位ms */
@property (nonatomic, strong) NSNumber *waitDuration;/** 等待耗时 单位ms */
@property (nonatomic, strong) NSNumber *receiveDuration;/** 接收耗时 单位ms */
@property (nonatomic, strong, readwrite) NSNumber *totalDuration;/** 下载总耗时 单位ms */

@property (nonatomic, strong) NSNumber *isSocketReused;
@property (nonatomic, strong) NSNumber *isCached;
@property (nonatomic, strong) NSNumber *isFromProxy;
@property (nonatomic, copy) NSString *remoteIP;
@property (nonatomic, strong) NSNumber *remotePort;
@property (nonatomic, copy) NSString *requestLog;

@property (nonatomic, strong) NSString *mimeType;/** 图片类型*/
@property (nonatomic, assign) NSInteger statusCode;/** http请求状态码*/
@property (nonatomic, strong) NSString *nwSessionTrace;/*图片系统在response header中增加的追踪信息，目前包含回复时间戳和处理总延迟*/

@property (nonatomic, assign) NSInteger cacheControlTime;


- (void)cancel;
@end

@protocol BDWebImageDownloader <NSObject>

@property (nonatomic, assign) NSInteger maxConcurrentTaskCount;//最大同时下载任务
@property (nonatomic, assign)CFTimeInterval timeoutInterval;
@property (nonatomic, assign)CFTimeInterval timeoutIntervalForResource;
@property (nonatomic, weak)id<BDWebImageDownloaderDelegate> delegate;
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> *defaultHeaders;//http request default headers
@property (nonatomic, assign) BOOL enableLog;
@property (nonatomic, assign) BOOL checkMimeType;
@property (nonatomic, assign) BOOL checkDataLength;
@property (nonatomic, assign) BOOL isCocurrentCallback; // default : NO

/**
 请求url并返回对应task，如果已有相同identifier的现在任务存在则返回已有task
 
 @param immediately 是否忽略队列立即开始请求，否则走队列逻辑
 @return 返回对应task
 */
- (id<BDWebImageDownloadTask>)downloadWithURL:(NSURL *)url identifier:(NSString *)identifier startImmediately:(BOOL)immediately;

- (id<BDWebImageDownloadTask>)downloadWithURL:(NSURL *)url
                                   identifier:(NSString *)identifier
                              timeoutInterval:(CFTimeInterval)timeoutInterval
                             startImmediately:(BOOL)immediately;


- (id<BDWebImageDownloadTask>)downloadWithURL:(NSURL *)url identifier:(NSString *)identifier priority:(NSOperationQueuePriority)priority timeoutInterval:(CFTimeInterval)timeoutInterval startImmediately:(BOOL)immediately progressDownload:(BOOL)progressDownload verifyData:(BOOL)verifyData;
/**
 返回identifier对应的task
 */
- (id<BDWebImageDownloadTask>)taskWithIdentifier:(NSString *)identifier;

@end
