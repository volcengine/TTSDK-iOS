#import "LSCamera.h"

#pragma mark -
#pragma mark Private methods and instance variables

@interface LSCamera ()  {
	AVCaptureDeviceInput *audioInput;
	AVCaptureAudioDataOutput *audioOutput;
    NSDate *startingCaptureTime;
    dispatch_queue_t cameraProcessingQueue, audioProcessingQueue;
    BOOL isFullYUVRange;
    BOOL addedAudioInputsDueToEncodingTarget;
    
    BOOL               _capturePaused;
    BOOL               _bRotatingCam;
    AVCaptureTorchMode _torchMode;
    BOOL               _bCapturing;
    NSLock          *  _camLock;
}
@end

@implementation LSCamera

@synthesize captureSessionPreset = _captureSessionPreset;
@synthesize captureSession = _captureSession;
@synthesize inputCamera = _camera;
@synthesize outputImageOrientation = _outputImageOrientation;
@synthesize bMirrorFrontCamera = _bMirrorFrontCamera;
@synthesize bMirrorRearCamera  = _bMirrorRearCamera;
@synthesize frameRate = _frameRate;
@synthesize outputPixelFmt = _outputPixelFmt;

#pragma mark -
#pragma mark Initialization and teardown

- (instancetype)init {
    if (!(self = [self initWithSessionPreset:AVCaptureSessionPreset640x480
                              cameraPosition:AVCaptureDevicePositionBack])) {
		return nil;
    }
    return self;
}

- (instancetype)initWithSessionPreset:(NSString *)sessionPreset
             cameraPosition:(AVCaptureDevicePosition)cameraPosition {
	if (!(self = [super init])){
		return nil;
    }
    cameraProcessingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0);
	audioProcessingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0);
	_frameRate = 15; // 为0 表示使用默认分辨率
    _capturePaused = NO;
    
	// Grab the back-facing or front-facing camera
    _camera = nil;
	NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	for (AVCaptureDevice *device in devices) {
		if ([device position] == cameraPosition) {
			_camera = device;
            break;
		}
	}
    if (!_camera) {
        return nil;
    }
	// Create the capture session
	_captureSession = [[AVCaptureSession alloc] init];
    [_captureSession beginConfiguration];
    
	// Add the video input	
	NSError *error = nil;
	deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:_camera error:&error];
	if ([_captureSession canAddInput:deviceInput]){
		[_captureSession addInput:deviceInput];
	}
    // check preset
    if ( [_captureSession canSetSessionPreset:sessionPreset] == NO ) {
        _captureSession = nil;
        return nil;
    }
	// Add the video frame output
	videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
	[videoDataOutput setAlwaysDiscardsLateVideoFrames:NO];
    
    [self setOutputPixelFmt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange];
    [videoDataOutput setSampleBufferDelegate:self queue:cameraProcessingQueue];
	if ([_captureSession canAddOutput:videoDataOutput]) {
		[_captureSession addOutput:videoDataOutput];
	}
	else {
		NSLog(@"Couldn't add video output");
        return nil;
	}
	_captureSessionPreset = sessionPreset;
    [_captureSession setSessionPreset:_captureSessionPreset];
    [self setBMirrorRearCamera:NO];
    [self setBMirrorFrontCamera:YES];
    [_captureSession commitConfiguration];
    [self reconfigCamera];
    _camLock = [[NSLock alloc] init];
    _bCapturing    = NO;
    _videoProcessingCallback = nil;
    _interruptCallback       = nil;
    [self addKVO];
	return self;
}

- (void)dealloc {
    [self rmKVO];
    self.videoProcessingCallback = nil;
    [self stopCameraCapture];
    [videoDataOutput setSampleBufferDelegate:nil queue:dispatch_get_main_queue()];
    [audioOutput setSampleBufferDelegate:nil queue:dispatch_get_main_queue()];
    [self removeInputsAndOutputs];
}

- (void)addKVO {
    NSKeyValueObservingOptions opts = 0;
    opts |= NSKeyValueObservingOptionNew;
    opts |= NSKeyValueObservingOptionOld;
    void * ctx = (__bridge void * _Nullable)(self);
    [_captureSession addObserver:self
                      forKeyPath:@"interrupted"
                         options:opts
                         context:ctx];
}
- (void)rmKVO {
    @try {
        void * ctx = (__bridge void * _Nullable)(self);
        [_captureSession removeObserver:self
                             forKeyPath:@"interrupted"
                                context:ctx];
    }
    @catch (NSException * __unused exception){}
}

