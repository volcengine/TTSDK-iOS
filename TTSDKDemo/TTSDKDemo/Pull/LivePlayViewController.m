//
//  LivePlayViewController.m
//  TTVideoLive-iOS
//
//  Created by 陈昭杰 on 2018/8/28.
//  Copyright © 2018年 头条视频云. All rights reserved.
//

#import "LivePlayViewController.h"
#import "PlayConfiguration.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>
#import <MediaPlayer/MPVolumeView.h>
#import <UIView+Toast.h>
#import "PreferencesViewController.h"
#import "LogViewController.h"

//连麦
#import "StreamingInteractManager.h"

typedef NS_ENUM(NSUInteger, TVLLiveStatus) {
    TVLLiveStatusUnknow,
    TVLLiveStatusEnd,
    TVLLiveStatusWaiting,
    TVLLiveStatusOngoing,
    TVLLiveStatusFail,
    TVLLiveStatusPulling
};

// TODO: 解耦V与VM

@interface LivePlayViewController () <TVLDelegate, TVLSettingsManagerDataSource>

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIView *stateInfoView;

@property (nonatomic, strong) UILabel *stateInfoLabel;

@property (nonatomic, strong) UITextView *infoTextView;

@property (nonatomic, strong) UIView *buttonsContainer;

@property (nonatomic, strong) UIButton *playbackButton;

@property (nonatomic, strong) UIButton *infoSwitchButton;

@property (nonatomic, strong) UIButton *volumeButton;

@property (nonatomic, strong) UIButton *muteButton;

@property (nonatomic, strong) UIButton *brightnessButton;

@property (nonatomic, strong) UIButton *rotationButton;

@property (nonatomic, strong) UIButton *interactButton;

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, strong) PlayConfiguration *playConfiguration;

@property (nonatomic, strong) TVLManager *liveManager;

@property (nonatomic, assign) NSInteger stallCount;

@property (nonatomic, assign) NSTimeInterval totalStallTime;

@property (nonatomic, strong) NSDate *stallStartDate;

@property (nonatomic, strong) TVLPlayerItem *playerItem;

@property (nonatomic, assign, getter=isMuted) BOOL muted;

//MARK: 连麦
@property (nonatomic, strong) StreamingInteractManager *interactManager;
@property (nonatomic, assign) BOOL isInteracting;

@end

@implementation LivePlayViewController {
    TVLLiveStatus _liveStatus;
    UISlider *_volumeSlider;        // 目前iOS调节音量需要通过MPVolumeView中的volumeSlider完成，为避免频繁查找volumeSlider，故在此处持有
    NSTimeInterval _firstFrameTime;
    NSDate *_previousMonitorEventDate;
    NSDate *_startDate;
    NSString *_playURL;
    NSInteger _videoRate;
    NSInteger _downloadSize;
    CGFloat _bandwidthInMbps;       // 由于回调过慢，计算结果相当于两个时间点间的平均带宽
    LogViewController *_logViewController;
    int64_t _stallTimeFromPlayingEvent;
    int64_t _stallTimeFromPlayStopEvent;
    int64_t _stallCountFromPlayingEvent;
    int64_t _stallCountFromPlayStopEvent;
    int64_t _stallDurationInStallEvent;
    int64_t _stallCountInStallEvent;
}

- (instancetype)initWithConfiguration:(PlayConfiguration *)configuration {
    if (self = [super init]) {
        _playConfiguration = configuration;
        _startDate = nil;
        _liveStatus = TVLLiveStatusUnknow;
        _previousMonitorEventDate = nil;
        _stallCount = 0;
        _totalStallTime = 0;
        _stallStartDate = nil;
        _firstFrameTime = 0;
        _downloadSize = 0;
        _bandwidthInMbps = 0;
        _playURL = configuration.playURL;
        _muted = NO;
    }
    return self;
}

