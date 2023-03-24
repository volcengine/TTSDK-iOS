//
//  VeLiveAnchorManager.m
//  TTQuickStartDemo
//
//  Created by ByteDance on 2023/2/22.
//

#import "VeLiveAnchorManager.h"
@interface VeLiveAnchorManager () <ByteRTCRoomDelegate, ByteRTCVideoDelegate, ByteRTCVideoSinkDelegate, ByteRTCAudioFrameObserver, LiveTranscodingDelegate>
@property (nonatomic, strong, readwrite) ByteRTCVideo *rtcVideo;
@property (nonatomic, strong, readwrite) ByteRTCRoom *rtcRoom;
@property (nonatomic, copy, readwrite) NSString *appId;
@property (nonatomic, copy, readwrite) NSString *userId;
@property (nonatomic, copy, readwrite) NSString *roomId;
@property (nonatomic, copy, readwrite) NSString *token;
@property (nonatomic, assign, getter=isInteractive) BOOL interactive;
@property (nonatomic, strong, readwrite) LiveCore *liveEngine;
@property (nonatomic, strong) ByteRTCLiveTranscoding *rtcLiveTranscoding;
@property (nonatomic, copy) NSString *streamUrl;
@property (nonatomic, copy) NSString *rtcTaskId;
@end
@implementation VeLiveAnchorManager
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

- (void)startInteract:(NSString *)roomId token:(NSString *)token delegate:(id <VeLiveAnchorDelegate>)delegate {
    /// 停止推流
    [self stopPush];
    
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
    self.rtcLiveTranscoding = nil;
    [self.rtcVideo stopLiveTranscoding:self.rtcTaskId];
    [self.rtcRoom leaveRoom];
    self.interactive = NO;
    [self startPushIfNeed];
}

- (void)sendSeiMessage:(NSString *)message repeat:(int)repeat {
    if (!self.isInteractive) {
        [self.liveEngine sendSEIMsgWithKey:@"live_engine"
                                     value:message
                               repeatTimes:repeat];
    } else {
        [self.rtcVideo sendSEIMessage:(ByteRTCStreamIndexMain)
                           andMessage:[message dataUsingEncoding:NSUTF8StringEncoding]
                       andRepeatCount:repeat];
    }
}

