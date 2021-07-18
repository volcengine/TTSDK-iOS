//
//  TTVideoEngineDownloader.h
//  TTVideoEngine
//
//  Created by 黄清 on 2020/3/12.
//

#import <Foundation/Foundation.h>
#import "TTVideoEngine+Preload.h"


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,TTVideoEngineDownloadState) {
    TTVideoEngineDownloadStateInit      = 0,
    TTVideoEngineDownloadStateWaiting   = 1,
    TTVideoEngineDownloadStateRunning   = 2,
    TTVideoEngineDownloadStateSuspended = 3,
    TTVideoEngineDownloadStateCanceling = 4,
    TTVideoEngineDownloadStateCompleted = 5, // finished or failed.
};

/// Error domain.
FOUNDATION_EXPORT NSErrorDomain const TTVideoEngineDownloadTaskErrorDomain;

/// Error key.
FOUNDATION_EXPORT NSErrorUserInfoKey const TTVideoEngineDownloadUserCancelErrorKey;

@class TTVideoEngineDownloadTask;
@class TTVideoEngineDownloadURLTask;
@class TTVideoEngineDownloadVidTask;
@protocol TTVideoEngineDownloaderDelegate;
@interface TTVideoEngineDownloader : NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;

+ (instancetype)shareLoader;

/// Default is 1.
@property (nonatomic, assign) NSUInteger maxDownloadOperationCount;
/// Default is 1024 * 1024 *1024 Byte.
@property (nonatomic, assign) int64_t limitFreeDiskSize;

@property (nonatomic, weak) id<TTVideoEngineDownloaderDelegate> delegate;

/// Needs to be called before creating or querying tasks.
- (void)getAllTasksWithCompletionHandler:(void (^)(NSArray<__kindof TTVideoEngineDownloadTask *> *tasks))completionHandler;

/// Only memory operation, need load all tasks before.
- (nullable TTVideoEngineDownloadURLTask *)existUrlTask:(NSString *)key;

- (nullable TTVideoEngineDownloadURLTask *)urlTask:(NSArray *)urls key:(NSString *)key videoId:(nullable NSString *)videoId;

/// Only memory operation, need load all tasks before.
- (nullable TTVideoEngineDownloadVidTask *)existVidTask:(NSString *)videoId
                                             resolution:(TTVideoEngineResolutionType)resolution
                                                h265:(BOOL)h265Enable
                                               baseDash:(BOOL)baseDashEnable
                                                  https:(BOOL)httpsEnable;

- (nullable TTVideoEngineDownloadVidTask *)existVidTask:(NSString *)videoId
                                             resolution:(TTVideoEngineResolutionType)resolution
                                                  codec:(TTVideoEngineEncodeType)codecType
                                               baseDash:(BOOL)baseDashEnable
                                                  https:(BOOL)httpsEnable;

- (nullable TTVideoEngineDownloadVidTask *)vidTask:(NSString *)videoId
                                        resolution:(TTVideoEngineResolutionType)resolution
                                           h265:(BOOL)h265Enable
                                          baseDash:(BOOL)baseDashEnable
                                             https:(BOOL)httpsEnable;

- (nullable TTVideoEngineDownloadVidTask *)vidTask:(NSString *)videoId
                                        resolution:(TTVideoEngineResolutionType)resolution
                                             codec:(TTVideoEngineEncodeType)codecType
                                          baseDash:(BOOL)baseDashEnable
                                             https:(BOOL)httpsEnable;



/// Only memory operation, need load all tasks before.
- (nullable TTVideoEngineDownloadVidTask *)existVidTaskWithVideoModel:(TTVideoEngineModel *)videoModel
                                                           resolution:(TTVideoEngineResolutionType)resolution;

- (nullable TTVideoEngineDownloadVidTask *)vidTaskWithVideoModel:(TTVideoEngineModel *)videoModel
                                                      resolution:(TTVideoEngineResolutionType)resolution;

@end


@interface TTVideoEngineDownloadTask : NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;

/*
 * The taskDescription property is available for the developer to
 * provide a descriptive label for the task.
 */
@property (nullable, copy) NSString *taskDescription;

