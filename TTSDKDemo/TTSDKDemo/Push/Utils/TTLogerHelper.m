//
//  TTLogerHelper.m
//  LiveStreamSdkDemo
//
//  Created by 王可成 on 2018/7/19.

#import "TTLogerHelper.h"
#import <UIKit/UIKit.h>
@implementation TTLogerHelper

#if ENABLE_TEST_LOG
+ (void)redirectLogToFile
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] containsString:@"Simulator"]) {
        return;
    }
    
    NSString *logDir = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/Logs"];
    BOOL isDir = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:logDir isDirectory:&isDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:logDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *logFilePath = [NSString stringWithFormat:@"%@/%ld.log", logDir, time(NULL)];
    
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:logFilePath error:nil];
    
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+", stderr);
}
#endif


@end
