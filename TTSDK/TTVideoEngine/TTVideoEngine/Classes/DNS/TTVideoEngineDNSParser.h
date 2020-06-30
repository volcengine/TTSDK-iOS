//
//  TTVideoEngineDNSParser.h
//  Pods
//
//  Created by guikunzhi on 16/12/2.
//
//

#import <Foundation/Foundation.h>
#import "TTVideoDNS.h"
#import "TTVideoNetUtils.h"

@interface TTVideoEngineDNSParser : NSObject<TTVideoEngineDNSBaseProtocol>

@property (nonatomic, weak) id<TTVideoEngineDNSProtocol> delegate;
@property (nonatomic, copy) NSString *hostname;
@property (nonatomic, assign) BOOL isUseDnsCache;
@property (nonatomic, assign) BOOL isForceReparse;
@property (nonatomic, assign) NSInteger expiredTimeSeconds;
@property (nonatomic, strong) NSArray<NSNumber *> *parserIndex;
@property (nonatomic, assign) TTVideoEngineNetWorkStatus networkType;

- (NSString *)getTypeStr;

- (void)setForceReparse;

- (void)setIsHTTPDNSFirst:(BOOL)isHTTPDNSFirst;

+ (void)setHTTPDNSServerIP:(NSString *)serverIP;

@end