/* number of body bytes already received */
@property (readonly) int64_t countOfBytesReceived;

/* number of byte bytes we expect to receive, usually derived from the Content-Length header of an HTTP response. */
@property (readonly) int64_t countOfBytesExpectedToReceive;

/* cancel returns immediately, but marks a task as being canceled.
 */
- (void)invalidateAndCancel;

/*
 * The current state of the task within the session.
 */
@property (readonly) TTVideoEngineDownloadState state;

/*
 * The error, if any, delivered via -VideoEngineDownloader:task:didCompleteWithError:
 * This property will be nil in the event that no error occured.
 */
@property (nullable, readonly, copy) NSError *error;

- (void)suspend;

- (void)resume;

/// Available cache file path.
@property (nullable, readonly, copy) NSString *availableLocalFilePath;

@end

@interface TTVideoEngineDownloadURLTask : TTVideoEngineDownloadTask
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;

/// Urls info.
@property (nonatomic, copy, readonly) NSArray *urls;
/// File unique identifier
@property (nonatomic, copy, readonly) NSString *key;

/// Update urls info.
- (void)updateUrls:(NSArray *)urls;

/// Optional.
@property (nonatomic, copy, readonly, nullable) NSString *videoId;

@end

@interface TTVideoEngineDownloadVidTask : TTVideoEngineDownloadTask
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;

/// video-id
@property (nonatomic,   copy, readonly) NSString *videoId;
/// Setting
@property (nonatomic, assign, readonly) TTVideoEngineResolutionType resolution;
@property (nonatomic, assign, readonly) TTVideoEngineEncodeType codecType;
@property (nonatomic, assign, readonly) BOOL h265Enable;
@property (nonatomic, assign, readonly) BOOL baseDashEnable;
@property (nonatomic, assign, readonly) BOOL httpsEnable;

/// Boe environment.
@property (nonatomic, assign) BOOL boeEnable;
/// Optional,filtering parameters
@property (nonatomic, nullable, strong) NSDictionary *params;
/// Optional, resolution map.
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSNumber *> *resolutionMap;

//MARK: - fetch videoModel
/// fetch data need.
@property (nonatomic, strong, nullable) id<TTVideoEngineNetClient> netClient;
/// api version
@property (nonatomic, assign) TTVideoEnginePlayAPIVersion apiVersion;
/// Return api-string for fetch videoinfo.
@property (nonatomic, copy, nullable) TTVideoEngineReturnStringBlock apiStringCall;
/// Return auth-string for fetch videoinfo.
@property (nonatomic, copy, nullable) TTVideoEngineReturnStringBlock authCall;
//MARK: -

///Resolution information used
@property (nonatomic, assign, readonly) TTVideoEngineResolutionType currentResolution;
///Fetch data info.
@property (nonatomic, strong, nullable, readonly) TTVideoEngineModel *videoModel;

@end


@protocol TTVideoEngineDownloaderDelegate <NSObject>

/* Sent as the last message related to a specific task.  Error may be
 * nil, which implies that no error occurred and this task is complete.
 */
- (void)VideoEngineDownloader:(TTVideoEngineDownloader *)downloader
                 downloadTask:(TTVideoEngineDownloadTask *)downloadTask
         didCompleteWithError:(nullable NSError *)error;

/** Sent periodically to notify the delegate of download progress. */
- (void)VideoEngineDownloader:(TTVideoEngineDownloader *)downloader
                 downloadTask:(TTVideoEngineDownloadTask *)downloadTask
                    writeData:(int64_t)bytesWritten
                 timeInterval:(double)timeMS;

/** Sent when a download has been resumed. */
- (void)VideoEngineDownloader:(TTVideoEngineDownloader *)downloader
                 downloadTask:(TTVideoEngineDownloadTask *)downloadTask
            didResumeAtOffset:(int64_t)fileOffset
           expectedTotalBytes:(int64_t)expectedTotalBytes;

- (void)VideoEngineDownloader:(TTVideoEngineDownloader *)downloader
                 downloadTask:(TTVideoEngineDownloadTask *)downloadTask
                 stateChanged:(TTVideoEngineDownloadState)downloadState;

@end

NS_ASSUME_NONNULL_END
