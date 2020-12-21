//
//  TTVideoEngineDNSCache.h
//  Pods
//
//  Created by 钟少奋 on 2017/5/18.
//
//

#import <Foundation/Foundation.h>
#import "TTVideoNetUtils.h"

@interface TTVideoEngineDNSCache : NSObject

@property (nonatomic, assign) TTVideoEngineNetWorkStatus networkType;
@property (nonatomic, copy) NSString *wifiName;
@property (nonatomic, copy) NSString *expiredTime;

+ (instancetype)shareCache;

- (NSString *)resolveHost:(NSString *)host;
- (BOOL)cacheHost:(NSString *)host respondJson:(NSDictionary *)respondJson;
- (void)clearHost;
- (BOOL)isCacheHostVaild:(NSString *)host andExpiredTime:(NSInteger)expiredTime;
- (void)setNetworkType:(TTVideoEngineNetWorkStatus)networkType;
- (void)setWifiName:(NSString *)wifiName;
@end
