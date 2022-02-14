//
//  StreamingViewController.m
//  LiveStreamSdkDemo
//
//  Created by 王可成 on 2018/7/11.

#import "StreamingViewController.h"
#import "StreamingViewController+KTV.h"
#import "StreamingViewController+MTV.h"
#import "LiveHelper.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "BEEffectManager.h"
#import "BEFrameProcessor.h"

#import "TTControlsBox.h"
#import "TTEffectsViewModel.h"
#import <Photos/Photos.h>

static NSString *const kRecordingText = @"录制中";
static NSString *const kRecordText = @"录制";
#define kSessionMixPic         @"加图片"
#define kSessionRemovePic      @"删图片"
static int const kTestSessionPicID = 60;


@interface StreamingViewController () <LCCameraOutputDelegate, LiveStreamSessionProtocol>

//MARK: UI
@property (nonatomic) UIView *controlView;
@property (nonatomic) UIButton *startButton;
@property (nonatomic) UIButton *stopButton;
@property (nonatomic) UIButton *cameraButton;
@property (nonatomic) UIButton *muteButton;
@property (nonatomic, strong) UIButton *mixPicButton; //端上合流加上一个图片

@property (nonatomic) UIView *canvasView;

@property (nonatomic, strong) NSMutableArray *observerArray;

@property (nonatomic, strong) UIView *cameraPreviewContainerView;

@property (nonatomic) UILabel *infoView;
@property (nonatomic, strong) UITapGestureRecognizer *effectsTapGesture;
@property (nonatomic, strong) UILabel *tipsLabel;

//MARK: Status - 状态
@property (nonatomic, assign) BOOL senceTime;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL effectSDK;
@property (nonatomic, assign) CGFloat recordRate;

@property (nonatomic, assign) BOOL audioMute;
@property (nonatomic, assign) BOOL dumpRecording;
//MARK: 媒体混流
@property (nonatomic, strong) NSLock* mixPicLock;
@property (nonatomic, strong) LiveStreamMultiTimerManager *pushMixPicTimer;
@property (nonatomic, assign) CVPixelBufferRef mixPicPixelBuffer;


//MARK: Streaming - 推流配置
@property (nonatomic, strong) LiveStreamConfiguration *liveConfig;

@property (nonatomic) StreamConfigurationModel *configuraitons;
@property (nonatomic, assign) CGSize captureSize;

@property (nonatomic, copy) NSString *did_str;

//MARK: Effect
@property (nonatomic, strong) BEFrameProcessor *processor;
@property (nonatomic, strong) BEEffectManager *effectManager;

@property (nonatomic, strong) TTControlsBox *controlsBox;

//MARK: 录屏
@property (nonatomic, strong) LiveStreamRawDataHelper *recorder;

//MARK:
@property (nonatomic, strong) StreamingKTVControllBox *karaokeControllersContainer;

@end

@implementation StreamingViewController

- (instancetype)initWithConfiguration:(StreamConfigurationModel *)configuraitons {
    if (self = [super init]) {
        self.configuraitons = configuraitons;
    }
    return self;
}

