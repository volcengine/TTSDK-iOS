//
//  TTVideoEngineExtraInfo.h
//  Pods
//
//  Created by thq on 2018/7/10.
//

#import <Foundation/Foundation.h>
#import "TTVideoEnginePublicProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoEngineExtraInfo : NSObject

+ (void)configExtraInfoProtocol:(nullable id<TTVideoEngineExtraInfoProtocol>)protocol;

@end


FOUNDATION_EXTERN void extraInfoCallback(void* user,int code,int64_t parameter1,int64_t parameter2);

NS_ASSUME_NONNULL_END
