//
//  TTVideoEngineNetwork.h
//  Pods
//
//  Created by guikunzhi on 17/1/10.
//
//

#import <Foundation/Foundation.h>
#import "TTVideoEngineNetClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoEngineNetwork : NSObject<TTVideoEngineNetClient>

- (instancetype)initWithTimeout:(NSTimeInterval)timeout;

@property (nonatomic, assign) BOOL useEphemeralSession;

@end

NS_ASSUME_NONNULL_END