- (void)destory {
    [self stopPush];
    self.liveEngine = nil;
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
        /// 接管视频采集回调
        [self.rtcVideo setLocalVideoSink:ByteRTCStreamIndexMain
                                withSink:self
                         withPixelFormat:(ByteRTCVideoSinkPixelFormatI420)];
        
        /// 接管音频采集回调
        ByteRTCAudioFormat *audioFormat = [[ByteRTCAudioFormat alloc] init];
        audioFormat.channel = ByteRTCAudioChannelStereo;
        audioFormat.sampleRate = ByteRTCAudioSampleRate44100;
        [self.rtcVideo enableAudioFrameCallback:(ByteRTCAudioFrameCallbackRecord) format:audioFormat];
        [self.rtcVideo setAudioFrameObserver:self];
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

- (void)startPush:(NSString *)url {
    self.streamUrl = url;
    [self setupLiveEngineWithUrl:url];
    [self.liveEngine startStreaming];
}

- (void)stopPush {
    [self.liveEngine stopStreaming];
}

- (void)startForwardStream:(NSArray<ForwardStreamConfiguration *> *)forwardStreamInfos {
    [self stopPush];
    [self.rtcRoom startForwardStreamToRooms:forwardStreamInfos];
}

- (void)stopForwardStream {
    [self.rtcRoom stopForwardStreamToRooms];
    [self startPushIfNeed];
}

- (void)updateLiveTranscodingLayout:(ByteRTCVideoCompositingLayout *)layout {
    if (self.rtcLiveTranscoding == nil) {
        self.rtcLiveTranscoding = [ByteRTCLiveTranscoding defaultTranscoding];
        self.rtcLiveTranscoding.roomId = self.roomId;
        self.rtcLiveTranscoding.userId = self.userId;
        
        // 设置视频编码参数
        self.rtcLiveTranscoding.video.width = self.config.videoEncoderWith;
        self.rtcLiveTranscoding.video.height = self.config.videoEncoderHeight;
        self.rtcLiveTranscoding.video.fps = self.config.videoEncoderFps;
        self.rtcLiveTranscoding.video.kBitRate = self.config.videoEncoderKBitrate;
        
        // 设置音频编码参数
        self.rtcLiveTranscoding.audio.sampleRate = self.config.audioEncoderSampleRate;
        self.rtcLiveTranscoding.audio.channels = self.config.audioEncoderChannel;
        self.rtcLiveTranscoding.audio.kBitRate = self.config.audioEncoderKBitrate;
        
        // 设置推流地址
        self.rtcLiveTranscoding.url = self.streamUrl;
        // 服务端合流
        self.rtcLiveTranscoding.expectedMixingType = ByteRTCStreamMixingTypeByServer;
        
        // 设置混流模版
        self.rtcLiveTranscoding.layout = layout;
        
        // 设置混流任务Id
        self.rtcTaskId = @"";
        
        [self.rtcVideo startLiveTranscoding:self.rtcTaskId transcoding:self.rtcLiveTranscoding observer:self];
    } else {
        // 设置混流模版
        self.rtcLiveTranscoding.layout = layout;
        // 开启RTC 服务端混流
        [self.rtcVideo updateLiveTranscoding:self.rtcTaskId transcoding:self.rtcLiveTranscoding];
    }
}

- (void)startPushIfNeed {
    if (self.liveEngine) {
        [self startPush:self.streamUrl];
    }
}



/// MARK: - Private
- (void)setupLiveEngineWithUrl:(NSString *)url {
    if (url == nil || url.length == 0) {
        return;
    }
    
    if (self.liveEngine == nil) {
        self.liveEngine = [[LiveCore alloc] initWithMode:(LiveCoreModuleLiveStreaming)];
        LiveStreamConfiguration *streamConfig = [LiveStreamConfiguration defaultConfiguration];
        streamConfig.outputSize  = CGSizeMake(self.config.videoEncoderWith, self.config.videoEncoderHeight);
        streamConfig.bitrate     = self.config.videoEncoderKBitrate * 1000;
        streamConfig.minBitrate  = self.config.videoEncoderKBitrate * 1000;
        streamConfig.maxBitrate  = self.config.videoEncoderKBitrate * 1000;
        streamConfig.videoFPS    = self.config.videoEncoderFps;
        streamConfig.URLs = @[url];
        [self.liveEngine setupLiveSessionWithConfig:streamConfig];
        if (self.liveEngine.liveSession == nil) {
            NSLog(@"license 无效");
            self.liveEngine = nil;
            return;
        }
        /// 日志回调
        [self.liveEngine setStreamLogCallback:^(NSDictionary *log) {
                    
        }];
        /// 状态回调
        [self.liveEngine setStatusChangedBlock:^(LiveStreamSessionState state, LiveStreamErrorCode errCode) {
                    
        }];
    }
}

/// MARK: - ByteRTCVideoSinkDelegate
- (void)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer
                 rotation:(ByteRTCVideoRotation)rotation
              contentType:(ByteRTCVideoContentType)contentType
             extendedData:(NSData *)extendedData {
    if (self.isInteractive) {
        return;
    }
    int64_t value = (int64_t)(CACurrentMediaTime() * 1000000000);
    int32_t timeScale = 1000000000;
    CMTime pts = CMTimeMake(value, timeScale);
    [self.liveEngine.liveSession pushVideoBuffer:pixelBuffer andCMTime:pts rotation:(int)rotation];
}

- (int)getRenderElapse {
    return 0;
}

/// MARK: - ByteRTCAudioFrameObserver
- (void)onRecordAudioFrame:(ByteRTCAudioFrame * _Nonnull)audioFrame {
    if (self.isInteractive) {
        return;
    }
    int channel = 2;
    if (audioFrame.channel == ByteRTCAudioChannelMono) {
        channel = 1;
    } else if (audioFrame.channel == ByteRTCAudioChannelStereo) {
        channel = 2;
    }
    
    int64_t value = (int64_t)(CACurrentMediaTime() * 1000000000);
    int32_t timeScale = 1000000000;
    CMTime pts = CMTimeMake(value, timeScale);
    
    int bytesPerFrame = 16 * channel / 8;
    int numFrames = (int)(audioFrame.buffer.length / bytesPerFrame);
    
    [self.liveEngine pushAudioBuffer:(uint8_t*)[audioFrame.buffer bytes]
                        andDataLen:(size_t)audioFrame.buffer.length
                 andInNumberFrames:numFrames
                         andCMTime:pts];
}

- (void)onPlaybackAudioFrame:(ByteRTCAudioFrame * _Nonnull)audioFrame; {
    
}

- (void)onRemoteUserAudioFrame:(ByteRTCRemoteStreamKey * _Nonnull)streamKey
                    audioFrame:(ByteRTCAudioFrame * _Nonnull)audioFrame; {
    
}

- (void)onMixedAudioFrame:(ByteRTCAudioFrame * _Nonnull)audioFrame {
    
}
/// MARK: - LiveTranscodingDelegate
- (BOOL)isSupportClientPushStream {
    return NO;
}

- (void)onStreamMixingEvent:(ByteRTCStreamMixingEvent)event
                  taskId:(NSString *_Nonnull)taskId
                      error:(ByteRtcTranscoderErrorCode)Code
                    mixType:(ByteRTCStreamMixingType)mixType {
    if (Code == ByteRtcTranscoderErrorCodeOK && event == ByteRTCStreamMixingEventStartSuccess) {
        // 如果合流降级到了服务端，需要把当前标识置为 NO，并停止 LiveCore 的推流
        if (mixType == ByteRTCStreamMixingTypeByServer) {
            NSLog(@"服务端合流成功");
        }
    }
    NSLog(@"转推直播状态回调%d-%d-%d", (int)event, (int)Code, (int)mixType);
}

@end