- (void)removeObservations {
    //MARK: 释放之前，移除对 LiveManager的KVO
    [self.liveManager.currentItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(presentationSize))];
    [self.liveManager removeObserver:self forKeyPath:NSStringFromSelector(@selector(error))];
    [self.liveManager removeObserver:self forKeyPath:NSStringFromSelector(@selector(playbackState))];
    [self.liveManager removeObserver:self forKeyPath:NSStringFromSelector(@selector(playerLoadState))];
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [AVAudioSession.sharedInstance setCategory:AVAudioSessionCategoryPlayback error:nil];
    [AVAudioSession.sharedInstance setActive:YES error:nil];
    
    LogViewController *logViewController = [[LogViewController alloc] init];
    logViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext | UIModalPresentationFullScreen;
    _logViewController = logViewController;
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self setupLivePlay];
    [self setupSubviews];
    
    [self.view addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)]];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLogView)]];
    
    self.definesPresentationContext = YES;
    // Keep Screen Open
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    __weak typeof(self) wself = self;
    [NSNotificationCenter.defaultCenter addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [wself.liveManager pause];
    }];
    [NSNotificationCenter.defaultCenter addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [wself.liveManager play];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.playConfiguration.shouldAutoPlay) {
        [self playbackButtonDidTouch];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self destoryLiveManager];
    [self archiveLogs];
    [self.interactManager dismiss];
    self.interactManager = nil;
    [UIApplication.sharedApplication.keyWindow hideAllToasts];
}

- (void)archiveLogs {
    if (!self.playConfiguration.shouldArchiveLogs) {
        return;
    }
    NSString *currentLog = [_logViewController currentLog];
    if (currentLog) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *logsDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"Logs"];
            BOOL isDir = NO;
            BOOL exists = [NSFileManager.defaultManager fileExistsAtPath:logsDir isDirectory:&isDir];
            NSError *error = nil;
            if (!isDir || !exists) {
                [NSFileManager.defaultManager createDirectoryAtPath:logsDir withIntermediateDirectories:YES attributes:nil error:&error];
            }
            void(^toastWithMessage)(NSString *) = ^(NSString *message) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIApplication.sharedApplication.keyWindow makeToast:message duration:1 position:@(self.view.center)];
                });
            };
            if (error) {
                toastWithMessage(@"日志目录创建失败");
                return;
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.timeZone = NSTimeZone.localTimeZone;
            [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *logFileName = [NSString stringWithFormat:@"%@ %@", [dateFormatter stringFromDate:NSDate.date], [dateFormatter.timeZone.name stringByReplacingOccurrencesOfString:@"/" withString:@" "]];
            NSString *logFile = [logsDir stringByAppendingPathComponent:logFileName];
            [currentLog writeToFile:logFile atomically:YES encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                toastWithMessage(@"日志写入失败");
            }
        });
    }
}

// MARK: Setters & Getters

- (void)setMuted:(BOOL)muted {
    _muted = muted;
    [self.liveManager setMuted:_muted];
}

// MARK: Private Methods

- (void)showLogView {
    [self presentViewController:_logViewController animated:YES completion:^{
    }];
}