- (void)dealloc {
    if (self.engine) {
        [self stopStreaming];
        [self.engine stopAudioCapture];
        self.engine = nil;
    }
    NSLog(@"\n--------------stream view controller dealloc---------------");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if (_engine) {
        [self stopStreaming];
    }
    
#if HAVE_EFFECT
    [_capture applyComposerNodes:@[]];
    [_capture applyEffect:@"" type:LSLiveEffectGroup];
    [_capture applyEffect:@"" type:LSLiveEffectFilter];
#endif
    
    if (_engine) {
        [self.engine stopVideoCapture];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

    NSLog(@"\n--------------stream view controller dealloced--------------- running");

    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
//    _did_str = [TTInstallIDManager sharedInstance].deviceID;
    [self requestAuthorization];
    [self setupUIComponent];
    _audioMute = NO;
    
    //MARK: 1. 创建采集模块
    _captureSize = _configuraitons.captureResolution;
    LiveStreamCaptureConfig * captureConfig = [LiveStreamCaptureConfig defaultConfig];
    _capture = [[LiveStreamCapture alloc] initWithMode:LSCaptureEffectMode config:captureConfig];
    [_capture setOutputSize:_liveConfig.outputSize];
    
    __weak typeof(self) wself = self;
    [_capture setFirstFrameRenderCallback:^(BOOL success, int64_t pts, uint32_t err_no) {
        NSLog(@"first frame render callback");
        if (!success) {
            return;
        }
        __strong typeof(wself) sself = wself;
        [sself setupProcessor];
    }];
    
    _capture.cameraPosition = AVCaptureDevicePositionFront ;
    _capture.inPixelFmt = kCVPixelFormatType_32BGRA;
    [_capture setEnableEffect:NO];
    [_capture resetPreviewView:self.cameraPreviewContainerView];
    
    //MARK: 2. 配置网路推流模块设置
    _liveConfig = [LiveStreamConfiguration defaultConfiguration];
    _liveConfig.enableBFrame = _configuraitons.enableBFrame;
    _liveConfig.outputSize = _configuraitons.streamResolution;
    _liveConfig.vCodec = (LiveStreamVideoCodec)_configuraitons.videoCodecType;
    _liveConfig.profileLevel = [self getProfileInfo:_configuraitons.profileLevel];
    _liveConfig.videoFPS = _configuraitons.fps;
    _liveConfig.bitrate = _configuraitons.videoBitrate * 1000;
    _liveConfig.minBitrate = _configuraitons.videoBitrate * 1000 * 2 / 5;
    _liveConfig.maxBitrate = _configuraitons.videoBitrate * 1000 * 5 / 3;
    _liveConfig.audioSource = LiveStreamAudioSourceMic;
 
    // 推流地址
    _liveConfig.URLs = @[_configuraitons.streamURL];
    _liveConfig.audioSampleRate = 44100;
    _liveConfig.streamLogTimeInterval = 5;
    _liveConfig.gopSec = 4;                         // gop 4s
    // 是允许后台推流
    _liveConfig.enableBackgroundMode = _configuraitons.enableBackgroundMode;
    _liveConfig.audioChannelCount = 2;
    _liveConfig.aCodec = [self getCodecType:_configuraitons.audioCodecType];
    if (_configuraitons.enableAudioStream) {
        _liveConfig.streamMode = LiveStreamModeAudioANDDarkFrame;
    }
    //MARK: 3. 创建LiveCore
    _engine = [[LiveCore alloc] initWithMode:LiveCoreModuleCapture | LiveCoreModuleLiveStreaming];
    if (_configuraitons.enableAudioStream) {
        _engine.captureMode = LiveCoreCaptureModeANDDarkFrame;
    }
    [_engine setEnableAudioCaptureInBackground:_configuraitons.enableBackgroundMode];
    [_engine setEnableExternalAU:YES];
    [_engine setReconnectCount:10];
    [_engine setLogLevel:LiveStreamLogLevelWarning];
    
    //MARK: 4. 传入推流网路配置到 LiveCore
    [_engine setupLiveSessionWithConfig:_liveConfig];
    
    //MARK: 3.1 LiveCore + 视频采集
    [_engine setLiveCapture:_capture];
    
    //MARK: 3.2 LiveCore + 音频采集
    // 如果需要
    LiveAudioConfiguration *audioConfig = [[LiveAudioConfiguration alloc] init];
    [_engine setupAudioCaptureWithConfig:audioConfig];

    //MARK: 5. 设置日志回调与状态通知
    // 网路状况回调
    [_engine setNetworkQualityCallback:^(LiveCoreNetworkQuality networkQuality) {
        NSLog(@"CurrentNetworkQuility = %ld", networkQuality);
    }];
    
    [_engine setDebugLogBlock:^(NSString *log) {
        NSLog(@"%@", log);
    }];

    // 推流日志
    [_engine setStreamLogCallback:^(NSDictionary *log) {
        __strong typeof(wself) sself = wself;
        if (!sself) {
            return;
        }
        NSMutableDictionary *log_dict = [NSMutableDictionary dictionaryWithDictionary:log];
        [log_dict addEntriesFromDictionary:[sself->_capture getStatisticInfo]];
        NSLog(@"<<<<< log <<<<< %@", log_dict);
    }];

    // 推流状态回调
    [_engine setStatusChangedBlock:^(LiveStreamSessionState state, LiveStreamErrorCode errCode) {
        if (state) {
            [wself streamSession:wself.engine.liveSession onStatusChanged:state];
        } else if (errCode) {
            [wself streamSession:wself.engine.liveSession onError:errCode];
        }
    }];
  
    //MARK: Final. 开始采集
    [_engine setDidCapturedVideoFrame:^(CVPixelBufferRef  _Nonnull buffer, CMTime pts) {
        __strong typeof(wself) sself = wself;
        if (sself.dumpRecording) {
            [sself.recorder processVideoPixelbuf:buffer presentationTime:pts sourceType:LSRawDataSourceTypeH264];
        }
    }];
    [_engine startVideoCapture];
    [_engine startAudioCapture];
    
    //MARK: 若需要美颜，需要接管摄影机采集
    self.engine.camera.outputPixelFmt = kCVPixelFormatType_32BGRA;
    self.engine.camera.outputDelegate = self;
    
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];

    id WillResignActiveObserver =
    [center addObserverForName:UIApplicationWillResignActiveNotification
                        object:nil
                         queue:[NSOperationQueue mainQueue]
                    usingBlock:^(NSNotification* notification) {
                        [wself.capture stopVideoCapture];
                    }];
    
    id DidBecomeActiveObserver =
    [center addObserverForName:UIApplicationDidBecomeActiveNotification
                        object:nil
                         queue:[NSOperationQueue mainQueue]
                    usingBlock:^(NSNotification* notification) {
                        [wself.capture startVideoCapture];
                    }];
    
    DidBecomeActiveObserver = CFBridgingRelease((__bridge_retained void*)DidBecomeActiveObserver);
    WillResignActiveObserver = (__bridge id)((__bridge_retained void*)WillResignActiveObserver);
}

