//
//  TTInteractViewController.m
//  TTQuickStartDemo
//
//  Created by ByteDance on 2022/10/18.
//

#import "VeLiveAnchorViewController.h"
#import "VeLiveAnchorManager.h"
#import "Constant.h"
@interface VeLiveAnchorViewController () <VeLiveAnchorDelegate>
@property (nonatomic, strong) VeLiveAnchorManager         *liveAnchorManager;   // 主播互动管理
@property (nonatomic, copy)   NSString                    *appId;               // AppID
@property (nonatomic, strong) UIView                      *previewView;         // 推流预览View
@property (nonatomic, copy)   NSString                    *pushUrl;             // 推流直播地址
@property (nonatomic, strong) NSMutableArray <NSString *> *usersInRoom;         // 参与连麦的用户列表
@property (nonatomic, copy)   NSString                    *roomId;              // 连麦房间Id
@property (nonatomic, copy)   NSString                    *userId;              // 当前用户Id
@property (nonatomic, copy)   NSString                    *rtcToken;            // 连麦Token
@property (nonatomic, strong) UIView                      *localView;           // 本地用户View
@property (nonatomic, strong) UIView                      *remoteView;          // 远端用户View
@property (nonatomic, strong)  UIButton                   *interactBtn;         // 连麦按钮
@property (nonatomic, strong)  UIButton                   *pkBtn;               // PK按钮
@end

@implementation VeLiveAnchorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主播推流+连麦";
    self.view.backgroundColor = [UIColor blackColor];
    self.usersInRoom = [NSMutableArray arrayWithCapacity:2];
    self.pushUrl = LIVE_PUSH_URL;
    self.appId = RTC_APPID;
    self.userId = RTC_ANCHOR_USER_ID;
    self.roomId = RTC_ROOM_ID;
    self.rtcToken = RTC_ANCHOR_USER_TOKEN;
    self.liveAnchorManager = [[VeLiveAnchorManager alloc] initWithAppId:self.appId userId:self.userId];
    [self startPush];
    [self setupUI];
}

- (void)dealloc {
    /// 业务处理时，尽量不要放到此处释放，推荐放到退出直播间时释放。
    if (self.liveAnchorManager != nil) {
        [self.liveAnchorManager destory];
        self.liveAnchorManager = nil;
    }
}