- (void)showPreferencesSettingView {
    if (!self.liveManager.currentItem.preferences) {
        return;
    }
    PreferencesViewController *preferencesViewController = [[PreferencesViewController alloc] init];
    preferencesViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext | UIModalPresentationFullScreen;
    [self presentViewController:preferencesViewController animated:YES completion:^{
        [preferencesViewController updateWithPlayerItemPreferences:self.liveManager.currentItem.preferences];
    }];
}

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//MARK:
- (void)setupLivePlay {
    TVLSettingsManager.defaultManager.dataSource = self;
    [TVLSettingsManager.defaultManager updateCurrentSettings];
    TVLManager *liveManager = [[TVLManager alloc] initWithOwnPlayer:YES];
    [liveManager setDelegate:self];                                                 // TVLProtocol代理设置
    [liveManager setProjectKey:self.playConfiguration.projectKey];                  // 标识产品
    [liveManager setRetryTimeInternal:self.playConfiguration.retryTimeInternal];    // 重试间隔
    [liveManager setRetryCountLimit:self.playConfiguration.retryCountLimit];        // 重试最大次数
    [liveManager setRetryTimeLimit:self.playConfiguration.retryTimeLimit];          // 单次重试最大时长
    [liveManager setPreviewFlag:self.playConfiguration.previewFlag];                // 设置是否预览
    [liveManager setPlayerViewScaleMode:self.playConfiguration.fillMode];           // contentMode设置，仅作用于自研播放器
    [liveManager setHardwareDecode:self.playConfiguration.isHardwareDecodeEnabled];
    liveManager.shouldIgnoreSettings = self.playConfiguration.shouldIgnoreSettings;
    liveManager.allowsAudioRendering = self.playConfiguration.allowsAudioRendering;
    liveManager.commonTag = self.playConfiguration.commonTag;
    liveManager.shouldUseLiveDNS = self.playConfiguration.shouldUseLiveDNS;
    liveManager.preferredToHTTPDNS = self.playConfiguration.isPreferredToHTTPDNS;
    liveManager.allowsResolutionDegrade = YES;
    [liveManager setMuted:self.isMuted];
    [liveManager setOptionValue:@(TVLOptionByteVC1CodecTypeJX) forIdentifier:@(TVLPlayerOptionByteVC1CodecType)];
    [liveManager setIpMappingTable:[self.playConfiguration.ipMapping copy]];
    [liveManager setShouldReportAudioFrame:YES];
    @weakify(self);
    TVLOptimumNodeInfoRequest optimumNodeInfoRequest = ^NSDictionary *(NSString *playURL) {
        @strongify(self);
        NSURL *URL = [NSURL URLWithString:playURL];
        NSString *IP = [self.playConfiguration.nodeOptimizeInfo objectForKey:URL.host];
        return IP ? @{@"ip": IP} : nil;
    };
    liveManager.optimumNodeInfoRequest = self.playConfiguration.isNodeOptimizingEnabled ? optimumNodeInfoRequest : nil;
    if (self.playConfiguration.playerItem) {
        [liveManager replaceCurrentItemWithPlayerItem:self.playConfiguration.playerItem];
    }
    
    [liveManager addObserver:self forKeyPath:NSStringFromSelector(@selector(error)) options:NSKeyValueObservingOptionNew context:nil];
    [liveManager addObserver:self forKeyPath:NSStringFromSelector(@selector(playbackState)) options:NSKeyValueObservingOptionNew context:nil];
    [liveManager addObserver:self forKeyPath:NSStringFromSelector(@selector(playerLoadState)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    self.liveManager = liveManager;
    
    NSLog(@"live_h264_hardware_decode_enable = %d, live_h265_hardware_decode_enable = %d", TVLSettingsManager.defaultManager.isH264HardwareDecodeEnabled, TVLSettingsManager.defaultManager.isByteVC1HardwareDecodeEnabled);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(error))] && object == self.liveManager) {
        if (self.liveManager.error) {
            NSLog(@"Live manager error: %@", self.liveManager.error);
        }
    } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(presentationSize))] && object == self.liveManager.currentItem) {
        NSLog(@"Video size did change: %@", change);
    } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(playbackState))] && object == self.liveManager) {
        NSLog(@"%@: Playback state is %ld", NSStringFromClass(self.class), (long)self.liveManager.playbackState);
        [self updateLiveInfo];
    } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(playerLoadState))] && object == self.liveManager) {
        [self handlePlayerLoadStateChange:change];
    }
}

- (void)handlePlayerLoadStateChange:(NSDictionary<NSKeyValueChangeKey,id> *)change {
    TVLPlayerLoadState newState = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
    TVLPlayerLoadState oldState = [[change objectForKey:NSKeyValueChangeOldKey] integerValue];
    if (newState == TVLPlayerLoadStatePlayable) {
        [UIApplication.sharedApplication.keyWindow hideAllToasts];
    } else if (oldState == TVLPlayerLoadStatePlayable) {
        [UIApplication.sharedApplication.keyWindow makeToast:@"Loading..." duration:3600 position:@(self.view.center)];
    }
    NSLog(@"%@: load state change %ld -> %ld", NSStringFromClass(self.class), oldState, newState);
}