- (void)setupProcessor {
    _processor = [[BEFrameProcessor alloc] initWithContext:[_capture getGLContext] resourceDelegate:nil];
    NSLog(@"%@", _processor.availableFeatures);
    [_processor setComposerMode:1];
    [_processor updateComposerNodes:@[]];
}

- (void)requestAuthorization {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    if (authStatus != AVAuthorizationStatusAuthorized) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                NSLog(@"授权成功！");
            }
            else {
                NSLog(@"授权失败！");
            }
        }];
    }
}

//MARK: 美颜特效
- (void)didCaptureVideoSampleBuffer:(CMSampleBufferRef)videoBuffer {
    CVPixelBufferRef buffer = CMSampleBufferGetImageBuffer(videoBuffer);
    CMTime pts = CMSampleBufferGetPresentationTimeStamp(videoBuffer);

    double timeStamp = (double)(pts.value / pts.timescale);
//    BEProcessResult *result = [self.processor process:buffer timeStamp:timeStamp];
//    [_capture pushVideoBuffer:result.pixelBuffer ?: buffer andCMTime:pts];
    [_capture pushVideoBuffer:buffer andCMTime:pts];
}

- (void)setupUIComponent {
    self.view.backgroundColor = [UIColor whiteColor];
    _controlView = [[UIView alloc] initWithFrame:self.view.bounds];
    _controlView.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 44);
    _controlView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:_controlView];
    
    self.cameraPreviewContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.cameraPreviewContainerView.backgroundColor = [UIColor clearColor];
    self.cameraPreviewContainerView.userInteractionEnabled = YES;
    
    [self.view insertSubview:self.cameraPreviewContainerView atIndex:0];
    
    self.effectSDK = YES;
    
    // control components
    [_controlView addSubview:[LiveHelper createButton:@"退出"
                                               target:self
                                               action:@selector(onQuitButtonClicked:)]];
    
    _startButton = [LiveHelper createButton:@"开始"
                                     target:self
                                     action:@selector(onStartButtonClicked:)];
    _stopButton = [LiveHelper createButton:@"停止"
                                    target:self
                                    action:@selector(onStopButtonClicked:)];
    _stopButton.hidden = YES;
    _cameraButton = [LiveHelper createButton:@"摄像头"
                                      target:self
                                      action:@selector(onToggleButtonClicked:)];
    _muteButton = [LiveHelper createButton:@"mute"
                                    target:self
                                    action:@selector(onMuteButtonClicked:)];
    [_controlView addSubview:_startButton];
    [_controlView addSubview:_stopButton];
    [_controlView addSubview:_cameraButton];
    [_controlView addSubview:_muteButton];
    
