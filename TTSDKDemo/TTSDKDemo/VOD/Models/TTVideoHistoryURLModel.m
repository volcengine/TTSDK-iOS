//
//  TTVideoHistoryURLModel.m
//  TTVideoEngineDemo
//
//  Created by 黄清 on 2018/12/24.
//  Copyright © 2018 bytedance. All rights reserved.
//

#import "TTVideoHistoryURLModel.h"

@implementation TTVideoHistoryURLModel
+ (NSArray *)mj_allowedCodingPropertyNames {
    return @[@"urlString"];
}

MJExtensionCodingImplementation

- (BOOL)isEqual:(id)object {
    BOOL result = [super isEqual:object];
    if (result) {
        return  result;
    }
    
    TTVideoHistoryURLModel *other = (TTVideoHistoryURLModel *)object;
    if (![other isKindOfClass:[TTVideoHistoryURLModel class]]) {
        return NO;
    }
    result = [self.urlString isEqual:other.urlString];
    return result;
}

- (CGFloat)cellHeight {
    return MAX(self.urlString.length * TT_BASE_375(16) * 0.08, TT_BASE_375(40));
}

@end
