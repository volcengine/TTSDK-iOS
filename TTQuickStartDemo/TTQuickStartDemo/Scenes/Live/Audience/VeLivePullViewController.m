//
//  VeLivePullViewController.m
//  TTQuickStartDemo
//
//  Created by ByteDance on 2022/10/18.
//

#import "VeLivePullViewController.h"
#import <TTSDK/TVLManager.h>
#import <TTSDK/TVLSettingsManager.h>
#import <TTSDK/TVLPlayerItem+TTSDK.h>
#import <TTSDK/TTLiveURLComposer.h>
#import "Constant.h"
#import <TTSDK/TTPlayerDef.h>
#import <TTSDK/TVLOption.h>
@interface VeLivePullViewController () <TVLDelegate, TVLSettingsManagerDataSource>
@property(nonatomic, strong) TVLManager *playerManager;
@property(nonatomic, assign) CGSize videoFrameSize;
@end

@implementation VeLivePullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"观众拉流";
    self.view.backgroundColor = [UIColor blackColor];
    /// 初试化播放器
    [self setupPlayer];
}

- (void)setupPlayer {
    /// 配置播放器参数数据源
    TVLSettingsManager.defaultManager.dataSource = self;
    /// 更新播放器参数
    [TVLSettingsManager.defaultManager updateCurrentSettings];
    /// 初试化拉流播放器
    TVLManager *liveManager = [[TVLManager alloc] initWithOwnPlayer:YES];
    if (liveManager == nil) {
        NSLog(@"license 无效");
        return;
    }
    /// 配置代理
    liveManager.delegate = self;
    /// 预览视图渲染类型
    liveManager.playerViewRenderType = TVLPlayerViewRenderTypeMetal;
    /// 预览视图填充模式
    liveManager.playerViewScaleMode = TVLViewScalingModeAspectFit;
    /// 是否开启硬解 11.0 及以上系统才支持
    liveManager.hardwareDecode = NO;
    if (@available(iOS 11.0, *)) {
        liveManager.hardwareDecode = YES;
    }
    /// 是否开启内部DNS解析，默认YES
    liveManager.shouldUseLiveDNS = NO;
    /// 网络超时时间，单位微妙
    [liveManager setOptionValue:@(3000000) forIdentifier:@(TVLPlayerOptionNetworkTimeout)];
    /// 播放器内部失败重试开关 YES 打开内部重试  NO 关闭内部重试
    [liveManager setOptionValue:@(YES) forIdentifier:@(TVLPlayerOptionIsPlayerCoreOpenFailToTryEnabled)];
    /// 缓冲超时时长，单位秒
    [liveManager setValue:30  forKey:KeyIsBufferingTimeOut];
    /// 卡顿后，播放器需要缓存数据的量，单位毫秒
    [liveManager setValue:3000  forKey:KeyIsDefaultBufferingEndMilliSeconds];
    /// 日志回调，建议接入日志系统
    [TVLManager setLogCallback:^(TVLLogLevel level, NSString *tag, NSString *log) {
        NSLog(@"TVLManager %@ %@ %@", @(level), tag, log);
    }];
    /// 开启 OpenGLES Activity
    [TVLManager startOpenGLESActivity];
    /// 配置application 通知监听
    [self setupApplicationNotifaction];
    /// 属性记录播放器
    self.playerManager = liveManager;
    /// 配置播放视图
    self.playerManager.playerView.frame = UIScreen.mainScreen.bounds;
    [self.view addSubview:self.playerManager.playerView];
    
    /// 推荐使用 URLComposer 构造 PlayerItem
    TTLiveURLComposer *composer = [[TTLiveURLComposer alloc] init];
    /// MARK: 如果是RTM拉流，需要把Format 改成 TVLMediaFormatTypeLLS
    /// 根据播放的url，修改对应的 Format 格式
    [composer addUrl:LIVE_PULL_URL forFormat:TVLMediaFormatTypeFLV];
    /// 构造播放Item
    TVLPlayerItem *item = [TVLPlayerItem playerItemWithComposer:composer];
    /// 替换播放源
    [self.playerManager replaceCurrentItemWithPlayerItem:item];
}

- (void)setupApplicationNotifaction {
    /// app 激活通知
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(applicationDidBecomeActive)
                                               name:UIApplicationDidBecomeActiveNotification
                                             object:nil];
    /// app 失活通知
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(applicationWillResignActive)
                                               name:UIApplicationWillResignActiveNotification
                                             object:nil];
}

