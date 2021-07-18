//
//  TTVideoEnginePublicProtocol.h
//  TTVideoEngine
//
//  Created by 黄清 on 2019/7/22.
//

#ifndef TTVideoEnginePublicProtocol_h
#define TTVideoEnginePublicProtocol_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTVideoEngineExtraInfoProtocol <NSObject>

@required
-(void)speedWithDataLength:(NSUInteger)length interval:(NSTimeInterval)interval;

@end


@protocol TTVideoEngineLogDelegate <NSObject>

- (void)consoleLog:(NSString *)log;

@end

NS_ASSUME_NONNULL_END

#endif /* TTVideoEnginePublicProtocol_h */
