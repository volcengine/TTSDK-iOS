//
//  TTVideoHistoryController.h
//  TTVideoEngineDemo
//
//  Created by 黄清 on 2018/12/24.
//  Copyright © 2018 bytedance. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SourceViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoHistoryController : BaseTableViewController

@property (nonatomic, weak) id<HistoryViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
