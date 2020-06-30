//
//  TTVideoEnginePlayPreloadSource.h
//  TTVideoEngine
//
//  Created by 黄清 on 2019/1/11.
//

#import "TTVideoEnginePlayVidSource.h"
#import "TTAVPreloaderItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoEnginePlayPreloadSource : TTVideoEnginePlayVidSource

@property (nonatomic, strong) TTAVPreloaderItem *preloadItem;

@end

NS_ASSUME_NONNULL_END
