//
//  TTVideoEngineNetwork.h
//  Pods
//
//  Created by guikunzhi on 17/1/10.
//
//

#import <Foundation/Foundation.h>
#import "TTVideoEngineNetClient.h"

@interface TTVideoEngineNetwork : NSObject<TTVideoEngineNetClient>

- (instancetype)initWithTimeout:(NSTimeInterval)timeout;

@end
