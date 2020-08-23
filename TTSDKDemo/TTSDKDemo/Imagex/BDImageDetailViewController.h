//
//  BDImageDetailViewController.h
//  BDWebImage_Example
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    BDImageDetailTypeStatic,
    BDImageDetailTypeAnim,
} BDImageDetailType;

@interface BDImageDetailViewController : UIViewController

@property(nonatomic, copy)NSString *url;
@property (nonatomic, assign) BDImageDetailType showType;

@end

NS_ASSUME_NONNULL_END