- (void)applicationDidBecomeActive {
    /// 开启 OpenGL Acitvity
    [TVLManager startOpenGLESActivity];
}

- (void)applicationWillResignActive {
    /// 关闭 OpenGL Activity
    [TVLManager stopOpenGLESActivity];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /// 页面开始展示，播放
    [self.playerManager play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    /// 页面消失，暂停播放
    [self.playerManager pause];
}

- (void)dealloc {
    /// 业务处理时，尽量不要放到此处释放，推荐放到退出直播间时释放。
    if (self.playerManager != nil) {
        /// 释放播放器资源
        [self.playerManager stop];
        [self.playerManager close];
    }
}

/// MARK: - TVLDelegate
- (void)recieveError:(NSError *)error {
    NSLog(@"播放器错误: %@", error);
}
- (void)startRender {
    NSLog(@"开始渲染");
}
- (void)stallStart {
    NSLog(@"卡顿-开始缓存");
}
- (void)stallEnd {
    NSLog(@"卡顿-缓存结束");
}
- (void)onStreamDryup:(NSError *)error {
    NSLog(@"推流端停止: %@", error);
}
- (void)onMonitorLog:(NSDictionary*) event {
    NSLog(@"日志回调: %@", event);
}
- (void)loadStateChanged:(NSNumber*)state {
    if (state.integerValue == TVLPlayerLoadStateStalled) {
        NSLog(@"卡顿，开始缓存");
    } else if (state.integerValue == TVLPlayerLoadStatePlayable) {
        NSLog(@"卡顿缓存完成，开始播放");
    } else if (state.integerValue == TVLPlayerLoadStateError) {
        NSLog(@"缓存失败");
    }
}

- (void)manager:(TVLManager *)manager playerItemStatusDidChange:(TVLPlayerItemStatus)status {
    if (status == TVLPlayerItemStatusReadyToPlay) {
        NSLog(@"开始播放");
    } else if (status == TVLPlayerItemStatusReadyToRender) {
        NSLog(@"开始渲染");
    } else if (status == TVLPlayerItemStatusCompleted) {
        NSLog(@"播放完成");
    } else if (status == TVLPlayerItemStatusFailed) {
        NSLog(@"播放失败");
    }
}

- (void)manager:(TVLManager *)manager didReceiveSEI:(NSDictionary *)SEI {
    NSLog(@"接收到SEI信息 %@", SEI);
}

- (void)manager:(TVLManager *)manager videoSizeDidChange:(CGSize)size {
    NSLog(@"视频内容大小变更 %@", [NSValue valueWithCGSize:size]);
}

- (void)manager:(TVLManager *)manager videoCropAreaDidAutomaticallyChange:(CGRect)frame {
    NSLog(@"视频裁剪位置自动变更 %@", [NSValue valueWithCGRect:frame]);
}

- (void)manager:(TVLManager *)manager willOpenAudioRenderWithSampleRate:(int)sampleRate channels:(int)channels duration:(int)duration {
    NSLog(@"将要开始渲染音频");
}

- (void)manager:(TVLManager *)manager willProcessAudioFrameWithRawData:(float **)rawData samples:(int)samples timeStamp:(int64_t)timestamp {
    NSLog(@"开始渲染音频");
}

- (void)manager:(TVLManager *)manager didCloseInAsyncMode:(BOOL)isAsync {
    NSLog(@"播放器关闭");
}

- (void)manager:(TVLManager *)manager didReceiveBinarySei:(const uint8_t*)binarySei length:(int)size {
    NSLog(@"接收到二进制 SEI 信息");
}

- (void)receivePlayerErrorForDebug:(NSError *)error {
    NSLog(@"播放器错误信息，用于调试 %@", error);
}

- (NSDictionary *)currentSettings {
    return @{
        TVLSettingsItemKeyPlayerLogCallbackEnabled : @(YES), /// 播放器日志开关
        TVLSettingsItemKeyMaxCacheSeconds : @(10), /// 播放器最大缓存量，单位秒
        TVLSettingsItemKeyIsH264HardwareDecodeEnabled : @(YES), ///播放器 h264 硬解开关
        TVLSettingsItemKeyIsByteVC1HardwareDecodeEnabled : @(YES), /// 播放器 h265 硬解开关
    };
}
- (NSDictionary *)currentCommonParams {
    return @{};
}
@end