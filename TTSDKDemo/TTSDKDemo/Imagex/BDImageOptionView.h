//
//  BDImageOptionView.h
//  BDWebImage_Example
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDImageOptionView : UIView

- (void)updateItems;
- (void)setSaveAction:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
