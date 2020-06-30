//
//  TTVideoDNS.h
//  Pods
//
//  Created by guikunzhi on 16/12/5.
//
//

#ifndef TTVideoDNS_h
#define TTVideoDNS_h

#import "TTVideoEngineUtil.h"

@protocol TTVideoEngineDNSProtocol <NSObject>

@required
// ipAddress array
- (void)parser:(id)dns didFinishWithAddress:(NSString *)ipAddress error:(NSError *)error;

@optional
- (void)parser:(id)dns didFailedWithError:(NSError *)error;
- (void)parserDidCancelled;

@end

@protocol TTVideoEngineDNSBaseProtocol <NSObject>

- (instancetype)initWithHostname:(NSString *)hostname;

- (instancetype)initWithHostname:(NSString *)hostname andType:(TTVideoEngineRetryStrategy)type;

- (void)start;

- (void)cancel;

@end

#endif /* TTVideoDNS_h */