- (BOOL)addAudioInputsAndOutputs {
    if (audioOutput)
        return NO;
    [_captureSession beginConfiguration];

    _microphone = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    audioInput = [AVCaptureDeviceInput deviceInputWithDevice:_microphone error:nil];
    if ([_captureSession canAddInput:audioInput]){
        [_captureSession addInput:audioInput];
    }
    audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    
    if ([_captureSession canAddOutput:audioOutput]){
        [_captureSession addOutput:audioOutput];
    }
    else{
        NSLog(@"Couldn't add audio output");
    }
    [audioOutput setSampleBufferDelegate:self queue:audioProcessingQueue];
    
    [_captureSession commitConfiguration];
    [self reconfigCamera];
    return YES;
}

- (BOOL)removeAudioInputsAndOutputs {
    if (!audioOutput)
        return NO;
    [_captureSession beginConfiguration];
    [_captureSession removeInput:audioInput];
    [_captureSession removeOutput:audioOutput];
    audioInput = nil;
    audioOutput = nil;
    _microphone = nil;
    [_captureSession commitConfiguration];
    return YES;
}

- (void)removeInputsAndOutputs {
    [_captureSession beginConfiguration];
    if (deviceInput) {
        [_captureSession removeInput:deviceInput];
        [_captureSession removeOutput:videoDataOutput];
        deviceInput = nil;
        videoDataOutput = nil;
    }
    if (_microphone != nil) {
        [_captureSession removeInput:audioInput];
        [_captureSession removeOutput:audioOutput];
        audioInput = nil;
        audioOutput = nil;
        _microphone = nil;
    }
    [_captureSession commitConfiguration];
}

#pragma mark -
#pragma mark Manage the camera video stream

- (void)startCameraCapture {
    if (![_captureSession isRunning])	{
        [_camLock lock];
        startingCaptureTime = [NSDate date];
		[_captureSession startRunning];
        [_camLock unlock];
	}
}

- (void)stopCameraCapture {
    if ([_captureSession isRunning])    {
        [_camLock lock];
        [_captureSession stopRunning];
        [_camLock unlock];
    }
}

- (void)pauseCameraCapture {
    _capturePaused = YES;
}

- (void)resumeCameraCapture {
    _capturePaused = NO;
}

- (void)rotateCamera {
    if (deviceInput == nil) {
        return;
    }
    AVCaptureDevicePosition currentCameraPosition = [[deviceInput device] position];
    AVCaptureDevice *backFacingCamera = nil;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	for (AVCaptureDevice *device in devices)  {
		if ([device position] != currentCameraPosition) {
			backFacingCamera = device;
            break;
		}
	}
    if (backFacingCamera == nil) {
        return;
    }
    NSError *error;
    AVCaptureDeviceInput *newInput;
    newInput = [[AVCaptureDeviceInput alloc] initWithDevice:backFacingCamera error:&error];
    if (newInput != nil) {
        _bRotatingCam = YES;
        [_captureSession beginConfiguration];
        [_captureSession removeInput:deviceInput];
        if ([_captureSession canAddInput:newInput]) {
            [_captureSession addInput:newInput];
            deviceInput = newInput;
        }
        else {
            [_captureSession addInput:deviceInput];
        }
        _camera = backFacingCamera;
        self.bMirrorRearCamera  = _bMirrorRearCamera;
        self.bMirrorFrontCamera = _bMirrorFrontCamera;
        [_captureSession commitConfiguration];
        [self reconfigCamera];
        _bRotatingCam = NO;
    }
}

- (AVCaptureDevicePosition)cameraPosition {
    return [[deviceInput device] position];
}

- (BOOL)isRunning {
    if(_captureSession)
        return [_captureSession isRunning];
    return NO;
}

+ (BOOL)isBackFacingCameraPresent {
	NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	for (AVCaptureDevice *device in devices) {
		if ([device position] == AVCaptureDevicePositionBack)
			return YES;
	}
	return NO;
}

- (BOOL)isBackFacingCameraPresent {
    return [LSCamera isBackFacingCameraPresent];
}

+ (BOOL)isFrontFacingCameraPresent {
	NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	for (AVCaptureDevice *device in devices){
		if ([device position] == AVCaptureDevicePositionFront)
			return YES;
	}
	return NO;
}

- (BOOL)isFrontFacingCameraPresent {
    return [LSCamera isFrontFacingCameraPresent];
}

- (void)setCaptureSessionPreset:(NSString *)captureSessionPreset {
    BOOL canSet = [_captureSession canSetSessionPreset:captureSessionPreset];
    if (canSet == NO){
        return;
    }
	[_captureSession beginConfiguration];
	_captureSessionPreset = captureSessionPreset;
	[_captureSession setSessionPreset:_captureSessionPreset];
	[_captureSession commitConfiguration];
    [self reconfigCamera];
}

- (void) reconfigCamera {
    if (videoDataOutput == nil){
        return;
    }
    [self setOutputImageOrientation:_outputImageOrientation];
    [self setFrameRate:_frameRate];
}

