//  Created by 黄清 on 2020/5/14.
//

#import <Foundation/Foundation.h>
#import "IVCMediaLoadMedia.h"
#import "IVCMediaLoadStateSupplier.h"

NS_ASSUME_NONNULL_BEGIN

@class VCMediaLoadTask;
@class VCMediaLoadAction;

@protocol IVCMediaLoadStrategy <NSObject>

- (nullable NSArray<VCMediaLoadAction *> *)probeLoadAction:(id<IVCMediaLoadStateSupplier>)stateSupplier
                                             priorityQueue:(NSArray<VCMediaLoadTask *> *)taskQueue
                                                mediaArray:(NSArray<id<IVCMediaLoadMedia>> *)orderMediaArray;

@end

NS_ASSUME_NONNULL_END
