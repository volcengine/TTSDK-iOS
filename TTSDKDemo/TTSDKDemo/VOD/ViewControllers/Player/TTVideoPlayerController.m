//
//  TTVideoPlayerController.m
//  TTVideoPlayerDemo
//
//  Created by 刘廷勇 on 2016/11/17.
//
//

#import "TTVideoPlayerController.h"
#import "TTVideoPlayerControlsController.h"
#import "TTVideoPlayerFullScreenManager.h"
#import "SourceViewController.h"
#import "TTVideoAudioSession.h"

NSString *const kTTVideoEngineEventNotification = @"kTTVideoEngineEventNotification.implement";

static NSString *const kFullScreenControllerKeyPath = @"fullScreen";
static NSString *const kEnginePlaybackStateKeyPath = @"playbackState";
@interface TTVideoPlayerController ()<TTVideoEngineDelegate,ControlsViewControllerDelegate,TTVideoEngineDataSource>

@property (nonatomic, strong) TTVideoPlayerControlsController *playerControls;
@property (nonatomic, strong) TTVideoPlayerFullScreenManager *fullScreenManager;
@property (nonatomic, strong) TTVideoEngine *engine;
@property (nonatomic, assign) NSInteger resolutionIndex;/// See tt_resolution_strings()
@property (nonatomic, assign, getter=isMuted) BOOL muted;
@property (nonatomic, assign, getter=isMixWithOther) BOOL mixWithOther;
@property (nonatomic, assign) CGFloat playbackSpeed;
@property (nonatomic, assign) BOOL debugViewStatus;

@end

@implementation TTVideoPlayerController

- (void)dealloc {
    [TTVideoAudioSession inActive];
    [_fullScreenManager removeObserverBlocksForKeyPath:kFullScreenControllerKeyPath];
    [_engine removeObserverBlocksForKeyPath:kEnginePlaybackStateKeyPath];
}

- (instancetype)init {
    if (self = [super init]) {
        _playbackSpeed = 1.0;
    }
    return self;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    self.playerControls.view.frame = self.view.bounds;
    self.engine.playerView.frame = self.view.bounds;
}

- (void)setUpUI {
    [super setUpUI];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self addChildViewController:self.playerControls];
    [self.view addSubview:self.playerControls.view];
    
    ///关于 AVAudioSessionCategory 参见：http://www.samirchen.com/ios-avaudiosession-3/
    [TTVideoAudioSession setCategory:AVAudioSessionCategoryPlayback];
}

