//  Created by 黄清 on 2020/5/14.
//

#import <Foundation/Foundation.h>
#import "VCMediaLoadTask.h"

typedef NS_ENUM(NSInteger, VCMediaLoadActionOption) {
    VCMediaLoadActionOptionStart       = 0,
    VCMediaLoadActionOptionStop        = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface VCMediaLoadAction : NSObject

@property (nonatomic, strong, nullable) VCMediaLoadTask *task;
@property (nonatomic, assign) VCMediaLoadActionOption action;

+ (instancetype)action:(id<IVCMediaLoadMedia>)media
       preloadByteSize:(NSInteger)preloadSize
              priority:(VCMediaLoadTaskPriority)priority
                option:(VCMediaLoadActionOption)option;
@end

NS_ASSUME_NONNULL_END
