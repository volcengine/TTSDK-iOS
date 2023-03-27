//
//  VeLivePushViewController.m
//  TTQuickStartDemo
//
//  Created by ByteDance on 2022/10/18.
//

#import "VeLivePushViewController.h"
#import <TTSDK/LiveCore.h>
#import <TTSDK/LiveCore+Capture.h>
#import "Constant.h"
@interface VeLivePushViewController ()
@property(nonatomic, strong) LiveCore *pushEngine;
@end

@implementation VeLivePushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主播推流";
    self.view.backgroundColor = [UIColor blackColor];
    /// 初试化推流器
    [self setupPushEngine];
}

- (void)setupPushEngine {
    /// 配置推流引擎
    self.pushEngine = [[LiveCore alloc] initWithMode:(LiveCoreModuleCapture | LiveCoreModuleLiveStreaming)];
    /// 设置日志级别
    [self.pushEngine setLogLevel:(LiveStreamLogLevelDebug)];
    
    /// 音频采集配置
    /// 音频采集参数
    LiveAudioConfiguration *audioCfg = [[LiveAudioConfiguration alloc] init];
    /// 配置音频采集
    [self.pushEngine setupAudioCaptureWithConfig:audioCfg];
    
    /// 配置采集模块
    /// 视频采集参数
    LiveStreamCaptureConfig *captureCfg = [LiveStreamCaptureConfig defaultConfig];
    /// 初试化视频采集模块
    LiveStreamCapture *capture = [[LiveStreamCapture alloc] initWithConfig:captureCfg];
    /// 设置预览视图
    [capture resetPreviewView:self.view];
    /// 把视频采集模块配置给推流引擎
    [self.pushEngine setLiveCapture:capture];
    
    /// 配置推流模块
    LiveStreamConfiguration *streamConfig = [LiveStreamConfiguration defaultConfiguration];
    // 设置推流视频编码参数
    /// 输出分辨率
    streamConfig.outputSize  = CGSizeMake(720, 1280); //仅供参考
    /// 默认比特率
    streamConfig.bitrate     = 1200 * 1000; //仅供参考
    /// 最低比特率
    streamConfig.minBitrate  = 800 * 1000;  //仅供参考
    /// 最大比特率
    streamConfig.maxBitrate  = 1900 * 1000; //仅供参考
    /// fps
    streamConfig.videoFPS    = 15; //仅供参考
    /// 推流地址
    streamConfig.rtmpURL = LIVE_PUSH_URL;
    /// 配置推流引擎
    [self.pushEngine setupLiveSessionWithConfig:streamConfig];
    
    if (self.pushEngine.liveSession == nil) {
        NSLog(@"license 无效");
        self.pushEngine = nil;
        return;
    }
    /// 开启音视频采集
    __weak __typeof(self)weakSelf = self;
    /// 获取麦克风摄像头权限
    [self authAudioVideo:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        /// 开启音频采集
        [strongSelf.pushEngine startAudioCapture];
        /// 开启视频采集
        [strongSelf.pushEngine startVideoCapture];
        
        /// 开启推流
        [strongSelf.pushEngine startStreaming];
    }];
}

- (void)authAudioVideo:(dispatch_block_t)block  {
    /// 获取麦克风和摄像头权限
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_group_leave(group);
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), block);
}

- (void)dealloc {
    /// 业务处理时，尽量不要放到此处释放，推荐放到退出直播间时释放。
    if (self.pushEngine != nil) {
        /// 停止推流
        [self.pushEngine stopStreaming];
        /// 停止音频采集
        [self.pushEngine stopAudioCapture];
        /// 停止视频采集
        [self.pushEngine stopVideoCapture];
        self.pushEngine = nil;
    }
}
@end
