//
//  TTVideoEngineUtil.h
//  Pods
//
//  Created by guikunzhi on 16/12/6.
//
//

#import <Foundation/Foundation.h>
#import "TTVideoEngineLogDelegate.h"


#if 1
#define TTVideoEngineLog(fmt, ...)\
do {\
    if(g_TTVideoEngineLogDelegate != nil) {\
        NSString *log = [NSString stringWithFormat:fmt, ##__VA_ARGS__];\
        log = [NSString stringWithFormat:@"TTVideoEngine: %@ \n",log];\
        [g_TTVideoEngineLogDelegate consoleLog:log];\
    }\
    if (isTTVideoEngineLogEnabled) { \
        NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);  \
    }\
} while(0)
#else
#define TTVideoEngineLog(...)
#endif

#if 1
#define TTVideoEngineEventLog(fmt, ...)\
do {    \
    if(g_TTVideoEngineLogDelegate != nil) {\
        NSString *log = [NSString stringWithFormat:fmt, ##__VA_ARGS__];\
        log = [NSString stringWithFormat:@"TTVideoEngine: %@ \n",log];\
        [g_TTVideoEngineLogDelegate consoleLog:log];\
    }\
    if (isTTVideoEngineLogEnabled) { \
        NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);  \
    }   \
} while(0)
#else
#define TTVideoEngineEventLog(...)
#endif

static NSString *const kTTVideoErrorDomainFetchingInfo = @"kTTVideoErrorDomainFetchingInfo";
static NSString *const kTTVideoErrorDomainLocalDNS = @"kTTVideoErrorDomainLocalDNS";
static NSString *const kTTVideoErrorDomainHTTPDNS = @"kTTVideoErrorDomainHTTPDNS";
static NSString *const kTTVideoErrorDomainCacheDNS = @"kTTVideoErrorDomainCacheDNS";
static NSString *const kTTVideoErrorDomainVideoPlayer = @"kTTVideoErrorDomainVideoPlayer";
static NSString *const kTTVideoEngineAPIResponseKey = @"kTTVideoEngineAPIResponseKey";
static NSString *const kTTVideoEngineAPIRetCodeKey = @"kTTVideoEngineAPIRetCodeKey";

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
};

typedef NS_ENUM(NSInteger, TTVideoEngineRetryStrategy) {
    TTVideoEngineRetryStrategyNone,
    TTVideoEngineRetryStrategyFetchInfo,    //重新获取URL
    TTVideoEngineRetryStrategyChangeURL,    //换备用URL
    TTVideoEngineRetryStrategyRestartPlayer,    //重启播放器
};

typedef NS_ENUM(NSInteger, TTVideoEnigneErrorType) {
    TTVideoEngineErrorTypeAPI = 1000,
    TTVideoEngineErrorTypeDNS = 1001,
    TTVideoEngineErrorTypePlayer = 1002,
    TTVideoEngineErrorTypeCDN = 1003,
};

typedef NS_ENUM(NSUInteger, TTVideoEngineDnsType) {
    TTVideoEngineDnsTypeLocal = 0,
    TTVideoEngineDnsTypeHttpAli = 1,
    TTVideoEngineDnsTypeHttpTT = 2,
    TTVideoEngineDnsTypeFromCache = 3,
};


extern BOOL isTTVideoEngineLogEnabled;

extern BOOL isIgnoreAudioInterruption;

extern BOOL isVideoEngineHTTPDNSFirst;

extern NSArray * sVideoEngineDnsTypes;

extern id<TTVideoEngineLogDelegate> g_TTVideoEngineLogDelegate;

#define notifyIfCancelled(sel)   if (self.isCancelled) {\
if (self.delegate && [self.delegate respondsToSelector:@selector(sel)]) {\
[self.delegate sel];\
}\
return;\
}

#if defined(__cplusplus)
#define TTVideo_EXTERN extern "C" __attribute__((visibility("default")))
#else
#define TTVideo_EXTERN extern __attribute__((visibility("default")))
#endif

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

TTVideo_EXTERN dispatch_queue_t getQueue(void);

TTVideo_EXTERN BOOL TTVideoIsMainQueue(void);
TTVideo_EXTERN void TTVideoRunOnMainQueue(dispatch_block_t block, BOOL sync);
TTVideo_EXTERN TTVideoEngineRetryStrategy TTVideoEngineGetStrategyFrom(NSError *error, NSInteger playerUrlDNSRetryCount);
TTVideo_EXTERN NSString *TTVideoEngineGetStrategyName(TTVideoEngineRetryStrategy strategy);
TTVideo_EXTERN TTVideoEnigneErrorType TTVideoEngineGetErrorType(NSError *error);
TTVideo_EXTERN long long TTVideoEngineGetLocalFileSize(NSString* filePath);
TTVideo_EXTERN NSString* TTVideoEngineGetCurrentWifiName(void);
TTVideo_EXTERN NSString* TTVideoEngineMD5(NSString* oriString);
TTVideo_EXTERN BOOL TTVideoEngineCheckHostNameIsIP(NSString *hostname);
TTVideo_EXTERN NSString *TTVideoEngineGetDescrptKey(NSString *spade);
TTVideo_EXTERN NSString *TTVideoEngineBuildBoeUrl(NSString* url);
TTVideo_EXTERN NSNumber* TTVideoEngineStringToNSNumber(const NSString *string);


