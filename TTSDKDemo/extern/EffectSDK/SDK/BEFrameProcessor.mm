// Copyright (C) 2018 Beijing Bytedance Network Technology Co., Ltd.
#import "BEFrameProcessor.h"
#import <CoreMotion/CoreMotion.h>
#import <OpenGLES/ES2/glext.h>
#import "bef_effect_ai_api.h"
#import "bef_effect_ai_yuv_process.h"

#import "BERender.h"
#import <memory>
#import "BEEffectManager.h"
#import "BEResourceHelper.h"
#import "BEMacro.h"

@implementation BEProcessResult
@end

@interface BEFrameProcessor() {
    
    EAGLContext *_glContext;

    BOOL                    _effectOn;
    BEEffectManager         *_effectManager;
    BERender                *_render;
    BEResourceHelper        *_resourceHelper;

    unsigned char           *_pixelBuffPointer;
    unsigned char           *_buffOutPointer;
    unsigned int            _pixelBufferPointerLength;
    unsigned int            _buffOutPointerLength;
    BOOL                    _shouldResetComposer;
}

@end

@implementation BEFrameProcessor

/**
 * license有效时间2019-03-01到2019-04-30
 * license只是为了追踪使用情况，可以随时申请无任何限制license
 */

- (instancetype)initWithContext:(EAGLContext *)context resourceDelegate:(id<BEResourceHelperDelegate>)delegate  {
    self = [super init];
    if (self) {
        _glContext = context;
        
        _pixelBuffPointer = NULL;
        _buffOutPointer = NULL;
        _effectOn = YES;
        _shouldResetComposer = YES;
        
        _effectManager = [[BEEffectManager alloc] init];
        _render = [[BERender alloc] init];
        _resourceHelper = [[BEResourceHelper alloc] init];
        _resourceHelper.delegate = delegate;

        [self _setupEffectSDK:[_resourceHelper licensePath] model:[_resourceHelper modelDirPath] composer:[_resourceHelper composerPath]];
    }
    return self;
}

/*
 * 初始化SDK
 */
- (void)_setupEffectSDK:(NSString *)license model:(NSString *)model composer:(NSString *)composer {
    [_effectManager setupEffectManagerWithLicense:license model:model composer:composer];
}

- (void)_releaseSDK {
    // 要在opengl上下文中调用
    [_effectManager releaseEffectManager];
}

//- (void)reset {
//    NSLog(@"BEFrameProcessor reset");
//    [self _releaseSDK];
//    [self _setupEffectSDK];
//}

- (void)dealloc {
    NSLog(@"BEFrameProcessor dealloc %@", NSStringFromSelector(_cmd));
    [EAGLContext setCurrentContext:_glContext];
    [self _releaseSDK];
    free(_pixelBuffPointer);
    free(_buffOutPointer);
}

/*
 * 帧处理流程
 */
- (BEProcessResult *)process:(CVPixelBufferRef)pixelBuffer timeStamp:(double)timeStamp{
    BEProcessResult *result = [[BEProcessResult alloc] init];
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    unsigned char *baseAddress = (unsigned char *) CVPixelBufferGetBaseAddress(pixelBuffer);
    int bytesPerRow = (int) CVPixelBufferGetBytesPerRow(pixelBuffer);
    int width = (int) CVPixelBufferGetWidth(pixelBuffer);
    int height = (int) CVPixelBufferGetHeight(pixelBuffer);

    //设置后续美颜以及其他识别功能的基本参数
    [_effectManager setWidth:width height:height orientation:[self getDeviceOrientation]];

    size_t iTop, iBottom, iLeft, iRight;
    CVPixelBufferGetExtendedPixels(pixelBuffer, &iLeft, &iRight, &iTop, &iBottom);

    width = width + (int) iLeft + (int) iRight;
    height = height + (int) iTop + (int) iBottom;
    bytesPerRow = bytesPerRow + (int) iLeft + (int) iRight;

    baseAddress = [self preProcessBuffer:baseAddress width:width height:height bytePerRow:bytesPerRow];
    
    // 设置 OpenGL 环境 , 需要与初始化 SDK 时一致
    if ([EAGLContext currentContext] != _glContext) {
        [EAGLContext setCurrentContext:_glContext];
    }
    GLuint textureResult;
    if (_effectOn) {
        //为美颜，瘦脸，滤镜分配输出纹理
        [_effectManager genInputAndOutputTexture:baseAddress width:width height:height];
        //美颜，瘦脸，滤镜的渲染， 返回渲染后的纹理
        textureResult = [_effectManager processInputTexture:timeStamp];
    } else {
        textureResult = [_effectManager genOutputTexture:baseAddress width:width height:height];
    }

    result.texture = textureResult;
//    result.rawData = [self transforTextureToRawData:textureResult width:width height:height];
    result.pixelBuffer = [self transforTextureToCVPixelBuffer:textureResult pixelBuffer:pixelBuffer width:width height:height bytesPerRow:bytesPerRow];
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    result.size  = CGSizeMake(width, height);
    return result;
}

