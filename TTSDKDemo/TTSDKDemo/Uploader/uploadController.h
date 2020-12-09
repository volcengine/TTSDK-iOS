//
//  uploadControoler.h
//  TTSDKDemo
//
//  Created by bytedance on 2020/10/29.
//  Copyright © 2020 ByteDance. All rights reserved.
//

#import "BaseViewController.h"

#import <UIKit/UIKit.h>
#import "UIBlockButton.h"

@interface uploadController : UIViewController

@property (nonatomic, strong) NSMutableArray<UIBlockButton *> *buttons;
- (NSArray *)videobuttonDescription;

+ (void)configTaskWithURL:(NSString *)urlString params:(NSDictionary *)params headers:(NSDictionary *)headers completion:(void (^)(id _Nullable jsonObject, NSError * _Nullable error))completionHandler;

@end
