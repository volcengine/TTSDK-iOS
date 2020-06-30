// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/glext.h>
#import <CoreMotion/CoreMotion.h>
#import <OpenGLES/EAGL.h>

#import "bef_effect_ai_api.h"
#import "BERenderHelper.h"

#define TTF_STRINGIZE(x) #x
#define TTF_STRINGIZE2(x) TTF_STRINGIZE(x)
#define TTF_SHADER_STRING(text) @ TTF_STRINGIZE2(text)

static NSString *const LINE_VERTEX = TTF_SHADER_STRING
(
 attribute vec4 a_Position;
 void main() {
     gl_Position = a_Position;
 }
 );

static NSString *const LINE_FRAGMENT = TTF_SHADER_STRING
(
 precision mediump float;
 uniform vec4 u_Color;
 void main() {
     gl_FragColor = u_Color;
 }
 );

static NSString *const POINT_VERTEX = TTF_SHADER_STRING
(
 attribute vec4 a_Position;
 uniform float uPointSize;
 void main() {
     gl_Position = a_Position;
     gl_PointSize = uPointSize;
 }
 );

static NSString *const POINT_FRAGMENT = TTF_SHADER_STRING
(
 precision mediump float;
 uniform vec4 u_Color;
 void main() {
     gl_FragColor = u_Color;
 }
 );

static NSString *const CAMREA_RESIZE_VERTEX = TTF_SHADER_STRING
(
attribute vec4 position;
attribute vec4 inputTextureCoordinate;
varying vec2 textureCoordinate;
void main(){
    textureCoordinate = inputTextureCoordinate.xy;
    gl_Position = position;
}
);

static NSString *const CAMREA_RESIZE_FRAGMENT = TTF_SHADER_STRING
(
 precision mediump float;
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 void main()
 {
     gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
 }
);

static NSString *const MASK_VERTEX = TTF_SHADER_STRING
(
 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;
 varying vec2 textureCoordinate;
 void main(){
     textureCoordinate = vec2(inputTextureCoordinate.x, 1.0 - inputTextureCoordinate.y);
     gl_Position = position;
 }
 );

static NSString *const MASK_FRAGMENT = TTF_SHADER_STRING
(
 precision mediump float;
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputMaskTexture;
 uniform vec4 maskColor;
 void main(){
     float maska = texture2D(inputMaskTexture, textureCoordinate).a;
     gl_FragColor = vec4(maskColor.rgb, maska * maskColor.a);
 }
 );

static NSString *const MASK_PORTRAIT_FRAGMENT = TTF_SHADER_STRING
(
 precision mediump float;
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputMaskTexture;
 uniform vec4 maskColor;
 void main(){
     float maska = texture2D(inputMaskTexture, textureCoordinate).a;
     gl_FragColor = vec4(maskColor.rgb, 1.0-maska);
 }
 );


@interface  BERenderHelper (){
    GLuint _lineProgram;
    GLuint _lineLocation;
    GLuint _lineColor;
    
    GLuint _pointProgram;
    GLuint _pointLocation;
    GLuint _pointColor;
    GLuint _pointSize;
    
    GLuint _resizeProgram;
    GLuint _resizeLocation;
    GLuint _resizeInputImageTexture;
    GLuint _resizeTextureCoordinate;
    
    GLuint _maskProgram;
    GLuint _maskColor;
    GLuint _maskInputMaskTexture;
    GLuint _maskPosition;
    GLuint _maskCoordinatLocation;
    
    //Portrait
    GLuint _maskPortraitProgram;
    GLuint _maskPortraitColor;
    GLuint _maskPortraitInputMaskTexture;
    GLuint _maskPortraitPosition;
    GLuint _maskPortraitCoordinatLocation;
    
    GLuint _cachedTexture;
    GLuint _resizeTexture;
    
    //为了resize buffer
    GLuint _frameBuffer;
    
    int width;
    int height;
    int viewWidth;
    int viewHeight;
    
    float _ratio;
}

@end

