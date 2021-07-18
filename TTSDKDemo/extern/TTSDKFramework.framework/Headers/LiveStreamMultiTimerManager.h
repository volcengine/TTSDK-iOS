//
//  LiveStreamMultiTimerManager.h
//  LiveStreamFramework
//
//  Created by 王可成 on 2018/8/21.
//  Copyright © 2018 wangkecheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveStreamMultiTimerManager : NSObject

+ (instancetype)manager;

/**
 创建timer

 @param name 定时器的标识符
 @param interval 执行间隔，单位为秒(s)
 @param queue 执行队列，默认为全局队列
 @param repeats 是否重复
 @param action 任务块
 */
- (void)schedualTimerWithIdentifier:(NSString *)name
                           interval:(NSTimeInterval)interval
                              queue:(dispatch_queue_t)queue
                            repeats:(BOOL)repeats
                             action:(dispatch_block_t)action;

/**
 停止timer

 @param name 定时器的标识符
 */
- (void)cancelTimerWithName:(NSString *)name;

/**
 停止所有timer
 */
- (void)cancelAllTimers;

@end
