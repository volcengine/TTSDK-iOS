// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.
#import "bef_effect_ai_public_define.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/glext.h>

@interface BERender : NSObject

@property (nonatomic, strong) NSMutableDictionary* composeNodeDict;

- (void) renderHelperSetWidth:(int)width height:(int)height resizeRatio:(float)ratio;
- (GLuint)transforImageToTexture:(unsigned char*)buffer imageWidth:(int)iWidth height:(int)iHeight;
- (void)transforTextureToImage:(GLuint)texture buffer:(unsigned char*)buffer width:(int)iWidth height:(int)iHeight;
- (void)transforTextureToImage:(GLuint)texture buffer:(unsigned char*)buffer width:(int)iWidth height:(int)iHeight format:(GLenum)format;

- (void)releaseRenderManger;
- (void) renderHelperSetResizeRatio:(float) ratio;
- (void) setRenderTargetTexture:(GLuint)texture;
@end