// TODO: 按组件拆分
- (void)setupSubviews {
    // 背景点击事件处理，目前用于关闭滑动条
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTouch)]];
    
    [self.view addSubview:self.liveManager.playerView];
    [self.liveManager.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setTitle:@"🔙" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(backButton);
    }];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(32.f);
        make.left.mas_equalTo(self.view).mas_offset(16.f);
        make.width.mas_equalTo(40.f);
        make.height.mas_equalTo(24.f);
    }];
    self.backButton = backButton;
    
    UIView *stateInfoView = [[UIView alloc] init];
    [self.view addSubview:stateInfoView];
    [stateInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(backButton);
    }];
    self.stateInfoView = stateInfoView;
    
    UILabel *stateInfoLabel = [[UILabel alloc] init];
    stateInfoLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.f];
    stateInfoLabel.text = @"尚未开始";
    [stateInfoView addSubview:stateInfoLabel];
    [stateInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(stateInfoView);
    }];
    self.stateInfoLabel = stateInfoLabel;
    
    // 按钮容器，用整体管理所有按钮的布局
    UIView *buttonsContainer = [[UIView alloc] init];
    [self.view addSubview:buttonsContainer];
    [buttonsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(-15.f);
        make.centerX.mas_equalTo(self.view);
    }];
    self.buttonsContainer = buttonsContainer;
    
    UIButton *playbackButton = [[UIButton alloc] init];
    [playbackButton addTarget:self action:@selector(playbackButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
    [playbackButton setTitle:@"⏯" forState:UIControlStateNormal];
    self.playbackButton = playbackButton;
    
    UIButton *infoSwitchButton = [[UIButton alloc] init];
    [infoSwitchButton addTarget:self action:@selector(infoSwitchButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
    [infoSwitchButton setTitle:@"📃" forState:UIControlStateNormal];
    self.infoSwitchButton = infoSwitchButton;
    
    UIButton *volumeButton = [[UIButton alloc] init];
    [volumeButton addTarget:self action:@selector(volumeButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
    [volumeButton setImage:[UIImage imageNamed:@"volume"] forState:UIControlStateNormal];
    self.volumeButton = volumeButton;
    
    UIButton *muteButton = [[UIButton alloc] init];
    [muteButton addTarget:self action:@selector(muteButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
    [muteButton setTitle:@"🔈" forState:UIControlStateNormal];
    self.muteButton = muteButton;
    
    UIButton *brightnessButton = [[UIButton alloc] init];
    [brightnessButton addTarget:self action:@selector(brightnessButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
    [brightnessButton setTitle:@"🔆" forState:UIControlStateNormal];
    self.brightnessButton = brightnessButton;
    
    UIButton *rotationButton = [[UIButton alloc] init];
    [rotationButton addTarget:self action:@selector(rotationButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
    [rotationButton setTitle:@"🔄" forState:UIControlStateNormal];
    self.rotationButton = rotationButton;
    
    UIButton *interactButton = [[UIButton alloc] init];
    [interactButton addTarget:self action:@selector(interactButtonDidTounch:) forControlEvents:UIControlEventTouchUpInside];
    [interactButton setTitle:@"👬" forState:UIControlStateNormal];
    self.interactButton = interactButton;
    
    // 按照数组中的顺序布局按钮位置
    NSArray *buttons = @[playbackButton, infoSwitchButton, muteButton, brightnessButton, rotationButton, interactButton];
    CGFloat buttonDimension = 40.f;
    CGFloat buttonMargin = 24.f;
    for (NSInteger index = 0; index < buttons.count; index++) {
        UIButton *button = buttons[index];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = buttonDimension / 2.f;
        button.clipsToBounds = YES;
        [buttonsContainer addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(buttonDimension);
            make.top.bottom.mas_equalTo(buttonsContainer);
            make.left.mas_equalTo(buttonsContainer).mas_offset(index * (buttonMargin + buttonDimension));
            make.right.mas_lessThanOrEqualTo(buttonsContainer);
        }];
    }
    
    UITextView *infoTextView = [[UITextView alloc] init];
    infoTextView.editable = NO;
    infoTextView.selectable = NO;
    infoTextView.textColor = [UIColor redColor];
    infoTextView.hidden = YES;
    infoTextView.backgroundColor = [UIColor clearColor];
    infoTextView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.f];
    [self.view addSubview:infoTextView];
    [infoTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(68.f);
        make.left.mas_equalTo(self.view).mas_offset(15.f);
        make.right.mas_equalTo(self.view).mas_offset(-15.f);
        make.bottom.mas_equalTo(buttonsContainer.mas_top).mas_offset(-20.f);
    }];
    self.infoTextView = infoTextView;
    
    MPVolumeView *volumeView = [[MPVolumeView alloc]init];
    UISlider *volumeSlider = nil;
    volumeView.showsRouteButton = NO;
    volumeView.showsVolumeSlider = NO;
    [volumeView sizeToFit];
    [volumeView setFrame:CGRectMake(-1000, -1000, 10, 10)];
    [self.view addSubview:volumeView];
    [volumeView userActivity];
    // 由于MPVolumeSlider为系统私有类，通过该方法获取volumeSlider
    for (UIView *view in [volumeView subviews]){
        if ([[view.class description] isEqualToString:@"MPVolumeSlider"]){
            volumeSlider = (UISlider*)view;
            break;
        }
    }
    [volumeSlider setValue:0.2];
    _volumeSlider = volumeSlider;
}

- (void)updateLiveStateInfo {
    NSMutableString *stateLabelText = [NSMutableString string];
    if (_liveStatus == TVLLiveStatusOngoing) {
        [stateLabelText appendString:@"直播中"];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit type = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *components = [calendar components:type
                                                   fromDate:_startDate
                                                     toDate:[NSDate date]
                                                    options:0];
        [stateLabelText appendFormat:@" %02ld:%02ld:%02ld", components.hour, components.minute, components.second];
    } else if (_liveStatus == TVLLiveStatusEnd) {
        [stateLabelText appendString:@"直播结束"];
    } else {
        [stateLabelText appendString:@"尚未开始"];
    }
    self.stateInfoLabel.text = [stateLabelText copy];
}

- (NSString *)currentDateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    formatter.timeZone = [NSTimeZone localTimeZone];
    return [formatter stringFromDate:[NSDate date]];
}

- (NSTimeInterval)timeintervalFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:type
                                               fromDate:fromDate
                                                 toDate:toDate
                                                options:0];
    return components.second;
}

// MARK: Action Methods

- (void)backgroundViewDidTouch {
    if (self.slider) {
        [self.slider removeFromSuperview];
        self.slider = nil;
    }
}

- (void)volumeValueDidChange:(id)sender {
    _volumeSlider.value = [(UISlider *)sender value];
}

- (void)muteButtonDidTouch {
    self.muted = !self.isMuted;
    self.muteButton.alpha = self.isMuted ? .7f : 1.f;
}

- (void)volumeButtonDidTouch {
    if (self.slider) {
        [self.slider removeFromSuperview];
    }
    
    UISlider *slider = [[UISlider alloc] init];
    slider.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI_2);
    slider.minimumValue = 0.f;
    slider.maximumValue = 1.f;
    slider.value = _volumeSlider.value;
    [slider addTarget:self action:@selector(volumeValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.volumeButton);
        make.centerY.mas_equalTo(self.volumeButton).mas_offset(-100);
        make.width.mas_equalTo(150.f);
        make.height.mas_equalTo(20.f);
    }];
    self.slider = slider;
}

- (void)brightnessValueDidChange:(id)sender {
    [[UIScreen mainScreen] setBrightness:[(UISlider *)sender value]];
}

- (void)brightnessButtonDidTouch {
    if (self.slider) {
        [self.slider removeFromSuperview];
    }
    UISlider *slider = [[UISlider alloc] init];
    slider.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI_2);
    slider.minimumValue = 0.f;
    slider.maximumValue = 1.f;
    slider.value = [[UIScreen mainScreen] brightness];
    [slider addTarget:self action:@selector(brightnessValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.brightnessButton);
        make.centerY.mas_equalTo(self.brightnessButton).mas_offset(-100);
        make.width.mas_equalTo(150.f);
        make.height.mas_equalTo(20.f);
    }];
    self.slider = slider;
}

- (void)rotationButtonDidTouch {
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeLeft) forKey:@"orientation"];
    } else {
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    }
}

