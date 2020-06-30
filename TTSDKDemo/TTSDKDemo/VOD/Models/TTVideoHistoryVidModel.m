//
//  TTVideoHistoryVidModel.m
//  TTVideoEngineDemo
//
//  Created by 黄清 on 2018/12/24.
//  Copyright © 2018 bytedance. All rights reserved.
//

#import "TTVideoHistoryVidModel.h"

@implementation TTVideoHistoryVidModel
+ (NSArray *)mj_allowedCodingPropertyNames {
    return @[@"vidString",@"authString",@"ptokenString"];
}

MJExtensionCodingImplementation

- (BOOL)isEqual:(id)object {
    BOOL result = [super isEqual:object];
    if (result) {
        return  result;
    }
    
    TTVideoHistoryVidModel *other = (TTVideoHistoryVidModel *)object;
    if (![other isKindOfClass:[TTVideoHistoryVidModel class]]) {
        return NO;
    }
    result = [self.vidString isEqual:other.vidString] &&
             [self.authString isEqual:other.authString] &&
             [self.ptokenString isEqual:other.ptokenString];
    return result;
}

- (CGFloat)cellHeight {
    return MAX((self.vidString.length + self.authString.length + self.ptokenString.length) * TT_BASE_375(16) * 0.08, TT_BASE_375(50));
}

@end
