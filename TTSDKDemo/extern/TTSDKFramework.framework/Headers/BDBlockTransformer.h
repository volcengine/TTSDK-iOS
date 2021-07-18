//
//  BDBlockTransformer.h
//  Pods
//
//
//  用于通过block创建Transformer

#import "BDBaseTransformer.h"

typedef UIImage * _Nullable (^BDTransformBlock)(UIImage *_Nullable image);

@interface BDBlockTransformer : BDBaseTransformer

/**
 *  用于通过block创建Transformer。transform的图片不缓存。缓存的是原图
 *
 *  @param block 处理图片使用的block
 *
 *  @return 一个使用block对图片进行处理的Transformer
 */
+ (nonnull instancetype)transformWithBlock:(nonnull BDTransformBlock)block;

@end
