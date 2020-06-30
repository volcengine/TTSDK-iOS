//
//  UIView+TTVideo.h
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/18.


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TTVideo)

@property(nonatomic, assign) UIEdgeInsets tt_hitTestEdgeInsets;

- (UIResponder *)tt_firstResponder;

@end

NS_ASSUME_NONNULL_END
