//
//  BDBaseTransformer.h
//  Pods
//
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BDBaseTransformer : NSObject

/**
 *  重写Transformer可以实现的方法，作为缓存的key
 *
 *  @return 返回一个string，作为缓存的key,不能返回nil
 */
- (nonnull NSString *)appendingStringForCacheKey;

/**
 *  重写Transformer可以实现的方法,在缓存前处理图片，图片处理后会被缓存
 *
 *  @param image 下载完成后的原始图片
 *
 *  @return 处理后的图片，图片会被缓存到本地
 */
- (nullable UIImage *)transformImageBeforeStoreWithImage:(nullable UIImage *)image;

/**
 *  重写Transformer可以实现的方法,在缓存后处理图片，图片仅用于本次使用，缓存的是原图
 *
 *  @param image 下载完成后被储存的图片
 *
 *  @return 处理后的图片，图片不会被缓存到本地
 */
- (nullable UIImage *)transformImageAfterStoreWithImage:(nullable UIImage *)image;

/**
 * 在缓存前处理图片，返回 Transformer 监控字段
 */
- (nullable NSDictionary *)transformImageRecoder;

@end
