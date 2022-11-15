#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <UIKit/UIKit.h>

@interface LSCamera : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>
{
    AVCaptureSession *_captureSession;
    AVCaptureDevice *_camera;
    AVCaptureDevice *_microphone;
    AVCaptureDeviceInput *deviceInput;
    AVCaptureVideoDataOutput *videoDataOutput;
}

/// Whether or not the underlying AVCaptureSession is running
@property(readonly, nonatomic) BOOL isRunning;

/// The AVCaptureSession used to capture from the camera
@property(readonly, retain, nonatomic) AVCaptureSession *captureSession;

/// This enables the capture session preset to be changed on the fly
@property (readwrite, nonatomic, copy) NSString *captureSessionPreset;

/** 采集帧率 */
@property (readwrite) int32_t frameRate;

/** 输出图像的像素格式 有效值 为 NV12 和BGRA
  - kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
  - kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
  - kCVPixelFormatType_32BGRA
 */
@property (readwrite) OSType outputPixelFmt;

/// Easy way to tell which cameras are present on device
@property (readonly, getter = isFrontFacingCameraPresent) BOOL frontFacingCameraPresent;
/// Easy way to tell which cameras are present on device
@property (readonly, getter = isBackFacingCameraPresent) BOOL backFacingCameraPresent;

/// Use this property to manage camera settings. Focus point, exposure point, etc.
@property(readonly) AVCaptureDevice *inputCamera;

/// This determines the rotation applied to the output image, based on the source material
@property(readwrite, nonatomic) UIInterfaceOrientation outputImageOrientation;

/// These properties determine whether or not the two camera orientations should be mirrored. By default, (YES, NO).
@property(readwrite, nonatomic) BOOL bMirrorFrontCamera, bMirrorRearCamera;

/// 后置摄像头是否存在
+ (BOOL)isBackFacingCameraPresent;
/// 前置摄像头是否存在
+ (BOOL)isFrontFacingCameraPresent;

/** UIInterfaceOrientation 转为 AVCaptureVideoOrientation
 @param orien UI 的朝向,比如状态栏相对Home键的位置
 */
+ (AVCaptureVideoOrientation) uiOrientationToAVOrientation: (UIInterfaceOrientation) orien;

/// @name Initialization and teardown

/** Begin a capture session
 
 See AVCaptureSession for acceptable values
 
 @param sessionPreset Session preset to use
 @param cameraPosition Camera to capture from
 */
- (id)initWithSessionPreset:(NSString *)sessionPreset
             cameraPosition:(AVCaptureDevicePosition)cameraPosition;

/** Add audio capture to the session. Adding inputs and outputs freezes the capture session momentarily, so you
    can use this method to add the audio inputs and outputs early, if you're going to set the audioEncodingTarget 
    later. Returns YES is the audio inputs and outputs were added, or NO if they had already been added.
 */
- (BOOL)addAudioInputsAndOutputs;

/** Remove the audio capture inputs and outputs from this session. Returns YES if the audio inputs and outputs
    were removed, or NO is they hadn't already been added.
 */
- (BOOL)removeAudioInputsAndOutputs;

/** Tear down the capture session
 */
- (void)removeInputsAndOutputs;

/// @name Manage the camera video stream

/** Start camera capturing
 */
- (void)startCameraCapture;

/** Stop camera capturing
 */
- (void)stopCameraCapture;

/** Pause camera capturing
 */
- (void)pauseCameraCapture;

/** Resume camera capturing
 */
- (void)resumeCameraCapture;

/** Get the position (front, rear) of the source camera
 */
- (AVCaptureDevicePosition)cameraPosition;

/** Get the AVCaptureConnection of the source camera
 */
- (AVCaptureConnection *)videoCaptureConnection;

/** This flips between the front and rear cameras
 */
- (void)rotateCamera;

/**
 @abstract   查询实际的采集分辨率
 @discussion 参见iOS的 AVCaptureSessionPresetXXX的定义
 */
- (CGSize) captureDimension;

#pragma mark - raw data
/**
 @abstract   视频处理回调接口
 @discussion sampleBuffer 原始采集到的视频数据
 @discussion 请注意本函数的执行时间，如果太长可能导致不可预知的问题
 @discussion 请参考 CMSampleBufferRef
 */
@property(nonatomic, copy) void(^videoProcessingCallback)(CMSampleBufferRef sampleBuffer);

/**
 @abstract   采集被打断的消息通知
 @discussion bInterrupt 为YES, 表明被打断, 采集暂停
 @discussion bInterrupt 为NO, 表明恢复采集
 */
@property(nonatomic, copy) void(^interruptCallback)(BOOL bInterrupt);

@end