- (void)interactButtonDidTounch:(UIButton *)sender {
    if (!self.isInteracting) {
        __weak typeof(self) wself = self;
        UIAlertController *alert = [StreamingInteractManager joinRoomRequestIsHost:NO configurations:NULL completeBlock:^(StreamingInteractManager * _Nonnull obj) {
            __strong typeof(wself) sself = wself;
            [sself.liveManager stop];
            [sself.liveManager.playerView removeFromSuperview];
            sself.interactManager = obj;
            [sself.interactManager joinChannel];
            [sself.view insertSubview:sself.interactManager.previewContainer atIndex:0];
            sself.isInteracting = YES;
        }];
        [self presentViewController:alert animated:YES completion: nil];
    } else {
        self.isInteracting = NO;
        [self.interactManager.previewContainer removeFromSuperview];
        [self.interactManager dismiss];
        self.interactManager = nil;
        [self.view insertSubview:self.liveManager.playerView atIndex:0];
        [self.liveManager play];
    }
}

- (void)infoSwitchButtonDidTouch {
    self.infoTextView.hidden = !self.infoTextView.hidden;
    if (!self.infoTextView.hidden) {
        [self updateLivePlayInfo];
    }
}

- (void)destoryLiveManager {
    [self.liveManager stop];
    [self.liveManager close];
    [self removeObservations];
    self.liveManager = nil;
}

