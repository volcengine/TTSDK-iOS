//
//  LiveStreamCapture.h
//  LiveStreamFramework
//
//  Created by KeeeeC on 2019/4/18.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "LiveStreamDefines.h"
#import "LiveStreamEffectDefines.h"

typedef void(^FetchEffectDetectResultCallback)(int result);

NS_ASSUME_NONNULL_BEGIN
@class LSLiveAlgorithmResultData;
@class LiveStreamSession;
@class LiveStreamCaptureConfig;
@interface LiveStreamCapture : NSObject

- (instancetype)initWithConfig:(LiveStreamCaptureConfig *)config;

+ (void)resetContext DEPRECATED_MSG_ATTRIBUTE("Use -stopVideoCapture instead");

/*
 开始采集/送入数据
 */
- (void)startVideoCapture;

/*
 停止并释放资源
 */
- (void)stopVideoCapture;

/*
 开启音频采集
 */
- (void)startAudioCapture;

/// 开启音频采集
/// @param needOpenAEC 传入是否需要回声消除
- (void)startAudioCapture:(BOOL)needOpenAEC;

/*
 关闭音频采集
 */
- (void)stopAudioCapture;

/*
 暂停/恢复音频采集
 */
- (void)audioCaptureInterrupted:(BOOL)bInterrupt;

/*
暂停/恢复音频播放
*/
- (void)audioPlayerInterrupted:(BOOL)bInterrupt;

/**
开/关 扬声器，默认走扬声器（NO:听筒 YES:扬声器）
*/
- (void)setEnableSpeaker:(BOOL)enable;

@property (nonatomic, assign) BOOL renderOnSingleView;

/**
 stopVideoCapture 情况下会释放内部，节省资源
 */
@property (nonatomic, assign) BOOL purgeMemoryIfNeeded;

/**
 摄像头方向信息
 */
@property (nonatomic, readwrite) AVCaptureDevicePosition cameraPosition;

/**
 设置外置输入源 pixel format
 */
@property (nonatomic, assign) OSType inPixelFmt;

/**
 外置输入源 图像旋转模式
 LSRotateModeRotateLeft | LSRotateModeRotateRight 会交换 outputSize的宽高
 */
@property (nonatomic, assign) LiveStreamRotateMode inRotateMode;

/**
 设置图形输出大小(默认与输入保持同样大小)
 */
@property (nonatomic, assign) CGSize outputSize;

@property (nonatomic, assign) CGSize mixerOutputSize;

/// 设置输出的裁剪size
- (void)setOutputCropSize:(CGSize)cropSize;

/**
 如需开启LiveGame，需要指定session对象
 */
@property (nonatomic, weak) LiveStreamSession *session;

- (EAGLContext *)getGLContext;

/**
 查看effect 模块是否开启
 
 @return BOOL
 */
- (BOOL)isEffectEnabled;

/**
 开启/关闭 effect 模块。默认未开启
 */
- (void)setEnableEffect:(BOOL)enable;

- (BOOL) isEffectEnabled:(LSLiveEffectType) type;

#pragma mark - Preview
/**
 开启预览
 
 @param view 承载预览的父视图
 */
- (UIView *)resetPreviewView:(UIView *)view;

/**
 设置预览视图大小

 @param rect 在父视图中的布局
 */
- (void)setPreviewFrame:(CGRect)rect;

/**
 获取预览视图
 */
- (UIView *)previewView;

/**
 设置当前采集模式
 */
typedef NS_ENUM(NSInteger, LSPreviewMode) {
    LSPreviewMode_Normal = 0,
    LSPreviewMode_GameInteract,
    LSPreviewMode_Gaming,
    LSPreviewMode_CameraGaming,
    LSPreviewMode_EffectInteractGame,
};
@property (nonatomic, assign) LSPreviewMode previewMode;

