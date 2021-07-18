//
//  TTVideoEngine+Mask.h
//  TTVideoEngine
//
//  Created by haocheng on 2020/12/7.
//

#import "TTVideoEngine.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TTVideoEngineMaskDelegate <NSObject>

- (void)videoEngine:(TTVideoEngine *)videoEngine onMaskInfoCallBack:(NSString*)svg pts:(NSUInteger)pts;

@end

@interface TTVideoEngine()
/* mask info interface*/
@property (nonatomic, weak, nullable) id<TTVideoEngineMaskDelegate> maskInfoDelegate;

@end

NS_ASSUME_NONNULL_END