- (unsigned char *)preProcessBuffer:(unsigned char *)buffer width:(int)width height:(int)height bytePerRow:(int)bytesPerRow {
    int realBytesPerRow = width * 4;
    if (bytesPerRow == realBytesPerRow) {
        return buffer;
    }

    if(_pixelBuffPointer == NULL) {
        _pixelBuffPointer = (unsigned char*)malloc(width*height*4*(sizeof(unsigned char)));
        _pixelBufferPointerLength = width * height * 4;
    } else if (width * height * 4 != _pixelBufferPointerLength) {
        free(_pixelBuffPointer);
        _pixelBuffPointer = (unsigned char *)malloc(width * height * 4);
        _pixelBufferPointerLength = width * height * 4;
    }

    unsigned char* to = _pixelBuffPointer;
    unsigned char* from = buffer;
    for(int i =0; i<height; i++) {
        memcpy(to, from, realBytesPerRow);
        to = to  + realBytesPerRow;
        from = from + bytesPerRow;
    }
    return _pixelBuffPointer;
}

- (unsigned char *)transforTextureToRawData:(GLuint)texture width:(int)width height:(int)height {
    if(_buffOutPointer == NULL) {
        _buffOutPointer = (unsigned char *)malloc(width * height * 4 * sizeof(unsigned char));
        _buffOutPointerLength = width * height * 4;
    } else if (_buffOutPointerLength != width * height * 4) {
        free(_buffOutPointer);
        _buffOutPointer = (unsigned char *)malloc(width * height * 4 * sizeof(unsigned char));
        _buffOutPointerLength = width * height * 4;
    }

    [_render transforTextureToImage:texture buffer:_buffOutPointer width:width height:height format:GL_RGBA];
    return _buffOutPointer;
}

- (CVPixelBufferRef)transforTextureToCVPixelBuffer:(GLuint)texture pixelBuffer:(CVPixelBufferRef)pixelBuffer width:(int)width height:(int)height bytesPerRow:(int)bytesPerRow {
    if(_buffOutPointer == NULL) {
        _buffOutPointer = (unsigned char *)malloc(width * height * 4 * sizeof(unsigned char));
        _buffOutPointerLength = width * height * 4;
    } else if (_buffOutPointerLength != width * height * 4) {
        free(_buffOutPointer);
        _buffOutPointer = (unsigned char *)malloc(width * height * 4 * sizeof(unsigned char));
        _buffOutPointerLength = width * height * 4;
    }

    [_render transforTextureToImage:texture buffer:_buffOutPointer width:width height:height format:GL_BGRA];
    unsigned char *baseAddres = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);
    unsigned char *from = _buffOutPointer;
    int realBytesPerRow = width * 4;
    if (bytesPerRow == realBytesPerRow) {
        memcpy(baseAddres, from, realBytesPerRow * height);
    } else {
        for (int i = 0; i < height; i++) {
            memcpy(baseAddres, from, realBytesPerRow);
            baseAddres += bytesPerRow;
            from += realBytesPerRow;
        }
    }

    return pixelBuffer;
}

- (long) currentTimeInMillis {
    return [[NSDate date] timeIntervalSince1970] * 1000;
}

/*
 * 设置滤镜强度
 */
-(void)setFilterIntensity:(float)intensity{
    [_effectManager setFilterIntensity:intensity];
}

/*
 * 设置贴纸资源
 */
- (void)setStickerPath:(NSString *)path{
    if (path != nil && ![path isEqualToString:@""]) {
        _shouldResetComposer = true;
    }
    [_effectManager setStickerPath:path];
}

- (void)setComposerMode:(int)mode {
    _composerMode = mode;
    [_effectManager setComposerMode:mode];
}

- (void)updateComposerNodes:(NSArray<NSString *> *)nodes {
    [self be_checkAndSetComposer];
    
    [_effectManager updateComposerNodes:nodes];
}

- (void)updateComposerNodeIntensity:(NSString *)node key:(NSString *)key intensity:(CGFloat)intensity {
    [_effectManager updateComposerNodeIntensity:node key:key intensity:intensity];
}

/*
 * 设置滤镜资源路径和系数
 */
- (void)setFilterPath:(NSString *)path {
    [_effectManager setFilterPath:path];
}

/*
 * 获取设备旋转角度
 */
- (int)getDeviceOrientation {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            return BEF_AI_CLOCKWISE_ROTATE_0;

        case UIDeviceOrientationPortraitUpsideDown:
            return BEF_AI_CLOCKWISE_ROTATE_180;

        case UIDeviceOrientationLandscapeLeft:
            return BEF_AI_CLOCKWISE_ROTATE_270;

        case UIDeviceOrientationLandscapeRight:
            return BEF_AI_CLOCKWISE_ROTATE_90;

        default:
            return BEF_AI_CLOCKWISE_ROTATE_0;
    }
}


- (void)setEffectOn:(BOOL)on
{
    _effectOn = on;
}

- (NSArray<NSString *> *)availableFeatures {
    return [_effectManager availableFeatures];
}

- (NSString *)sdkVersion {
    return [_effectManager sdkVersion];
}

- (BEResourceHelper *)resourceHelper {
    return _resourceHelper;
}

#pragma mark - private
- (void)be_checkAndSetComposer {
    if ([self be_shouldResetComposer]) {
        [_effectManager initEffectCompose:[_resourceHelper composerPath]];
        _shouldResetComposer = false;
    }
}

- (BOOL)be_shouldResetComposer {
    return _shouldResetComposer && _composerMode == 0;
}

@end

