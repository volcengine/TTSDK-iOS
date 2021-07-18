//
//  BDWebImageURLFactory.h
//  BDWebImage
//
//  Created by 陈奕 on 2020/12/25.
//

#import <Foundation/Foundation.h>
#import "BDWebImageRequestConfig.h"
#import "BDWebImageRequestBlocks.h"
#import "BDWebImageRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDWebImageURLFactory : NSObject

/// 通过 url 附带的标识，如：http://xxx.jpg?from=yyy 给所有对应的 request 附加对应的 options，会覆盖原有 request 的 options，谨慎使用
- (BDImageRequestOptions)setupRequestOptions:(BDImageRequestOptions)options URL:(NSURL *)url;

/// 通过 url 附带的标识，如：http://xxx.jpg?transformer=yyy 给所有对应的 request 附加对应的 config，会覆盖原有 request 的 config，谨慎使用
- (BDWebImageRequestConfig *)setupRequestConfig:(BDWebImageRequestConfig *)config URL:(NSURL *)url;

/// 通过 url 附带的标识，如：http://xxx.jpg?transformer=yyy 给所有对应的 request 附加对应的 blocks，会覆盖原有 request 的 blocks，类似 hook blocks 的实现
- (BDWebImageRequestBlocks *)setupRequestBlocks:(BDWebImageRequestBlocks *)blocks URL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
