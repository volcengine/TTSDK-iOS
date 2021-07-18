//  Created by 黄清 on 2020/5/14.
//

#import <Foundation/Foundation.h>
#import "IVCMediaLoadMedia.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IVCMediaLoadStateSupplier <NSObject>

- (float)getPlayPos;
- (float)getNetworkSpeed; // kb/s
- (nullable NSDictionary<id<IVCMediaLoadMedia>, NSNumber *> *)getCacheState;
- (NSString *)getCurrentPlaySourceId;

@end

NS_ASSUME_NONNULL_END
