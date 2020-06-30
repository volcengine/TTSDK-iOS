//
//  StreamingViewController.h
//  LiveStreamSdkDemo
//
//  Created by 王可成 on 2018/7/11.

#import <UIKit/UIKit.h>
#import "StreamConfigurationModel.h"
#import <TTSDK/LiveStreamLibrary.h>

#if __has_include(<NodeProber/LiveNodeSortManager.h>)
#   define LIVE_NODE_PROBER_TEST 1
#   import <NodeProber/LiveNodeSortManager.h>
#endif

@interface StreamingViewController : UIViewController

- (instancetype)initWithConfiguration:(StreamConfigurationModel *)configuraitons;
@end
