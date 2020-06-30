//
//  LogViewController.h
//  TTVideoLive-iOS
//
//  Created by 陈昭杰 on 2019/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogViewController : UIViewController

- (void)appendLogWithLogInfo:(NSDictionary *)info;

- (void)clear;

- (NSString *)currentLog;

@end

NS_ASSUME_NONNULL_END
