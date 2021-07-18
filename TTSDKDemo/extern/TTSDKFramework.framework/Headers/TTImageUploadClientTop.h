//
//  TTImageUploadClientTop.h
//  TTUploader
//
//  Created by 申明明1 on 2019/5/15.
//  Copyright © 2019 gkz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTFUConstDefination.h"
NS_ASSUME_NONNULL_BEGIN
@interface TTUploadImageInfoTop : NSObject

@property (nonatomic, copy,nullable) NSString *storeUri; //资源id，资源uri
@property (nonatomic, assign) NSInteger fileIndex; //文件索引
@property (nonatomic, assign) NSInteger errCode; //错误码
@property (nonatomic, copy) NSDictionary *mediaInfoDict; //媒体信息
@property (nonatomic, copy) NSDictionary *encryptionMedia; //加密信息

@end

@protocol TTImageUploadClientDelegate <NSObject>

- (void)uploadDidFinish:(TTUploadImageInfoTop *)imageInfo error:(NSError *)error;
- (void)uploadImagesDidFinish;

- (void)uploadProgressDidUpdate:(NSInteger)progress fileIndex:(NSInteger) fileIndex;
- (int)uploadCheckIfNeedTry:(NSInteger)errCode tryCount:(NSInteger)tryCount;

@end
@interface TTImageUploadClientTop : NSObject

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


/**
 initAppLog
 @param  appId  appName channel region
 */
+(void)initAppLog:(NSString*)appId
             name:(NSString*)appName
          channel:(NSString*)channel
           region:(NSString*)region __attribute__((deprecated("已废弃，请用applog的初始化方法")));

@property (nonatomic, weak) id<TTImageUploadClientDelegate> delegate;

/**
 init
 
 @param imagePaths filePaths to upload
 @return TTImageUploadClientTop
 */
- (instancetype)initWithFilePaths:(NSArray<NSString*> *)imagePaths;

- (instancetype)initWithimageDataArray:(NSArray<NSData*> *)imageDataArray;

/**
 videoHost
 
 @param hostName hostName
 */
- (void)setImageHostName:(NSString *)hostName;

/**
 上传的配置策略
 
 @param config
 key                                     type                  Describe                         necessary
 TTFileUploadFileRetryCount          NSNumber(NSInteger)      FileRetryCount                       NO
 TTFileUploadSliceTimeout            NSNumber(NSInteger)      SliceTimeout                         NO
 TTFileUploadHttpsEnable             NSNumber(BOOL)           YES is https                         NO
 TTFileUploadSocketNum               NSNumber(NSInteger)      socketNum                            NO
 TTFileUploadMaxFailTimes            NSNumber(NSInteger)      MaxFaileTimes                        NO
 TTFileUploadMaxFailLimitEnable      NSNumber(BOOL)           MaxFailLimitEnable                   NO
 TTFileUploadTcpOpenTimeOutMilliSec  NSNumber(NSInteger)      OpenTimeOutMilliSec                  NO
 TTFileUploadExternDNSEnable         NSNumber(BOOL)           whether or not use extern NDS        NO
 TTFileUploadPostMethodEnable        NSNumber(BOOL)           defalut is PUT                       NO
 TTFileUploadTranTimeOutUnit         NSNumber(NSInteger)      transfer timeout                     NO
 */
- (void)setUploadConfig:(NSDictionary*)config;

/**
 这个接口不支持imageX

  @param processAction 需要处理的类型
 @param parameter 需要携带的参数
 */
- (void)setProcessActionType:(TTImageUploadActionType)processAction parameter:(NSDictionary*)parameter;

/**
 Authorization
 
 @param parameter get from server
 */
- (void)setAuthorizationParameter:(NSDictionary*)parameter ;

/**
 severParameter
 
 @param parameter get from server
 */
- (void)setSeverParameter:(NSString*)parameter;

/**
 start upload
 */
- (void)start;

/**
 pause or stop upload
 */
- (void)stop;

/**
 close
 */
- (void)close;
/**
 
 @param parameter
 key                              type                      Describe            necessary
 TTFileUploadFileTypeStr        NSString               "image" or "object"          NO
 */
- (void)setRequestParameter:(NSDictionary*)parameter;

- (void)setCookies:(NSArray<NSHTTPCookie *>*)cookies;

/**
 设置图片的文件名
 这个接口仅支持imageX，既TTImageUploadTypeImageX

 @param fileNames fileNames
 */
- (void)setFileNames:(NSArray<NSString*> *)fileNames;


@end

NS_ASSUME_NONNULL_END
