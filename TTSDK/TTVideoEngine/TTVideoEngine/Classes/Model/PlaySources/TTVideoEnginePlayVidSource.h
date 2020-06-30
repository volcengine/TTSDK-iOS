//
//  TTVideoEnginePlayVidSource.h
//  TTVideoEngine
//
//  Created by 黄清 on 2019/1/11.
//

#import "TTVideoEnginePlayBaseSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoEnginePlayVidSource : TTVideoEnginePlayBaseSource


@property (nonatomic, copy) NSString *videoId;

@end


@interface TTVideoEnginePlayLiveVidSource : TTVideoEnginePlayVidSource

@end

NS_ASSUME_NONNULL_END
