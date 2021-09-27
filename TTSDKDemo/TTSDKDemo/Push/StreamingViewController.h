//
//  StreamingViewController.h
//  LiveStreamSdkDemo
//
//  Created by 王可成 on 2018/7/11.

#import <UIKit/UIKit.h>
#import "StreamConfigurationModel.h"

#if __has_include(<NodeProber/LiveNodeSortManager.h>)
#   define LIVE_NODE_PROBER_TEST 1
#   import <NodeProber/LiveNodeSortManager.h>
#endif

#if USE_EFFECT
//#define HAVE_EFFECT 1
#define HAVE_AUDIO_EFFECT 1
#else
//#define HAVE_EFFECT 0
#define HAVE_AUDIO_EFFECT 0
#endif
// LiveCore 無法接入
#define LIVECORE_ENABLE 0

@interface StreamingViewController : UIViewController
@property (nonatomic) LiveStreamCapture *capture;
#if HAVE_AUDIO_EFFECT
@property (nonatomic, strong) LSLiveAudioUnitProcess *audioUnit;
@property (nonatomic, strong) UIButton *karaokeButton;
@property (nonatomic, strong) UIButton *musicTypeButton;
#endif
@property (nonatomic, strong) UISlider *recordVolumeSlider;
@property (nonatomic, strong) UISlider *musicVolumeSlider;
@property (nonatomic, strong) UIView *karaokeControllersContainer;
- (instancetype)initWithConfiguration:(StreamConfigurationModel *)configuraitons;
@end
