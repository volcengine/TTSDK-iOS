//
//  TTVideoEngineLogDelegate.h
//  TTVideoEngine
//
//  Created by 黄清 on 2019/4/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTVideoEngineLogDelegate <NSObject>

- (void)consoleLog:(NSString *)log;

@end

NS_ASSUME_NONNULL_END
