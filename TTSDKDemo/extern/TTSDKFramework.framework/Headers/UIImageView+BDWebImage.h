//
//  UIImageView+BDWebImage.h
//  BDWebImage
//
//

#import <UIKit/UIKit.h>
#import "BDWebImageManager.h"
#import "BDBaseTransformer.h"

NS_ASSUME_NONNULL_BEGIN
@interface UIImageView (BDWebImage)
@property (nonatomic, strong, nullable) BDWebImageRequest *imageRequest;
// 通过 UIImageView-Category 请求，按照 View 的大小进行下采样 default : NO
@property (nonatomic, assign) BOOL bd_isOpenDownsample;

- (nullable BDWebImageRequest *)bd_setImageWithURL:(nonnull NSURL *)imageURL;

- (nullable BDWebImageRequest *)bd_setImageWithURL:(nonnull NSURL *)imageURL placeholder:(nullable UIImage *)placeholder;

- (nullable BDWebImageRequest *)bd_setImageWithURL:(nonnull NSURL *)imageURL options:(BDImageRequestOptions)options;

- (nullable BDWebImageRequest *)bd_setImageWithURL:(nonnull NSURL *)imageURL
                              placeholder:(nullable UIImage *)placeholder
                                  options:(BDImageRequestOptions)options
                               completion:(nullable BDImageRequestCompletedBlock)completion;

- (nullable BDWebImageRequest *)bd_setImageWithURL:(nonnull NSURL *)imageURL
                              placeholder:(nullable UIImage *)placeholder
                                  options:(BDImageRequestOptions)options
                                 progress:(nullable BDImageRequestProgressBlock)progress
                               completion:(nullable BDImageRequestCompletedBlock)completion;

- (nullable BDWebImageRequest *)bd_setImageWithURL:(nonnull NSURL *)imageURL
                              placeholder:(nullable UIImage *)placeholder
                                  options:(BDImageRequestOptions)options
                                cacheName:(nullable NSString *)cacheName
                                 progress:(nullable BDImageRequestProgressBlock)progress
                               completion:(nullable BDImageRequestCompletedBlock)completion;

- (nullable BDWebImageRequest *)bd_setImageWithURL:(nonnull NSURL *)imageURL
                              placeholder:(nullable UIImage *)placeholder
                                  options:(BDImageRequestOptions)options
                              transformer:(nullable BDBaseTransformer *)transformer
                                 progress:(nullable BDImageRequestProgressBlock)progress
                               completion:(nullable BDImageRequestCompletedBlock)completion;

- (nullable BDWebImageRequest *)bd_setImageWithURLs:(nonnull NSArray *)imageURLs
                               placeholder:(nullable UIImage *)placeholder
                                   options:(BDImageRequestOptions)options
                               transformer:(nullable BDBaseTransformer *)transformer
                                  progress:(nullable BDImageRequestProgressBlock)progress
                                completion:(nullable BDImageRequestCompletedBlock)completion;

- (nullable BDWebImageRequest *)bd_setImageWithURL:(nonnull NSURL *)imageURL
                          alternativeURLs:(nullable NSArray *)alternativeURLs
                              placeholder:(nullable UIImage *)placeholder
                                  options:(BDImageRequestOptions)options
                                cacheName:(nullable NSString *)cacheName
                              transformer:(nullable BDBaseTransformer *)transformer
                                 progress:(nullable BDImageRequestProgressBlock)progress
                               completion:(nullable BDImageRequestCompletedBlock)completion;

- (nullable BDWebImageRequest *)bd_setImageWithURL:(NSURL *)imageURL
                          alternativeURLs:(nullable NSArray *)alternativeURLs
                              placeholder:(nullable UIImage *)placeholder
                                  options:(BDImageRequestOptions)options
                          timeoutInterval:(CFTimeInterval)timeoutInterval
                                cacheName:(nullable NSString *)cacheName
                              transformer:(nullable BDBaseTransformer *)transformer
                                 progress:(nullable BDImageRequestProgressBlock)progress
                               completion:(nullable BDImageRequestCompletedBlock)completion;

- (nullable BDWebImageRequest *)bd_setImageWithURL:(nonnull NSURL *)imageURL
                          alternativeURLs:(nullable NSArray *)alternativeURLs
                              placeholder:(nullable UIImage *)placeholder
                                  options:(BDImageRequestOptions)options
                          timeoutInterval:(CFTimeInterval)timeoutInterval
                                cacheName:(nullable NSString *)cacheName
                              transformer:(nullable BDBaseTransformer *)transformer
                             decryptBlock:(nullable BDImageRequestDecryptBlock)decrypt
                                 progress:(nullable BDImageRequestProgressBlock)progress
                               completion:(nullable BDImageRequestCompletedBlock)completion;

- (void)bd_cancelImageLoad;

- (nullable NSURL *)bd_imageURL;

NS_ASSUME_NONNULL_END

@end
