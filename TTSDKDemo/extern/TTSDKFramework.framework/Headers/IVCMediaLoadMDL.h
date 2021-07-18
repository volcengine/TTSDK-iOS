//  Created by 黄清 on 2020/5/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class VCMediaLoadTask;

@protocol IVCMediaLoadMDL <NSObject>

- (void)startPreloadTask:(VCMediaLoadTask *)task;
- (void)stopPreloadTask:(VCMediaLoadTask *)task;

@end

NS_ASSUME_NONNULL_END
