//
//  TTFileUploadConstDefination.h
//  TTFileUpload
//
//  Created by 申明明 on 2018/10/23.
//  Copyright © 2018年 gkz. All rights reserved.
//
#import <VideoToolbox/VideoToolbox.h>
#ifndef TTFUConstDefination_h
#define TTFUConstDefination_h
//typedef NS_OPTIONS(NSUInteger, TTFileUploadTopActionType) {
//    TTFileUploadTopActionTypeNoProcess = 1 << 0,//不做处理
//    TTFileUploadTopActionTypeSnapshot = 1 << 1, //截图，仅支持video
//    TTFileUploadTopActionTypeEntryption = 1 << 2,//加密，图片和视频都支持
//    TTFileUploadTopActionTypeStartWorkflow = 1 << 3,//触发工作流
//    TTFileUploadTopActionTypeAddOptionInfo = 1 << 4,//添加可选信息
//    TTFileUploadTopActionTypeGetMedia = 1 << 5,//获取属性信息，图片和视频都支持
//};
typedef NS_OPTIONS(NSUInteger, TTVideoUploadActionType){
    TTVideoUplaodActionTypeNoProcess = 0,
    TTVideoUploadActionTypeSnapshot,
    TTVideoUploadActionTypeEncrypt,
};
typedef NS_OPTIONS(NSUInteger, TTImageUploadActionType){
    TTImageUploadActionTypeNoProcess = 0,
    TTImageUploadActionTypeGetMeta,
    TTImageUploadActionTypeEncrypt,
};
typedef NS_OPTIONS(NSUInteger, TTImageUploadType){
    TTImageUploadTypeImage,
    TTImageUploadTypeImageX,
};
// 上传的配置
extern NSString *const TTFileUploadSliceRetryCount;
extern NSString *const TTFileUploadFileRetryCount;
extern NSString *const TTFileUploadSliceTimeout;
extern NSString *const TTFileUploadOpenTimeout;
extern NSString *const TTFileUploadSliceSize;
extern NSString *const TTFileUploadSnapshotTime;
extern NSString *const TTFileUploadSocketNum;
extern NSString *const TTFileUploadMaxFailTimes;
extern NSString *const TTFileUploadAliveMaxFailTime;
extern NSString *const TTFileUploadTcpOpenTimeOutMilliSec;
extern NSString *const TTFileUploadMaxFailLimitEnable;
extern NSString *const TTFileUploadHttpsEnable;
extern NSString *const TTFileUploadExternDNSEnable;
extern NSString *const TTFileUploadPostMethodEnable;
extern NSString *const TTFileUploadExternNetValue;
extern NSString *const TTFileUploadQuicEnable;
extern NSString *const TTFileUploadTranTimeOutUnit;
extern NSString *const TTFileUploadSpace;
extern NSString *const TTFileUploadFileTypeStr;


extern NSString *const TTFileUploadEncryptionConfig;//加密配置
extern NSString *const TTFileUploadEncryptionPolicyParams;//加密参数

extern NSString *const TTFileUploadOptionInfo;//添加可选信息

extern NSString *const TTFileUploadTemplateId;//工作流模版id


//上传的路径
extern NSString *const TTFileUploadImagePathKey;

extern NSString *const TTFileUploadDeviceID;// 设置 deviceID
extern NSString *const TTFileUploadEnableBOE; //设置是否开启BOE
extern NSString *const TTFileUploadTraceId; //traceId

extern NSString *const UploadVideoErrorMsgKey;
extern NSString *const UploadVideoErrorCodeKey;
extern NSString *const UploadVideoErrorRedirectLocation;

extern NSString *const UploadImageErrorMsgKey;
extern NSString *const UploadImageErrorCodeKey;

extern NSString *const TTFileUploadAccessKey;
extern NSString *const TTFileUploadSecretKey;
extern NSString *const TTFileUploadSessionToken;
extern NSString *const TTFileUploadExpiredTime;
extern NSString *const TTFileUploadRegionName;
#endif /* TTFUVideoKitConstDefination_h */
