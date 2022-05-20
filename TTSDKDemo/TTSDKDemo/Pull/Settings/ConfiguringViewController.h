//
//  ConfiguringViewController.h
//  TTVideoLive-iOS
//
//  Created by 陈昭杰 on 2019/1/24.
//

#import <UIKit/UIKit.h>
#import "PlayConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfiguringViewController : UIViewController

@property (nonatomic, strong) RACCommand *confirmCommand;

@property (nonatomic, strong) RACCommand *cancelCommand;

@property (nonatomic, strong) PlayConfiguration *currentConfiguration;

- (instancetype)initWithConfiguration:(PlayConfiguration *)configuration;

@end

NS_ASSUME_NONNULL_END