@property (nonatomic, readonly, assign) AudioStreamBasicDescription audioStreamBasicDescription;
@property (nonatomic, assign, getter=isEchoCancellationEnabled) BOOL echoCancellationEnabled;
@property (nonatomic, assign) BOOL audioEffectSpeakerEnable;

/**
 设置推流镜像
*/
- (void)setStreamMirror:(BOOL)bMirror;

@property(nonatomic, assign) int cameraLayer;
/**
 预览绘制首帧回调
 */
@property (nonatomic, copy) void(^firstFrameRenderCallback)(BOOL success, int64_t pts, uint32_t err_no);

/**
 采集的音频数据回调，请避免耗时操作
 */
@property (nonatomic, copy) void(^ __nullable didCapturedAudioBufferList)(
                                            AudioBufferList *audioData,
                                            const AudioTimeStamp *inTimeStamp,
                                            UInt32          numberOfFrames,
                                            AudioBufferList *processedData,
                                            AudioBufferList *headphonesMonitoringData);

#pragma mark - Callback
/**
 输入视频数据
    默认输入到 camera layer(layerId 为0)

 @param pixelBufferRef imageBuffer
 @param pts 时间戳
 */
- (void)pushVideoBuffer:(CVPixelBufferRef)pixelBufferRef
              andCMTime:(CMTime)pts;

- (void)pushVideoBuffer:(CVPixelBufferRef)pixelBufferRef
              withCMTime:(CMTime)pts
                toLayer:(GLint)layerId;

- (void)forceDisplayTexture:(int)textureId
                      width:(NSInteger)width
                     height:(NSInteger)height
                        pts:(CMTime)pts
                    layerId:(int)layerId;

- (void)pushVideoTexture:(int)textureId
                   width:(NSInteger)width
                  height:(NSInteger)height
                     pts:(CMTime)pts
                 toLayer:(int)layerId;
/**
 处理后的视频数据回调信息
 */
- (void)setVideoProcessedCallback:(void (^ _Nullable)(CVPixelBufferRef _Nonnull buffer, GLint texture, CMTime pts))videoProcessedCallback;

/**
获取音频信息使用AudioDevcie播放
 */
- (void)setGetAudioCallback:(void (^ _Nullable)(void * _Nonnull buffer, int bufferSize, int frames, int bytesPerSample, int channels, int sampleRate))getAudioCallback;

#pragma mark - Bypass

/**
 开启/关闭 旁路推流(bypass). 设置输出大小及格式

 @param size 图像大小
 @param fmt 像素格式
 @param enable 开启/关闭
 */
- (void)setBypassOutputSize:(CGSize)size pixelFormat:(OSType)fmt enable:(BOOL)enable;

- (void)setBypassOutputSize:(CGSize)size pixelFormat:(OSType)fmt enable:(BOOL)enable isLandscapeVideo:(BOOL)isLandscapeVideo;
/**
 @param bypassCallback 旁路推流(bypass)数据回调
 */
- (void)setVideoProcessedBypassCallback:(void (^ _Nonnull)(CVPixelBufferRef _Nonnull buffer, CMTime pts))bypassCallback;

typedef void(^EffectInfoBlock_t)(void *a, void *b);
@property (nonatomic, copy) void(^effectInfoBlck)(void *framebuffer, CMTime frametime, EffectInfoBlock_t(^)(void));

#pragma mark - Effect
- (void)fetchEffectDetectPhotoContentWithImage:(UIImage *)image algorithmType:(NSString *) algorithmType isLastPhone:(BOOL)isLastPhone callback:(FetchEffectDetectResultCallback)callback;

- (void)setEffectRenderCacheTextureWithImage:(UIImage *)image algorithmType:(NSString *) algorithmType;

@end

@interface LiveStreamCapture (Interact)

/**
 增加输入源

 @param rect 设置绘制rect
 @param layerId layer 的唯一标识符
 
 @discussion
    按照layerId 递增顺序进行绘制(camera layer 为 0),请按照递增配置layerId
 */
