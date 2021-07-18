//
//  UIButton+SDInterface.h
//  BDWebImage
//
//
#import <UIKit/UIKit.h>
#import "SDInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (SDInterface)

- (nullable NSURL *)sdi_imageURLForState:(UIControlState)state;

- (void)sdi_setImageWithURL:(nullable NSURL *)url
                   forState:(UIControlState)state;

- (void)sdi_setImageWithURL:(nullable NSURL *)url
                   forState:(UIControlState)state
           placeholderImage:(nullable UIImage *)placeholder;

- (void)sdi_setImageWithURL:(nullable NSURL *)url
                   forState:(UIControlState)state
           placeholderImage:(nullable UIImage *)placeholder
                    options:(BDImageRequestOptions)options;

- (void)sdi_setImageWithURL:(nullable NSURL *)url
                   forState:(UIControlState)state
                  completed:(nullable SDInterfaceExternalCompletionBlock)completedBlock;

- (void)sdi_setImageWithURL:(nullable NSURL *)url
                   forState:(UIControlState)state
           placeholderImage:(nullable UIImage *)placeholder
                  completed:(nullable SDInterfaceExternalCompletionBlock)completedBlock;

- (void)sdi_setImageWithURL:(nullable NSURL *)url
                   forState:(UIControlState)state
           placeholderImage:(nullable UIImage *)placeholder
                    options:(BDImageRequestOptions)options
                  completed:(nullable SDInterfaceExternalCompletionBlock)completedBlock;

- (void)sdi_setBackgroundImageWithURL:(nullable NSURL *)url
                             forState:(UIControlState)state;

- (void)sdi_setBackgroundImageWithURL:(nullable NSURL *)url
                             forState:(UIControlState)state
                     placeholderImage:(nullable UIImage *)placeholder;

- (void)sdi_setBackgroundImageWithURL:(nullable NSURL *)url
                             forState:(UIControlState)state
                     placeholderImage:(nullable UIImage *)placeholder
                              options:(BDImageRequestOptions)options;

- (void)sdi_setBackgroundImageWithURL:(nullable NSURL *)url
                             forState:(UIControlState)state
                            completed:(nullable SDInterfaceExternalCompletionBlock)completedBlock;

- (void)sdi_setBackgroundImageWithURL:(nullable NSURL *)url
                             forState:(UIControlState)state
                     placeholderImage:(nullable UIImage *)placeholder
                            completed:(nullable SDInterfaceExternalCompletionBlock)completedBlock;

- (void)sdi_setBackgroundImageWithURL:(nullable NSURL *)url
                             forState:(UIControlState)state
                     placeholderImage:(nullable UIImage *)placeholder
                              options:(BDImageRequestOptions)options
                            completed:(nullable SDInterfaceExternalCompletionBlock)completedBlock;

- (void)sdi_cancelImageLoadForState:(UIControlState)state;

- (void)sdi_cancelBackgroundImageLoadForState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END
