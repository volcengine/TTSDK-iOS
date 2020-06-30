//
//  TVLMonitor.h
//  TTVideoLive
//
//  Created by 陈昭杰 on 2018/12/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TVLMonitor : NSObject

@property (nonatomic, assign) BOOL shouldReportTimeSeries;

+ (instancetype)defaultMonitor;

- (NSDictionary *)reportDataWithUserInfo:(NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
