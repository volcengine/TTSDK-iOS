//
//  StreamingInteractManager.m
//  TTSDKDemo
//
//  Created by guojieyuan on 2021/11/9.
//  Copyright © 2021 ByteDance. All rights reserved.
//

#import "StreamingInteractManager.h"
#import "StreamConfigurationModel.h"
#if __has_include(<VolcEngineRTC/VolcEngineRTC.h>)
#import <VolcEngineRTC/VolcEngineRTC.h>
#endif

static NSString *const kLiveCoreSEIKEYSource = @"kLiveCoreSEIKEYSource";
static NSString *const kLiveCoreSEIValueSourceNone = @"kLiveCoreSEIValueSourceNone";
static NSString *const kLiveCoreSEIValueSourceCoHost = @"kLiveCoreSEIValueSourceCoHost";

@interface StreamingInteractManagerPreviewContainer: UIView

@property (strong, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UIView *hostView;
@property (weak, nonatomic) IBOutlet UIView *guestView;

@end

@implementation StreamingInteractManagerPreviewContainer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViewWithNib];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initSubViewWithNib];
    }
    return self;
}

-(void)initSubViewWithNib {
    [[NSBundle mainBundle] loadNibNamed:@"StreamingInteractManagerPreviewContainer" owner:self options:NULL];
    [self addSubview:self.rootView];
    [self.rootView setFrame:self.bounds];
}

@end


//MARK: RTC SDK 封装
@interface StreamingInteractManager () <ByteRTCEngineDelegate, LiveTranscodingDelegate>

@property (nonatomic, strong) LiveRtc *rtcKit;

@property (nonatomic, weak) id<StreamingInteractManagerDelegate> delegate;

@property (nonatomic, strong) StreamingInteractManagerPreviewContainer *previewContainer;

@property (nonatomic, weak) StreamConfigurationModel *configurations;

@end

@implementation StreamingInteractManager {
    NSString *_appID;
    NSString *_userID;
    NSString *_roomID;
    BOOL _isHost;
    //
    ByteRTCVideoCanvas *_localByteCanvas;
    ByteRTCVideoCanvas *_remoteByteCanvas;
    //
    NSMutableArray<NSString *> *_usersInRoom;
}