#if HAVE_AUDIO_EFFECT
    _musicTypeButton = [LiveHelper createButton:@"伴奏" target:self action:@selector(setupAudioUnitProcess:)];
    [_controlView addSubview:_musicTypeButton];
    [self initKTVView];
#endif
    
    //[_controlView addSubview:[LiveHelper createButton:@"测试SEI" target:self action:@selector(onSendSEIMsgButtonClicked:)]];
    [_controlView addSubview:[LiveHelper createButton:@"回声消除: 关" target:self action:@selector(onEchoCancellationButtonClicked:)]];
    
    [_controlView addSubview:[LiveHelper createButton:@"特效" target:self action:@selector(onEffectButtonClicked:)]];
    [_controlView addSubview:[LiveHelper createButton:@"贴纸" target:self action:@selector(onStickerButtonClicked:)]];
    [_controlView addSubview:[LiveHelper createButton:@"镜像" target:self action:@selector(onMirrorButtonClicked:)]];
    [_controlView addSubview:[LiveHelper createButton:@"耳返开" target:self action:@selector(onHeadphoneBackButtonClicked:)]];
    [_controlView addSubview:[LiveHelper createButton:kRecordText target:self action:@selector(onRecordButtonClicked:)]];
    [_controlView addSubview:[LiveHelper createButton:kSessionMixPic target:self action:@selector(mixPicButtonClicked:)]];
    [_controlView addSubview:[LiveHelper createButton:@"开mv" target:self action:@selector(mvButtonClicked:)]];
    [self.view addSubview:self.infoView];
    
    // layout
    CGFloat btnHeight = 30;
    CGFloat btnWidth  = 64;
    
    CGRect content = CGRectInset(self.controlView.bounds, 0, 20);
    NSInteger row = CGRectGetHeight(content)/btnHeight;//行数
    NSInteger col = CGRectGetWidth(content)/btnWidth;//列数
    NSArray *subViews = [self.controlView subviews];
    CGRect lastControlFrame = CGRectZero;
    for (int index = 0; index < [subViews count]; index++) {
        UIControl*  control = subViews[index];
        if ([control isKindOfClass:[UIButton class]]) {
            CGRect frame = [LiveHelper frameForItemAtIndex:index+1/*从1开始*/ contentArea:content rows:row cols:col itemHeight:btnHeight itemWidth:btnWidth];
            control.frame = CGRectInset(frame, 1, 1);
            lastControlFrame = control.frame;
        }
    }
    
    self.tipsLabel = [LiveHelper createLable:@""];
    self.tipsLabel.frame = CGRectMake(CGRectGetMinX(content)+5, CGRectGetMaxY(lastControlFrame)+10, CGRectGetMaxX(content)-10, 20);
    [_controlView addSubview:self.tipsLabel];
    
    TTEffectsViewModel *effectsViewModel = [[TTEffectsViewModel alloc] initWithModel:TTEffectsModel.defaultModel];
    __weak typeof(self) weakSelf = self;
    effectsViewModel.composerNodesChangedBlock = ^(NSArray<NSString *> * _Nonnull currentComposerNodes) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.processor updateComposerNodes:currentComposerNodes];
    };
    effectsViewModel.composerNodeIntensityChangedBlock = ^(NSString * _Nonnull path, NSString * _Nonnull key, CGFloat intensity) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.processor updateComposerNodeIntensity:path key:key intensity:intensity];
    };
    effectsViewModel.stickerChangedBlock = ^(NSString * _Nonnull path) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.processor setStickerPath:path];
    };
    effectsViewModel.filterChangedBlock = ^(NSString * _Nonnull path) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.processor setFilterPath:path];
    };
    TTControlsBox *controlsBox = [[TTControlsBox alloc] initWithViewModel:effectsViewModel];
    [self.view addSubview:controlsBox.view];
    controlsBox.view.hidden = YES;
    self.controlsBox = controlsBox;
}

