//
//  VideoDebugInfoBusiness.h
//  Article
//
//  Created by jiangyue on 2020/4/13.
//
#import <UIKit/UIKit.h>
#import "TTVideoEngine.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoEngineDebugTools : NSObject

@property (nonatomic, strong, nullable) UIView *debugInfoView;
@property (nonatomic) BOOL debugToolsEnable;
@property (nonatomic) BOOL videoDebugInfoViewIsShowing;
//需要提前设置
@property (nonatomic) BOOL isFullScreen;
@property (nonatomic, weak)  TTVideoEngine *videoEngine;
@property (nonatomic) NSInteger indexForSuperView;

- (void)start;
- (void)remove;
- (void)hide;
- (void)show;

@end

NS_ASSUME_NONNULL_END
