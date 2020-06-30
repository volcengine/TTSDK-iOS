//
//  TTVideoEngineExtraInfoProtocol.h
//  Pods
//
//  Created by thq on 2018/7/11.
//

#import <Foundation/Foundation.h>

@protocol TTVideoEngineExtraInfoProtocol <NSObject>

@required
-(void)speedWithDataLength:(NSUInteger)length interval:(NSTimeInterval)interval;

@end