static float TEXTURE_FLIPPED[] = {0.0f, 1.0f, 1.0f, 1.0f, 0.0f, 0.0f, 1.0f, 0.0f,};
static float TEXTURE_RORATION_0[] = {0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 1.0f, 1.0f, 1.0f,};
static float TEXTURE_ROTATED_90[] = {0.0f, 1.0f, 0.0f, 0.0f, 1.0f, 1.0f, 1.0f, 0.0f,};
static float TEXTURE_ROTATED_180[] = {1.0f, 1.0f, 0.0f, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f,};
static float TEXTURE_ROTATED_270[] = {1.0f, 0.0f, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,};
static float CUBE[] = {-1.0f, -1.0f, 1.0f, -1.0f, -1.0f, 1.0f, 1.0f, 1.0f,};

@implementation BERenderHelper

- (instancetype) init
{
    self = [super init];
    if (self){
        [self loadPointShader];
        [self loadLineShader];
        [self loadResizeShader];
        [self loadMaskShader];
        [self loadMaskPortratiShader];
        
        viewWidth = 720;
        viewWidth = 1080;
        _cachedTexture = -1;
        _ratio = 0.0;
    }
    
    glGenFramebuffers(1, &_frameBuffer);
    glGenTextures(1, &_resizeTexture);
    return self;
}

-(void)dealloc{
    glDeleteFramebuffers(1, &_frameBuffer);
    if (_cachedTexture != -1)
        glDeleteTextures(1, &_cachedTexture);
    glDeleteTextures(1, &_resizeTexture);
}

- (void)setViewWidth:(int)iWidth height:(int)iHeight{
    viewWidth = iWidth;
    viewHeight = iHeight;
}

- (void)setResizeRatio:(float)ratio{
    _ratio = ratio;
}

+ (int) compileShader:(NSString *)shaderString withType:(GLenum)shaderType {
    GLuint shaderHandle = glCreateShader(shaderType);
    const char * shaderStringUTF8 = [shaderString UTF8String];
    
    int shaderStringLength = (int) [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    glCompileShader(shaderHandle);
    GLint success;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &success);
    
    if (success == GL_FALSE){
        NSLog(@"BErenderHelper compiler shader error: %s", shaderStringUTF8);
        return 0;
    }
    return shaderHandle;
}

/*
 * load point shader
 */

