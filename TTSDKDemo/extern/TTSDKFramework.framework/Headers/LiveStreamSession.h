//
//  iLiveStream.h
//  WebrtcCaptureDemo
//
//  Created by tangzhixin on 2018/6/29.
//  Copyright © 2018年 tangzhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AVFoundation/AVFoundation.h>
#import "LiveStreamConfiguration.h"
#import "LiveStreamDefines.h"
#import "LiveStreamLinkInfo.h"
#import "LiveStreamMediaSource.h"

@class LiveStreamSession;
@protocol LiveStreamSessionProtocol;
@class LiveStreamLinkInfo;
@class LiveStreamCapture;


@interface LiveStreamSession : NSObject

/**
 LiveStreamSession stream delegate
 */
@property (nonatomic, weak) id<LiveStreamSessionProtocol> delegate;

/**
 LiveStreamSession 状态
 */
@property (nonatomic, readonly) LiveStreamSessionState liveSessionState;

/**
 设置/查询是否静音
 
 @discussion
     静音推流非纯视频推流，纯视频推流可通过推流模式设置，具体参考 LiveStreamConfiguration.h
     支持推流中改变 audioMute 状态
 */
@property (nonatomic, assign, getter=isAudioMute) BOOL audioMute;

/**
 获取当前推流参数
 */
@property (nonatomic, readonly) LiveStreamConfiguration *configuration;

#pragma mark - Report Log
/**
 推流周期上报日志间隔，默认为5s
 */
@property (nonatomic, assign) NSInteger streamLogTimeInterval;

/**
 上报log 日志回调接口
 */
@property (nonatomic, copy) void(^streamLogCallback)(NSDictionary *log);

#pragma mark - Reconnect
/**
 是否开启自动重连，默认开启
 */
@property (nonatomic, assign) BOOL shouldAutoReconnect;

/**
 重连次数，默认 9 次
 */
@property (nonatomic, assign) NSInteger reconnectCount;

/**
 重连间隔，默认 1s
 */
@property (nonatomic, assign) NSInteger reconnectTimeInterval;

#pragma mark - Audio
/**
 耳机监听(耳返)开关
 */
@property (nonatomic, assign, getter=isHeadphonesMonitoringEnabled) BOOL headphonesMonitoringEnabled;

//蓝牙耳机监听开关，开关生效依赖 headphonesMonitoringEnabled=YES
@property (nonatomic, assign, getter=isBlueToothMonitoringEnabled) BOOL blueToothMonitoringEnabled;
#pragma mark - Track
/**
 default is 0
 */
@property (nonatomic, assign) NSInteger mainVideoTrackId;

/**
 default is 0
 */
@property (nonatomic, assign) NSInteger mainAudioTrackId;

/**
 获取推流SDK版本
 
 @return SDK版本
 */
+ (NSString *)getSdkVersion;

/**
 采集的音频数据回调，请避免耗时操作
 */
@property (nonatomic, copy) void(^didCapturedAudioBufferList)(AudioBufferList *ioData,
                                                              UInt32          inNumberFrames,
                                                              AudioBufferList *processedData,
                                                              AudioBufferList *headphonesMonitoringData);


@property (nonatomic, copy) void(^didCapturedAudioBufferList_withBGMPlayer)(AudioBufferList *ioData,
                            UInt32          inNumberFrames,
                            AudioBufferList *processedData,
                            AudioBufferList *headphonesMonitoringData);
/**
获取音频信息使用AudioDevcie播放
 */
- (void)setGetAudioCallback:(void (^)(void * _Nonnull buffer, int bufferSize, int frames, int bytesPerSample, int channels, int sampleRate))getAudioCallback;

/**
 实例化 LiveStreamSession 对象

 @param config 推流配置
 @return 推流实例
 */
- (instancetype)initWithConfig:(LiveStreamConfiguration *)config;

/**
重新推流，更新参数配置
*/
- (void)pushRestartUpdateParams;

/**
 开始推流，会读取configuration中的rtmpUrl进行推流
 */
- (void)start;

/**
 根据设置的rtmpURL推流,并更新configuration中的rtmpUrl
 @param rtmpURL 推流地址
 */
- (void)startStreamWithURL:(NSString *)rtmpURL;

/**
 停止推流，并释放推流对象
 */
- (void)stop;

