//
//  TTVideoEngineExtraInfo.h
//  Pods
//
//  Created by thq on 2018/7/10.
//

#import <Foundation/Foundation.h>
#import "TTVideoEngineExtraInfoProtocol.h"

#if defined(__cplusplus)
#define TTVideo_EXTERN extern "C" __attribute__((visibility("default")))
#else
#define TTVideo_EXTERN extern __attribute__((visibility("default")))
#endif



@interface TTVideoEngineExtraInfo : NSObject

+ (void)configExtraInfoProtocol:(id<TTVideoEngineExtraInfoProtocol>)protocol;

@end


TTVideo_EXTERN void extraInfoCallback(void* user,int code,int64_t parameter1,int64_t parameter2);

