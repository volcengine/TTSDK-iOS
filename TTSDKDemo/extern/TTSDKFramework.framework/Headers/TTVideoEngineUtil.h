//
//  TTVideoEngineUtil.h
//  Pods
//
//  Created by guikunzhi on 16/12/6.
//
//


#ifndef TTVideoEngineUtil_h
#define TTVideoEngineUtil_h

#import <Foundation/Foundation.h>
#import "TTVideoEnginePublicProtocol.h"

typedef NS_ENUM(NSInteger, TTVideoEngineError) {
    TTVideoEngineErrorTimeout = -10000,     //超时
    TTVideoEngineErrorParameterNull = -9999,  //参数为空
    TTVideoEngineErrorParsingResponse = -9998, //解析返回结果错误
    TTVideoEngineErrorResultEmpty = -9997, //返回结果为空
    TTVideoEngineErrorResultNotApplicable = -9996,  //返回结果不可用
    TTVideoEngineErrorUserCancel = -9995,    //用户取消
    TTVideoEngineErrorHTTPNot200 = -9994,
    TTVideoEngineErrorInvalidURLFormat = -9993, // URL 格式错误
    TTVideoEngineErrorCacheDNSEmpty = -9992, // 本地缓存成功过的IP地址为空
    TTVideoEngineErrorVideoValidateFail = -9991, // 视频头部信息校验失败
    TTVideoEngineErrorInvalidRequest = -9990, //非法请求
    
    TTVideoEngineErrorParseApiString = -9980, // 解析apistring错误
    TTVideoEngineErrorParseJson = -9979, //解析json错误
    TTVideoEngineErrorFetchEncrypt = -9978, //play接口加密失败
    TTVideoEngineErrorFetchDecrypt = -9977, //play接口解密失败
    TTVideoEngineErrorVideoModelExtract = -9976, // fetch到的info解析成videomodel时错误
    
    TTVideoEngineErrorAuthEmpty = -9970, //STS为空；playauthtoken由业务方拼到url中，暂时没用到
    TTVideoEngineErrorAuthFail = -9969, //PlayAuthToken鉴权失败
    
    TTVideoEngineErrorDnsParse = -9968,
    TTVideoEngineErrorUrlEmpty = -9967,
    TTVideoEngineErrorUrlInvalid = -9966,
    
    //TOP错误码
    TOPAUTHInvalidClientTokenId = 100009,
    TOPAUTHSignatureDoesNotMatch = 100010,
    TOPAUTHMissingSignature = 100005,
    TOPAUTHInvalidTimestamp = 100006,
    TOPAUTHLackPolicy = 100012,
    TOPAUTHAccessDenied = 100013,
    TOPAUTHInternalError = 100014,
    TOPAUTHInternalServiceTimeout = 100016,
    TOPAUTHFlowLimitExceeded = 100018,
    TOPAUTHServiceUnavailableTemp = 100019,
    TOPAUTHMethodNotAllowed = 100020,
    
    /// Download
    TTVideoEngineErrorNetworkNotAvailable = -9960,//网络不可用
    TTVideoEngineErrorSaveTaskItem = -9949,
    TTVideoEngineErrorWriteFile    = -9948,
    TTVideoEngineErrorNotEnoughDiskSpace = -9947,
    TTVideoEngineErrorURLUnavailable = -9945,
    TTVideoEngineErrorServiceInaccessible = -9944,
    
    /// preload
    TTVideoEnginePreloadErrCodeParameter =  -100000,
    TTVideoEnginePreloadErrCodeSameTask =  -100001,
};

typedef NS_ENUM(NSInteger, TTVideoEngineRetryStrategy) {
    TTVideoEngineRetryStrategyNone          = 0,
    TTVideoEngineRetryStrategyFetchInfo     = 1,    //重新获取URL
    TTVideoEngineRetryStrategyChangeURL     = 2,    //换备用URL
    TTVideoEngineRetryStrategyRestartPlayer = 3,    //重启播放器
    TTVideoEngineRetryStrategyReSelectCodec = 4,   //重新选择编解码类型
};

typedef NS_ENUM(NSInteger, TTVideoEnigneErrorType) {
    TTVideoEngineErrorTypeAPI        = 1000,
    TTVideoEngineErrorTypeDNS        = 1001,
    TTVideoEngineErrorTypePlayer     = 1002,
    TTVideoEngineErrorTypeCDN        = 1003,
};

