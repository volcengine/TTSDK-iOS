//
//  TTVideoSwitch.h
//  TTVideoEngineDemo
//
//  Created by 黄清 on 2018/12/24.
//  Copyright © 2018 bytedance. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoSwitch : BaseView

+ (instancetype)switchWithTitle:(NSString *)titile;

@property (nonatomic, copy) ButtonClick switchCall;

@end

NS_ASSUME_NONNULL_END
