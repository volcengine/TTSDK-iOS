//
//  UIImageView+SDInterface.h
//  BDWebImage
//
//

#import <UIKit/UIKit.h>
#import "SDInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (SDInterface)

- (nullable NSURL *)sdi_imageURL;

- (void)sdi_setImageWithURL:(nullable NSURL *)url;

- (void)sdi_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder;

- (void)sdi_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(BDImageRequestOptions)options;

- (void)sdi_setImageWithURL:(nullable NSURL *)url
                  completed:(nullable SDInterfaceExternalCompletionBlock)completedBlock;

- (void)sdi_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                  completed:(nullable SDInterfaceExternalCompletionBlock)completedBlock;

- (void)sdi_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(BDImageRequestOptions)options
                  completed:(nullable SDInterfaceExternalCompletionBlock)completedBlock;

- (void)sdi_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(BDImageRequestOptions)options
                   progress:(nullable SDInterfaceDownloaderProgressBlock)progressBlock
                  completed:(nullable SDInterfaceExternalCompletionBlock)completedBlock;

- (void)sdi_cancelCurrentImageLoad;

@end

NS_ASSUME_NONNULL_END
