//
//  StreamingViewController+_MTV.h
//  TTSDKDemo
//
//  Created by guojieyuan on 2022/1/28.
//  Copyright © 2022 ByteDance. All rights reserved.
//

#import "StreamingViewController.h"
#import "LSPlayController.h"

@interface StreamingViewController (MTV)

@property (nonatomic, assign, readonly) BOOL isMVRunning;

- (void)mvButtonClicked:(UIButton *)sender;

@end