- (void)backButtonDidTouch {
    [self destoryLiveManager];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)playbackButtonDidTouch {
    NSString *imageName = @"";
    if (self.liveManager.isPlaying) {
        imageName = @"play";
        [self.liveManager pause];
    } else {
        imageName = @"pause";
        [self.liveManager.currentItem addObserver:self forKeyPath:NSStringFromSelector(@selector(presentationSize)) options:NSKeyValueObservingOptionNew context:nil];
        [self.liveManager play];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.playbackButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    });
}

- (void)timerTick {
    [self updateLivePlayInfo];
    [self updateLiveStateInfo];
}

- (void)updateLivePlayInfo {
    // MARK: 由于liveManager的logEvent总为nil，原本可从其中获取的数据需要进行人工计算，因此存在两种计算方案
    // TODO: 待重构或接口问题修复后选定一种计算方案
    [self useManuallyCalculation];
//    [self useManagerLogEvent];
}

// MARK: TVLSettingsManagerDataSource Methods

- (NSDictionary *)currentSettings {
    return self.playConfiguration.settingsData;
}

// MARK: TVLDelegate Methods

- (TVLMediaResolutionType)degradeTargetResolutionWithResolution:(TVLMediaResolutionType)resolution {
    if (![TVLManager.recommendedrResolutionDegradeSequence containsObject:resolution]
        || [resolution isEqualToString:TVLManager.recommendedrResolutionDegradeSequence.lastObject]) {
        return nil;
    }
    NSUInteger index = [TVLManager.recommendedrResolutionDegradeSequence indexOfObject:resolution];
    TVLMediaResolutionType degradeResolution = [TVLManager.recommendedrResolutionDegradeSequence objectAtIndex:(index + 1)];
    return degradeResolution;
}

- (void)playerItem:(TVLPlayerItem *)playerItem didSwitchFromPreviousPreferences:(TVLPlayerItemPreferences *)previousPreferences toCurrentPreferences:(TVLPlayerItemPreferences *)currentPreferences {
    if (![currentPreferences.resolutionType isEqualToString:previousPreferences.resolutionType]) {
        [UIApplication.sharedApplication.keyWindow makeToast:[NSString stringWithFormat:@"清晰度已切换至%@", [self descriptionOfResolutionType:currentPreferences.resolutionType]] duration:1.0 position:@(self.view.center)];
    }
}

- (void)manager:(TVLManager *)manager videoSizeDidChange:(CGSize)size {
    NSLog(@"%s", __FUNCTION__);
}

