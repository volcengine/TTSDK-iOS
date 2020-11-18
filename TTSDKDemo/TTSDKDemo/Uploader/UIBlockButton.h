//
//  UIBlockButton.h
//  TTSDKDemo
//
//  Created by bytedance on 2020/10/30.
//  Copyright © 2020 ByteDance. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionBlock)();

@interface UIBlockButton : UIButton {
    ActionBlock _actionBlock;
}
+ (UIBlockButton*)buttonFrame:(CGRect)frame titile:(NSString*)title action:(ActionBlock)action;
- (void)handleControlEvent:(UIControlEvents)event
                 withBlock:(ActionBlock) action;
- (void)addActionBlock:(ActionBlock) action;
@end
