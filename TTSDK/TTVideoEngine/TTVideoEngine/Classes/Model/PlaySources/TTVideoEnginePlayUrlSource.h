//
//  TTVideoEnginePlayUrlSource.h
//  TTVideoEngine
//
//  Created by 黄清 on 2019/1/11.
//

#import "TTVideoEnginePlayBaseSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoEnginePlayUrlSource : TTVideoEnginePlayBaseSource

@property (nonatomic, copy) NSString *url;

@end


@interface TTVideoEnginePlayLocalSource : TTVideoEnginePlayUrlSource

@end

NS_ASSUME_NONNULL_END
