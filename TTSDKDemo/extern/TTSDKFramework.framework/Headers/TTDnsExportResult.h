//
//  TTDnsExportResult.h
//  BytedanceHTTPDNS
//
//  Created by coricpat on 2021/7/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DnsResultSource) {
// httpdns cache / httpdns过期cache / httpdns请求
// local dns请求 / local dns cache  / dns失败
    SourceHttpDnsRequest = 0,
    SourceHttpDnsCache,
    SourceHttpDnsExpiredCache,
    SourceLocalDns,
    SourceLocalDnsCache,
    SourceLocalDnsExpiredCache,
    SourceNone
};

@interface TTHttpDnsAuthenticationInfo : NSObject

@property(nonatomic, copy) NSString* httpDnsAccount;
@property(nonatomic, assign) BOOL useTemporaryKey;
@property(nonatomic, copy) NSString* key;
@property(nonatomic, copy) NSString* keyExpiredTimeStamp;

@end


@interface TTDnsExportResult : NSObject

@property(nonatomic, assign) DnsResultSource source;
@property(nonatomic, assign) int ttl;
@property(nonatomic, strong) NSArray<NSString*>* ipv4List;
@property(nonatomic, strong) NSArray<NSString*>* ipv6List;
- (NSString*)printSelf;
- (void)printSource;

@end

typedef void (^DnsCallback)(TTDnsExportResult* _Nullable);
typedef TTHttpDnsAuthenticationInfo* _Nullable (^HttpdnsAuthenticationBlock)(void);


NS_ASSUME_NONNULL_END