- (void)setupUI {
    UIButton *interactBtn = [[UIButton alloc] init];
    [interactBtn setTitle:@"加入房间" forState:(UIControlStateNormal)];
    [interactBtn setTitle:@"离开房间" forState:(UIControlStateSelected)];
    [interactBtn setTitleColor:UIColor.blueColor forState:(UIControlStateNormal)];
    [interactBtn setTitleColor:UIColor.blueColor forState:(UIControlStateSelected)];
    interactBtn.frame = CGRectMake(100, 150, 100, 30);
    self.interactBtn = interactBtn;
    [interactBtn addTarget:self action:@selector(interactBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:interactBtn];
    
    UIButton *pkBtn = [[UIButton alloc] init];
    [pkBtn setTitle:@"开始跨房PK" forState:(UIControlStateNormal)];
    [pkBtn setTitle:@"停止跨房PK" forState:(UIControlStateSelected)];
    [pkBtn setTitleColor:UIColor.blueColor forState:(UIControlStateNormal)];
    [pkBtn setTitleColor:UIColor.blueColor forState:(UIControlStateSelected)];
    pkBtn.frame = CGRectMake(100, 210, 100, 30);
    self.pkBtn = pkBtn;
    [pkBtn addTarget:self action:@selector(pkBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:pkBtn];
    
    UIButton *seiBtn = [[UIButton alloc] init];
    [seiBtn setTitle:@"发送SEI" forState:(UIControlStateNormal)];
    [seiBtn setTitleColor:UIColor.blueColor forState:(UIControlStateNormal)];
    [seiBtn setTitleColor:UIColor.blueColor forState:(UIControlStateSelected)];
    seiBtn.frame = CGRectMake(100, 270, 100, 30);
    [seiBtn addTarget:self action:@selector(seiBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:seiBtn];
}

- (void)seiBtnClick:(UIButton *)btn {
    [self.liveAnchorManager sendSeiMessage:@"anchor_test_sei" repeat:20];
}
- (void)interactBtnClick:(UIButton *)btn {
    if (btn.isSelected) {
        [self stopInteractive];
    } else {
        [self startInteractive];
    }
    [self.view bringSubviewToFront:btn];
}

- (void)pkBtnClick:(UIButton *)btn {
    if (btn.isSelected) {
        [self stopPk];
    } else {
        [self startPk];
    }
}

- (void)startPush {
    // 创建预览视图
    self.previewView = [UIView new];
    self.previewView.frame = self.view.bounds;
    [self.view addSubview:self.previewView];
    /// 配置本地预览视图
    [self.liveAnchorManager setLocalVideoView:self.previewView];
    /// 开启视频采集
    [self.liveAnchorManager startVideoCapture];
    /// 开启音频采集
    [self.liveAnchorManager startAudioCapture];
    /// 开始推流
    [self.liveAnchorManager startPush:self.pushUrl];
}

- (void)stopPush  {
    /// 停止推流
    [self.liveAnchorManager stopPush];
}

- (void)startInteractive {
    /// 清空历史用户，业务逻辑处理
    [self.usersInRoom removeAllObjects];
    /// 开始连麦
    [self.liveAnchorManager startInteract:self.roomId
                                    token:self.rtcToken
                                 delegate:self];
    self.interactBtn.selected = YES;
    [self.view bringSubviewToFront:self.interactBtn];
}

- (void)stopInteractive {
    /// 清空历史用户，业务逻辑处理
    [self.usersInRoom removeAllObjects];
    
    /// 停止连麦
    [self.liveAnchorManager stopInteract];
    
    // 移除连麦远端View
    [self.remoteView removeFromSuperview];
 
    self.interactBtn.selected = NO;
    [self.view bringSubviewToFront:self.interactBtn];
}

- (void)startPk {
    if (!self.interactBtn.isSelected) {
        NSLog(@"请先进入房间");
        return;
    }
    /// 跨房间转推
    ForwardStreamConfiguration *cfg = [[ForwardStreamConfiguration alloc] init];
    cfg.roomId = RTC_OTHER_ANCHOR_ROOM_ID;
    cfg.token = RTC_ANCHOR_OTHER_ROOM_TOKEN;
    [self.liveAnchorManager startForwardStream:@[cfg]];
    self.pkBtn.selected = YES;
}

- (void)stopPk {
    [self.liveAnchorManager stopForwardStream];
    self.pkBtn.selected = NO;
}

/// MARK: - VELiveRTCDelegate
- (void)manager:(VeLiveAnchorManager *)manager onJoinRoom:(NSString *)uid {
    [self.usersInRoom addObject:[uid copy]];
    
    /// 更新布局参数
    [manager updateLiveTranscodingLayout:[self rtcLayout]];
}

- (void)manager:(VeLiveAnchorManager *)manager onUserJoined:(NSString *)uid {
    [self.usersInRoom addObject:uid.copy];
    
}

- (void)manager:(VeLiveAnchorManager *)manager onUserLeave:(NSString *)uid {
    // 更新连麦用户列表
    [self.usersInRoom removeObject:uid];
    /// 更新混流布局
    [manager updateLiveTranscodingLayout:[self rtcLayout]];
}

- (void)manager:(VeLiveAnchorManager *)manager onUserPublishStream:(nonnull NSString *)uid type:(ByteRTCMediaStreamType)streamType {
    if (streamType == ByteRTCMediaStreamTypeAudio) {
        return;
    }
    // 设置远端用户view
    self.remoteView = [UIView new];
    self.remoteView.frame =  CGRectMake(self.view.bounds.size.width/2, 0, self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    [self.view addSubview:self.remoteView];
    [manager setRemoteVideoView:self.remoteView forUid:uid];
    
    /// 更新布局参数
    [manager updateLiveTranscodingLayout:[self rtcLayout]];
}

- (void)manager:(VeLiveAnchorManager *)manager onUserUnPublishStream:(nonnull NSString *)uid type:(ByteRTCMediaStreamType)streamType reason:(ByteRTCStreamRemoveReason)reason {
    if (streamType == ByteRTCMediaStreamTypeAudio) {
        return;
    }
    [self.usersInRoom removeObject:uid];
    /// 移除远端视图
    [manager setRemoteVideoView:nil forUid:uid];
    /// 更新混流布局
    [manager updateLiveTranscodingLayout:[self rtcLayout]];
}

- (ByteRTCVideoCompositingLayout *)rtcLayout {
    // 初始化布局
    ByteRTCVideoCompositingLayout * layout = [[ByteRTCVideoCompositingLayout alloc]init];
    
    // 设置背景色
    layout.backgroundColor = @"#000000"; //仅供参考
 
    NSMutableArray *regions = [[NSMutableArray alloc]initWithCapacity:6];
    __block NSUInteger guestIndex = 0;
    [self.usersInRoom enumerateObjectsUsingBlock:^(NSString * _Nonnull uid, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ByteRTCVideoCompositingRegion *region = [[ByteRTCVideoCompositingRegion alloc]init];
        region.uid          = uid;
        region.roomId       = self.roomId;
        region.localUser    = [uid isEqualToString:self.userId]; // 判断是否为当前主播
        region.renderMode   = ByteRTCRenderModeHidden;
        
        if (region.localUser) { //当前主播位置，仅供参考
            region.x        = 0.0;
            region.y        = 0.0;
            region.width    = 1.0;
            region.height   = 1.0;
            region.zOrder   = 0;
            region.alpha    = 1.0;
        } else { // 远端用户位置，仅供参考
            region.x        = 0.5;
            region.y        = 0.0;
            region.width    = 0.5;
            region.height   = 0.5;
            region.zOrder   = 1;
            region.alpha    = 1;
            guestIndex ++;
        }
        [regions addObject:region];
    }];
    layout.regions = regions;
    return layout;
}

@end
