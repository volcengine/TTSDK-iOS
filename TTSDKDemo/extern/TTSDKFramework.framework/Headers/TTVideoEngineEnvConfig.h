//  TTVideoEngineEnvConfig.h
//  TTVideoEngine

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *TTVideoEngineDnsTTHostString;
FOUNDATION_EXTERN NSString *TTVideoEngineDnsGoogleHostString;
FOUNDATION_EXTERN NSString *TTVideoEngineDnsServerHostString;
FOUNDATION_EXTERN NSString *TTVideoEngineBoeHostString;
FOUNDATION_EXTERN NSString *TTVideoEngineTestReachabilityHostString;

@interface TTVideoEngineEnvConfig : NSObject
@property (nonatomic, class, nullable, copy) NSString *dnsTTHost;
@property (nonatomic, class, nullable, copy) NSString *dnsGoogleHost;
@property (nonatomic, class, nullable, copy) NSString *dnsServerHost;
@property (nonatomic, class, nullable, copy) NSString *boeHost;
@property (nonatomic, class, nullable, copy) NSString *testReachabilityHost;
@end

NS_ASSUME_NONNULL_END
