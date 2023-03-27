//
//  VeLiveAudienceViewController.m
//  TTQuickStartDemo
//
//  Created by ByteDance on 2022/10/18.
//

#import "VeLiveAudienceViewController.h"
#import "VeLiveAudienceManager.h"
#import "Constant.h"

@interface VeLiveAudienceViewController ()<VeLiveAudienceDelegate>
@property (nonatomic, strong) VeLiveAudienceManager       *audienceManager;     // 拉流+连麦管理
@property (nonatomic, copy)   NSString                    *appId;               // AppID
@property (nonatomic, copy)   NSString                    *roomId;              // 连麦房间Id
@property (nonatomic, copy)   NSString                    *userId;              // 当前用户Id
@property (nonatomic, copy)   NSString                    *pullUrl;             // 拉流直播地址
@property (nonatomic, copy)   NSString                    *rtcToken;            // 连麦Token
@property (nonatomic, strong) UIView                      *localView;           // 本地用户View
@property (nonatomic, strong) UIView                      *remoteView;          // 远端用户View
@property(nonatomic, strong)  UIButton                    *interactBtn;         // 连麦按钮
@end

@implementation VeLiveAudienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"观众拉流+连麦";
    self.view.backgroundColor = UIColor.blackColor;
    self.pullUrl = LIVE_PULL_URL;
    self.appId = RTC_APPID;
    self.userId = RTC_AUDIENCE_USER_ID;
    self.roomId = RTC_ROOM_ID;
    self.rtcToken = RTC_AUDIENCE_USER_TOKEN;
    self.audienceManager = [[VeLiveAudienceManager alloc] initWithAppId:self.appId userId:self.userId];
    [self startPlay];
    [self setupInteractBtn];
}

- (void)dealloc {
    /// 业务处理时，尽量不要放到此处释放，推荐放到退出直播间时释放。
    if (self.audienceManager != nil) {
        [self.audienceManager destory];
        self.audienceManager = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TVLManager startOpenGLESActivity];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TVLManager stopOpenGLESActivity];
}

- (void)setupInteractBtn {
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"加入房间" forState:(UIControlStateNormal)];
    [btn setTitle:@"离开房间" forState:(UIControlStateSelected)];
    [btn setTitleColor:UIColor.blueColor forState:(UIControlStateNormal)];
    [btn setTitleColor:UIColor.blueColor forState:(UIControlStateSelected)];
    btn.frame = CGRectMake(100, 150, 100, 30);
    self.interactBtn = btn;
    [btn addTarget:self action:@selector(interactBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    UIButton *seiBtn = [[UIButton alloc] init];
    [seiBtn setTitle:@"发送SEI" forState:(UIControlStateNormal)];
    [seiBtn setTitleColor:UIColor.blueColor forState:(UIControlStateNormal)];
    [seiBtn setTitleColor:UIColor.blueColor forState:(UIControlStateSelected)];
    seiBtn.frame = CGRectMake(100, 210, 100, 30);
    [seiBtn addTarget:self action:@selector(seiBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:seiBtn];
}

- (void)seiBtnClick:(UIButton *)btn {
    [self.audienceManager sendSeiMessage:@"audience_test_sei_for_interactive" repeat:20];
}

- (void)interactBtnClick:(UIButton *)btn {
    if (btn.isSelected) {
        [self stopInteractive];
    } else {
        [self startInteractive];
    }
    [self.view bringSubviewToFront:btn];
}

- (void)startPlay {
    self.localView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.localView];
    [self.audienceManager setLocalVideoView:self.localView];
    [self.audienceManager startPlay:self.pullUrl];
}

- (void)startInteractive {
    [self.audienceManager startInteract:self.roomId token:self.rtcToken delegate:self];

    self.interactBtn.selected = YES;
    [self.view bringSubviewToFront:self.interactBtn];
}

- (void)manager:(VeLiveAudienceManager *)manager onUserJoined:(NSString *)uid {
    
}

- (void)manager:(VeLiveAudienceManager *)manager onUserLeave:(NSString *)uid {
    
}

- (void)manager:(VeLiveAudienceManager *)manager onJoinRoom:(NSString *)uid {
    
}

- (void)manager:(VeLiveAudienceManager *)manager onUserPublishStream:(nonnull NSString *)uid type:(ByteRTCMediaStreamType)streamType {
    if (streamType == ByteRTCMediaStreamTypeAudio) {
        return;
    }
    // 设置远端用户view
    self.remoteView = [UIView new];
    self.remoteView.frame =  CGRectMake(self.view.bounds.size.width/2, 0, self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    [self.view addSubview:self.remoteView];
    [manager setRemoteVideoView:self.remoteView forUid:uid];
}

- (void)manager:(VeLiveAudienceManager *)manager onUserUnPublishStream:(nonnull NSString *)uid type:(ByteRTCMediaStreamType)streamType reason:(ByteRTCStreamRemoveReason)reason {
    if (streamType == ByteRTCMediaStreamTypeAudio) {
        return;
    }
    
    [self.remoteView removeFromSuperview];
    [manager setRemoteVideoView:nil forUid:uid];
}


- (void)stopInteractive {
    /// 停止连麦
    [self.audienceManager stopInteract];
    
    // 移除远端view
    [self.remoteView removeFromSuperview];
    
    self.interactBtn.selected = NO;
    [self.view bringSubviewToFront:self.interactBtn];
}

- (void)stopPlay {
    /// 停止播放
    [self.audienceManager stopPlay];
}

@end
