//
//  LiveHelper.m
//  TTLiveSDKDemo
//
//  Created by zhaokai on 16/3/24.
//  Copyright © 2016年 zhaokai. All rights reserved.

#import "LiveHelper.h"
#include <sys/sysctl.h>

// MARK: LiveHelper
@implementation LiveHelper

// MARK: Utils 辅助功能
+ (CGRect)frameForItemAtIndex:(NSUInteger)index
                  contentArea:(CGRect)area
                         rows:(NSUInteger)rows
                         cols:(NSUInteger)cols
                   itemHeight:(CGFloat)itemHeight
                    itemWidth:(CGFloat)itemWidth {
    int midPadding = 0;
    int leftPadding = (area.size.width - itemWidth * cols) / (cols + 1);
    NSUInteger inColumn = (index - 1) % cols + 1;   //在第几列, 从一开始
    NSUInteger inRow = ceil(index / (double) cols); //在第几行, 从1 开始

    float originX = leftPadding + (itemWidth + leftPadding) * (inColumn - 1) + area.origin.x;
    float originY = itemHeight * (inRow - 1) + midPadding * (inRow - 1) + area.origin.y;

    return CGRectMake(originX, originY, itemWidth, itemHeight);
}

+ (UIButton *)createButton:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *button;
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setMinimumScaleFactor:0.1f];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled | UIControlStateSelected];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 4.0;
    button.layer.masksToBounds = YES;
    [button setAdjustsImageWhenHighlighted:NO];
    
    UIColor *color = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    
    CGRect rect = CGRectMake(0, 0, button.frame.size.width, button.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    button.layer.borderColor = [[UIColor colorWithRed:53/255.0 green:126/255.0 blue:189/255.0 alpha:1] CGColor];
    [button setBackgroundColor:[UIColor colorWithRed:66/255.0 green:139/255.0 blue:202/255.0 alpha:0.3]];
    [button setBackgroundImage:img forState:UIControlStateHighlighted];
    
    
    return button;
}

+ (UIButton *)createButton2:(NSString*)title target:(id)target action:(SEL)action
{
    UIButton * button;
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle: title forState: UIControlStateNormal];
    //    button.titleLabel.font = [UIFont systemFontOfSize:10.];
    [button.titleLabel setMinimumScaleFactor:0.1f];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.numberOfLines = 2;
    button.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return button;
}

+ (UISlider *)createSlider:(id)target action:(SEL)action {
    UISlider *slider;
    slider = [[UISlider alloc] initWithFrame:CGRectMake(40, 200, 200, 50)];
    slider.minimumValue = 0;                                        // 设置最小值
    slider.maximumValue = 100;                                      // 设置最大值
    slider.value = (slider.minimumValue + slider.maximumValue) / 2; // 设置初始值
    slider.continuous = YES;                                        // 设置可连续变化
    [slider addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    return slider;
}

+ (UISegmentedControl *)createSegmentedControl:(NSArray*)items
                        focusIndex:(NSInteger)index
                            target:(id)target
                            action:(SEL)action {

    UISegmentedControl *segCtr = [[UISegmentedControl alloc]initWithItems:items];
    segCtr.selectedSegmentIndex=index;
    [segCtr addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    return segCtr;
}

+ (UILabel *)createLable:(NSString *)title {
    UILabel *lbl = [[UILabel alloc] init];
    lbl.text = title;
    return lbl;
}

+ (UISwitch *)createSwitch:(BOOL)on {
    UISwitch *sw = [[UISwitch alloc] init];
    sw.on = on;
    return sw;
}

+ (void)arertMessage:(NSString *)message {
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@""
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil, nil];
    [view show];
}

+ (CVPixelBufferRef)pixelBufferWithLayer:(nonnull CALayer *)layer
{
    CGSize pointSize = layer.bounds.size;
    CGSize frameSize =CGSizeMake(layer.contentsScale * pointSize.width, layer.contentsScale * pointSize.height);
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES],kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES],kCVPixelBufferCGBitmapContextCompatibilityKey,nil];
    
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          frameSize.width,
                                          frameSize.height,
                                          kCVPixelFormatType_32BGRA,
                                          (__bridge CFDictionaryRef)options,
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata,
                                                 frameSize.width,
                                                 frameSize.height,
                                                 8,
                                                 CVPixelBufferGetBytesPerRow(pxbuffer),
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    NSParameterAssert(context);
    
    CGContextTranslateCTM(context, 0.0f, frameSize.height);
    CGContextScaleCTM(context, layer.contentsScale, -layer.contentsScale);
    [layer renderInContext:context];
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    return pxbuffer;
}

+ (void)layoutView:(UIView *)view
{
    CGFloat btnHeight = 50;
    CGFloat btnWidth  = 75;
    
    CGRect content = CGRectInset(view.bounds, 0, 20);
    content = CGRectOffset(content, 0, 20);
    NSInteger row = CGRectGetHeight(content)/btnHeight;//行数
    NSInteger col = CGRectGetWidth(content)/btnWidth;//列数
    NSArray *subViews = [view subviews];
    for (int index = 0; index < [subViews count]; index++) {
        UIControl*  control = subViews[index];
        control.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        if ([control isKindOfClass:[UIButton class]] || [control isKindOfClass:[UISwitch class]] || [control isKindOfClass:[UISlider class]] || [control isKindOfClass:[UILabel class]]) {
            CGRect frame = [LiveHelper frameForItemAtIndex:index+1/*从1开始*/ contentArea:content rows:row cols:col itemHeight:btnHeight itemWidth:btnWidth];
            control.frame = CGRectInset(frame, 2, 2);
        }
    }
}