typedef NS_ENUM(NSInteger, TTVideoEngineDnsType) {
    TTVideoEngineDnsTypeLocal       = 0,
    TTVideoEngineDnsTypeHttpAli     = 1,
    TTVideoEngineDnsTypeHttpTT      = 2,
    TTVideoEngineDnsTypeFromCache   = 3,
    TTVideoEngineDnsTypeHttpGoogle  = 4, /// mdl support
    TTVideoEngineDnsTypeCustom      = 5
};

typedef NS_ENUM(NSUInteger, TTVideoEngineRangeMode) {
    TTVideoEngineRangeModeNone      = 0,
    TTVideoEngineRangeModeSize      = 1,
    TTVideoEngineRangeModeSidxSize  = 2,
    TTVideoEngineRangeModeSidxTime  = 3,
};

typedef NS_ENUM(NSUInteger, TTVideoEngineReadMode) {
    TTVideoEngineReadModeNormal        = 0,
    TTVideoEngineReadModeComplete      = 1,
    TTVideoEngineReadModePartial       = 2,
    TTVideoEngineReadModeDirectPartial = 3,
};

typedef NS_ENUM(NSUInteger, TTVideoEngineUpdateTimestampMode) {
    TTVideoEngineUpdateTimestampModePts       = 0,
    TTVideoEngineUpdateTimestampModeDts       = 1,
    TTVideoEngineUpdateTimestampModeAdjustDts = 2,
};

static NSString *const kTTVideoErrorDomainFetchingInfo = @"kTTVideoErrorDomainFetchingInfo";
static NSString *const kTTVideoErrorDomainLocalDNS = @"kTTVideoErrorDomainLocalDNS";
static NSString *const kTTVideoErrorDomainHTTPDNS = @"kTTVideoErrorDomainHTTPDNS";
static NSString *const kTTVideoErrorDomainCacheDNS = @"kTTVideoErrorDomainCacheDNS";
static NSString *const kTTVideoErrorDomainVideoPlayer = @"kTTVideoErrorDomainVideoPlayer";
static NSString *const kTTVideoEngineAPIResponseKey = @"kTTVideoEngineAPIResponseKey";
static NSString *const kTTVideoEngineAPIRetCodeKey = @"kTTVideoEngineAPIRetCodeKey";
static NSString *const kTTVideoEngineAPIErrorMessageKey = @"kTTVideoEngineAPIErrorMessageKey";
static NSString *const kTTVideoErrorDomainOwnPlayer = @"kTTVideoErrorDomainOwnPlayer";
static NSString *const kTTVideoErrorDomainSysPlayer = @"kTTVideoErrorDomainSysPlayer";
static NSString *const kTTVideoErrorDomainPreload = @"kTTVideoErrorDomainPreload";

FOUNDATION_EXTERN BOOL TTVideoEngineIsNetworkError(NSInteger code);
FOUNDATION_EXTERN BOOL TTVideoEngineIsHijackError(NSInteger code);
FOUNDATION_EXTERN BOOL TTVideoEngineIsDrmError(NSInteger code);
FOUNDATION_EXTERN BOOL TTVideoEngineNeedRestartPlayer(NSInteger code);
FOUNDATION_EXTERN BOOL TTVideoEngineIsOpenCodecError(NSInteger code);
FOUNDATION_EXTERN TTVideoEngineRetryStrategy TTVideoEngineGetStrategyFrom(NSError *error, NSInteger playerUrlDNSRetryCount);
FOUNDATION_EXTERN TTVideoEnigneErrorType TTVideoEngineGetErrorType(NSError *error);
FOUNDATION_EXTERN NSString *TTVideoEngineBuildHttpsUrl(NSString *url);
FOUNDATION_EXTERN NSString *TTVideoEngineGetMachineModel(void);

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __unused __typeof__(object) weak##_##object = object; \
_Pragma("clang diagnostic pop")
#else
#define weakify(object) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __block __unused __typeof__(object) block##_##object = object; \
_Pragma("clang diagnostic pop")
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} {} __weak __unused __typeof__(object) weak##_##object = object; \
_Pragma("clang diagnostic pop")
#else
#define weakify(object) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} {} __block __unused __typeof__(object) block##_##object = object; \
_Pragma("clang diagnostic pop")
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __unused __typeof__(object) object = weak##_##object; \
_Pragma("clang diagnostic pop")
#else
#define strongify(object) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __unused __typeof__(object) object = block##_##object; \
_Pragma("clang diagnostic pop")
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __unused __typeof__(object) object = weak##_##object; \
_Pragma("clang diagnostic pop")
#else
#define strongify(object) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __unused __typeof__(object) object = block##_##object; \
_Pragma("clang diagnostic pop")
#endif
#endif
#endif

#endif