- (void)buildUI {
    [super buildUI];
    
    self.resolutionIndex = 2;//HD, See tt_resolution_strings()
    @weakify(self)
    [self.fullScreenManager addObserverBlockForKeyPath:kFullScreenControllerKeyPath block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        @strongify(self)
        if (!self) {
            return;
        }
        
        dispatch_async_on_main_queue(^{
            BOOL fullScreen = [newVal boolValue];
            self.playerControls.fullScreen = fullScreen;
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.fullScreenManager beginMonitor];
    [self.engine play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.fullScreenManager endMonitor];
    [self.engine pause:YES];
}

- (void)setResolutionIndex:(NSInteger)resolutionIndex {
    _resolutionIndex = resolutionIndex;
    
    self.playerControls.resolutionIndex = resolutionIndex;
}

- (void)updateDebugViewStatus:(BOOL)hiden {
    self.playerControls.debugView.alpha = hiden ? 0.0 : 1.0;
    self.debugViewStatus = hiden;
}

- (void)setParams:(NSDictionary *)params {
    if (params == nil || params.count == 0) {
        return;
    }
    _params = params;
    
    NSString *url = params[SourceKeyURL];
    NSString *vid = params[SourceKeyVid];
    
    if (tt_valid_string(url)) {
        [self _resetEngine];
        
        [self.engine ls_setDirectURL:url key:url.md5String];
    } else if(tt_valid_string(vid)) {
        [self _resetEngine];
        
        [self.engine setPlayAuthToken:params[SourceKeyAuth]];
        [self.engine setVideoID:vid];
    }
    
    [TTVideoAudioSession mixWithOther:self.isMixWithOther];
    
#if TARGET_IPHONE_SIMULATOR
    self.engine.hardwareDecode = NO;
#else
    self.engine.hardwareDecode = YES;
#endif
#if DEBUG
    [TTVideoEngine setLogEnabled:YES];
#else
    [TTVideoEngine setLogEnabled:NO];
#endif
    
    self.engine.hardwareDecode = YES;
    // 控制循环播放，默认是 NO;
    self.engine.looping = NO;
    self.engine.muted = self.muted;
    self.engine.playbackSpeed = self.playbackSpeed;
    // 开启 VideoModel 缓存
    [self.engine setOptionForKey:VEKKeyModelCacheVideoInfoEnable_BOOL value:@(YES)];
    // 设置代理
    self.engine.delegate = self;
    self.engine.dataSource = self;
    /// 上传播放器产生的日志
    self.engine.reportLogEnable = YES;
    /// 异步初始化播放器
    /// [self.engine setOptions:@{VEKKEY(VEKKeyPlayerAsyncInit_BOOL):@(YES)}];
#if IS_METAL_ENABLED
    /// 开启 Metal 渲染
    [self.engine setOptions:@{VEKKEY(VEKKeyViewRenderEngine_ENUM):@(TTVideoEngineRenderEngineMetal)}];
#endif
    [self.engine setOptionForKey:VEKKeyLogTag_NSString value:@"普通视频"];
    /// 设置 分辨率
    [self.engine configResolution:self.resolutionIndex];
    /// 网络超时时间
    //[self.engine setOptionForKey:VEKKeyPlayerOpenTimeOut_NSInteger value:@(30)];

    /// 设置开始播放的时间点
    /** 这里需要被设置的开始时间小于资源的总时长 */
//    [self.engine setOptions:@{VEKKEY(VEKKeyPlayerStartTime_CGFloat):@(5.0)}];
    
    /// 将播放器视图放在合适的视图层级上
    [self.view insertSubview:self.engine.playerView atIndex:0];
    // Debug view. get only debug environment.
    self.playerControls.debugView = self.engine.debugInfoView;
    [self updateDebugViewStatus:self.debugViewStatus];
    
    [self _startPlay];
    self.playerControls.titleInfo = params[SourceKeyTitle]?:@"";
}

/// MARK: - Private Method

- (void)_beginObservePlayTime {
    [self _endObservePlayTime];
    self.playerControls.currentPlayingTime = self.engine.currentPlaybackTime;
    
    @weakify(self);
    [self.engine addPeriodicTimeObserverForInterval:0.1 queue:dispatch_get_main_queue() usingBlock:^{
        @strongify(self);
        if (!self.playerControls.isInteractive && self.engine.duration > 0.0) {
            self.playerControls.currentPlayingTime = [self.engine currentPlaybackTime];
            [self.playerControls setCacheProgress:self.engine.playableDuration  / self.engine.duration animated:YES];
        }
    }];
}

- (void)_endObservePlayTime {
    [self.engine removeTimeObserver];
}

- (void)_resetEngine {
    [self.engine.playerView removeFromSuperview];
    [self.engine.debugInfoView removeFromSuperview];
    [self.engine stop];
    [self.engine close];
    [self.engine removeObserverBlocks];
    
    _engine = nil;
    self.engine = [[TTVideoEngine alloc] initWithOwnPlayer:YES];
    // Engine 和 localserver 关联，必要的步骤
    self.engine.proxyServerEnable = YES;
    
    // Reset view show.
    self.playerControls.timeDuration = 0.0;
    self.playerControls.currentPlayingTime = 0.0f;
    [self.playerControls setCacheProgress:0.0 animated:NO];
    
    [self _throwLog:@" ****************  "];
    [self _throwLog:@"切换播放器(Engine)"];
    [self _throwLog:@" ****************  "];
    
    @weakify(self)
    [self.engine addObserverBlockForKeyPath:kEnginePlaybackStateKeyPath block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        @strongify(self)
        if (!self) {
            return;
        }
        
        dispatch_async_on_main_queue(^{
            TTVideoEnginePlaybackState status = [newVal integerValue];
            [UIApplication sharedApplication].idleTimerDisabled = (status == TTVideoEnginePlaybackStatePlaying);
        });
    }];
}

- (void)_startPlay {
    [self.playerControls startLoading];
    [self.engine play];
}

- (void)_throwLog:(NSString *)logInfo {
    if (logInfo == nil || logInfo.length < 1) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kTTVideoEngineEventNotification object:logInfo];
}

/// MARK: - TTVideongineDelegate

- (void)videoEngineDidFinish:(TTVideoEngine *)videoEngine error:(NSError *)error {
    self.playerControls.play = NO;
    
    if (error) {
        [self.playerControls showRetry];
    } else {
        self.playerControls.play = (videoEngine.playbackState == TTVideoEnginePlaybackStatePlaying);
    }
    
    [self _throwLog:[NSString stringWithFormat:@"播放结束：error:%@",error.localizedDescription]];
}

