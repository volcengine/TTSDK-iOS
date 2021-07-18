//
//  NSError+TTVideoLive.h
//  TTVideoLive
//
//  Created by chenzhaojie on 2018/12/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

OBJC_EXTERN NSErrorDomain const TTVideoLiveErrorDomainUndefined;
OBJC_EXTERN NSErrorDomain const TTVideoLiveErrorDomainSDK;
OBJC_EXTERN NSErrorDomain const TTVideoLiveErrorDomainCore;

typedef NS_ENUM(NSInteger, TVLErrorCode) {
    TVLNoError                              = 0,
    TVLErrorParseJSON                       = -100000,
    TVLErrorPlayerPrepare                   = -100001,
    TVLErrorPlayerDataSource                = -100002,
    TVLErrorPlayerCoreError                 = -100003,
    TVLErrorResponseError                   = -100004,
    TVLErrorResponseParseEmpty              = -100005,
    TVLErrorLiveInfoURLInvalid              = -100006,
    TVLErrorRetryTimeout                    = -100007,
    TVLErrorResponseIsNotHTTP               = -100008,
    TVLErrorStreamDryUp                     = -100009,
    TVLErrorLiveDNSResolveFailed            = -100010,
    TVLErrorResponseEmpty                   = -100011,
    TVLErrorDNSInfo                         = -100012,     // Unused
    TVLErrorPlayerDNSResolveFailed          = -100013,
    TVLErrorRetryFailed                     = -100014,
    TVLErrorStall                           = -100015,
    TVLErrorNoAvailableDegradeResolution    = -100016,
    
    TVLHASErrorBase                         = -300000,
    TVLHASErrorControlURLUnavailable        = -299999,
    TVLHASErrorSessionOrStreamNotFound      = -299998,      // 404
    TVLHASErrorServerSwitchFailed           = -299997,      // 50X

    TVLPlayerCoreErrorHTTPBadRequest        = -499899,      // 400
    TVLPlayerCoreErrorHTTPUnauthorized      = -499898,      // 401
    TVLPlayerCoreErrorHTTPForbidden         = -499897,      // 403
    TVLPlayerCoreErrorHTTPNotFound          = -499896,      // 404
    TVLPlayerCoreErrorHTTPTimeout           = -499895,
    TVLPlayerCoreErrorHTTPOther4xx          = -499894,
    TVLPlayerCoreErrorHTTPServerError       = -499893,
    TVLPlayerCoreErrorHTTPUserInterrupt     = -499892,
};

typedef NS_ENUM(NSUInteger, TVLErrorType) {
    TVLErrorTypeUnknown,
    TVLErrorTypePlayerProcessing,
    TVLErrorTypePlayerNetworking,
    TVLErrorTypePlayerAbortRequest,
};

@interface NSError (TTVideoLive)

@property (nonatomic, readonly, assign) TVLErrorType type;

@property (nonatomic, readonly, assign) BOOL shouldReport;

@property (readonly, copy) NSErrorDomain tvl_domain;

+ (instancetype)errorWithCode:(NSInteger)code userInfo:(nullable NSDictionary<NSErrorUserInfoKey, id> *)dict;

@end

NS_ASSUME_NONNULL_END
