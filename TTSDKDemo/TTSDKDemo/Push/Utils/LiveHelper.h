//
//  LiveHelper.h
//  TTLiveSDKDemo
//
//  Created by zhaokai on 16/3/24.
//  Copyright © 2016年 zhaokai. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const LiveSliderViewValueChangedNotification;
#pragma mark - 宏定义

#if !defined(NS_BLOCK_ASSERTIONS)
#define BlockAssert(condition, desc, ...) \
do {\
if (!(condition)) { \
[[NSAssertionHandler currentHandler] handleFailureInFunction:NSStringFromSelector(_cmd) \
file:[NSString stringWithUTF8String:__FILE__] \
lineNumber:__LINE__ \
description:(desc), ##__VA_ARGS__]; \
}\
} while(0);

#else // NS_BLOCK_ASSERTIONS defined
#define BlockAssert(condition, desc, ...)
#endif

#pragma mark - UI

@interface LiveHelper : NSObject

+ (CGRect)frameForItemAtIndex:(NSUInteger)index
                  contentArea:(CGRect)area
                         rows:(NSUInteger)rows
                         cols:(NSUInteger)cols
                   itemHeight:(CGFloat)itemHeight
                    itemWidth:(CGFloat)itemWidth;
+ (UIButton *)createButton:(NSString *)title target:(id)target action:(SEL)action;
+ (UIButton *)createButton2:(NSString*)title target:(id)target action:(SEL)action;
+ (UISlider *)createSlider:(id)target action:(SEL)action;
+ (UILabel *)createLable:(NSString *)title;
+ (UISwitch *)createSwitch:(BOOL)on;
+ (UISegmentedControl *)createSegmentedControl:(NSArray*)items
                                    focusIndex:(NSInteger)index
                                        target:(id)target
                                        action:(SEL)action;
+ (void)arertMessage:(NSString *)message;

+ (CVPixelBufferRef)pixelBufferWithLayer:(nonnull CALayer *)layer;
+ (void)layoutView:(UIView *)view;

+ (NSString *)platformString;
@end