+ (NSString *)getSysInfoByName:(char *)typeSpecifier {
    size_t size;
    // 根据name填充输出的size
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    // 申请空间
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

+ (NSString *)platform {
    // CTL_HW_NAMES.CTLTYPE_STRING
    return [[self class] getSysInfoByName:"hw.machine"];
}

// 参考:https://www.theiphonewiki.com/wiki/List_of_iPhones 各section中internal name字段
+ (NSString *)platformString {
    NSString *platform = [[self class] platform];
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"]) {
        BOOL smallerScreen = [[UIScreen mainScreen] bounds].size.width < 768;
        return smallerScreen ? @"iPhone Simulator" : @"iPad Simulator";
    } else {
        NSDictionary *internalAndOfficialNameDic = @{
                                                     // iPhone
                                                     @"iFPGA": @"iFPGA",
                                                     @"iPhone1,1": @"iPhone 1G",
                                                     @"iPhone1,2": @"iPhone 3G",
                                                     @"iPhone2,1": @"iPhone 3GS",
                                                     @"iPhone3,1": @"iPhone 4",
                                                     @"iPhone3,2": @"iPhone 4",
                                                     @"iPhone3,3": @"iPhone 4",
                                                     @"iPhone4,1": @"iPhone 4S",
                                                     @"iPhone5,1": @"iPhone 5 (GSM)",
                                                     @"iPhone5,2": @"iPhone 5 (Global)",
                                                     @"iPhone5,3": @"iPhone 5C",
                                                     @"iPhone5,4": @"iPhone 5C",
                                                     @"iPhone6,1": @"iPhone 5S",
                                                     @"iPhone6,2": @"iPhone 5S",
                                                     @"iPhone7,1": @"iPhone 6 Plus",
                                                     @"iPhone7,2": @"iPhone 6",
                                                     @"iPhone8,1": @"iPhone 6S",
                                                     @"iPhone8,2": @"iPhone 6S Plus",
                                                     @"iPhone8,4": @"iPhone SE",
                                                     @"iPhone9,1": @"iPhone 7",
                                                     @"iPhone9,3": @"iPhone 7",
                                                     @"iPhone9,2": @"iPhone 7 Plus",
                                                     @"iPhone9,4": @"iPhone 7 Plus",
                                                     @"iPhone10,1": @"iPhone 8",
                                                     @"iPhone10,4": @"iPhone 8",
                                                     @"iPhone10,2": @"iPhone 8 Plus",
                                                     @"iPhone10,5": @"iPhone 8 Plus",
                                                     @"iPhone10,3": @"iPhone X",
                                                     @"iPhone10,6": @"iPhone X",
                                                     @"iPhone11,4": @"iPhone XS Max",
                                                     @"iPhone11,6": @"iPhone XS Max",
                                                     @"iPhone11,8": @"iPhone XR",
                                                     @"iPhone11,2": @"iPhone XS",
                                                     // iPod
                                                     @"iPod1,1": @"iPod touch 1G",
                                                     @"iPod2,1": @"iPod touch 2G",
                                                     @"iPod3,1": @"iPod touch 3G",
                                                     @"iPod4,1": @"iPod touch 4G",
                                                     @"iPod5,1": @"iPod touch 5G",
                                                     // iPad
                                                     @"iPad1,1": @"iPad 1G",
                                                     @"iPad2,5": @"iPad Mini",
                                                     @"iPad2,6": @"iPad Mini",
                                                     @"iPad2,7": @"iPad Mini",
                                                     @"iPad2,1": @"iPad 2G",
                                                     @"iPad2,2": @"iPad 2G",
                                                     @"iPad2,3": @"iPad 2G",
                                                     @"iPad2,4": @"iPad 2G",
                                                     @"iPad3,1": @"iPad 3G",
                                                     @"iPad3,2": @"iPad 3G",
                                                     @"iPad3,3": @"iPad 3G",
                                                     @"iPad3,4": @"iPad 4G",
                                                     @"iPad3,5": @"iPad 4G",
                                                     @"iPad3,6": @"iPad 4G",
                                                     @"iPad4,1": @"iPad Air",
                                                     @"iPad4,2": @"iPad Air",
                                                     @"iPad4,3": @"iPad Air",
                                                     @"iPad5,3": @"iPad Air 2",
                                                     @"iPad5,4": @"iPad Air 2",
                                                     @"iPad4,4": @"iPad Mini Retina",
                                                     @"iPad4,5": @"iPad Mini Retina",
                                                     @"iPad6,7": @"iPad Pro (12.9-inch)",
                                                     @"iPad6,8": @"iPad Pro (12.9-inch)",
                                                     @"iPad6,3": @"iPad Pro (9.7-inch)",
                                                     @"iPad6,4": @"iPad Pro (9.7-inch)",
                                                     @"iPad7,1": @"iPad Pro (12.9-inch, 2nd generation)",
                                                     @"iPad7,2": @"iPad Pro (12.9-inch, 2nd generation)",
                                                     @"iPad7,3": @"iPad Pro (10.5-inch)",
                                                     @"iPad7,4": @"iPad Pro (10.5-inch)",
                                                     // Apple TV
                                                     @"AppleTV2": @"Apple TV 2G"
                                                     };
        NSString *result = [internalAndOfficialNameDic valueForKey:platform];
        return result ? result : platform;
    }
}
@end
