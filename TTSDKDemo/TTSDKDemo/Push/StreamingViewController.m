//
//  StreamingViewController.m
//  LiveStreamSdkDemo
//
//  Created by 王可成 on 2018/7/11.

#import "StreamingViewController.h"
#import "LSCamera.h"
#import "LiveHelper.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "BEEffectManager.h"
#import "BEFrameProcessor.h"

#import "TTControlsBox.h"
#import "TTEffectsViewModel.h"

#define HAVE_EFFECT 0
#define HAVE_AUDIO_EFFECT 0


@interface StreamingViewController () <LiveStreamSessionProtocol>

@property (nonatomic) UIView *controlView;
@property (nonatomic) UIButton *startButton;
@property (nonatomic) UIButton *stopButton;
@property (nonatomic) UIButton *cameraButton;
@property (nonatomic) UIButton *muteButton;
@property (nonatomic) UIButton *echoCancellationButton;

@property (nonatomic) UIView *canvasView;

@property (nonatomic, strong) LSCamera *camera;

@property (nonatomic, strong) UIButton *headphonesMonitoringButton;


@property (nonatomic, strong) UIButton *beautifyButton;
@property (nonatomic, strong) UIButton *beautifyButton2;
@property (nonatomic, strong) UIButton *mattingSwitchButton;
@property (nonatomic, strong) UIButton *mirrorOutputButton;
@property (nonatomic, strong) UIButton *captureImageButton;
@property (nonatomic, strong) UISlider *shrinkSlider;
@property (nonatomic, strong) UILabel *shrinkLable;
@property (nonatomic, strong) UISlider *filterSlider;
@property (nonatomic, strong) UILabel *filterLable;
@property (nonatomic, strong) UISlider *whitenSlider;
@property (nonatomic, strong) UILabel *whitenLable;
@property (nonatomic, strong) UILabel *beautifyLable;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) NSMutableArray *observerArray;

@property (nonatomic, assign) BOOL senceTime;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) LiveStreamConfiguration *liveConfig;


@property (nonatomic, assign) BOOL effectSDK;
@property (nonatomic, assign) CGFloat recordRate;

@property (nonatomic, assign) BOOL audioMute;

@property (nonatomic, assign) BOOL isPhotoMovie;//测试照片电影

@property (nonatomic, strong) UIButton *changCameraConfButton;
@property (nonatomic, strong) UIView *cameraPreviewContainerView;

@property (nonatomic) UILabel *infoView;

@property (nonatomic) LiveStreamSession *liveSession;
@property (nonatomic) LiveStreamCapture *capture;
@property (nonatomic) StreamConfigurationModel *configuraitons;
@property (nonatomic, assign) CGSize captureSize;

@property (nonatomic, copy) NSString *did_str;
@property (nonatomic, strong) UIView *karaokeControllersContainer;
@property (nonatomic, strong) UISlider *recordVolumeSlider;
@property (nonatomic, strong) UISlider *musicVolumeSlider;

@property (nonatomic, assign) BOOL is_gamimg;
@property (nonatomic, assign) BOOL is_game_playing;

@property (nonatomic, strong) UITapGestureRecognizer *effectsTapGesture;
@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) BEFrameProcessor *processor;
@property (nonatomic, strong) BEEffectManager *effectManager;

@property (nonatomic, strong) TTControlsBox *controlsBox;

@end

@implementation StreamingViewController

