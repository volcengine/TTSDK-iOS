//
//  UIBlockButton.m
//  TTSDKDemo
//
//  Created by bytedance on 2020/10/30.
//  Copyright © 2020 ByteDance. All rights reserved.
//

#import "UIBlockButton.h"

@implementation UIBlockButton

+ (UIBlockButton*)buttonFrame:(CGRect)frame titile:(NSString*)title action:(ActionBlock)action{
    UIBlockButton* button = [UIBlockButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    [button addActionBlock:action];
    [button sizeToFit];
    return button;
}
- (void)handleControlEvent:(UIControlEvents)event
                 withBlock:(ActionBlock) action
{
    _actionBlock = action;
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

- (void)callActionBlock:(id)sender{
    _actionBlock();
}
- (void)addActionBlock:(ActionBlock) action{
    [self handleControlEvent:UIControlEventTouchUpInside withBlock:action];
}
@end
