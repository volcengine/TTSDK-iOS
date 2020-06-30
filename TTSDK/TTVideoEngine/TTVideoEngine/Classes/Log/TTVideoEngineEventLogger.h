//
//  TTVideoEngineEventLogger.h
//  Pods
//
//  Created by guikunzhi on 16/12/26.
//
//

#import <Foundation/Foundation.h>
#import "TTVideoEngineUtil.h"
#import "TTVideoEnginePlayerDefine.h"
#import "TTVideoEngine.h"

static NSInteger const LOGGER_VALUE_CODEC_TYPE  = 0;
static NSInteger const LOGGER_VALUE_RENDER_TYPE = 1;
static NSInteger const LOGGER_VALUE_PLAYER_INFO = 2;
static NSInteger const LOGGER_VALUE_API_STRING  = 3;
static NSInteger const LOGGER_VALUE_NET_CLIENT  = 4;
static NSInteger const LOGGER_VALUE_INTERNAL_IP                    = 5;
static NSInteger const LOGGER_VALUE_DNS_TIME                       = 7;
static NSInteger const LOGGER_VALUE_TRANS_CONNECT_TIME             = 10;
static NSInteger const LOGGER_VALUE_TRANS_FIRST_PACKET_TIME        = 11;
static NSInteger const LOGGER_VALUE_RECEIVE_FIRST_VIDEO_FRAME_TIME = 12;
static NSInteger const LOGGER_VALUE_RECEIVE_FIRST_AUDIO_FRAME_TIME = 13;
static NSInteger const LOGGER_VALUE_DECODE_FIRST_VIDEO_FRAME_TIME  = 14;
static NSInteger const LOGGER_VALUE_DECODE_FIRST_AUDIO_FRAME_TIME  = 15;
static NSInteger const LOGGER_VALUE_AUDIO_DEVICE_OPEN_TIME         = 16;
static NSInteger const LOGGER_VALUE_VIDEO_DEVICE_OPEN_TIME         = 17;
static NSInteger const LOGGER_VALUE_AUDIO_DEVICE_OPENED_TIME       = 18;
static NSInteger const LOGGER_VALUE_VIDEO_DEVICE_OPENED_TIME       = 19;
static NSInteger const LOGGER_VALUE_P2P_LOAD_INFO                  = 20;
static NSInteger const LOGGER_VALUE_PLAYBACK_STATE                 = 21;
static NSInteger const LOGGER_VALUE_LOAD_STATE                     = 22;
static NSInteger const LOGGER_VALUE_ENGINE_STATE                   = 23;
static NSInteger const LOGGER_VALUE_VIDEO_CODEC_NAME               = 24;
static NSInteger const LOGGER_VALUE_AUDIO_CODEC_NAME               = 25;
static NSInteger const LOGGER_VALUE_DURATION                       = 26;

static const NSString *kTTVideoEngineVideoDurationKey = @"duration";
static const NSString *kTTVideoEngineVideoSizeKey = @"size";
static const NSString *kTTVideoEngineVideoCodecKey = @"codec";
static const NSString *kTTVideoEngineVideoTypeKey = @"vtype";

typedef NS_ENUM(NSInteger,TTVideoSettingLogType){
    TTVideoSettingLogTypeBufferTimeOut,
};

@class TTVideoEngineEventLogger;

@protocol TTVideoEngineEventLoggerProtocol <NSObject>

@required

- (NSDictionary *)versionInfoForEventLogger:(TTVideoEngineEventLogger *)eventLogger;
- (NSDictionary *)bytesInfoForEventLogger:(TTVideoEngineEventLogger *)eventLogger;
- (int64_t)getLogValueLong:(NSInteger)key;
- (NSString *)getLogValueStr:(NSInteger)key;
- (NSInteger)getLogValueInt:(NSInteger)key;

@end

@interface TTVideoEngineEventLogger : NSObject

@property (nonatomic, weak) id<TTVideoEngineEventLoggerProtocol> delegate;
@property (nonatomic, assign) BOOL reportLogEnable; /// Report switch.
@property (nonatomic,   copy) NSString *userUniqueId;
@property (nonatomic, assign) BOOL isLocal;
@property (nonatomic, copy) NSString *vid;
@property (nonatomic, copy) NSArray *vu;
@property (nonatomic, assign) NSInteger loopCount;
@property (nonatomic, assign) NSTimeInterval accumulatedStalledTime;
@property (nonatomic, assign) NSInteger seekCount;

- (void)setURLArray:(NSArray *)urlArray;

- (void)setSourceType:(NSInteger)sourceType vid:(NSString *)vid;

- (void)beginToPlayVideo:(NSString *)vid;

- (void)setTag:(NSString *)tag;

- (void)setSubTag:(NSString *)subtag;

- (void)needRetryToFetchVideoURL:(NSError *)error apiVersion:(NSInteger)apiVersion;

- (void)playerError:(NSError *)error url:(NSString *)url;

- (void)mainURLCDNError:(NSError *)error url:(NSString *)url;

- (void)mainURLLocalDNSError:(NSError *)error;

- (void)mainURLHTTPDNSError:(NSError *)error;

- (void)firstDNSFailed:(NSError *)error;

- (void)fetchedVideoURL:(NSDictionary *)videoInfo error:(NSError *)error apiVersion:(NSInteger)apiVersion;

- (void)validateVideoMetaDataError:(NSError *)error;

- (void)showedOneFrame;

