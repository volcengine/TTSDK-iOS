//
//  TTVideoEnginePlayInfoSource.h
//  TTVideoEngine
//
//  Created by 黄清 on 2019/1/11.
//

#import "TTVideoEnginePlayVidSource.h"
#import "TTVideoEngineVideoInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoEnginePlayInfoSource : TTVideoEnginePlayVidSource

@property (nonatomic, strong, nullable) TTVideoEngineVideoInfo *videoInfo;

@end

NS_ASSUME_NONNULL_END
