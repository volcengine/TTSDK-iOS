// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.

#import <Foundation/Foundation.h>
#import "BERenderHelper.h"
#import "BERender.h"
#import "bef_effect_ai_public_define.h"
#import "bef_effect_ai_api.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/glext.h>
#import "BEMacro.h"

@interface BERender () {
    BERenderHelper *renderHelper;
    GLuint _frameBuffer;
    GLuint _textureInput;
    GLuint _textureOutput;
    unsigned char* _pixelBuffer;
}

@property (nonatomic, readwrite) NSString *triggerAction;
@property (nonatomic, assign) BOOL effectEnable;

@property (nonatomic, assign) GLuint currentTexture;
@end

@implementation BERender

static NSString* LICENSE_PATH;

- (instancetype) init{
    self = [super init];
    if (self){
        renderHelper = [[BERenderHelper alloc] init];
        glGenFramebuffers(1, &_frameBuffer);
    }
    return self;
}

- (void)releaseRenderManger{
    glDeleteFramebuffers(1, &_frameBuffer);
}

- (GLuint)transforImageToTexture:(unsigned char*)buffer imageWidth:(int)iWidth height:(int)iHeight{
    GLuint textureInput;
    
    glGenTextures(1, &textureInput);
    glBindTexture(GL_TEXTURE_2D, textureInput);
    
    // 加载相机数据到纹理
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, iWidth, iHeight, 0, GL_BGRA, GL_UNSIGNED_BYTE, buffer);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glBindTexture(GL_TEXTURE_2D, 0);
    return textureInput;
}

//将texture转换为另一种大小的buffer
- (void)transforTextureToImage:(GLuint)texture buffer:(unsigned char*)buffer width:(int)iWidth height:(int)iHeight{
    [renderHelper textureToImage:texture withBuffer:buffer Width:iWidth height:iHeight];
}

- (void)transforTextureToImage:(GLuint)texture buffer:(unsigned char*)buffer width:(int)iWidth height:(int)iHeight format:(GLenum)format {
    [renderHelper textureToImage:texture withBuffer:buffer Width:iWidth height:iHeight format:format];
}

- (void) renderHelperSetResizeRatio:(float) ratio{
    [renderHelper setResizeRatio:ratio];
}

- (void) renderHelperSetWidth:(int)width height:(int)height resizeRatio:(float)ratio{
    [renderHelper setViewWidth:width height:height];
    [renderHelper setResizeRatio:ratio];
}


- (void) setRenderTargetTexture:(GLuint)texture{
    _currentTexture = texture;
}

- (void)checkGLError {
    int error = glGetError();
    if (error != GL_NO_ERROR) {
        NSLog(@"%d", error);
        @throw [NSException exceptionWithName:@"GLError" reason:@"error " userInfo:nil];
    }
}

- (BERenderHelper*) renderHelper{
    if (!renderHelper){
        renderHelper = [[BERenderHelper alloc] init];
    }
    return renderHelper;
}

@end

