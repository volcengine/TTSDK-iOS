//
//  TTVideoUploadClientTop.h
//  TTUploader
//
//  Created by 申明明1 on 2019/4/17.
//  Copyright © 2019 gkz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTFUConstDefination.h"
NS_ASSUME_NONNULL_BEGIN
@interface TTVideoUploadInfoTop : NSObject

@property (nonatomic,copy) NSString* vid;
@property (nonatomic,copy) NSString* storeUri;
@property (nonatomic,copy) NSString* coverURI;
@property (nonatomic,copy) NSDictionary* encryptionInfo;
@property (nonatomic,copy) NSString* callbackArgs;
@property (nonatomic,copy) NSDictionary* sourceInfo;
@end

@protocol TTVideoUploadClientTopDelegate <NSObject>

- (void)uploadDidFinish:(nullable TTVideoUploadInfoTop *)videoInfo error:(nullable NSError *)error;

- (void)uploadProgressDidUpdate:(NSInteger)progress;

- (int)uploadCheckIfNeedTry:(NSInteger)errCode tryCount:(NSInteger)tryCount;

@end

@interface TTVideoUploadClientTop : NSObject

/**
 for fetch Setting Config
 
 @param config is NSDictionary,
 key                   value          Description
 eg.    TTFileUploadAID           NSNumber         appId
 eg.    TTFileUploadAppName       NString          appName
 eg.    ....                  ....             ...
 
 such as config = @{TTVideoEngineAppId:@(13),TTVideoEngineAppName:@"news_article"}
 */
+ (void)configureAppInfo:(NSDictionary<NSString *, id>*)config;



@property (nonatomic, weak) id<TTVideoUploadClientTopDelegate> delegate;

/**
 init

 @param filePath filePath to upload
 @return TTVideoUploadClientTop
 */
- (instancetype)initWithFilePath:(NSString *)filePath;

/**
 videoHost

 @param hostName hostName
 */
- (void)setVideoHostName:(NSString *)hostName;

/**
 上传的配置策略

 @param config
     key                                type                  Describe                         necessary
 TTFileUploadSliceRetryCount         NSNumber(NSInteger)      SliceRetryCount                      NO
 TTFileUploadFileRetryCount          NSNumber(NSInteger)      FileRetryCount                       NO
 TTFileUploadTranTimeOutUnit         NSNumber(NSInteger)      transfer timeout                     NO
 TTFileUploadSliceSize               NSNumber(NSInteger)      SliceSize                            NO
 TTFileUploadSocketNum               NSNumber(NSInteger)      socketNum                            NO
 TTFileUploadMaxFailTimes            NSNumber(NSInteger)      MaxFaileTimes                        NO
 TTFileUploadAliveMaxFailTime        NSNumber(NSInteger)      AliveMaxFailTime                     NO
 TTFileUploadTcpOpenTimeOutMilliSec  NSNumber(NSInteger)      OpenTimeOutMilliSec                  NO
 TTFileUploadExternNetValue          NSNumber(NSInteger)      defalut is NO                        NO
 TTFileUploadSliceTimeout            NSNumber(NSInteger)      SliceTimeout                         NO
 TTFileUploadOpenTimeout             NSNumber(NSInteger)      OpenTimeout                          NO
 TTFileUploadMaxFailLimitEnable      NSNumber(BOOL)           MaxFailLimitEnable                   NO
 TTFileUploadHttpsEnable             NSNumber(BOOL)           YES is https                         NO
 TTFileUploadExternDNSEnable         NSNumber(BOOL)           whether or not use extern NDS        NO
 TTFileUploadPostMethodEnable        NSNumber(BOOL)           defalut is PUT                       NO
 TTFileUploadQuicEnable              NSNumber(BOOL)           whether or not use Quic              NO
 
 */
- (void)setUploadConfig:(NSDictionary*)config;

/**
 Authorization
 
 @param parameter get from server
 */
- (void)setAuthorizationParameter:(NSDictionary*)parameter;

/**
 video process
 if processAction is TTFileUploadTopActionTypeSnapshot ,parameter = @{}

 @param processAction TTFileUploadTopActionType
 @param parameter NSDictionary
 */
- (void)setProcessActionType:(TTVideoUploadActionType)processAction parameter:(NSDictionary*)parameter;

/**
 start upload
 */
- (void)start;

/**
 pause or stop upload
 */
- (void)stop;

/**
 
 External network library object

 @param reslLoader loader object
 */
- (void)setHttpResl:(void*)reslLoader;

/**
 
 @param parameter
    key                       type                         Describe                 necessary
 TTFileUploadFileTypeStr     NSString         "video" or "audio" or "object"         NO
 */
- (void)setRequestParameter:(NSDictionary*)parameter;

- (void)setCookies:(NSArray<NSHTTPCookie *>*)cookies;

/**
 
 @param parameter
 
 */

- (void)setSeverParameter:(NSString*)parameter;



@end

NS_ASSUME_NONNULL_END
