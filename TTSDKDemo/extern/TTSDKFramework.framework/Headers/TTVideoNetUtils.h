//
//  TTVideoNetUtils.h
//  Pods
//
//  Created by 江月 on 2019/4/2.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TTVideoEngineNetWorkStatus) {
    TTVideoEngineNetWorkStatusNotReachable = 0,
    TTVideoEngineNetWorkStatusUnknown = 1,
    TTVideoEngineNetWorkStatusWWAN2G = 2,
    TTVideoEngineNetWorkStatusWWAN3G = 3,
    TTVideoEngineNetWorkStatusWWAN4G = 4,
    
    TTVideoEngineNetWorkStatusWiFi = 9,
};

extern NSString *kTTVideoEngineNetWorkReachabilityChangedNotification;

@interface TTVideoEngineNetWorkReachability : NSObject

/*!
 * Use to check the reachability of a given IP address.
 */
//+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;

/*!
 * Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
 */
//+ (instancetype)reachabilityForInternetConnection;

+ (instancetype)shareInstance;

- (void)startNotifier;

- (void)stopNotifier;

- (TTVideoEngineNetWorkStatus)currentReachabilityStatus;

@end