//MARK: Public
- (instancetype)initWithAppID:(NSString *)appID
                       userID:(NSString *)userID
                       roomID:(NSString *)roomID
                       isHost:(BOOL)isHost
                       config:(StreamConfigurationModel *)config {
    self = [super init];
    if (self) {
        _appID = appID;
        _userID = userID;
        _roomID = roomID;
        _isHost = isHost;
        _configurations = config;
        //
        _localByteCanvas = nil;
        _remoteByteCanvas = nil;
        _previewContainer = [[StreamingInteractManagerPreviewContainer alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _usersInRoom = [NSMutableArray new];
        [self createRTCEngine];
        
    }
    return self;
}

- (void)createRTCEngine {
    self.rtcKit = [[LiveRtc alloc] initLiveRtcWithAppId:_appID delegate:self monitorDelegate:nil parameters:nil];
    self.rtcKit.liveRtcExpectedMixType = LIVERTC_MIX_TYPE_SERVER;
    if (_isHost) {
        self.rtcKit.isVideoExtSource = YES;
        [self.rtcKit setVideoInputType:ByteRTCMediaInputTypeExternal];
        [self.rtcKit setUserRole:ByteRTCUserRoleTypeBroadcaster];
        //[self.rtcKit configEngine];
    } else {
        [self.rtcKit setVideoInputType:ByteRTCMediaInputTypeInternal];
        [self.rtcKit setUserRole:ByteRTCUserRoleTypeSilentAudience];
    }
}

- (void)joinChannel {
    [self startAudioCapture];
    if (!_isHost) {
        [self.rtcKit startVideoCapture];
    }
    ByteRTCUserInfo *userInfo = [[ByteRTCUserInfo alloc] init];
    userInfo.userId = [_userID copy];
    [self.rtcKit joinRoomByKey:nil roomId:_roomID roomProfile:ByteRTCRoomProfileLiveBroadcasting userInfo:userInfo];
}

// RTC合流转推至原本主播的推流地址
- (void)startServerMixPush {
    if (!_isHost) {
        // 主播才需要
        return;
    }
    StreamConfigurationModel *model = _configurations;
    ByteRTCLiveTranscoding *transcoding = [ByteRTCLiveTranscoding defaultTranscoding];
    transcoding.url = model.streamURL;
    transcoding.video.width = model.streamResolution.width;
    transcoding.video.height = model.streamResolution.height;
    transcoding.video.kBitRate = model.videoBitrate;
    transcoding.video.fps = model.fps;
    transcoding.video.gop = 4;
    transcoding.video.codec = model.videoCodecType == 1 ? @"ByteVC1" : @"H264";
    transcoding.audio.channels = 2;
    transcoding.audio.kBitRate = model.audioBitrate;
    transcoding.audio.sampleRate = 44100;
    transcoding.audio.codec = @"AAC";
    transcoding.audio.profile = ByteRTCAACProfileLC;
    transcoding.expectedMixingType = StreamMixingTypeByServer;
    //
    transcoding.layout = [self rtcLayout];
    int ret = [self.rtcKit startLiveTranscoding:transcoding observer:self];
    if (ret != 0) {
        
    }
}

- (ByteRTCVideoCompositingLayout *)rtcLayout {
    ByteRTCVideoCompositingLayout * onerLayout = [[ByteRTCVideoCompositingLayout alloc]init];
    onerLayout.backgroundColor = @"#000000";
    //AppData
    NSString *value = _isHost ? kLiveCoreSEIValueSourceCoHost : kLiveCoreSEIValueSourceNone;
    NSDictionary *dic = @{kLiveCoreSEIKEYSource : value};
    NSString *json = [dic mj_JSONString];
    onerLayout.appData = json;
    //
    NSMutableArray *regions = [[NSMutableArray alloc]initWithCapacity:6];
    [_usersInRoom enumerateObjectsUsingBlock:^(NSString * _Nonnull uid, NSUInteger idx, BOOL * _Nonnull stop) {
        ByteRTCVideoCompositingRegion *region = [[ByteRTCVideoCompositingRegion alloc]init];
        region.uid = uid;
        region.x = 0;
        region.y = 0.5 * (CGFloat)idx;
        region.width = 1;
        region.height = 0.5;
        region.zOrder = 0;;
        region.alpha = 1;
        region.renderMode = ByteRTCRenderModeHidden;
        region.contentControl = 0;
        region.localUser = YES;
        [regions addObject:region];
    }];

    onerLayout.regions = regions;
    return onerLayout;
}

- (void)dismiss {
    [self.rtcKit stopLiveTranscoding];
    [self.rtcKit leaveRoom:^(ByteRTCRoomStats * _Nonnull stat) {
        
    }];
    [self.rtcKit destroyEngine];
}

- (void)startAudioCapture {
    [self.rtcKit startAudioCapture];
}

// 本端
- (void)setupLocalPreview {
    if (!_localByteCanvas) {
        if (_isHost) {
            // 自己是主持，自己放上面
            _localByteCanvas = [self.class byteCanvasWithHostingView:_previewContainer.hostView userID:_userID roomID:_roomID];
        } else {
            // 自己是观众，自己放上面
            _localByteCanvas = [self.class byteCanvasWithHostingView:_previewContainer.guestView userID:_userID roomID:_roomID];
        }
        [self.rtcKit setLocalVideoCanvas:0 withCanvas:_localByteCanvas];
    }
}

// 本端视频源
- (BOOL)processVideoPixelbuf:(CVPixelBufferRef)pixelbuf presentationTime:(CMTime) frameTime {
    return [self.rtcKit pushExternalVideoFrame:pixelbuf time:frameTime];
}

// 远端
- (void)setRemotePreviewWithUserID:(NSString *)remoteUID roomID:(NSString *)remoteRoomID streamIndex:(ByteRTCStreamIndex)streanIndex {
    if (!_remoteByteCanvas) {
        if (_isHost) {
            // 自己是主持，远端放下面
            _remoteByteCanvas = [self.class byteCanvasWithHostingView:_previewContainer.guestView userID:remoteUID roomID:remoteRoomID];
        } else {
            // 自己是观众，远端放上面
            _remoteByteCanvas = [self.class byteCanvasWithHostingView:_previewContainer.hostView userID:remoteUID roomID:remoteRoomID];
        }
        [self.rtcKit setRemoteVideoCanvas: remoteUID withIndex:streanIndex withCanvas:_remoteByteCanvas];
    }
}

+ (ByteRTCVideoCanvas*)byteCanvasWithHostingView:(UIView *)hostingView userID:(NSString *)userID roomID:(NSString *)roomID {
    ByteRTCVideoCanvas* byteCanvas = [[ByteRTCVideoCanvas alloc] init];
    byteCanvas.uid = userID;
    byteCanvas.view = hostingView;
    byteCanvas.roomId = roomID;
    byteCanvas.renderMode = ByteRTCRenderModeHidden;
    byteCanvas.view.backgroundColor = [UIColor grayColor];
    return byteCanvas;
}

//MARK: GET
- (UIView *)previewContainer {
    return _previewContainer;
}

//MARK: ByteRTCEngineDelegate
- (void)rtcEngine:(ByteRTCEngineKit *)engine onFirstRemoteVideoFrameRendered:(ByteRTCRemoteStreamKey *)streamKey withFrameInfo:(ByteRTCVideoFrameInfo *)frameInfo {
    // 远端用户视频以到达
    NSString *remoteUserID = streamKey.userId;
    NSString *remoteRoomID = streamKey.roomId;
    ByteRTCStreamIndex index = streamKey.streamIndex;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setRemotePreviewWithUserID:remoteUserID roomID:remoteRoomID streamIndex:index];
        [self startServerMixPush];
    });
}

