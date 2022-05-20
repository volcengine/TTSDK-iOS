//
//  NSString+TTVideo.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/17.


#import "NSString+TTVideo.h"

@implementation NSString (TTVideo)

+ (NSString *)tt_dateString {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"HH:mm:ss.SSS";
    });
    return [dateFormatter stringFromDate:[NSDate date]];
}

@end
