//
//  UIImage+BDWebImage.h
//  BDWebImage
//
//

#import <UIKit/UIKit.h>
#import "BDImage.h"
#import "BDImageRequestKey.h"

@interface UIImage (BDWebImage)
@property (nonatomic, strong, nullable)NSURL *bd_webURL;//图片原始对应的下载地址
@property (nonatomic, strong, nullable)BDImageRequestKey *bd_requestKey;//图片加载后对应的key
@property (nonatomic, assign)BOOL bd_loading;//是否下载中
@property (nonatomic, assign)BOOL bd_isDidScaleDown;//是否已经被缩小过
@property (nonatomic, readonly, nullable) NSData *bd_animatedImageData;
@end

@interface UIImage (BDWebImageToData)

/**
 Return a 'best' data representation for this image.
 
 @discussion The convertion based on these rule:
 1. If the image is created from an animated GIF/APNG/WebP, it returns the original data.
 2. It returns PNG or JPEG(0.9) representation based on the alpha information.
 
 @return Image data, or nil if an error occurs.
 */
- (nullable NSData *)bd_imageDataRepresentation;

+ (nullable UIImage *) bd_imageWithGifData:(nullable NSData *)data;

- (void)bd_awebpToGifDataWithCompletion:(void(^ __nullable)(NSData * _Nullable gifData, NSError * _Nullable error))completion;

- (NSUInteger)bd_imageCost;

/**
  This method does not support encoding animated image
 */
- (nullable NSData *)bd_encodeWithImageType:(BDImageCodeType)codeType;
@end
