//
//  TTVideoLogModel.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/12.


#import "TTVideoLogModel.h"

@implementation TTVideoLogModel

+ (instancetype)item:(NSString *)logInfo {
    TTVideoLogModel *item = [TTVideoLogModel new];
    item.logInfo = logInfo;
    item.dataString = [NSString tt_dateString];
    return item;
}

- (CGFloat)cellHeight {
    if (self.logInfo) {///Simple calculation
        return MAX(TT_BASE_375(44), ceil(self.logInfo.length * 0.08) * TT_BASE_375(16));
    } else {
        return TT_BASE_375(50.0);
    }
}

@end
