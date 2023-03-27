//
//  VeLiveAudienceManager.m
//  TTQuickStartDemo
//
//  Created by ByteDance on 2023/2/22.
//

#import "VeLiveAudienceManager.h"
@interface VeLiveAudienceManager () <ByteRTCRoomDelegate, ByteRTCVideoDelegate, TVLDelegate>
@property (nonatomic, strong, readwrite) ByteRTCVideo *rtcVideo;
@property (nonatomic, strong, readwrite) ByteRTCRoom *rtcRoom;
@property (nonatomic, copy, readwrite) NSString *appId;
@property (nonatomic, copy, readwrite) NSString *userId;
@property (nonatomic, copy, readwrite) NSString *roomId;
@property (nonatomic, copy, readwrite) NSString *token;
@property (nonatomic, assign, getter=isInteractive) BOOL interactive;
@property (nonatomic, copy) NSString *playUrl;
@property (nonatomic, strong, readwrite) TVLManager *playerManager;
@property (nonatomic, assign) NSInteger streamRetryCount;
@end
@implementation VeLiveAudienceManager
- (instancetype)initWithAppId:(NSString *)appId userId:(NSString *)userId {
    if (self = [super init]) {
        self.appId = appId;
        self.userId = userId;
        self.config = [[VeLiveConfig alloc] init];
    }
    return self;
}

- (instancetype)init {
    return [self initWithAppId:@"" userId:@""];
}

- (void)setLocalVideoView:(UIView *)localVideoView {
    _localVideoView = localVideoView;
    [self setupLocalVideoView:localVideoView];
}

- (void)setRemoteVideoView:(UIView *)view forUid:(NSString *)uid {
    if (self.rtcVideo) {
        ByteRTCVideoCanvas *canvasView = [[ByteRTCVideoCanvas alloc] init];
        canvasView.uid = uid;
        canvasView.view = view;
        canvasView.roomId = self.roomId;
        canvasView.renderMode = ByteRTCRenderModeHidden;
        [self.rtcVideo setRemoteVideoCanvas:uid withIndex:(ByteRTCStreamIndexMain) withCanvas:canvasView];
    }
}

- (void)startVideoCapture {
    [self createRTCVideoIfNeed];
    __weak __typeof__(self)weakSelf = self;
    [self authorPermissionFor:(AVMediaTypeVideo) completion:^(BOOL granted) {
        __strong __typeof__(weakSelf)self = weakSelf;
        if (granted) {
            [self.rtcVideo startVideoCapture];
        } else {
            NSLog(@"请打开摄像头权限");
        }
    }];
    
}

- (void)stopVideoCapture {
    [self.rtcVideo stopVideoCapture];
    [self setupLocalVideoView:nil];
}

- (void)startAudioCapture {
    [self createRTCVideoIfNeed];
    __weak __typeof__(self)weakSelf = self;
    [self authorPermissionFor:(AVMediaTypeAudio) completion:^(BOOL granted) {
        __strong __typeof__(weakSelf)self = weakSelf;
        if (granted) {
            [self.rtcVideo startAudioCapture];
        } else {
            NSLog(@"请打开麦克风权限");
        }
    }];
    
}

- (void)stopAudioCapture {
    [self.rtcVideo stopAudioCapture];
}

- (void)startInteract:(NSString *)roomId token:(NSString *)token delegate:(id <VeLiveAudienceDelegate>)delegate {
    [self stopPlay];
    [self startAudioCapture];
    [self startVideoCapture];
    
    self.roomId = roomId;
    self.token = token;
    self.delegate = delegate;
    [self setupRTCRoomIfNeed];
    
    // 设置用户信息
    ByteRTCUserInfo *userInfo = [[ByteRTCUserInfo alloc] init];
    userInfo.userId = self.userId;
    
    // 加入房间，开始连麦
    ByteRTCRoomConfig *config = [ByteRTCRoomConfig new];
    config.isAutoPublish = YES;
    config.isAutoSubscribeAudio = YES;
    config.isAutoSubscribeVideo = YES;
    
    // 加入RTC房间
    NSLog(@"join room %@ - %@", roomId, self.userId);
    [self.rtcRoom joinRoomByToken:token userInfo:userInfo roomConfig:config];
    self.interactive = YES;
}


