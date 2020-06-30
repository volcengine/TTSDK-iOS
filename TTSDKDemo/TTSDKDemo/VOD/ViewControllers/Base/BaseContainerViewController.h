//
//  BaseContainerViewController.h
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/13.


#import "BaseViewController.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^ContainerIndexDidChange)(NSInteger index);

@interface BaseContainerViewController : BaseViewController

@property(nonatomic, assign, readonly) NSInteger index;///< 当前索引
@property(nonatomic, copy  , readonly) NSArray<NSString *> *titles;///< titles
@property(nonatomic, copy  , readonly) NSArray<BaseViewController *> *viewControllerArray;///< 控制器
@property(nonatomic,   weak, readonly) BaseViewController *currentViewController;
@property(nonatomic, assign, readonly) CGFloat indexViewHeight;

@property(nonatomic,   copy) ContainerIndexDidChange indexChangeCall;
@property(nonatomic, assign) BOOL hiddenLineView;

- (void)setTitles:(NSArray<NSString *> *)titles viewControllers:(NSArray<BaseViewController *> *) viewControllers;

@end

NS_ASSUME_NONNULL_END