- (instancetype)initWithConfiguration:(StreamConfigurationModel *)configuraitons {
    if (self = [super init]) {
        self.configuraitons = configuraitons;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"\n--------------stream view controller dealloc---------------");
    if (self.liveSession) {
        [self stopStreaming];
    }
    
#if HAVE_EFFECT
    [_capture applyComposerNodes:@[]];
    [_capture applyEffect:@"" type:LSLiveEffectGroup];
    [_capture applyEffect:@"" type:LSLiveEffectFilter];
#endif
    [_capture stopVideoCapture];
    [LiveStreamCapture resetContext];
    _capture = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        NSLog(@"\n----------------setIdleTimerDisabled-");
    });
    
    _liveSession = nil;
    _camera = nil;
    
    NSLog(@"\n--------------stream view controller dealloced---------------");
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
//    _did_str = [TTInstallIDManager sharedInstance].deviceID;
    [self requestAuthorization];
    [self setupUIComponent];
    _is_gamimg = NO;
    _is_game_playing = NO;
    _audioMute = NO;
    _captureSize = _configuraitons.captureResolution;

    // 1. camera
    _camera = [[LSCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    _camera.outputPixelFmt = kCVPixelFormatType_32BGRA;
    _camera.frameRate = _configuraitons.fps;
    
    // 2. effect & preview
    LiveStreamCaptureConfig * captureConfig = [LiveStreamCaptureConfig defaultConfig];
    captureConfig.useNewEffectLabAPI = YES;
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
//    [_capture setEnableEffect:YES];
    [_capture resetPreviewView:self.cameraPreviewContainerView];
    [_capture startVideoCapture];
    
    // 3. liveStreamConfiguration
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
    _liveConfig.rtmpURL = _configuraitons.streamURL;
    _liveConfig.audioSampleRate = 44100;
    _liveConfig.streamLogTimeInterval = 5;
    _liveConfig.gopSec = 4;                         // gop 4s
    _liveConfig.project_key = @"ttlive";            // 用于区分app 上报日志
    // 后台推流
    _liveConfig.enableBackgroundMode = _configuraitons.enableBackgroundMode;
    // 后台推流背景图，默认后台推流推最后一帧
//    NSString *img = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpeg"];
//    _liveConfig.backgroundImage = [UIImage imageWithContentsOfFile:img];
    _liveConfig.audioChannelCount = 2;
    _liveConfig.aCodec = [self getCodecType:_configuraitons.audioCodecType];
    _liveConfig.enableBlueToothEarMonitoring = YES;
    
    // 4. LiveStreamSession
    _liveSession = [[LiveStreamSession alloc] initWithConfig:_liveConfig];
    [_liveSession setLogLevel:LiveStreamLogLevelWarning];
    _liveSession.delegate = self;
    // 自动重连
    _liveSession.reconnectTimeInterval = 1;
    _liveSession.shouldAutoReconnect = YES;
    _liveSession.reconnectCount = 10;
    // 日志上报
    _liveSession.streamLogTimeInterval = 5;
    
    _liveSession.didCapturedAudioBufferList = nil;
    
    _capture.session = _liveSession;
#if ENABLE_LIVE_NODE_PROBER
    _liveSession.shouldUpdateOptimumIPAddress = ^(NSString *host) {
        return [[LiveNodeSortManager sharedManager] bestIPForHost:host];
    };
#endif
    
    _liveSession.streamLogCallback = ^(NSDictionary *log) {
        __strong typeof(wself) sself = wself;
        if (!sself) {
            return;
        }
        NSMutableDictionary *log_dict = [NSMutableDictionary dictionaryWithDictionary:log];
        [log_dict addEntriesFromDictionary:[sself->_capture getStatisticInfo]];
        NSLog(@"<<<<< log <<<<< %@", log_dict);
    };
    
    // 5. video graph: camera -> caputre -> session
    [self.camera setVideoProcessingCallback:^(CMSampleBufferRef sampleBuffer) {
        CVPixelBufferRef buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        
        double timeStamp = (double)(pts.value / pts.timescale);
        BEProcessResult *result = [wself.processor process:buffer timeStamp:timeStamp];

        [wself.capture pushVideoBuffer:result.pixelBuffer ?: buffer andCMTime:pts];
//        [wself.capture pushVideoBuffer:buffer andCMTime:pts];
    }];
    
    [self.capture setVideoProcessedCallback:^(CVPixelBufferRef buffer, int32_t textureId, CMTime pts) {
        [wself.liveSession pushVideoBuffer:buffer texture:textureId andCMTime:pts];
    }];
    
    [_camera startCameraCapture];
    
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
    _processor = [[BEFrameProcessor alloc] initWithContext:[_liveSession getEAGLContext] resourceDelegate:nil];
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
    
    _headphonesMonitoringButton = [LiveHelper createButton:@"耳返: 开" target:self action:@selector(onHeadphonesMonitoringButtonClicked:)];
    [_controlView addSubview:_headphonesMonitoringButton];
    
    [_controlView addSubview:[LiveHelper createButton:@"测试SEI" target:self action:@selector(onSendSEIMsgButtonClicked:)]];
    [_controlView addSubview:[LiveHelper createButton:@"回声消除: 开" target:self action:@selector(onEchoCancellationButtonClicked:)]];
    
    [_controlView addSubview:[LiveHelper createButton:@"特效" target:self action:@selector(onEffectButtonClicked:)]];
    [_controlView addSubview:[LiveHelper createButton:@"贴纸" target:self action:@selector(onStickerButtonClicked:)]];
    [_controlView addSubview:[LiveHelper createButton:@"镜像" target:self action:@selector(onMirrorButtonClicked:)]];
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
    
    CGSize karaokeControllersContainerSize = CGSizeMake(self.view.bounds.size.width, 160);
    UIView *karaokeControllersContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - karaokeControllersContainerSize.height, karaokeControllersContainerSize.width, karaokeControllersContainerSize.height)];
    karaokeControllersContainer.backgroundColor = UIColor.whiteColor;
    karaokeControllersContainer.alpha = .7;
    [self.view addSubview:karaokeControllersContainer];
    self.karaokeControllersContainer = karaokeControllersContainer;
    
    UILabel *recordVolumeLabel = [[UILabel alloc] init];
    recordVolumeLabel.text = @"人声";
    recordVolumeLabel.textAlignment = NSTextAlignmentCenter;
    [karaokeControllersContainer addSubview:recordVolumeLabel];
    UISlider *recordVolumeSlider = [[UISlider alloc] init];
    recordVolumeSlider.value = .5;
    [recordVolumeSlider addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [karaokeControllersContainer addSubview:recordVolumeSlider];
    self.recordVolumeSlider = recordVolumeSlider;
    UILabel *musicVolumeLabel = [[UILabel alloc] init];
    musicVolumeLabel.text = @"伴奏";
    musicVolumeLabel.textAlignment = NSTextAlignmentCenter;
    [karaokeControllersContainer addSubview:musicVolumeLabel];
    UISlider *musicVolumeSlider = [[UISlider alloc] init];
    musicVolumeSlider.value = .5;
    musicVolumeSlider.tag = 1;
    [musicVolumeSlider addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [karaokeControllersContainer addSubview:musicVolumeSlider];
    self.musicVolumeSlider = musicVolumeSlider;
    NSInteger rows = karaokeControllersContainer.subviews.count;
    CGFloat rowHeight = karaokeControllersContainerSize.height / rows;
    CGFloat rowWidth = self.view.bounds.size.width;
    for (NSInteger row = 0; row < rows; row++) {
        CGFloat width = rowWidth * 0.9;
        CGFloat originX = (rowWidth - width) / 2;
        CGRect frame = CGRectMake(originX, rowHeight * row, rowWidth * 0.9, rowHeight);
        UIView *view = karaokeControllersContainer.subviews[row];
        view.frame = frame;
    }
    karaokeControllersContainer.hidden = YES;
    
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
    NSDictionary *dic = [_liveSession getStatistics];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Streaming
- (void)startStreaming {
    if (![self isAudioAuthorized] || ![self isVideoAuthorized]) {
        NSLog(@"Streaming Error: AVDEVICE IS UNAUTHORIZED");
        return;
    }
    
    NSLog(@"开始推流: %@",_configuraitons.streamURL);
    _infoView.text = [NSString stringWithFormat:@"Start Stream Connecting ... "];

    [_liveSession start];
}

- (void)stopStreaming {
    NSLog(@"stop begin --->");
    [_liveSession stop];
    NSLog(@"stop end --->");
}

- (void)switchCamera {
    if(self.camera) {
        [self.camera rotateCamera];
    }
}

// pause audio capture
- (void)muteAudio {
    NSLog(@"---%s", __FUNCTION__);
    if(!_audioMute) {
        [self.muteButton setTitle:@"unmute..." forState:UIControlStateNormal];
    }else {
        [self.muteButton setTitle:@"mute..." forState:UIControlStateNormal];
    }
    _audioMute = !_audioMute;
    [_liveSession setAudioMute:_audioMute];
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

- (void)onHeadphonesMonitoringButtonClicked:(UIButton *)sender {
    [_liveSession setHeadphonesMonitoringEnabled:!_liveSession.isHeadphonesMonitoringEnabled];
    NSString *buttonText = [NSString stringWithFormat:@"耳返: %@", _liveSession.isHeadphonesMonitoringEnabled ? @"关" : @"开"];
    [sender setTitle:buttonText forState:UIControlStateNormal];
}

- (void)onStartButtonClicked:(UIButton *)sender {
    _startButton.hidden = YES;
    if(_liveSession) {
        [self startStreaming];
    }
   // _stopButton.hidden = NO;
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
    
    if(self.capture){
        [self.capture resetRecording];
    }
    
    [_timer invalidate];
    _timer = nil;
    
    [self removeObservers];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onEchoCancellationButtonClicked:(UIButton *)sender {
    if (self.liveSession) {
        self.liveSession.echoCancellationEnabled = !self.liveSession.isEchoCancellationEnabled;
        NSLog(@"echo cancellation turn %@", self.liveSession.isEchoCancellationEnabled ? @"on" : @"off");
        [sender setTitle:[NSString stringWithFormat:@"回声消除: %@", self.liveSession.isEchoCancellationEnabled ? @"关" : @"开"] forState:UIControlStateNormal];
    }
}

- (void)onSendSEIMsgButtonClicked:(UIButton *)sender{
    if (self.liveSession) {
        //测试数据
        NSTimeInterval a=[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000;
        NSString *timeString = [NSString stringWithFormat:@"当前时间%f", a];
        NSDictionary * appDict = @{@"ver":[[self.liveSession class] getSdkVersion],@"time":timeString,@"statistic":[self.liveSession getStatistics]};
//        [self.liveSession sendSEIMsgWithKey:@"info" value:appDict repeatTimes:2];
//        [self.liveSession sendSEIMsgWithKey:@"testInt" value:[NSNumber numberWithInteger:111222333] repeatTimes:2];
//        [self.liveSession sendSEIMsgWithKey:@"testBool" value:[NSNumber numberWithBool:YES] repeatTimes:2];
//        [self.liveSession sendSEIMsgWithKey:@"testBoolNO" value:[NSNumber numberWithBool:NO] repeatTimes:2];
        [self.liveSession sendSEIMsgWithKey:@"testDouble" value:[NSNumber numberWithDouble:111222.333] repeatTimes:2];
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
            break;
        case 1:
            if (LiveStreamVideoCodec_VT_264 == (LiveStreamVideoCodec)_configuraitons.videoCodecType)
                type = LiveEnCodecMainAutoLevel;
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
            aCodec = LiveStreamAudioCodec_AT_AAC_LC;
            break;
        case 1:
            aCodec = LiveStreamAudioCodec_AT_AAC_HE;
            break;
        case 2:
            aCodec = LiveStreamAudioCodec_FAAC_LC;
            break;
        case 3:
            aCodec = LiveStreamAudioCodec_FAAC_HE;
            break;
        case 4:
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

// MARK: - LiveStreamSessionProtocol
- (void)streamSession:(LiveStreamSession *)session onStatusChanged:(LiveStreamSessionState)state {
    NSLog(@"liveSessionState:%ld\n", (long)state);
//    LiveStreamStateStarting,
//    LiveStreamStateStarted,
//    LiveStreamStateEnded,
//    LiveStreamStateError,
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (state) {
            case LiveStreamSessionStateStarting:
                
                break;
            case LiveStreamSessionStateStarted:
                if (!self.timer || ![self.timer isValid]) {
                    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerStatistics) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
                }
                
                _stopButton.hidden = NO;
                break;
            case LiveStreamSessionStateEnded:
                _startButton.hidden = NO;
                break;
            case LiveStreamSessionStateError:
                _startButton.hidden = NO;
                _stopButton.hidden = YES;
                break;
            case LiveStreamSessionStateReconnecting:
                NSLog(@"// reconnect // %@", [NSDate date]);
                break;
            default:
                break;
        }
    
        if (state == LiveStreamSessionStateEnded || state == LiveStreamSessionStateError) {
            [_timer invalidate];
            _infoView.text = [NSString stringWithFormat:@"Connection_ended %ld", (long)state];
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
