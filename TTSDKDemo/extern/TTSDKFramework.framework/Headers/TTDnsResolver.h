//
//  TTDnsResolver.h
//  TTNetworkDispatcher
//
//  Created by liuzhe on 2020/12/11.
//

#import <Foundation/Foundation.h>
#import "TTDnsExportResult.h"

@class TTHttpDnsHandler;
@class TTLocalDnsHandler;

NS_ASSUME_NONNULL_BEGIN

@interface TTDnsResolver : NSObject

typedef void (^Monitorblock)(NSDictionary*, NSString*);

@property(nonatomic, assign) BOOL isCompareLocalDnsWithHttpDns;
@property(nonatomic, assign) int firstTaskPreferTimeMs;
@property(nonatomic, assign) int overStaleCacheTimeIntervalAfterTTL;
@property(nonatomic, strong) NSArray<NSString*>* preloadDomains;

@property(atomic, assign) BOOL isLocalDnsMode;
@property(nonatomic, strong) TTHttpDnsHandler* httpDnsHandler;
@property(nonatomic, strong) TTLocalDnsHandler* localDnsHandler;
@property(strong, nonatomic) dispatch_queue_t queue;
@property(nonatomic, assign) BOOL enableHttpDns;

// singleton
+ (instancetype)shareInstance;

// set and start init
- (void)setHttpdnsHost:(NSString*)host;

- (void)setHttpDnsHardcodeIps:(NSArray*)ips;

- (void)setPreloadDomains:(NSArray<NSString*>*)domains;

- (void)setHttpDnsMonitorBlock:(Monitorblock)block;

- (void)setHttpDnsAuthenticationBlock:(HttpdnsAuthenticationBlock)block;

- (void)dnsResolverColdStart;

- (void)setPreferLocalDnsMode:(BOOL)isLocalDnsMode;

- (void)setHttpDnsAppId:(NSString*)appId;

// interface to call httpdns
- (void)getDnsResultForHostAsync:(NSString*)host
                        callback:(DnsCallback)callback;

- (TTDnsExportResult*)getDnsResultForHost:(NSString*)host;

- (void)getHttpDnsResultForHostWithoutCacheAsync:(NSString*)host
                                        callback:(DnsCallback)callback;

- (TTDnsExportResult*)getHttpDnsResultForHostWithoutCache:(NSString*)host;


// other utils
- (void)startCacheMonitorForHost:(NSString*)host withTTL:(int)ttl;

- (NSURLRequest*)getIpDirectURLRequest:(NSURLRequest*)request withOriginalHost:(NSString*)host;


@end

NS_ASSUME_NONNULL_END