- (void)videoEngineDidFinish:(TTVideoEngine *)videoEngine videoStatusException:(NSInteger)status {
    self.playerControls.play = NO;
    Log(@"=====status: %zd=====", status);
    [self.playerControls showRetry];
    
    [self _throwLog:[NSString stringWithFormat:@"播放结束 StatusException:%zd",status]];
}

- (void)videoEngine:(TTVideoEngine *)videoEngine retryForError:(NSError *)error {
    Log(@"error:%@",error.userInfo);
    
    [self _throwLog:[NSString stringWithFormat:@"播放错误，尝试重试: error:%@",error.localizedDescription]];
}

- (void)videoEngine:(TTVideoEngine *)videoEngine playbackStateDidChanged:(TTVideoEnginePlaybackState)playbackState {
    Log(@"===playback state:%zd",playbackState);
    dispatch_async_on_main_queue(^{
        switch (playbackState) {
            case TTVideoEnginePlaybackStatePlaying:
                self.playerControls.play = YES;
                self.playerControls.timeDuration = self.engine.duration;
                break;
            case TTVideoEnginePlaybackStatePaused:
                self.playerControls.play = NO;
            case TTVideoEnginePlaybackStateError:
                //[self.playerControls showRetry];
            default:
                break;
        }
        
//        [self _throwLog:[NSString stringWithFormat:@"播放状态改变： status:%s",playbackStateGetName(playbackState)]];
    });
}

- (void)videoEngine:(TTVideoEngine *)videoEngine loadStateDidChanged:(TTVideoEngineLoadState)loadState {
    dispatch_async_on_main_queue(^{
        switch (loadState) {
            case TTVideoEngineLoadStatePlayable:
                [self.playerControls stopLoading];
                break;
            case TTVideoEngineLoadStateStalled:
                [self.playerControls startLoading];
                break;
            case TTVideoEngineLoadStateError:
                //[self.playerControls showRetry];
                break;
            default:
                break;
        }
//        [self _throwLog:[NSString stringWithFormat:@"加载状态改变： status:%s",loadStateGetName(loadState)]];
    });
}

- (void)videoEngine:(TTVideoEngine *)videoEngine fetchedVideoModel:(TTVideoEngineModel *)videoModel {
    Log(@"%@  fetchedVideoModel ... :%@",videoEngine,videoModel);
    dispatch_async_on_main_queue(^{
        [self _throwLog:[NSString stringWithFormat:@"获取到 videoModel： vid:%@",videoModel.videoInfo.videoID]];
    });
}

- (void)videoEnginePrepared:(TTVideoEngine *)videoEngine {
    Log(@"%@  prepared ...",videoEngine);
    
    [self _throwLog:@"EnginePrepared"];
    
    NSArray<NSNumber *> *temArray = self.engine.supportedResolutionTypes;
    NSInteger temInt = temArray.lastObject.integerValue;
    self.resolutionIndex = MIN(temInt, self.resolutionIndex);
}

- (void)videoEngineReadyToPlay:(TTVideoEngine *)videoEngine {
    Log(@"%@  readyToPlay ...",videoEngine);
    
    [self _throwLog:@"EngineReadyToPlay"];
}

- (void)videoEngineStalledExcludeSeek:(TTVideoEngine *)videoEngine {
    Log(@"%@  stall ...",videoEngine);
    
    [self _throwLog:@"EngineStalled"];
}

- (void)videoEngineUserStopped:(TTVideoEngine *)videoEngine {
    [self _throwLog:@"EngineUserStopped"];
}

- (void)videoEngineCloseAysncFinish:(TTVideoEngine *)videoEngine {
    [self _throwLog:@"EngineCloseAysncFinish"];
}

- (TTVideoEngineNetworkType)networkType {
    /// Need get accurate value.
    return TTVideoEngineNetworkTypeWifi;
}

/// MARK: - ControlsViewControllerDelegate

- (void)controlsViewController:(TTVideoPlayerControlsController *)controller showStatus:(BOOL)isShowing {
    isShowing ? [self _beginObservePlayTime] : [self _endObservePlayTime];
}

- (void)controlsViewController:(TTVideoPlayerControlsController *)controller playStatus:(BOOL)isPlay {
    isPlay ? [self.engine play] : [self.engine pause:YES];
    
    [self _throwLog:[NSString stringWithFormat:@"手动切换播放状态：play:%d",isPlay]];
}