- (void)stopInteract {
    [self.rtcRoom leaveRoom];
    self.interactive = NO;
    [self stopAudioCapture];
    [self stopVideoCapture];
    [self startPlayIfNeed];
}

- (void)sendSeiMessage:(NSString *)message repeat:(int)repeat {
    [self.rtcVideo sendSEIMessage:(ByteRTCStreamIndexMain)
                       andMessage:[message dataUsingEncoding:NSUTF8StringEncoding]
                   andRepeatCount:repeat];
}

- (void)destory {
    [self stopPlay];
    self.playerManager = nil;
    [self stopInteract];
    [self stopVideoCapture];
    [self stopAudioCapture];
    [self.rtcRoom destroy];
    self.rtcRoom = nil;
    [ByteRTCVideo destroyRTCVideo];
    self.rtcVideo = nil;
}

/// MARK: - ByteRTCVideoDelegate
- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine onWarning:(ByteRTCWarningCode)Code {
    NSLog(@"rtc 引擎警告");
}

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine onError:(ByteRTCErrorCode)errorCode {
    NSLog(@"rtc 引擎错误");
}

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine onCreateRoomStateChanged:(NSString * _Nonnull)roomId errorCode:(NSInteger)errorCode {
    if (errorCode != 0) {
        NSLog(@"房间创建失败");
    }
}

/// MARK: - ByteRTCRoomDelegate
- (void)rtcRoom:(ByteRTCRoom *_Nonnull)rtcRoom
   onRoomStateChanged:(NSString *_Nonnull)roomId
            withUid:(nonnull NSString *)uid
          state:(NSInteger)state
      extraInfo:(NSString *_Nonnull)extraInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (state == 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(manager:onJoinRoom:)]) {
                [self.delegate manager:self onJoinRoom:uid];
            }
        } else {
            NSLog(@"加入房间失败");
        }
    });
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onUserJoined:(ByteRTCUserInfo *)userInfo elapsed:(NSInteger)elapsed {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(manager:onUserJoined:)]) {
            [self.delegate manager:self onUserJoined:userInfo.userId];
        }
    });
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onUserLeave:(NSString *)uid reason:(ByteRTCUserOfflineReason)reason {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(manager:onUserLeave:)]) {
            [self.delegate manager:self onUserLeave:uid];
        }
    });
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onUserPublishStream:(NSString *)userId type:(ByteRTCMediaStreamType)type {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(manager:onUserPublishStream:type:)]) {
            [self.delegate manager:self onUserPublishStream:userId type:type];
        }
    });
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onUserUnpublishStream:(NSString * _Nonnull)userId type:(ByteRTCMediaStreamType)type reason:(ByteRTCStreamRemoveReason)reason {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(manager:onUserUnPublishStream:type:reason:)]) {
            [self.delegate manager:self onUserUnPublishStream:userId type:type reason:reason];
        }
    });
}

/// MARK: - Private
- (void)createRTCVideoIfNeed {
    if (self.rtcVideo == nil && self.appId != nil && self.appId.length > 0) {
        self.rtcVideo = [ByteRTCVideo createRTCVideo:self.appId delegate:self parameters:@{}];
        ByteRTCVideoEncoderConfig *solution = [[ByteRTCVideoEncoderConfig alloc] init];
        solution.width = self.config.captureWidth;
        solution.height = self.config.captureHeight;
        solution.frameRate = self.config.captureFps;
        solution.maxBitrate = self.config.videoEncoderKBitrate;
        [self.rtcVideo SetMaxVideoEncoderConfig:solution];
        [self setupLocalVideoView:_localVideoView];
    }
}