/* ......... */
- (void)timerStatistics {
    //
    if (self.engine && self.engine.musicIsPlaying) {
        float progress = [self.engine currentPlayTime] / [self.engine musicDuration];
        [self.timeSeekSlider setValue:progress];
    }
    
    //
    NSDictionary *dic = [_engine.liveSession getStatistics];
    if(!dic) {
        return;
    }
    
    NSString *sdkVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *capInfo = [_capture getStatisticInfo];
    int in_fps = [[capInfo objectForKey:@"in_cap_fps"] intValue];
    int out_fps = [[capInfo objectForKey:@"out_cap_fps"] intValue];
    self.infoView.text = [NSString stringWithFormat:
                          @"%@\n"
                          "did: %@\n"
                          "LiveSDK: v%@\n"
                          "URL:%@\n"
                          "Audio bitrate: %d kbps\n"
                          "Video max bitrate: %lu kbps\n"
                          "Video init bitrate: %lu kbps\n"
                          "Video min bitrate: %lu kbps\n"
                          "Current video bitrate: %d kbps\n"
                          "Capture size:%d, %d\n"
                          "Stream size:%d, %d\n"
                          "Capture FPS:%d\n"
                          "Capture I/O FPS: %d|%d \n"
                          "Realtime transport FPS:%d\n"
                          "Realtime enc bitrate:%d kbps\n"
                          "Realtime rtmp bitrate:%d kbps\n"
                          "DropFrameCount:%d\n",
                          [NSDate date],
                          _did_str,
                          sdkVersion,
                          _configuraitons.streamURL,
                          _configuraitons.audioBitrate,                                             // audio encode bitrate
                          _liveConfig.maxBitrate / 1000,                                            // video max encode bitrate
                          _liveConfig.bitrate / 1000,                                               // video init encode bitrate
                          _liveConfig.minBitrate / 1000,                                            // video min encode bitrate
                          [[dic valueForKey:LiveStreamInfo_CurrentVideoBitrate] intValue] / 1000,
                          (int)_captureSize.width, (int)_captureSize.height,    // capture size     // capture size
                          [[dic valueForKey:@"width"] intValue],                                    // encode height
                          [[dic valueForKey:@"height"] intValue],                                   // encode height
                          _configuraitons.fps,                                                      // capture fps
                          in_fps, out_fps,                                                          // in&out capture fps
                          [[dic valueForKey:LiveStreamInfo_EncodeFPS] intValue],                    // real fps
                          [[dic valueForKey:LiveStreamInfo_RealEncodeBitrate] intValue] / 1000,     // encode bitrate
                          [[dic valueForKey:LiveStreamInfo_RealTransportBitrate] intValue] / 1000,  // send bitrate
                          [[dic valueForKey:@"dropCount"] intValue]
                          ];
}


#pragma mark - device auth check
- (BOOL)isAudioAuthorized {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus != AVAuthorizationStatusAuthorized) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isVideoAuthorized {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus != AVAuthorizationStatusAuthorized) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Streaming (推流控制)

//MARK: 开始推流
- (void)startStreaming {
    if (![self isAudioAuthorized] || ![self isVideoAuthorized]) {
        NSLog(@"Streaming Error: AVDEVICE IS UNAUTHORIZED");
        return;
    }
    
    NSLog(@"开始推流: %@",_configuraitons.streamURL);
    _infoView.text = [NSString stringWithFormat:@"Start Stream Connecting ... "];
    [_engine startStreaming];
}

//MARK: 停止推流
- (void)stopStreaming {
    NSLog(@"stop begin --->");
    [_engine stopBgMusic];
    [_engine stopStreaming];
    NSLog(@"stop end --->");
}

//MARK: 切换设像头
- (void)switchCamera {
    if(self.engine.camera) {
        [self.engine.camera switchCamera];
    }
}

// 静音
- (void)muteAudio {
    NSLog(@"---%s", __FUNCTION__);
    if(!_audioMute) {
        [self.muteButton setTitle:@"unmute..." forState:UIControlStateNormal];
    }else {
        [self.muteButton setTitle:@"mute..." forState:UIControlStateNormal];
    }
    _audioMute = !_audioMute;
    [_engine setAudioMute:_audioMute];
}

// pause video capture
- (void)frozeVideo {
    NSLog(@"---%s", __FUNCTION__);
}