- (void)manager:(TVLManager *)manager didReceiveSEI:(NSDictionary *)SEI {
   // NSLog(@"%s\n%@", __FUNCTION__, SEI);
}

- (void)manager:(TVLManager *)manager playerItemStatusDidChange:(TVLPlayerItemStatus)status {
    NSLog(@"%s", __FUNCTION__);
}

- (void)manager:(TVLManager *)manager willProcessAudioFrameWithRawData:(float **)rawData samples:(int)samples timeStamp:(int64_t)timestamp {
    
}

- (void)manager:(TVLManager *)manager willOpenAudioRenderWithSampleRate:(int)sampleRate channels:(int)channels duration:(int)duration {
    NSLog(@"TTSDK: Audio Render Will Open");
}

- (void)loadStateChanged:(NSNumber *)state {
    NSLog(@"%s %@", __FUNCTION__, state);
}

- (void)onMonitorLog:(NSDictionary *)event {
    NSLog(@"%@", event);
//    NSLog(@"Server address: %@", self.liveManager.currentItem.accessLog.events.lastObject.serverAddress);
    NSString *eventKey = [event objectForKey:@"event_key"];
    if ([eventKey isEqualToString:@"first_frame"]) {
        _liveStatus = TVLLiveStatusOngoing;
        _startDate = [NSDate date];
        _firstFrameTime = [[event objectForKey:@"first_frame_render_end"] doubleValue] - [[event objectForKey:@"start"] doubleValue];
        NSDictionary *details = @{
                                  @"SDK DNS": @([[event objectForKey:@"sdk_dns_analysis_end"] doubleValue] - [[event objectForKey:@"start"] doubleValue]),
                                  @"Player DNS": @([[event objectForKey:@"player_dns_analysis_end"] doubleValue] - [[event objectForKey:@"sdk_dns_analysis_end"] doubleValue]),
                                  @"TCP Connect": @([[event objectForKey:@"tcp_connect_end"] doubleValue] - [[event objectForKey:@"player_dns_analysis_end"] doubleValue]),
                                  @"TCP First Package": @([[event objectForKey:@"tcp_first_package_end"] doubleValue] - [[event objectForKey:@"tcp_connect_end"] doubleValue]),
                                  @"Video First Package": @([[event objectForKey:@"first_video_package_end"] doubleValue] - [[event objectForKey:@"tcp_first_package_end"] doubleValue]),
                                  @"Video First Package Decode": @([[event objectForKey:@"first_video_frame_decode_end"] doubleValue] - [[event objectForKey:@"first_video_package_end"] doubleValue]),
                                  @"Video First Package Render": @([[event objectForKey:@"first_frame_render_end"] doubleValue] - [[event objectForKey:@"first_video_frame_decode_end"] doubleValue]),
                                  @"Video First Package View": @([[event objectForKey:@"first_frame_render_end"] doubleValue] - [[event objectForKey:@"start"] doubleValue]),
                                  };
        NSLog(@"%@: \n%@", NSStringFromClass(self.class), details);
    }
    if ([eventKey isEqualToString:@"playing"]) {
        _playURL = [event objectForKey:@"cdn_play_url"];
        _videoRate = [[event objectForKey:@"video_rate"] integerValue];
        NSInteger prevDownloadSize = _downloadSize;
        _downloadSize = [[event objectForKey:@"video_download_size"] integerValue];
        _bandwidthInMbps = 8 * (_downloadSize - prevDownloadSize) / [self timeintervalFromDate:_previousMonitorEventDate toDate:[NSDate date]] / 1000000;
        _stallTimeFromPlayingEvent += [[event objectForKey:@"stall_time"] longLongValue];
        _stallCountFromPlayingEvent += [[event objectForKey:@"stall_count"] longLongValue];
    }
    if ([eventKey isEqualToString:@"play_stop"]) {
        _stallTimeFromPlayStopEvent = [[event objectForKey:@"stall_time"] longLongValue];
        _stallCountFromPlayStopEvent += [[event objectForKey:@"stall_count"] longLongValue];
        NSLog(@"stall time -> playing: %lld, play_stop: %lld, delegate: %lld, stall: %lld", _stallTimeFromPlayingEvent, _stallTimeFromPlayStopEvent, (int64_t)(self.totalStallTime * 1000), _stallDurationInStallEvent);
        NSLog(@"stall count -> playing: %lld, play_stop: %lld, delegate: %lld, stall: %lld", _stallCountFromPlayingEvent, _stallCountFromPlayStopEvent, (int64_t)self.stallCount, _stallCountInStallEvent);
    }
    if ([eventKey isEqualToString:@"stall"]) {
        _stallCountInStallEvent += 1;
        _stallDurationInStallEvent += [[event objectForKey:@"stall_end"] longLongValue] - [[event objectForKey:@"stall_start"] longLongValue];
    }
    [self updateLiveInfo];
    _previousMonitorEventDate = [NSDate date];
    [_logViewController appendLogWithLogInfo:event];
}

