//
//  VeLiveAnchorManager.h
//  TTQuickStartDemo
//
//  Created by ByteDance on 2023/2/22.
//

#import <UIKit/UIKit.h>
#import <VolcEngineRTC/VolcEngineRTC.h>
#import <TTSDK/LiveCore.h>
#import <TTSDK/LiveCore+Capture.h>
#import "VeLiveConfig.h"

NS_ASSUME_NONNULL_BEGIN

@class VeLiveAnchorManager;
@protocol VeLiveAnchorDelegate <NSObject>
/// 用户加入房间
- (void)manager:(VeLiveAnchorManager *)manager onUserJoined:(NSString *)uid;
/// 用户离开房间事件回调
- (void)manager:(VeLiveAnchorManager *)manager onUserLeave:(NSString *)uid;
/// 本人加入房间回调
- (void)manager:(VeLiveAnchorManager *)manager onJoinRoom:(NSString *)uid;
/// 用户发布视频流回调，用于更新合流布局
- (void)manager:(VeLiveAnchorManager *)manager onUserPublishStream:(NSString *)uid type:(ByteRTCMediaStreamType)streamType;
/// 用户取消发布视频流回调，用于更新合流布局
- (void)manager:(VeLiveAnchorManager *)manager onUserUnPublishStream:(NSString *)uid type:(ByteRTCMediaStreamType)streamType reason:(ByteRTCStreamRemoveReason)reason;
@end

@interface VeLiveAnchorManager : NSObject
/// 推流引擎
@property (nonatomic, strong, readonly) LiveCore *liveEngine;
/// 主播预览视图
@property (nonatomic, strong) UIView *localVideoView;
/// 直播+RTC 推流配置
@property (nonatomic, strong, nullable) VeLiveConfig *config;
/// rtc 视频管理
@property (nonatomic, strong, readonly, nullable) ByteRTCVideo *rtcVideo;
/// rtc 房间管理
@property (nonatomic, strong, readonly, nullable) ByteRTCRoom *rtcRoom;
/// 创建时传入的appid
@property (nonatomic, copy, readonly, nullable) NSString *appId;
/// 创建时，传入的 userId
@property (nonatomic, copy, readonly, nullable) NSString *userId;
/// 加入的房间ID
@property (nonatomic, copy, readonly, nullable) NSString *roomId;
/// 加入房间的Token
@property (nonatomic, copy, readonly, nullable) NSString *token;
/// 是否连麦中
@property (nonatomic, assign, getter=isInteractive, readonly) BOOL interactive;
/// 代理
@property(nonatomic, weak) id <VeLiveAnchorDelegate> delegate;

/// 初始化
- (instancetype)initWithAppId:(NSString *)appId userId:(NSString *)userId NS_DESIGNATED_INITIALIZER;

/// 配置远端用户视图
- (void)setRemoteVideoView:(nullable UIView *)view forUid:(NSString *)uid;

/// 开启视频采集
- (void)startVideoCapture;

/// 停止视频采集
- (void)stopVideoCapture;

/// 开启音频采集
- (void)startAudioCapture;

/// 停止音频采集
- (void)stopAudioCapture;

/// 开始连麦
- (void)startInteract:(NSString *)roomId token:(NSString *)token delegate:(id <VeLiveAnchorDelegate>)delegate;

/// 停止连麦
- (void)stopInteract;

/// 发送SEI消息
/// - Parameters:
///   - message: sei 消息长度，最长2kb
///   - repeat: [0, 30]
- (void)sendSeiMessage:(NSString *)message repeat:(int)repeat;

/// 销毁引擎
- (void)destory;

/// 开始推流
- (void)startPush:(NSString *)url;

/// 停止推流
- (void)stopPush;

/// 更新合流布局
- (void)updateLiveTranscodingLayout:(ByteRTCVideoCompositingLayout *)layout;

/// 开始跨房间转推
- (void)startForwardStream:(NSArray <ForwardStreamConfiguration *> *)forwardStreamInfos;

/// 停止跨房间转推
- (void)stopForwardStream;
@end

NS_ASSUME_NONNULL_END