/*
 通过SEI发生app附加信息，调用后，跟随之后的sei发送，主要用于连麦混流布局信息的传递。
 sei 载荷类型100，内容类似 {"ts":1502857493753,"source":"TTLiveSDK_iOS”,"app_data":XXX}，ts：为时间戳，毫秒；source：字符串，来源。app_data 存储appData
 @param key 添加的key
 @param value 添加的value：支持类型NSNumber（int、double、bool）、NSString、NSDictionary（json），有类型检查，按需设置； 如果key为 nil，则从sei信息中移出，之后不会再发送
 @param repeatTimes  <0 表示重复发送无限次，直到从sei信息中移出
 @param keyFrameOnly 是否只在关键帧前发送
 @param allowsCovered 是否允许被覆盖
 */
- (int)sendSEIMsgWithKey:(NSString *)key
                   value:(NSObject *)value
             repeatTimes:(NSInteger)repeatTimes
            keyFrameOnly:(BOOL)keyFrameOnly
           allowsCovered:(BOOL)allowsCovered;


/*
 通过SEI发生app附加信息，调用后，跟随之后的sei发送，主要用于连麦混流布局信息的传递。仅在关键帧前发送。
  sei 载荷类型100，内容类似 {"ts":1502857493753,"source":"TTLiveSDK_iOS”,"app_data":XXX}，ts：为时间戳，毫秒；source：字符串，来源。app_data 存储appData
 @param key 添加的key
 @param value 添加的value：支持类型NSNumber（int、double、bool）、NSString、NSDictionary（json），有类型检查，按需设置； 如果key为 nil，则从sei信息中移出，之后不会再发送
 @param repeatTimes  <0 表示重复发送无限次，直到从sei信息中移出
 */
- (int)sendSEIMsgWithKey:(NSString *)key
                   value:(NSObject *)value
             repeatTimes:(NSInteger)repeatTimes;

/**
 输入视频数据 (main track)

 @param pixelBufferRef 图像数据
 @param pts 时间戳(CMTime)
 */
- (void)pushVideoBuffer:(CVPixelBufferRef)pixelBufferRef
              andCMTime:(CMTime)pts;

/**
 输入视频数据及纹理id (main track)
 
 @param pixelBufferRef 图像数据
 @param pts 时间戳(CMTime)
 */
- (void)pushVideoBuffer:(CVPixelBufferRef)pixelBufferRef
                texture:(int32_t)textureId
              andCMTime:(CMTime)pts;


/**
 输入视频数据到对应 track
 
 @param tid 用于标志track的唯一标志符
 @param timestamp_ns （非 main track 可以输入0）
 @param rotation 角度(0、90、180 etc)
 */
- (void)pushVideoDataWithTrackId:(NSUInteger)tid
                       timestamp:(int64_t)timestamp_ns
                         yBuffer:(void *)yBuffer yStride:(int)yStride
                         uBuffer:(void *)uBuffer uStride:(int)uStride
                         vBuffer:(void *)vBuffer vStride:(int)vStride
                           width:(int)width
                          height:(int)height
                        rotation:(int)rotation;

/**
 输入视频数据到对应的 track
 
 @param buffer CVPixelBufferRef
 @param textureId 纹理id
 @param pts 时间戳(非 main track 可输入kCMTimeZero)
 @param tid 用于标志track的唯一标志符
 */
- (void)pushVideoBuffer:(CVPixelBufferRef)buffer
                texture:(int32_t)textureId
              andCMTime:(CMTime)pts
                trackId:(NSUInteger)tid;

/**
 刷新上一个视频帧
 
 @param pts 时间戳
 */
- (void)flushLastImageBufferWithTime:(CMTime)pts;

/**
 输入音频数据

 @param data 音频数据
 @param inNumberFrames 音频帧数量
 @param bytesPerSample 采样的字节数
 @param audioChannelCount 声道数
 @param sampleRate 采样率(例如：44100Hz)
 @param timestamp_us 时间戳(微秒)
 */
- (void)pushAudioBuffer:(uint8_t *)data
      andInNumberFrames:(int)inNumberFrames
      andBytesPerSample:(int)bytesPerSample
    andNumberOfChannels:(int)audioChannelCount
          andSampleRate:(int)sampleRate
         andTimestampUs:(int64_t)timestamp_us;

/**
 输入音频数据

 @param data 音频数据
 @param size 音频数据字节数
 @param inNumberFrames 音频帧数量
 @param pts 时间戳(CMTime)
 */
- (void)pushAudioBuffer:(uint8_t *)data
             andDataLen:(size_t)size
      andInNumberFrames:(int)inNumberFrames
              andCMTime:(CMTime)pts;


