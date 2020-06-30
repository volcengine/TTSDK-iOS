//
//  TTControlsBox.h
//  TTSDKDemo
//
//  Created by 陈昭杰 on 2020/1/19.
//  Copyright © 2020 ByteDance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTEffectsViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTControlsBox : UIViewController

@property (nonatomic, strong, readonly) TTEffectsViewModel *viewModel;

- (instancetype)initWithViewModel:(TTEffectsViewModel *)viewModel;

- (void)present;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END

