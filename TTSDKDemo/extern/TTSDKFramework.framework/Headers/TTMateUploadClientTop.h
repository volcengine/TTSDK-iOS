//
//  TTMateUploadClientTop.h
//  TTUploader
//
//  Created by changyan on 2021/4/9.
//  Copyright © 2021 gkz. All rights reserved.
//

#ifndef TTMateUploadClientTop_h
#define TTMateUploadClientTop_h


#endif /* TTMateUploadClientTop_h */

#import <Foundation/Foundation.h>
#import "TTFUConstDefination.h"
NS_ASSUME_NONNULL_BEGIN
@interface TTMateUploadInfoTop : NSObject

@property (nonatomic,copy) NSString* mid;
@property (nonatomic,copy) NSString* callbackArgs;
@property (nonatomic,copy) NSString* posterUri;
@property (nonatomic,copy) NSDictionary* sourceInfo;
@end

@protocol TTMateUploadClientTopDelegate <NSObject>

- (void)uploadDidFinish:(nullable TTMateUploadInfoTop *)mateInfo error:(nullable NSError *)error;

- (void)uploadProgressDidUpdate:(NSInteger)progress;

- (int)uploadCheckIfNeedTry:(NSInteger)errCode tryCount:(NSInteger)tryCount;

@end

@interface TTMateUploadClientTop : NSObject

/**
 for fetch Setting Config
 
 @param config is NSDictionary,
 key                   value          Description
 eg.    TTFileUploadAID           NSNumber         appId
 eg.    TTFileUploadAppName       NString          appName
 eg.    ....                  ....             ...
 
 such as config = @{TTMateEngineAppId:@(13),TTVideoEngineAppName:@"news_article"}
 */
+ (void)configureAppInfo:(NSDictionary<NSString *, id>*)config;



@property (nonatomic, weak) id<TTMateUploadClientTopDelegate> delegate;

/**
 init

 @param filePath filePath to upload
 @return TTMateUploadClientTop
 */
- (instancetype)initWithFilePath:(NSString *)filePath;

/**
 mateHost

 @param hostName hostName
 */
- (void)setMateHostName:(NSString *)hostName;

/**
 recordType

 @param recordType recordType
 */
- (void)setRecordType:(NSInteger)recordType;

/**
 category

 @param category category
 */
- (void)setCategory:(NSString *)category;

/**
 title

 @param title title
 */
- (void)setTitle:(NSString *)title;

/**
 tags

 @param tags tags
 */
- (void)setTags:(NSString *)tags;

/**
 description

 @param description description
 */
- (void)setDescription:(NSString *)description;

/**
 format

 @param format format
 */
- (void)setFormat:(NSString *)format;


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
