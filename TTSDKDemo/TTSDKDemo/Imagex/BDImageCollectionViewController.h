//
//  BDImageCollectionViewController.h
//  BDWebImage_Example
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDImageCollectionViewController : UIViewController

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray *imageUrls;
@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
