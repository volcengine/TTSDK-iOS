//
//  BaseViewController.h
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/13.


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

/// Init views
- (void)setUpUI __attribute__((objc_requires_super));

/// Did get data, update UI.
- (void)buildUI __attribute__((objc_requires_super));

@end

NS_ASSUME_NONNULL_END