- (void)rtcEngine:(ByteRTCEngineKit *)engine onJoinRoomResult:(NSString *)roomId withUid:(NSString *)uid errorCode:(NSInteger)errorCode joinType:(NSInteger)joinType elapsed:(NSInteger)elapsed {
    NSLog(@"%@: onJoinRoomResult %ld", NSStringFromClass(self.class), (long)errorCode);
    if (joinType == 0) {
        [_usersInRoom addObject:[uid copy]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupLocalPreview];
            [self startServerMixPush];
        });
    }
}

- (void)rtcEngine:(ByteRTCEngineKit *)engine onUserJoined:(ByteRTCUserInfo *)userInfo elapsed:(NSInteger)elapsed {
    NSString *remoteUserID = userInfo.userId;
    [_usersInRoom addObject:[remoteUserID copy]];
    NSLog(@"%@: onUserJoined, userID %ld", NSStringFromClass(self.class), (long)remoteUserID);
}

- (void)rtcEngine:(ByteRTCEngineKit *)engine onUserLeave:(NSString *)uid reason:(ByteRTCUserOfflineReason)reason {
    [_usersInRoom removeObject:uid];
}

- (void)rtcEngine:(ByteRTCEngineKit *)engine onError:(ByteRTCErrorCode)errorCode {
    NSLog(@"%@: onErrpr %ld", NSStringFromClass(self.class), (long)errorCode);
}

- (void)rtcEngine:(ByteRTCEngineKit *)engine onLiveTranscodingResult:(NSString *)url errorCode:(ByteRTCTranscodingError)errorCode {
    NSLog(@"%@: live transcoding url: %@", NSStringFromClass(self.class), url);
    if (errorCode != ByteRTCTranscodingErrorOK) {
        NSLog(@"%@%ld",@"StreamInteractManager - 合流Error", (long)errorCode);
    }
}

//MARK: LiveTranscodingDelegate
- (BOOL)isSupportClientPushStream {
    return YES;
}

- (void)onStreamMixingEvent:(ByteRTCStreamMixingEvent)event
                  eventData:(NSString *)msg
                      error:(ByteRtcTranscoderErrorCode)Code
                    mixType:(ByteRTCStreamMixingType)mixType {
    NSLog(@"%@: live transcoding message: %@", NSStringFromClass(self.class), msg);
    if (Code != TranscoderErrorOK) {
        NSLog(@"%@%ld",@"StreamInteractManager - 合流Error", (long)Code);
    }
}

//MARK: Static Method
+ (UIAlertController *)joinRoomRequestIsHost:(BOOL)isHost
                              configurations:(StreamConfigurationModel *)config
                               completeBlock:(void (NS_NOESCAPE^)(StreamingInteractManager *obj))block {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"加入房间" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入房间号码";
        textField.text = @"2222";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入用户ID";
        textField.text = isHost ? @"6666" : @"6667";
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *roomID = [[alertController textFields][0] text];
        NSString *userID = [[alertController textFields][1] text];
        StreamingInteractManager *manager = [[StreamingInteractManager alloc] initWithAppID:@"5a7451222679214f668e7085" userID:roomID roomID:userID isHost:isHost config:config];
        block(manager);
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Canelled");
    }];
    [alertController addAction:cancelAction];
    return alertController;
}


@end