- (void)switchTorch {
    NSLog(@"---%s", __FUNCTION__);
}

#pragma mark - User Interaction

- (void)onEffectButtonClicked:(UIButton *)button {
    self.controlsBox.viewModel.type = TTEffectsViewModelTypeEffect;
    [self.controlsBox present];
}

- (void)onStickerButtonClicked:(UIButton *)button {
    self.controlsBox.viewModel.type = TTEffectsViewModelTypeSticker;
    [self.controlsBox present];
}

- (void)onMirrorButtonClicked:(UIButton *)button {
    button.selected = !button.selected;
    [self.capture setStreamMirror:button.selected];
}

- (void)onHeadphoneBackButtonClicked:(UIButton *)button {
    if (self.engine.isHeadphonesMonitoringEnabled) {
        [button setTitle:@"耳返开" forState:UIControlStateNormal];
        [self.engine setHeadphonesMonitoringEnabled:NO];
    } else {
        [button setTitle:@"耳返关" forState:UIControlStateNormal];
        [self.engine setHeadphonesMonitoringEnabled:YES];
    }
}

//MARK: 添加图片媒体混流
- (BOOL)isMixPicRunning {
    return _pushMixPicTimer != nil;
}

- (void)mixPicButtonClicked:(UIButton *)button
{
    if ([button.titleLabel.text isEqual:kSessionMixPic]) {
        [self startPushMixPicBuffer];
        // 添加视频流，LayerID: kTestSessionPicID
        [self.engine.liveCapture addVideoInput:CGRectMake(0, 0, 0.5, 0.40625) fillMode:LSRenderModeScaleAspectFill zOrder:100 forLayer:kTestSessionPicID rotation:LSRotateModeNoRotation];
        // 设置本地可预览
        [self.engine setPreviewMode:LCPreviewMode_GameInteract];
        [button setTitle:kSessionRemovePic forState:UIControlStateNormal];
    } else if ([button.titleLabel.text isEqual:kSessionRemovePic]) {
        // 移除视频流
        [self.engine.liveCapture removeVideoInput:kTestSessionPicID];
        if (!self.isMVRunning) {
            [self.engine setPreviewMode:LCPreviewMode_Normal];
        }
        [self stopPushMixPicBuffer];
        [button setTitle:kSessionMixPic forState:UIControlStateNormal];
    }
}

- (void) startPushMixPicBuffer
{
    if (!_pushMixPicTimer) {
        // 创建Timer
        _pushMixPicTimer = [[LiveStreamMultiTimerManager alloc] init];
    }
    // 本地图片
    NSString *img = [[NSBundle mainBundle] pathForResource:@"test1" ofType:@"png"];
    UIImage *mixImage = [UIImage imageNamed:img];
    [self.mixPicLock lock];
    // 将图片保存成PixelBuffer
    self.mixPicPixelBuffer = [LSIHelper imageBufferFromImage:mixImage];
    [self.mixPicLock unlock];
    
    @ls_weakify(self);
    // 15fps 的 Timer
    [_pushMixPicTimer schedualTimerWithIdentifier:@"push_mix_pic_indentifier"
                                      interval:1.0/15
                                              queue:nil
                                          repeats:YES
                                             action:^{
       @ls_strongify(self);
        if (!self) {
           return;
        }
        int64_t value = (int64_t)(CACurrentMediaTime() * 1000000000);
        int32_t timeScale = 1000000000;
        CMTime pts = CMTimeMake(value, timeScale);
        [self.mixPicLock lock];
        if (self.mixPicPixelBuffer != NULL) {
            // 将图片推入采集模块 - ID: kTestSessionPicID
            [self.engine.liveCapture pushVideoBuffer:self.mixPicPixelBuffer withCMTime:pts toLayer:kTestSessionPicID];
        }
        [self.mixPicLock unlock];
    }];
}

- (void) stopPushMixPicBuffer
{
    // 释放Timer
    if (_pushMixPicTimer) {
        [_pushMixPicTimer cancelTimerWithName:@"push_mix_pic_indentifier"];
        _pushMixPicTimer = nil;
    }
    
    [self.mixPicLock lock];
    // 释放PixelBuffer
    if (self.mixPicPixelBuffer != NULL) {
        CVPixelBufferRelease(self.mixPicPixelBuffer);
        self.mixPicPixelBuffer = NULL;
    }
    [self.mixPicLock unlock];
}