- (void)updateLiveInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateLivePlayInfo];
        [self updateLiveStateInfo];
    });
}

- (void)onStreamDryup:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
}

- (void)recieveError:(NSError *)error {
    if (error.code == -499896 && self.liveManager.ipMappingTable.count != 0) {
        NSString *errorMessage = @"IP mapping table settings may be wrong";
        [self.view makeToast:errorMessage duration:5.f position:CSToastPositionBottom title:nil image:nil style:nil completion:nil];
    } else if (error.code == -499594) {
        // RTC 会话超时，重新连接
        [self.liveManager stop];
        [self.liveManager play];
    } else {
        [self.view makeToast:[NSString stringWithFormat:@"%@", error]];
    }
}

- (void)stallEnd {
    if (!self.stallStartDate) {
        return;
    }
    // 卡顿事件统计
    self.stallCount += 1;
    self.totalStallTime += [[NSDate date] timeIntervalSinceDate:self.stallStartDate];
    self.stallStartDate = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateLivePlayInfo];
    });
}

- (void)stallStart {
    self.stallStartDate = [NSDate date];
}

- (void)startRender {
    NSLog(@"%s", __FUNCTION__);
//    [self testRepeatedlyStop];
}

- (TVLPlayerItemPreferences *)playerItem:(TVLPlayerItem *)playerItem customizedPreferencesWithUserInfo:(NSDictionary *)userInfo {
    TVLPlayerItemPreferences *customizedPreferences = [TVLPlayerItemPreferences defaultPreferences];
   // customizedPreferences.videoCodecType = TVLVideoCodecTypeH264;
    return customizedPreferences;
}

// MARK: Development Methods

- (void)testRepeatedlyStop {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self testRepeatedlyStopTick];
    });
}

- (void)testRepeatedlyStopTick {
    [self.liveManager stop];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self testRepeatedlyStopTick];
    });
}

- (void)mockStallEvent {
    [self stallStart];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(arc4random() % 5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stallEnd];
    });
}

- (NSString *)descriptionOfResolutionType:(TVLMediaResolutionType)resolutionType {
    return [(NSString *)resolutionType uppercaseString];
}

- (NSString *)descriptionOfPlaybackState:(TVLPlayerPlaybackState)playbackState {
    NSString *description = @"Unknown";
    switch (playbackState) {
        case TVLPlayerPlaybackStateStopped:
        description = @"Stopped";
        break;
        case TVLPlayerPlaybackStatePlaying:
        description = @"Playing";
        break;
        case TVLPlayerPlaybackStatePaused:
        description = @"Paused";
        break;
        case TVLPlayerPlaybackStateError:
        description = @"Error";
        break;
            
        default:
            break;
    }
    return description;
}

- (void)useManuallyCalculation {
    NSMutableString *formattedDebugInfo = [NSMutableString string];
    NSDictionary *formattedDebugInfoItems = self.liveManager.formattedDebugInfoItems;
    for (NSString *key in formattedDebugInfoItems.allKeys) {
        id value = [formattedDebugInfoItems objectForKey:key];
        [formattedDebugInfo appendFormat:@"%@: %@\n", key, value];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.infoTextView.text = formattedDebugInfo;
    });
}

@end