- (void) loadPointShader {
    GLuint vertexShader = [BERenderHelper compileShader:POINT_VERTEX withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [BERenderHelper compileShader:POINT_FRAGMENT withType:GL_FRAGMENT_SHADER];
    
    _pointProgram = glCreateProgram();
    glAttachShader(_pointProgram, vertexShader);
    glAttachShader(_pointProgram, fragmentShader);
    glLinkProgram(_pointProgram);
    
    GLint linkSuccess;
    glGetProgramiv(_pointProgram, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE){
        NSLog(@"BERenderHelper link shader error");
    }
    
    glUseProgram(_pointProgram);
    _pointLocation = glGetAttribLocation(_pointProgram, "a_Position");
    _pointColor = glGetUniformLocation(_pointProgram, "u_Color");
    _pointSize = glGetUniformLocation(_pointProgram, "uPointSize");
    
    if (vertexShader)
        glDeleteShader(vertexShader);
    
    if (fragmentShader)
        glDeleteShader(fragmentShader);
}

/*
 * load line shader
 */

- (void) loadLineShader {
    GLuint vertexShader = [BERenderHelper compileShader:LINE_VERTEX withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [BERenderHelper compileShader:LINE_FRAGMENT withType:GL_FRAGMENT_SHADER];
    
    _lineProgram = glCreateProgram();
    glAttachShader(_lineProgram, vertexShader);
    glAttachShader(_lineProgram, fragmentShader);
    glLinkProgram(_lineProgram);
    
    GLint linkSuccess;
    glGetProgramiv(_lineProgram, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE){
        NSLog(@"BERenderHelper link shader error");
    }
    
    glUseProgram(_lineProgram);
    _lineLocation = glGetAttribLocation(_lineProgram, "a_Position");
    _lineColor = glGetUniformLocation(_lineProgram, "u_Color");
    
    if (vertexShader)
        glDeleteShader(vertexShader);
    
    if (fragmentShader)
        glDeleteShader(fragmentShader);
    
}

/*
 * load resize shader
 */
- (void) loadResizeShader{
    GLuint vertexShader = [BERenderHelper compileShader:CAMREA_RESIZE_VERTEX withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [BERenderHelper compileShader:CAMREA_RESIZE_FRAGMENT withType:GL_FRAGMENT_SHADER];
    
    _resizeProgram = glCreateProgram();
    glAttachShader(_resizeProgram, vertexShader);
    glAttachShader(_resizeProgram, fragmentShader);
    glLinkProgram(_resizeProgram);
    
    GLint linkSuccess;
    glGetProgramiv(_resizeProgram, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE){
        NSLog(@"BERenderHelper link shader error");
    }
    
    glUseProgram(_resizeProgram);
    _resizeLocation = glGetAttribLocation(_resizeProgram, "position");
    _resizeTextureCoordinate = glGetAttribLocation(_resizeProgram, "inputTextureCoordinate");
    _resizeInputImageTexture = glGetUniformLocation(_resizeProgram, "inputImageTexture");
    
    if (vertexShader)
        glDeleteShader(vertexShader);
    
    if (fragmentShader)
        glDeleteShader(fragmentShader);
}

- (void) loadMaskShader {
    GLuint vertexShader = [BERenderHelper compileShader:MASK_VERTEX withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [BERenderHelper compileShader:MASK_FRAGMENT withType:GL_FRAGMENT_SHADER];
    
    _maskProgram = glCreateProgram();
    glAttachShader(_maskProgram, vertexShader);
    glAttachShader(_maskProgram, fragmentShader);
    glLinkProgram(_maskProgram);
    
    GLint linkSuccess;
    glGetProgramiv(_maskProgram, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE){
        NSLog(@"BERenderHelper link shader error");
    }
    
    glUseProgram(_maskProgram);
    _maskPosition = glGetAttribLocation(_maskProgram, "position");
    _maskCoordinatLocation = glGetAttribLocation(_maskProgram, "inputTextureCoordinate");
    
    _maskInputMaskTexture = glGetUniformLocation(_maskProgram, "inputMaskTexture");
    _maskColor = glGetUniformLocation(_maskProgram, "maskColor");
    
    if (vertexShader)
        glDeleteShader(vertexShader);
    
    if (fragmentShader)
        glDeleteShader(fragmentShader);
    
    [self checkGLError];
}

- (void) loadMaskPortratiShader{
    GLuint vertexShader = [BERenderHelper compileShader:MASK_VERTEX withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [BERenderHelper compileShader:MASK_PORTRAIT_FRAGMENT withType:GL_FRAGMENT_SHADER];
    
    _maskPortraitProgram = glCreateProgram();
    glAttachShader(_maskPortraitProgram, vertexShader);
    glAttachShader(_maskPortraitProgram, fragmentShader);
    glLinkProgram(_maskPortraitProgram);
    
    GLint linkSuccess;
    glGetProgramiv(_maskPortraitProgram, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE){
        NSLog(@"BERenderHelper link shader error");
    }
    
    glUseProgram(_maskPortraitProgram);
    _maskPortraitPosition = glGetAttribLocation(_maskPortraitProgram, "position");
    _maskPortraitCoordinatLocation = glGetAttribLocation(_maskPortraitProgram, "inputTextureCoordinate");
    
    _maskPortraitInputMaskTexture = glGetUniformLocation(_maskPortraitProgram, "inputMaskTexture");
    _maskPortraitColor = glGetUniformLocation(_maskPortraitProgram, "maskColor");
    
    if (vertexShader)
        glDeleteShader(vertexShader);
    
    if (fragmentShader)
        glDeleteShader(fragmentShader);
    
    [self checkGLError];
    
}

- (float) _transFormX:(int)x{
    float retX = (float)2.0 * x / _ratio / viewWidth - 1.0;
    return retX;
}

- (float) _transFormY:(int)y{
    float retX = (float)2.0 * y / _ratio / viewHeight - 1.0;
    return retX;
}
/*
 * draw a single point
 */

- (void) drawPoint:(int)x y:(int)y withColor:(be_rgba_color)color pointSize:(float)pointSize
{
    float transFormedX = [self _transFormX:x];
    float transFormedY = [self _transFormY:y];
    
    GLfloat positions[] = {
        transFormedX, transFormedY
    };
    
    glViewport(0, 0, viewWidth, viewHeight);
    glUseProgram(_pointProgram);
    glVertexAttribPointer(_pointLocation, 2, GL_FLOAT, false, 0, positions);
    glEnableVertexAttribArray(_pointLocation);
    
    glUniform4f(_pointColor, color.red, color.green, color.blue, color.alpha);
    glUniform1f(_pointSize, pointSize);
    glDrawArrays(GL_POINTS, 0, 1);
    glDisableVertexAttribArray(_pointLocation);
}

/*
 * draw  points
 */

- (void) drawPoints:(bef_ai_fpoint*)points count:(int)count color:(be_rgba_color)color pointSize:(float)pointSize
{
    GLfloat* positions = (GLfloat*)malloc(count * 2 * sizeof(GLfloat));
    if (positions == 0){
        NSLog(@"drawPoints malloc error");
        return ;
    }
    
    for (int i = 0; i < count; i ++){
        positions[i * 2] = [self _transFormX:points[i].x];
        positions[i * 2 + 1] = [self _transFormY:points[i].y];
    }
    glUseProgram(_pointProgram);
    
    glViewport(0, 0, viewWidth, viewHeight);
    glVertexAttribPointer(_pointLocation, 2, GL_FLOAT, false, 2 * sizeof(GLfloat), positions);
    glEnableVertexAttribArray(_pointLocation);
    
    glUniform4f(_pointColor, color.red, color.green, color.blue, color.alpha);
    glUniform1f(_pointSize, pointSize);
    glDrawArrays(GL_POINTS, 0, count);
    glDisableVertexAttribArray(_pointLocation);
    
    [self checkGLError];
    free(positions);
}

/*
 * Draw a line with color
 */

- (void) drawLine:(be_render_helper_line*)line withColor:(be_rgba_color)color lineWidth:(float)lineWidth{
    float x1 = [self _transFormX:line->x1];
    float y1 = [self _transFormY:line->y1];
    float x2 = [self _transFormX:line->x2];
    float y2 = [self _transFormY:line->y2];
    
    GLfloat positions[] = {
        x1, y1,
        x2, y2
    };
    
    glViewport(0, 0, viewWidth, viewHeight);
    glUseProgram(_lineProgram);
    glVertexAttribPointer(_lineLocation, 2, GL_FLOAT, false, 2 * sizeof(GLfloat), positions);
    glEnableVertexAttribArray(_lineLocation);
    glUniform4f(_lineColor, color.red, color.green, color.blue, color.alpha);
    
    glLineWidth(lineWidth);
    glDrawArrays(GL_LINES, 0, 2);
    glDisableVertexAttribArray(_lineLocation);
}

/*
 * Draw lines with count and color
 */

- (void) drawLines:(bef_ai_fpoint*) lines withCount:(int)count withColor:(be_rgba_color)color lineWidth:(float)lineWidth{
    if (count <= 0) return;
    
    //here we suppose GFfloat == float, not a good way
    GLfloat* positions = (GLfloat*)calloc(count, sizeof(GLfloat) * 2);
    
    for (int i = 0; i < count; i ++){
        positions[2 * i] = [self _transFormX:lines[i].x];
        positions[2 * i + 1] = [self _transFormY:lines[i].y];
    }
    glViewport(0, 0, viewWidth, viewHeight);
    glUseProgram(_lineProgram);
    glVertexAttribPointer(_lineLocation, 2, GL_FLOAT, false, 2 * sizeof(GLfloat), positions);
    glEnableVertexAttribArray(_lineLocation);
    glUniform4f(_lineColor, color.red, color.green, color.blue, color.alpha);
    
    glLineWidth(lineWidth);
    glDrawArrays(GL_LINES, 0, count);
    glDisableVertexAttribArray(_lineLocation);
    free(positions);
}

/*
 * Draw lines with count and color strip
 */
- (void) drawLinesStrip:(bef_ai_fpoint*) lines withCount:(int)count withColor:(be_rgba_color)color lineWidth:(float)lineWidth{
    if (count <= 0) return;
    
    //here we suppose GFfloat == float, not a good way
    GLfloat* positions = (GLfloat*)calloc(count, sizeof(GLfloat) * 2);
    
    for (int i = 0; i < count; i ++){
        positions[2 * i] = [self _transFormX:lines[i].x];
        positions[2 * i + 1] = [self _transFormY:lines[i].y];
    }
    
    glViewport(0, 0, viewWidth, viewHeight);
    glUseProgram(_lineProgram);
    glVertexAttribPointer(_lineLocation, 2, GL_FLOAT, false, 2 * sizeof(GLfloat), positions);
    glEnableVertexAttribArray(_lineLocation);
    glUniform4f(_lineColor, color.red, color.green, color.blue, color.alpha);
    
    glLineWidth(lineWidth);
    glDrawArrays(GL_LINE_STRIP, 0, count);
    glDisableVertexAttribArray(_lineLocation);
    
    free(positions);
}
/*
 * Draw a rect with color
 */
- (void) drawRect:(bef_ai_rect*)rect withColor:(be_rgba_color)color lineWidth:(float)lineWidth
{
    float x1 = [self _transFormX:rect->left];
    float y1 = [self _transFormY:rect->top];
    float x2 = [self _transFormX:rect->right];
    float y2 = [self _transFormY:rect->bottom];
    
    GLfloat positions[] = {
        x1, y1,
        x1, y2,
        x2, y2,
        x2, y1,
        x1, y1
    };
    
    glViewport(0, 0, viewWidth, viewHeight);
    glUseProgram(_lineProgram);
    glVertexAttribPointer(_lineLocation, 2, GL_FLOAT, 0, 2 * sizeof(GLfloat), positions);
    glEnableVertexAttribArray(_lineLocation);
    
    glUniform4f(_lineColor, color.red, color.green, color.blue, color.alpha);
    
    glLineWidth(lineWidth);
    glDrawArrays(GL_LINE_STRIP, 0, 5);
    glDisableVertexAttribArray(_lineLocation);
}

/*
 * transfer a image th buffer
 */
- (void) textureToImage:(GLuint)texture withBuffer:(unsigned char*)buffer Width:(int)rWidth height:(int)rHeight{
    glBindTexture(GL_TEXTURE_2D, _resizeTexture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, rWidth, rHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _resizeTexture, 0);
    
    glUseProgram(_resizeProgram);
    glVertexAttribPointer(_resizeLocation, 2, GL_FLOAT, false, 0, CUBE);
    glEnableVertexAttribArray(_resizeLocation);
    glVertexAttribPointer(_resizeTextureCoordinate, 2, GL_FLOAT, false, 0, TEXTURE_RORATION_0);
    glEnableVertexAttribArray(_resizeTextureCoordinate);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(_resizeInputImageTexture, 0);
    glViewport(0, 0, rWidth, rHeight);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glDisableVertexAttribArray(_resizeLocation);
    glDisableVertexAttribArray(_resizeTextureCoordinate);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    glReadPixels(0, 0, rWidth, rHeight, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    [self checkGLError];
}

- (void) textureToImage:(GLuint)texture withBuffer:(unsigned char*)buffer Width:(int)rWidth height:(int)rHeight format:(GLenum)format {
    glBindTexture(GL_TEXTURE_2D, _resizeTexture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, rWidth, rHeight, 0, format, GL_UNSIGNED_BYTE, NULL);
    
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _resizeTexture, 0);
    
    glUseProgram(_resizeProgram);
    glVertexAttribPointer(_resizeLocation, 2, GL_FLOAT, false, 0, CUBE);
    glEnableVertexAttribArray(_resizeLocation);
    glVertexAttribPointer(_resizeTextureCoordinate, 2, GL_FLOAT, false, 0, TEXTURE_RORATION_0);
    glEnableVertexAttribArray(_resizeTextureCoordinate);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(_resizeInputImageTexture, 0);
    glViewport(0, 0, rWidth, rHeight);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glDisableVertexAttribArray(_resizeLocation);
    glDisableVertexAttribArray(_resizeTextureCoordinate);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    glReadPixels(0, 0, rWidth, rHeight, format, GL_UNSIGNED_BYTE, buffer);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    [self checkGLError];
}

/*
 * Draw mask with color
 */
- (void) drawMask:(unsigned char*)mask withColor:(be_rgba_color)color currentTexture:(GLuint)texture frameBuffer:(GLuint)frameBuffer size:(int*)size {
    glViewport(0, 0, viewWidth, viewHeight);
    glUseProgram(_maskProgram);
    glVertexAttribPointer(_maskPosition, 2, GL_FLOAT, false, 0, CUBE);
    glEnableVertexAttribArray(_maskPosition);
    glVertexAttribPointer(_maskCoordinatLocation, 2, GL_FLOAT, false, 0, TEXTURE_FLIPPED);
    glEnableVertexAttribArray(_maskCoordinatLocation);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    if (_cachedTexture == -1){
        glGenTextures(1, &_cachedTexture);
        glBindTexture(GL_TEXTURE_2D, _cachedTexture);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, size[0], size[1], 0, GL_ALPHA, GL_UNSIGNED_BYTE, mask);
    }else{
        glBindTexture(GL_TEXTURE_2D, _cachedTexture);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, size[0], size[1], 0, GL_ALPHA, GL_UNSIGNED_BYTE, mask);
    }
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _cachedTexture);
    glUniform1i(_maskInputMaskTexture, 0);
    glUniform4f(_maskColor, color.red, color.green, color.blue, color.alpha);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisable(GL_BLEND);
    //glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, texture, 0);
    
    glDisableVertexAttribArray(_maskCoordinatLocation);
    glDisableVertexAttribArray(_maskPosition);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, 0);
    glUseProgram(0);
    [self checkGLError];
    
}

/*
 * Draw portrait mask with color
 */
- (void) drawPortraitMask:(unsigned char*)mask withColor:(be_rgba_color)color currentTexture:(GLuint)texture frameBuffer:(GLuint)frameBuffer size:(int*)size {
    glViewport(0, 0, viewWidth, viewHeight);
    glUseProgram(_maskPortraitProgram);
    glVertexAttribPointer(_maskPortraitPosition, 2, GL_FLOAT, false, 0, CUBE);
    glEnableVertexAttribArray(_maskPortraitPosition);
    glVertexAttribPointer(_maskPortraitCoordinatLocation, 2, GL_FLOAT, false, 0, TEXTURE_FLIPPED);
    glEnableVertexAttribArray(_maskPortraitCoordinatLocation);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    if (_cachedTexture == -1){
        glGenTextures(1, &_cachedTexture);
        glBindTexture(GL_TEXTURE_2D, _cachedTexture);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, size[0], size[1], 0, GL_ALPHA, GL_UNSIGNED_BYTE, mask);
    }else{
        glBindTexture(GL_TEXTURE_2D, _cachedTexture);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, size[0], size[1], 0, GL_ALPHA, GL_UNSIGNED_BYTE, mask);
    }
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _cachedTexture);
    glUniform1i(_maskPortraitInputMaskTexture, 0);
    glUniform4f(_maskPortraitColor, color.red, color.green, color.blue, color.alpha);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisable(GL_BLEND);
    
    glDisableVertexAttribArray(_maskPortraitCoordinatLocation);
    glDisableVertexAttribArray(_maskPortraitPosition);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, 0);
    glUseProgram(0);
    [self checkGLError];
    
}

- (void)drawTexture:(GLuint)texture{
    glUseProgram(_resizeProgram);
    glVertexAttribPointer(_resizeLocation, 2, GL_FLOAT, false, 0, CUBE);
    glEnableVertexAttribArray(_resizeLocation);
    glVertexAttribPointer(_resizeTextureCoordinate, 2, GL_FLOAT, false, 0, TEXTURE_RORATION_0);
    glEnableVertexAttribArray(_resizeTextureCoordinate);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(_resizeInputImageTexture, 0);
    glViewport(0, 0, viewHeight, viewHeight);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glDisableVertexAttribArray(_resizeLocation);
    glDisableVertexAttribArray(_resizeTextureCoordinate);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    glUseProgram(0);
}

- (void)checkGLError {
    int error = glGetError();
    if (error != GL_NO_ERROR) {
        NSLog(@"%d", error);
        @throw [NSException exceptionWithName:@"GLError" reason:@"error " userInfo:nil];
    }
}

@end
