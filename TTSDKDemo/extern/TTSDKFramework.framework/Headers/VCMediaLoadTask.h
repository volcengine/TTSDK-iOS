//  Created by 黄清 on 2020/5/14.
//

#import <Foundation/Foundation.h>
#import "IVCMediaLoadMedia.h"


typedef NS_ENUM(NSInteger, VCMediaLoadTaskPriority) {
    VCMediaLoadTaskPriorityPlay       = 0,
    VCMediaLoadTaskPriorityPreload    = 1,
};

typedef NS_ENUM(NSInteger, VCMediaLoadTaskState) {
    VCMediaLoadTaskStateInit       = 0,
    VCMediaLoadTaskStateRunning    = 1,
    VCMediaLoadTaskStateStoped     = 2,
    VCMediaLoadTaskStateFailed     = 3,
    VCMediaLoadTaskStateCompleted  = 4,
};

NS_ASSUME_NONNULL_BEGIN

@interface VCMediaLoadTask : NSObject

@property (nonatomic, strong, nullable) id<IVCMediaLoadMedia> media;
@property (nonatomic, assign) NSInteger loadByteSize;
@property (nonatomic, assign) NSInteger targetByteSize;
@property (nonatomic, assign) VCMediaLoadTaskPriority priority;
@property (nonatomic, assign, getter=getLoadProgress) float loadProgress;
@property (nonatomic, assign, getter=getState) VCMediaLoadTaskState status;

+ (instancetype)loadTask:(id<IVCMediaLoadMedia>)media
         preloadByteSize:(NSInteger)preloadSize
                priority:(VCMediaLoadTaskPriority)priority;

@end

NS_ASSUME_NONNULL_END