- (void)setOutputImageOrientation:(UIInterfaceOrientation)newValue {
    if(self.videoCaptureConnection &&
       [self.videoCaptureConnection isVideoOrientationSupported]){
        AVCaptureVideoOrientation newOri = [[self class] uiOrientationToAVOrientation:newValue];
        AVCaptureVideoOrientation oldOri = self.videoCaptureConnection.videoOrientation;
        if ( oldOri != newOri) {
            [self.videoCaptureConnection setVideoOrientation:newOri];
            [self setFrameRate:_frameRate];
        }
    }
    _outputImageOrientation = newValue;
}

- (void)setBMirrorFrontCamera:(BOOL)newValue {
    _bMirrorFrontCamera = newValue;
    if ( [_camera position] == AVCaptureDevicePositionFront){
        if ( [self.videoCaptureConnection isVideoMirroringSupported]) {
            self.videoCaptureConnection.videoMirrored = newValue;
        }
    }
}

- (void)setBMirrorRearCamera:(BOOL)newValue {
    _bMirrorRearCamera = newValue;
    if ( [_camera position] == AVCaptureDevicePositionBack){
        if ( [self.videoCaptureConnection isVideoMirroringSupported]) {
            self.videoCaptureConnection.videoMirrored = newValue;
        }
    }
}


+ (AVCaptureVideoOrientation)uiOrientationToAVOrientation:(UIInterfaceOrientation)orien {
    switch (orien) {
        case UIInterfaceOrientationPortraitUpsideDown:
            return AVCaptureVideoOrientationPortraitUpsideDown;
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
        default:
            return AVCaptureVideoOrientationPortrait;
    }
}



- (int32_t) getMaxFrameRate {
    return 30;
}
- (int32_t) getMinFrameRate {
    if (_camera == nil) {
        return 1;
    }
    int32_t minFps = 300;
    NSArray *ranges;
    ranges = [_camera.activeFormat videoSupportedFrameRateRanges];
    for (AVFrameRateRange* range in ranges ) {
        minFps = MIN( range.minFrameRate, minFps);
    }
    return minFps;
}

- (void)setFrameRate:(int32_t)frameRate {
    if (frameRate < 0){
        return;
    }
    // get max fps
    int maxFPS = [self getMaxFrameRate];
    int minFPS = [self getMinFrameRate];
    frameRate = MIN(maxFPS, frameRate);
    frameRate = MAX(minFPS, frameRate);
	_frameRate = frameRate;
    NSError *error;
    [_camera lockForConfiguration:&error];
    if (error == nil) {
        [_camera setActiveVideoMinFrameDuration:CMTimeMake(1, _frameRate)];
        [_camera setActiveVideoMaxFrameDuration:CMTimeMake(1, _frameRate)];
    }
    [_camera unlockForConfiguration];
}

- (int32_t)frameRate {
	return _frameRate;
}

- (void)setOutputPixelFmt:(OSType)outputPixelFmt{
    if(outputPixelFmt != kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange &&
       outputPixelFmt != kCVPixelFormatType_420YpCbCr8BiPlanarFullRange &&
       outputPixelFmt != kCVPixelFormatType_32BGRA) {
        return;
    }
    _outputPixelFmt = outputPixelFmt;
    NSNumber *pixelFmt =[NSNumber numberWithInt:_outputPixelFmt];
    NSDictionary* vSettings =[NSDictionary dictionaryWithObject: pixelFmt forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [videoDataOutput setVideoSettings: vSettings];
}

- (OSType)outputPixelFmt{
    return _outputPixelFmt;
}

- (AVCaptureConnection *)videoCaptureConnection {
    for (AVCaptureConnection *connection in [videoDataOutput connections]) {
		for (AVCaptureInputPort *port in [connection inputPorts] ) {
			if ( [[port mediaType] isEqual:AVMediaTypeVideo] ) {
				return connection;
			}
		}
	}
    return nil;
}

/**
 @abstract   查询实际的采集分辨率
 @discussion 参见iOS的 AVCaptureSessionPresetXXX的定义
 */
- (CGSize) captureDimension {
    if (_camera){
        CMVideoDimensions dim;
        dim = CMVideoFormatDescriptionGetDimensions(_camera.activeFormat.formatDescription);
        return CGSizeMake(dim.width, dim.height);
    }
    return CGSizeZero;
}

#pragma mark -
#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    if (!self.captureSession.isRunning ||
        _capturePaused) {
        return;
    } else if (captureOutput == audioOutput) {
        //
    } else {
        [self processVideoSampleBuffer:sampleBuffer];
    }
}

- (void)processVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    if (_bRotatingCam) {
        return;
    }
    [_camLock lock];
    if( _videoProcessingCallback ){
        _videoProcessingCallback(sampleBuffer);
    }
    [_camLock unlock];
}


#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqual:@"interrupted"] == NO) {
        return;
    }
    if (_interruptCallback){
        _interruptCallback(_captureSession.interrupted);
    }
}

@end