- (void)addVideoInput:(CGRect)rect forLayer:(int)layerId;

- (void)addVideoInput:(CGRect)rect
             fillMode:(LSRenderMode)mode
               zOrder:(int)zOrder
             forLayer:(int)layerId
             rotation:(LiveStreamRotateMode)rotate;
/**
 设置触发合流的 layerId
 */
- (void)setMixerTriggerLayer:(int)layerId;

- (void)updateVideoRect:(CGRect)rect forLayer:(int)layerId animated:(BOOL)animated frames:(int)frames;
/**
 移除输入源

 @param layerId layer 的唯一标识符
 */
- (void)removeVideoInput:(int)layerId;

/**
  set mixer‘s canvas color
 @param colorString canvas背景颜色，支持格式 "#000000" OR "000000"
 */
- (void)setCanvasColor:(NSString *)colorString;
@end


@interface LiveStreamCapture (ReducedMode)

typedef NS_ENUM(NSInteger, LSCaptureMode) {
    LSCaptureEffectMode,    // 特效模式(Default)
    LSCaptureReducedMode    // 精简模式
};

/**
 根据采集、渲染模式创建capture
 默认为 LSCaptureEffectMode 带有整套特效渲染链
 @param config capture 参数配置透传
 @param mode 采集、渲染模式
 */
- (instancetype)initWithMode:(LSCaptureMode)mode config:(LiveStreamCaptureConfig *)config;

@end

#pragma LiveStreamCaptureConfig
typedef NS_ENUM(NSInteger, LiveStreamPreviewMode) {
    LiveStreamPreviewMode_LIVE = 0,
    LiveStreamPreviewMode_PK = 1,
    LiveStreamPreviewMode_GAME = 2
};

@interface LiveStreamCaptureConfig : NSObject
// 采集预览模式
@property (nonatomic, assign) LiveStreamPreviewMode mode;
@property (nonatomic, assign) BOOL useExternalCamera;

@property (nonatomic, assign) BOOL useNewEffectLabAPI;
@property (nonatomic, assign) BOOL useAmazing;
@property (nonatomic, copy) NSString *effectPlatformConfig;
@property (nonatomic, copy) NSString *effectLicense; //effect 场景属性

/**
 canvas's background color. Default is dark(#000000)
 */
@property (nonatomic, copy) NSString *backgroundColorOfCanvas;

+ (LiveStreamCaptureConfig *)defaultConfig;
@end

@interface LiveStreamCapture(DumpRawData)
- (void)startRecordingWithDuration:(NSTimeInterval)duration
                             delay:(NSTimeInterval)delay
                               fps:(NSUInteger)fps
                WithCompletionHandler:(void (^)(NSError * _Nonnull error, int type, NSURL * _Nonnull url))completionHandler;

- (void)resetRecording;
- (BOOL)dumpIsFinished;

- (void) setEffectRecordPath:(NSString *)filePath;


- (void) startRecordingWav:(NSInteger) ticketId maxRecordingDuration:(float) recordingSeconds withCompleteHandler:(void (^)(NSString *audioURL, NSInteger ticketId, NSError *error)) completionHandler;
 
- (void) stopRecordingWav:(void (^)(NSString *audioURL, NSInteger ticketId, NSError *error)) completionHandler;
@end

@interface LiveStreamCapture (statistic)
- (NSDictionary *)getStatisticInfo;
- (void)checkAudioIOPipeline;
@end

@interface LiveStreamCapture (SpeechRecognizing)
/**
 * 开启/关闭语音识别
 */
- (void)startSpeechRecognizing;
- (void)stopSpeechRecognizing;
- (BOOL)isSpeechRecognizing;

- (void)setEnableAudioEffect:(BOOL)enable;
@property (nonatomic, copy) void(^speechRecognizeCallback)(NSInteger _id, NSString *info);



@end

NS_ASSUME_NONNULL_END
