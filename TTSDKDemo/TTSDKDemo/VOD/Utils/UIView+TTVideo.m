//
//  UIView+TTVideo.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/18.


#import "UIView+TTVideo.h"
#import <YYCategories/NSObject+YYAdd.h>
#import <objc/runtime.h>

static const NSString *kIsKeyHitTestEdgeInsets = @"k_TTvideo_IsKeyHitTestEdgeInsets";

@implementation UIView (TTVideo)

+ (void)load {
    [self swizzleInstanceMethod:@selector(pointInside:withEvent:) with:@selector(ttvideo_pointInside:withEvent:)];
}

- (void)setTt_hitTestEdgeInsets:(UIEdgeInsets)tt_hitTestEdgeInsets {
    NSValue *value = [NSValue value:&tt_hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &kIsKeyHitTestEdgeInsets, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)tt_hitTestEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &kIsKeyHitTestEdgeInsets);
    if(value) {
        UIEdgeInsets edgeInsets; [value getValue:&edgeInsets]; return edgeInsets;
    }else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)ttvideo_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL callOrigin = NO;
    if (self.hidden || self.alpha < 0.0001) {
        callOrigin = YES;
    }
    if ([self isKindOfClass:[UIControl class]] && ((UIControl *)self).enabled == NO) {
        callOrigin  = YES;
    }
    if (UIEdgeInsetsEqualToEdgeInsets(self.tt_hitTestEdgeInsets, UIEdgeInsetsZero) ) {
        callOrigin = YES;
    }
    if (callOrigin) {
        return [self ttvideo_pointInside:point withEvent:event];
    }
    
    CGRect bounds = self.bounds;
    CGRect rect = UIEdgeInsetsInsetRect( bounds, self.tt_hitTestEdgeInsets);
    rect.size.width = MAX(rect.size.width, 0.0);
    rect.size.height = MAX(rect.size.height, 0.0);
    return CGRectContainsPoint(rect, point);
}

- (UIResponder *)tt_firstResponder {
    if (self.isFirstResponder) {
        return self;
    }
    
    for (UIView *subView in self.subviews) {
        id responder = [subView tt_firstResponder];
        if (responder) {
            return responder;
        }
    }
    
    return nil;
}

@end