- (void)controlsViewController:(TTVideoPlayerControlsController *)controller changeProgress:(CGFloat)progress {
    NSTimeInterval currentTime = self.engine.duration * progress;
    [self _throwLog:[NSString stringWithFormat:@"开始 seek：time:%f",currentTime]];
    @weakify(self)
    [self.engine setCurrentPlaybackTime:currentTime complete:^(BOOL success) {
        Log(@"seek complete %@", @(success));
        @strongify(self)
        if (!self) {
            return;
        }
        
        [self _throwLog:[NSString stringWithFormat:@"结束 seek：time:%f",currentTime]];
    }];
}

- (void)controlsViewController:(TTVideoPlayerControlsController *)controller fullScreen:(BOOL)toFullScreen {
    [self _throwLog:[NSString stringWithFormat:@"屏幕切换：fullscreen:%d",toFullScreen]];
    // 视频的本身是否是竖屏
    NSInteger videoWidth = [[self.engine getOptionBykey:VEKKEY(VEKGetKeyPlayerVideoWidth_NSInteger)] integerValue];
    NSInteger videoHeight = [[self.engine getOptionBykey:VEKKEY(VEKGetKeyPlayerVideoHeight_NSInteger)] integerValue];
    BOOL verticalScreen = NO;
    if (toFullScreen && videoWidth > 0 && videoWidth <  videoHeight) {
        verticalScreen = YES;
    }
    controller.verticalScreen = verticalScreen;
    self.fullScreenManager.verticalScreen = verticalScreen;
    [self.fullScreenManager setFullScreen:toFullScreen animated:YES];
}

- (void)controlsViewController:(TTVideoPlayerControlsController *)controller changeResolution:(NSInteger)resolution {
    self.resolutionIndex = resolution;
    [self _throwLog:[NSString stringWithFormat:@"开始切换分辨率：%@",tt_resolution_strings()[resolution]]];
    [self.engine configResolution:resolution completion:^(BOOL success, TTVideoEngineResolutionType completeResolution) {
        Log(@"change resolution complete: %@",@(success));
        [self _throwLog:[NSString stringWithFormat:@"切换分辨率结束：%@ result:%d",tt_resolution_strings()[completeResolution],success]];
    }];
}

- (void)controlsViewController:(TTVideoPlayerControlsController *)controller retry:(NSInteger)times {
    [self _startPlay];
    [self _throwLog:[NSString stringWithFormat:@"点击重试按钮"]];
}

- (void)controlsViewController:(TTVideoPlayerControlsController *)controller playBackSpeed:(CGFloat)speed {
    [self _throwLog:[NSString stringWithFormat:@"切换播放速率：%.2f",speed]];
    self.playbackSpeed = speed;
    self.engine.playbackSpeed = speed;
}

- (void)controlsViewController:(TTVideoPlayerControlsController *)controller muted:(BOOL)isMuted {
    [self _throwLog:[NSString stringWithFormat:@"静音开关：status:%d",isMuted]];
    self.muted = isMuted;
    self.engine.muted = isMuted;
}

- (void)controlsViewController:(TTVideoPlayerControlsController *)controller mixWithOther:(BOOL)isOn {
    [self _throwLog:[NSString stringWithFormat:@"混播开关：status:%d",isOn]];
    
    self.mixWithOther = isOn;
    [self.engine pause];
    [TTVideoAudioSession mixWithOther:isOn];
    [self.engine play];
}

/// MARK: - ControlsViewControllerDataSource

- (NSArray<NSString *> *)resolutionsForControls:(TTVideoPlayerControlsController *)controls {
    NSMutableArray *temarray = [NSMutableArray array];
    NSArray *stringArray = tt_resolution_strings();
    [self.engine.supportedResolutionTypes enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger temInt = obj.integerValue;
        if (temInt >= 0 && temInt < stringArray.count) {
            [temarray addObject:stringArray[temInt]];
        }
    }];
    return temarray.copy;
}

/// MARK: - Getter

- (TTVideoPlayerControlsController *)playerControls {
    if (!_playerControls) {
        _playerControls = [[TTVideoPlayerControlsController alloc] init];
        _playerControls.delegate = (id<ControlsViewControllerDelegate>)self;
        _playerControls.dataSource = (id<ControlsViewControllerDataSource>)self;
        _playerControls.fullScreen = NO;
        _playerControls.resolutionIndex = self.resolutionIndex;
    }
    return _playerControls;
}

- (TTVideoPlayerFullScreenManager *)fullScreenManager {
    if (!_fullScreenManager) {
        _fullScreenManager = [[TTVideoPlayerFullScreenManager alloc] initWithPlayerView:self.view];
    }
    return _fullScreenManager;
}

@end
