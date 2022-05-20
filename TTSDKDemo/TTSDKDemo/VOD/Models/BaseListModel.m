//
//  BaseListModel.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/12.


#import "BaseListModel.h"

@implementation BaseListModel

+ (NSArray *)mj_ignoredCodingPropertyNames {
    return @[@"superclass",@"description",@"debugDescription"];
}

MJExtensionCodingImplementation

- (CGFloat)cellHeight {
    return 0.0f;
}

@end
