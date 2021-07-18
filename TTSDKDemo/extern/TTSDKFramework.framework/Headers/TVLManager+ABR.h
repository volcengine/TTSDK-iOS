//
//  TVLManager+ABR.h
//  TTVideoLive
//
//  Created by chenzhaojie on 2020/8/6.
//

#import "TVLManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface TVLManager (ABR)

- (void)configABRWithUserInfo:(nullable NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