//MARK: MTV
- (void)mvButtonClicked:(UIButton *)button {
    [self mvButtonClicked:button];
}

//MARK: 录制
- (void)onRecordButtonClicked:(UIButton *)button {
    if (self.dumpRecording) {
        [LiveHelper arertMessage:@"视频录置中，请稍后"];
        return;
    }
    if (!(self.capture && [_engine isStreaming])) {
        [LiveHelper arertMessage:@"需要先开启推流"];
        return;
    }
    [button setTitle:kRecordingText forState:UIControlStateNormal];
    self.dumpRecording = YES;
    if (!self.recorder) {
        self.recorder = [[LiveStreamRawDataHelper alloc] init];
    }
    __weak typeof(self) weakself = self;
    [self.recorder startRawRecordingWithFileName:@"originMp4" maxProcessVideoBufCount:10 * 15 CompletionHandler:^(NSError * _Nonnull error, LSRawDataSourceType type, NSURL * _Nonnull url) {
        __strong typeof(weakself) sself = weakself;
        sself.dumpRecording = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [sself didRecordingFinished:url error:error];
            [button setTitle:kRecordText forState:UIControlStateNormal];
        });
    }];
}

- (void)didRecordingFinished:(NSURL *)path error:(nonnull NSError *)error {
    NSLog(@"[Recorder] did finished recording:%@", path);
    [LiveHelper arertMessage:[NSString stringWithFormat:@"录制结束!返回进沙盒目录导出%@",error]];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:path];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if(success) {
            NSLog(@"saved down");
        } else {
            NSLog(@"something wrong");
        }
    }];
}
//MARK: 推流控制
- (void)onStartButtonClicked:(UIButton *)sender {
    _startButton.hidden = YES;
    if(_engine) {
        [self startStreaming];
    }
}

- (void)onStopButtonClicked:(UIButton *)sender {
    if (_startButton.hidden) {
        _stopButton.hidden = YES;
        
        [_timer invalidate];
        _timer = nil;
        [self stopStreaming];
        //_startButton.hidden = NO;
    }
}

- (void)onToggleButtonClicked:(UIButton *)sender {
//    [self switchCamera];
    
    //bugfix: 推流过程中，切换前后摄像头，在切换后推流端屏幕会出现一帧蓝色
    //KK：短时间快速切换都会添加到Editor的操作队列，并且切换摄像头有一个渐变动画，会执行多次。修改目的，避免短时间内执行多次
    UIButton *button = (UIButton *)sender;
    if (self.cameraButton == button) {
        if (self.cameraButton.enabled) {
            self.cameraButton.enabled = NO;
            [self switchCamera];
            
            __weak typeof(self)weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (strongSelf) {
                    strongSelf.cameraButton.enabled = YES;
                }
            });
        }
    }
}

- (void)onMuteButtonClicked:(UIButton *)sender {
    [self muteAudio];
}

- (void)onQuitButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onEchoCancellationButtonClicked:(UIButton *)sender {
    if (self.engine) {
        self.engine.echoCancellationEnabled = !self.engine.isEchoCancellationEnabled;
        NSLog(@"echo cancellation turn %@", self.engine.isEchoCancellationEnabled ? @"on" : @"off");
        [sender setTitle:[NSString stringWithFormat:@"回声消除: %@", self.engine.isEchoCancellationEnabled ? @"开" : @"关"] forState:UIControlStateNormal];
    }
}

- (void)onSendSEIMsgButtonClicked:(UIButton *)sender{
    if (self.engine) {
        //测试数据
        NSTimeInterval a=[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000;
        NSString *timeString = [NSString stringWithFormat:@"当前时间%f", a];
//        NSDictionary * appDict = @{@"ver":[[self.liveSession class] getSdkVersion],@"time":timeString,@"statistic":[self.liveSession getStatistics]};
//        [self.liveSession sendSEIMsgWithKey:@"info" value:appDict repeatTimes:2];
//        [self.liveSession sendSEIMsgWithKey:@"testInt" value:[NSNumber numberWithInteger:111222333] repeatTimes:2];
//        [self.liveSession sendSEIMsgWithKey:@"testBool" value:[NSNumber numberWithBool:YES] repeatTimes:2];
//        [self.liveSession sendSEIMsgWithKey:@"testBoolNO" value:[NSNumber numberWithBool:NO] repeatTimes:2];
        [self.engine sendSEIMsgWithKey:@"testDouble" value:[NSNumber numberWithDouble:111222.333] repeatTimes:2];
    }
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showTips:(NSString *)msg{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
    NSString *tipsMsg = [NSString stringWithFormat:@"%@：%@",[dateFormatter stringFromDate:[NSDate date]],msg];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipsLabel.text = tipsMsg;
    });
}

