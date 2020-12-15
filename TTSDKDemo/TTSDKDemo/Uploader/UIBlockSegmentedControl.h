//
//  UIBlockSegmentedControl.h
//  TTSDKDemo
//
//  Created by bytedance on 2020/11/2.
//  Copyright © 2020 ByteDance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^BlockAction)();
@interface UIBlockSegmentedControl : UISegmentedControl

@property (nonatomic,copy)BlockAction blockAction;

+ (UIBlockSegmentedControl* )initSegMentFrame:(CGRect)frame item:(NSArray*) items tag:(NSInteger)tag;
- (void)addActionBlock:(BlockAction) action;
@end

NS_ASSUME_NONNULL_END
