// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.
#import "bef_effect_ai_public_define.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/glext.h>

typedef struct be_rgba_color {
    float red;
    float green;
    float blue;
    float alpha;
}be_rgba_color;

typedef struct be_render_helper_line {
    float x1;
    float y1;
    float x2;
    float y2;
} be_render_helper_line;

@interface BERenderHelper : NSObject

- (void)setViewWidth:(int)iWidth height:(int)iHeight;
- (void)setResizeRatio:(float)ratio;

- (void)drawTexture:(GLuint)texture;

- (void) textureToImage:(GLuint)texture withBuffer:(unsigned char*)buffer Width:(int)rWidth height:(int)rHeight;

- (void) textureToImage:(GLuint)texture withBuffer:(unsigned char*)buffer Width:(int)rWidth height:(int)rHeight format:(GLenum)format;

+ (int) compileShader:(NSString *)shaderString withType:(GLenum)shaderType;
@end