- (LiveProfileLevelType)getProfileInfo:(NSInteger)index {
    LiveProfileLevelType type;
    switch (index) {
        case 0:
            if (LiveStreamVideoCodec_VT_264 == (LiveStreamVideoCodec)_configuraitons.videoCodecType)
                type = LiveEnCodecBaseAutoLevel;
            else
                type = 901;
            break;            
        case 1:
            if (LiveStreamVideoCodec_VT_264 == (LiveStreamVideoCodec)_configuraitons.videoCodecType)
                type = LiveEnCodecMainAutoLevel;
            else
                type = 901;
            break;
        case 2:
            type = LiveEnCodecHighAutoLevel;
            break;
        default:
            type = LiveEnCodecMainAutoLevel;
            break;
    }
    return type;
}

- (LiveStreamAudioCodec)getCodecType:(NSInteger)index {
    LiveStreamAudioCodec aCodec = LiveStreamAudioCodec_FAAC_LC;
    switch (index) {
        case 0:
            aCodec = 0;//LiveStreamAudioCodec_AT_AAC_LC
            break;
        case 1:
            aCodec = LiveStreamAudioCodec_FAAC_LC;
            break;
        case 2:
            aCodec = LiveStreamAudioCodec_FAAC_HE;
            break;
        case 3:
            aCodec = LiveStreamAudioCodec_FAAC_HE_V2;
            break;
    }
    return aCodec;
}

- (UILabel *)infoView {
    if (!_infoView) {
        _infoView = [[UILabel alloc] initWithFrame:self.view.bounds];
        _infoView.textAlignment = NSTextAlignmentLeft;
        _infoView.backgroundColor = [UIColor clearColor];
        _infoView.numberOfLines = 0;
        _infoView.textColor = [UIColor redColor];
        _infoView.font = [UIFont systemFontOfSize:14];
    }
    return _infoView;
}

// MARK: - 状态处理与分析
- (void)streamSession:(LiveStreamSession *)session onStatusChanged:(LiveStreamSessionState)state {
    NSLog(@"liveSessionState:%ld\n", (long)state);
//    LiveStreamStateStarting,
//    LiveStreamStateStarted,
//    LiveStreamStateEnded,
//    LiveStreamStateError,
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (state) {
            case LiveStreamSessionStateStarting:
                
                break;
            case LiveStreamSessionStateStarted:
                if (!self.timer || ![self.timer isValid]) {
                    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerStatistics) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
                }
                
                weakSelf.stopButton.hidden = NO;
                break;
            case LiveStreamSessionStateEnded:
                weakSelf.startButton.hidden = NO;
                break;
            case LiveStreamSessionStateError:
                weakSelf.startButton.hidden = NO;
                weakSelf.stopButton.hidden = YES;
                break;
            case LiveStreamSessionStateReconnecting:
                NSLog(@"// reconnect // %@", [NSDate date]);
                
                break;
            default:
                break;
        }
    
        if (state == LiveStreamSessionStateEnded || state == LiveStreamSessionStateError) {
            [weakSelf.timer invalidate];
            weakSelf.infoView.text = [NSString stringWithFormat:@"Connection_ended %ld", (long)state];
        }
    });

}

- (void)streamSession:(LiveStreamSession *)session onError:(LiveStreamErrorCode)error {
    NSLog(@"streamSession: onErrorOccure %ld", (long)error);
    
    [_timer invalidate];
    _infoView.text = [NSString stringWithFormat:@"stream error %ld", (long)error];
    
    _startButton.hidden = NO;
    _stopButton.hidden = YES;
    
}

@end