- (void)logPlayerSetURLToFirstFrameTimeWithDNSFinish:(int64_t)DNSTs
                                          TCPConnect:(int64_t)connectTs
                                             TCPRecv:(int64_t)recevTs
                                            vedeoPkt:(int64_t)vPktTs
                                            audioPkt:(int64_t)aPktTs
                                          videoFrame:(int64_t)vFrameTs
                                          audioFrame:(int64_t)aFrameTs;

- (void)setDNSParseTime:(int64_t)dnsTime;

- (void)setCurrentDefinition:(NSString *)toDefinition lastDefinition:(NSString *)lastDefinition;

- (void)switchToDefinition:(NSString *)toDefinition fromDefinition:(NSString *)fromDefinition;

- (void)seekToTime:(NSTimeInterval)afterSeekTime cachedDuration:(NSTimeInterval)cachedDuration switchingResolution:(BOOL)isSwitchingResolution;

- (void)movieStalled;

- (void)movieStalledAfterFirstScreen:(TTVideoEngineStallReason)reason;

- (void)stallEnd;

/// 没有调用
- (void)movieBufferDidReachEnd;

- (void)moviePlayRetryWithError:(NSError *)error strategy:(TTVideoEngineRetryStrategy)strategy apiver:(TTVideoEnginePlayAPIVersion)apiver;

- (void)movieFinishError:(NSError *)error currentPlaybackTime:(NSTimeInterval)currentPlaybackTime apiver:(TTVideoEnginePlayAPIVersion)apiver;

- (void)playbackFinish:(TTVideoEngineFinishReason)reason;

- (void)videoStatusException:(NSInteger)status;

- (void)userCancelled;

- (void)setPreloadInfo:(NSDictionary *)preload;

- (void)setPlayItemInfo:(NSDictionary *)playItem;

- (void)setFeedInfo:(NSDictionary *)feed;

- (void)setInitalURL:(NSString *)url;

- (void)useHardware:(BOOL)enable;

- (void)loopAgain;
/// 观看结束
- (void)watchFinish;
/// 开启边播边下功能
- (void)enableCacheFile;
/// 设置初始播放host
- (void)setInitialHost:(NSString* )hostString;
/// 初始播放使用的ip
- (void)setInitialIp:(NSString* )ipString;
/// 初始播放使用的分辨率
- (void)setInitialResolution:(NSString* )resolutionString;
/// prepare开始的时间戳，单位是毫秒
- (void)setPrepareStartTime:(long long)prepareStartTime;
/// prepared结束的时间戳，单位是毫秒
- (void)setPrepareEndTime:(long long)prepareEndTime;
/// 渲染类型
- (void)setRenderType:(NSInteger )renderType;
/// 是否使用了预加载
- (void)enablePreload:(NSInteger) preload;
/// video_preload_size, 视频预加载大小(播放前)
- (void)setVideoPreloadSize:(long long) preloadSize;
/// wifi 名称
- (void)setWifiName:(NSString* )wifiName;
/// 当前视频的播放进度：ms
- (void)logCurPos:(long)curPos;
/// 视频暂停
- (void)playerPause;
/// 视频播放
- (void)playerPlay;
/// 开始加载数据，卡顿或者seek
- (void)beginLoadDataWhenBufferEmpty;
/// 结束加载数据，卡顿或者seek
- (void)endLoadDataWhenBufferEmpty;
/// 错误重试次数非累积
- (void)updateTryErrorCount:(NSInteger )count;
/// 累积错误次数
- (void)updateCalculateErrorCount:(NSInteger )count;
/// 业务方设置的播放参数
- (void)updateCustomPlayerParms:(NSDictionary* )param;
/// 解码器类型（0表示使用FFMPEG解码器 1表示使用金山解码器）
- (void)setDecoderType:(NSInteger) decoderType;
/// 0表示点播，1表示直播回放
- (void)setPlayerSourceType:(NSInteger) sourceType;
/// 平均帧率
- (void)setVideoOutFPS:(NSInteger) fps;
// Socket连接复用
- (void)setReuseSocket:(NSInteger)reuseSocket;
// 禁止精准起播
- (void)setDisableAccurateStart:(NSInteger)disableAccurateStart;
/// 平均观看时长
- (void)logWatchDuration:(NSInteger)watchDuration;
/// 播放状态
- (void)playbackState:(TTVideoEnginePlaybackState)playbackState;
/// 加载状态
- (void)loadState:(TTVideoEngineLoadState)loadState;
/// engine状态
- (void)engineState:(TTVideoEngineState)engineState;
//记录视频size
- (void)videoChangeSizeWidth:(NSInteger)width height:(NSInteger)height;
/// 使用代理服务器
- (void)proxyUrl:(NSString *)proxyUrl;
// drm类型
- (void)setDrmType:(NSInteger)drmType;
// play接口请求url
- (void)setApiString:(NSString *)apiString;
// 网络client类型
- (void)setNetClient:(NSString *)netClient;
// 记录apiversion和auth
- (void)setPlayAPIVersion:(TTVideoEnginePlayAPIVersion)apiVersion auth:(NSString *)auth;
// 记录用户设置的起始播放时间
- (void)setStartTime:(NSInteger)startTime;
- (void)closeVideo;
/// 解码器名称id
- (void)logCodecNameId:(NSInteger)audioNameId video:(NSInteger)videoNameId;
/// 视频播放总时长，单位：毫秒
- (void)updateMediaDuration:(NSTimeInterval)duration;
/// 记录码率
- (void)logBitrate:(NSInteger)bitrate;
/// 解码器名称
- (void)logCodecName:(NSString *)audioName video:(NSString *)videoName;

- (void)setSettingLogType:(TTVideoSettingLogType)logType value:(int)value;

@end
