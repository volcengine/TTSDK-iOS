//
//  NSTimer.h
//  Pods
//
//  Created by guikunzhi on 16/12/13.
//
//

#import <Foundation/Foundation.h>

@interface NSTimer (TTVideoEngine)

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval queue:(dispatch_queue_t)queue block:(void (^)())inBlock repeats:(BOOL)inRepeats;

@end
