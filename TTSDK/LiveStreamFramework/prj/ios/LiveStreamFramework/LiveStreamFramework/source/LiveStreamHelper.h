//
//  LiveStreamHelper.h
//  LiveStreamFramework
//
//  Created by 王可成 on 2018/9/17.
//  Copyright © 2018 wangkecheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <CoreMedia/CoreMedia.h>

#define USE_FEEDBACK_LOOP 0

typedef NS_ENUM(NSInteger, LSApplicationStatus) {
    LSApplicationStatusBecomeActive,
    LSApplicationStatusActive,
    LSApplicationStatusWillResignActive,
    LSApplicationStatusBackground,
};

@interface LSIHelper : NSObject
+ (void)swizzleForClass:(Class)cls oriSEL:(SEL)originalSelector newSEL:(SEL)swizzledSelector;

+ (void)swizzleForClass:(Class)cls oriSEL:(SEL)originalSelector fromClass:(Class)newClass newSEL:(SEL)swizzledSelector;

+ (instancetype)sharedInstance;

@property (nonatomic, readonly) LSApplicationStatus appStatus;


/*
 * fmt 支持 I420 y420 nv12 nv21
 */
+ (CVPixelBufferRef)generateCVPixelBufferWithFmt:(OSType)fmt
                                         yBuffer:(void *)yBuffer
                                         uBuffer:(void *)uBuffer
                                         vBuffer:(void *)vBuffer
                                         yStride:(int)yStride
                                         uStride:(int)uStride
                                         vStride:(int)vStride
                                           width:(int)width
                                          height:(int)height;
@end



