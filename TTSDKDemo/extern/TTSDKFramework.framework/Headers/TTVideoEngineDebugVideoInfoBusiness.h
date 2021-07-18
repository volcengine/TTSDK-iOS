//
//  VideoDebugInfoBusiness.h
//  Article
//
//  Created by guoyuhang on 2020/3/2.
//

#import <Foundation/Foundation.h>
#import "TTVideoEngine.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoEngineDebugVideoInfoBusiness : NSObject

@property (nonatomic) BOOL isFullScreen;
@property (nonatomic) NSInteger indexForSuperView;

+ (instancetype)shareInstance;
- (void)setPlayer:(TTVideoEngine *)videoEngine view:(UIView*)hudView;

- (void)hideDebugVideoInfoView;

- (void)removeDebugVideoInfoView;

- (BOOL)videoInfoViewIsShowing;

- (void)showDebugVideoInfoView;


@end

NS_ASSUME_NONNULL_END