- (void)setupLocalVideoView:(UIView *)view {
    if (_rtcVideo) {
        // 设置本地View
        ByteRTCVideoCanvas *canvasView = [[ByteRTCVideoCanvas alloc] init];
        canvasView.uid = self.userId;
        canvasView.view = view;
        canvasView.roomId = self.roomId;
        canvasView.renderMode = ByteRTCRenderModeHidden;
        [self.rtcVideo setLocalVideoCanvas:ByteRTCStreamIndexMain withCanvas:canvasView];
    }
    
    if (_playerManager) {
        [view addSubview:_playerManager.playerView];
        _playerManager.playerView.frame = view.bounds;
    }
}

- (void)setupRTCRoomIfNeed {
    // 创建 RTC 房间
    if (self.rtcRoom == nil) {
        self.rtcRoom = [self.rtcVideo createRTCRoom:self.roomId];
        self.rtcRoom.delegate = self;
    }
}

- (void)authorPermissionFor:(AVMediaType)type completion:(void (^)(BOOL granted))completion  {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:type];
    if (status == AVAuthorizationStatusNotDetermined || status == AVAuthorizationStatusRestricted) {
        [AVCaptureDevice requestAccessForMediaType:type completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(granted);
            });
        }];
    } else {
        completion(status == AVAuthorizationStatusAuthorized);
    }
}

- (void)dealloc {
    [self destory];
}

- (void)startPlay:(NSString *)url {
    self.streamRetryCount = 0;
    [self setupPlayerIfNeed];
    self.playUrl = url;
    TTLiveURLComposer *composer = [[TTLiveURLComposer alloc] init];
    /// MARK: 如果是RTM拉流，需要把Format 改成 TVLMediaFormatTypeLLS
    /// 根据播放的url，修改对应的 Format 格式
    [composer addUrl:url forFormat:TVLMediaFormatTypeFLV];
    /// 构造播放Item
    TVLPlayerItem *item = [TVLPlayerItem playerItemWithComposer:composer];
    /// 替换播放源
    [self.playerManager replaceCurrentItemWithPlayerItem:item];
    [self.playerManager play];
    self.playerManager.playerView.hidden = NO;
    [self setupLocalVideoView:self.localVideoView];
}

- (void)stopPlay {
    [self.playerManager stop];
    self.playerManager.playerView.hidden = YES;
}

/// MARK: - Private
- (void)startPlayIfNeed {
    if (self.playerManager) {
        [self startPlay:self.playUrl];
    }
}
- (void)setupPlayerIfNeed {
    if (self.playerManager == nil) {
        TVLManager *liveManager = [[TVLManager alloc] initWithOwnPlayer:YES];
        if (liveManager == nil) {
            NSLog(@"license 无效");
            return;
        }
        liveManager.playerViewRenderType = TVLPlayerViewRenderTypeMetal;
        liveManager.playerViewScaleMode = TVLViewScalingModeAspectFit;
        liveManager.hardwareDecode = NO;
        if (@available(iOS 11.0, *)) {
            liveManager.hardwareDecode = YES;
        }
        liveManager.shouldUseLiveDNS = NO;
        liveManager.delegate = self;
        /// 开启 OpenGLES Activity
        [TVLManager startOpenGLESActivity];
        /// 属性记录播放器
        self.playerManager = liveManager;
    }
    
    if (self.playerManager.playerView.superview != self.localVideoView) {
        [self.playerManager.playerView removeFromSuperview];
        [self.localVideoView addSubview:self.playerManager.playerView];
        self.playerManager.playerView.frame = self.localVideoView.bounds;
    }
}

/// TVLDelegate
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
    if (self.streamRetryCount++ < 3) {
        [self.playerManager stop];
        [self startPlayIfNeed];
    }
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

@end
