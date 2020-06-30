//
//  TTVideoEnginePlayPlayItemSource.h
//  TTVideoEngine
//
//  Created by 黄清 on 2019/1/11.
//

#import "TTVideoEnginePlayVidSource.h"
#import "TTVideoEnginePlayItem.h"


NS_ASSUME_NONNULL_BEGIN

@interface TTVideoEnginePlayPlayItemSource : TTVideoEnginePlayVidSource

@property (nonatomic, strong) TTVideoEnginePlayItem *playItem;

@end

NS_ASSUME_NONNULL_END