/**
 输入音频数据到对应的 track

 @param data 音频数据
 @param size 长度
 @param inNumberFrames frames数
 @param pts 时间戳 us
 @param trackId 用于标志音频track的唯一标志符
 */
- (void)pushAudioBuffer:(uint8_t *)data
             andDataLen:(size_t)size
      andInNumberFrames:(int)inNumberFrames
              timestamp:(int64_t)pts_us
                trackId:(int)trackId;

/**
输入音频数据到对应的 track，录屏直播专用
@param data 音频数据
@param size 长度
@param sampelRate 采样率
@param channels 信道数
@param bytesPerSample 每采样字节数
@param pts 时间戳 us
@param trackId 用于标志音频track的唯一标志符
*/
- (void)pushAudioBuffer:(uint8_t *)data
         andDataLen:(size_t)size
         sampelRate:(int)sampelRate
           channels:(int)channels
  andBytesPerSample:(int)bytesPerSample
          timestamp:(int64_t)pts
                trackId:(int)tid;

/**
输入编码压缩后的数据，录屏直播专用
@param data 视频压缩后的数据
@param timestamp 时间戳pts
@param dts 时间戳dts
@param videoFrameType 帧类型, 1: IDR帧  2:SPSPPS帧  3:B帧  4:P帧
*/
- (void)pushEncodedData:(uint8_t *)data size:(int)size timestamp:(int64_t)timestamp_us dts:(int64_t)dts videoFrameType:(int)videoFrameType;


- (EAGLContext *)getEAGLContext;

#pragma - mark DNSNodeSort
/**
 需要更新优选节点列表
 */
@property (nonatomic, copy) NSDictionary *(^shouldUpdateOptimumIPAddress)(NSString *host);

#pragma - Status
/**
 LiveStreamSession 是否为 running 推流状态(链接中/推流中)

 @return session 的状态
 */
- (BOOL)isRunning;

/**
 查找对应的推流信息

 @param name 键的名字，参考 LiveStreamInfoKeys
 @return 对应键名的InfoValue, 具体返回值请参考 LiveStreamInfoKeys
 */
- (id)getStreamInfoForKey:(NSString *)name;

/**
 获取实时统计信息
 
 @discussion
         外部定时调用查看推流信息，会有额外CPU占用，只做DEBUG使用
 
 @return 推流统计数据
 */
- (NSDictionary *)getStatistics;

#pragma mark - StreamMixer
@property (nonatomic, assign) BOOL enableAudioMixing;//是否支持多路音频混合处理,默认NO
@property (nonatomic, assign) BOOL enableVideoMixing;//是否支持多路视频帧混合处理,默认NO

- (void)addAudioSource:(LiveStreamLinkInfo *)linkInfo;

- (void)addVideoSource:(LiveStreamLinkInfo *)linkInfo;

// 需要再updateLinkInfo之前设置，否则会有一两帧布局异常
- (void)setMixerOutputSize:(CGSize)size;

- (void)removeVideoSource:(NSString *)uid;

// 0: audio 1: video
- (LSStreamMediaSource *)getSourceWithUID:(NSString *)uid streamType:(int)type;

- (LSStreamAudioSource *)getOriginAudioSource;
- (void)updateLinkInfo:(LSStreamMediaSource *)source;

/**
 !!! 该接口在推流运行状态下进行参数修改，谨慎使用
 具体字段见 LSStreamingParameterKey (LiveStreamDefines.h)
*/
- (void)updateTransportParamter:(NSString *)key value:(NSNumber *)value;
@end

@protocol LiveStreamSessionProtocol <NSObject>


@required
- (void) streamSession:(LiveStreamSession *)session onStatusChanged:(LiveStreamSessionState)state;

- (void) streamSession:(LiveStreamSession *)session onError:(LiveStreamErrorCode)error;

@end

@interface LiveStreamSession (Audio)

@property (nonatomic, readonly, assign) AudioStreamBasicDescription audioStreamBasicDescription;

@property (nonatomic, assign, getter=isEchoCancellationEnabled) BOOL echoCancellationEnabled;

- (void)updateAudioDeviceWithCapture:(LiveStreamCapture *)capture;

- (AudioSource *)getAudioSource;

@end

@interface LiveStreamSession (Debug)
/**
 设置debug等级 （默认为LiveStreamLogLevelInfo）
 */
- (void)setLogLevel:(LiveStreamLogLevel)level;

/**
 设置total rtmpk 模式

 @param enable 默认为NO
 */
- (void)setOnlyRTMPKMode:(BOOL)enable;

@end
