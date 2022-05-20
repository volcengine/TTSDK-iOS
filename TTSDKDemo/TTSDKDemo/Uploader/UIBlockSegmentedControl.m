//
//  UIBlockSegmentedControl.m
//  TTSDKDemo
//
//  Created by bytedance on 2020/11/2.
//  Copyright © 2020 ByteDance. All rights reserved.
//

#import "UIBlockSegmentedControl.h"

@implementation UIBlockSegmentedControl
+ (UIBlockSegmentedControl* )initSegMentFrame:(CGRect)frame item:(NSArray*) items tag:(NSInteger)tag{
    UIBlockSegmentedControl *segment = [[UIBlockSegmentedControl alloc]initWithItems:items];
    segment.frame = frame;
    [segment sizeToFit];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGPoint point = CGPointMake(screenWidth/2, segment.center.y);
    segment.center = point;
    segment.tag = tag;
    segment.selectedSegmentIndex = 0;
    return segment;
}

- (void)addActionBlock:(BlockAction) action{
    _blockAction = action;
    [self addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
}
- (void)change:(UIBlockSegmentedControl*)sementedControl{
    _blockAction();
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
