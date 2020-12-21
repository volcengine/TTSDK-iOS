//
//  TTVideoDNSBase.h
//  Pods
//
//  Created by guikunzhi on 16/12/5.
//
//

#import <Foundation/Foundation.h>
#import "TTVideoDNS.h"

@interface TTVideoDNSBase : NSObject<TTVideoEngineDNSBaseProtocol>

@property (nonatomic, weak) id<TTVideoEngineDNSProtocol> delegate;
@property (nonatomic, copy) NSString *hostname;

@end
