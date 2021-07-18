//
//  BDRoundCornerTransformer.h
//  Pods
//
//
//  切圆角所用的Transformer，Transformer的图片会缓存到本地

#import <Foundation/Foundation.h>
#import "BDBaseTransformer.h"

typedef NS_ENUM(NSUInteger, BDRoundCornerImageSizes) {
    BDRoundCornerImageSize16 = 16,
    BDRoundCornerImageSize30 = 30,
    BDRoundCornerImageSize32 = 32,
    BDRoundCornerImageSize40 = 40,
    BDRoundCornerImageSize51 = 51,
    BDRoundCornerImageSize100 = 100,
};

@interface BDRoundCornerTransformer : BDBaseTransformer

/**
 *  默认使用BDRoundCornerImageSize100
 *
 *  @return 尺寸为100x100图片的Transformer
 */
+ (instancetype)defaultTransformer;

/**
 *  根据不同图片尺寸，创建出不同的Transformer。这里返回的都是单例，会复用
 *
 *  @param imageSize Transformer的图片尺寸
 *
 *  @return 不同尺寸图片的Transformer
 */
+ (instancetype)transformerWithImageSize:(BDRoundCornerImageSizes)imageSize;

+ (instancetype)transformerWithImageSize:(BDRoundCornerImageSizes)imageSize borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;


@end
