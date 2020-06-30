//  Copyright © 2019 ailab. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BEEffectManager.h"
#import "bef_effect_ai_api.h"
#import "bef_effect_ai_version.h"
#import "BEStudioConstants.h"
#import "BEMacro.h"

@interface BEEffectManager () {
    GLuint _textureInput;
    GLuint _textureOutput;
}

@property (nonatomic, strong) NSDictionary *composerNodeDict;

@property (nonatomic, copy) NSString *licensePath;
@property (nonatomic, assign) bef_effect_handle_t renderMangerHandle;
@end

@implementation BEEffectManager

/*
 * 初始化时设置effect manager的 license，license 无效时，美颜，美妆，滤镜，贴纸无效果
 */
//- (void)setupEffectMangerWithLicenseVersion:(NSString* )path {
//    _licensePath = [path mutableCopy];
//    
//    bef_effect_result_t result = bef_effect_ai_create(&_renderMangerHandle);
//    if (result != BEF_RESULT_SUC) {
//        NSLog(@"bef_effect_ai_create error: %d", result);
//    }
//    
//    result = bef_effect_ai_check_license(_renderMangerHandle, _licensePath.UTF8String);
//    if (result != BEF_RESULT_SUC) {
//        NSLog(@"bef_effect_ai_check_license error: %d", result);
//    }
//    
//    NSString *resourceBundleName = [[NSBundle mainBundle] pathForResource:@"ModelResource" ofType:@"bundle"];
//    // 此处宽高传入视频捕获宽高。此处传入的路径是算法模型文件所在目录的父目录，设备名称传空即可。
//    result = bef_effect_ai_init(_renderMangerHandle, VIDEO_INPUT_WIDTH, VIDEO_INPUT_HEIGHT, resourceBundleName.UTF8String, "");
//    if (result != BEF_RESULT_SUC) {
//        NSLog(@"bef_effect_ai_init error: %d", result);
//    }
//    
//    [self initEffectCompose];
//}

- (void)setupEffectManagerWithLicense:(NSString *)license model:(NSString *)model composer:(NSString *)composer {
    _licensePath = [license mutableCopy];
    
    NSLog(@"sdk version is: %@", [self sdkVersion]);
    
    bef_effect_result_t result = bef_effect_ai_create(&_renderMangerHandle);
    if (result != BEF_RESULT_SUC) {
        [self be_sendNotification:@"Effect Initialization failed"];
        NSLog(@"bef_effect_ai_create error: %d", result);
        return;
    }

    result = bef_effect_ai_check_license(_renderMangerHandle, _licensePath.UTF8String);
    if (result != BEF_RESULT_SUC) {
        [self be_sendNotification:@"Effect Initialization failed"];
        NSLog(@"bef_effect_ai_check_license error: %d", result);
        return;
    }

    // 此处宽高传入视频捕获宽高。此处传入的路径是算法模型文件所在目录的父目录，设备名称传空即可。
    result = bef_effect_ai_init(_renderMangerHandle, VIDEO_INPUT_WIDTH, VIDEO_INPUT_HEIGHT, model.UTF8String, "");
    if (result != BEF_RESULT_SUC) {
        [self be_sendNotification:@"Effect Initialization failed"];
        NSLog(@"bef_effect_ai_init error: %d", result);
        return;
    }
}


/*
 * 初始化高级美妆和美颜资源路径
 * 初始化步骤：
 * 1.初始化特效部分，传入算法的组合模块，composer文件
 */
- (void)initEffectCompose:(NSString *)composer {
    bef_effect_result_t result;
    
    // 传入compose 文件的路径
    result = bef_effect_ai_set_effect(_renderMangerHandle, [composer UTF8String]);
    if (result != BEF_RESULT_SUC) {
        [self be_sendNotification:@"Effect Initialization failed"];
        NSLog(@"bef_effect_set_effect error: %d", result);
    }
}

/*
 * 根据输入的buffer在内存得到输入和输出的纹理，这一步必须在eagl环境中，不然会有OpenGL erroe
 */
- (void) genInputAndOutputTexture:(unsigned char*) buffer width:(int)iWidth height:(int)iHeigth
{
    GLuint textureInput = _textureInput;
    
    if (!glIsTexture(textureInput)) {
        NSLog(@"gen input texture");
        glGenTextures(1, &textureInput);
    }
    glBindTexture(GL_TEXTURE_2D, textureInput);
    
    // 加载相机数据到纹理
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, iWidth, iHeigth, 0, GL_BGRA, GL_UNSIGNED_BYTE, buffer);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    GLuint textureOutput = _textureOutput;;
    
    if (!glIsTexture(textureOutput)) {
        NSLog(@"gen output texture");
        glGenTextures(1, &textureOutput);
    }
    glBindTexture(GL_TEXTURE_2D, textureOutput);
    
    // 为输出纹理开辟空间
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, iWidth, iHeigth, 0, GL_BGRA, GL_UNSIGNED_BYTE, NULL);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    _textureInput = textureInput;
    _textureOutput = textureOutput;
}


/**
 当不需要展示特效时，只生成一个输出纹理

 @param buffer buffer
 @param width width
 @param height height
 */
- (GLuint)genOutputTexture:(unsigned char *)buffer width:(int)width height:(int)height
{
    GLuint textureOut = _textureOutput;
    
    if (!glIsTexture(textureOut)) {
        NSLog(@"gen output texture");
        glGenTextures(1, &textureOut);
    }
    glBindTexture(GL_TEXTURE_2D, textureOut);
    
    // 加载相机数据到纹理
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_BGRA, GL_UNSIGNED_BYTE, buffer);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    return textureOut;
}

/*
 * SDK内部处理纹理，返回经过特效处理后的纹理，必须先使用genInputAndOutputTexture 函数产生输入输出纹理
 */
- (GLuint) processInputTexture:(double) timeStamp {
    bef_effect_result_t ret;
    // 用于大眼瘦脸，根据输入纹理执行算法，检测人脸位置，要在opengl上下文中调用
    bef_effect_ai_algorithm_texture(_renderMangerHandle, _textureInput, timeStamp);
    GLuint textureResult = _textureInput;
    
    // 帧处理，渲染到输出纹理，要在opengl上下文中调用
    ret = bef_effect_ai_process_texture(_renderMangerHandle, _textureInput, _textureOutput, timeStamp);
    
    if (ret == BEF_RESULT_SUC) {
        textureResult = _textureOutput;
    } else {
        NSLog(@"bef_effect_ai_process_texture error: %d", ret);
    }
    
    return textureResult;
}

/*
 * 特效sdk设置输入图片的宽，高和方向，每一次处理前调用
 */
- (void)setWidth:(int) iWidth height:(int)iHeight orientation:(int)orientation{
    bef_effect_result_t ret = bef_effect_ai_set_width_height(_renderMangerHandle, iWidth, iHeight);
    if (ret != BEF_RESULT_SUC) {
        NSLog(@"bef_effect_ai_set_width_height error: %d", ret);
    }
    
    ret = bef_effect_ai_set_orientation(_renderMangerHandle, (bef_ai_rotate_type)orientation);
    if (ret != BEF_RESULT_SUC) {
        NSLog(@"bef_effect_ai_set_orientation: error %d", ret);
    }
}

/*
 * 设置滤镜资源的路径
 */
- (void) setFilterPath:(NSString *)path {
    bef_effect_result_t status = BEF_RESULT_SUC;
    status = bef_effect_ai_set_color_filter_v2(_renderMangerHandle, [path UTF8String]);
    
    if (status != BEF_RESULT_SUC){
        NSLog(@"bef_effect_ai_set_color_filter_v2 error: %d", status);
    }
}

/*
 * 设置滤镜的强度
 */
-(void) setFilterIntensity:(float)intensity {
    bef_effect_result_t status = BEF_RESULT_SUC;
    status = bef_effect_ai_set_intensity(_renderMangerHandle, BEF_INTENSITY_TYPE_GLOBAL_FILTER_V2, intensity);
    
    if (status != BEF_RESULT_SUC){
        NSLog(@"bef_effect_ai_set_intensity error: %d", status);
    }
}

/*
 * 设置贴纸资源的路径
 */
- (void) setStickerPath:(NSString *)path {
    bef_effect_result_t status = BEF_RESULT_SUC;
    status = bef_effect_ai_set_effect(_renderMangerHandle, [path UTF8String]);
    
    if (status != BEF_RESULT_SUC){
        NSLog(@"bef_effect_ai_set_effect error: %d", status);
    }
}

/*
 * 释放SDK内部的handle
 */
- (void)releaseEffectManager {
    glDeleteTextures(1, &_textureInput);
    glDeleteTextures(1, &_textureOutput);
    bef_effect_ai_destroy(_renderMangerHandle);
}

- (void)setComposerMode:(int)mode {
    bef_effect_result_t result = bef_effect_ai_composer_set_mode(_renderMangerHandle, mode, 0);
    if (result != BEF_RESULT_SUC) {
        NSLog(@"bef_effect_ai_composer_set_mode error: %d", result);
    }
}

- (void)updateComposerNodes:(NSArray<NSString *> *)nodes {
    char **nodesPath = (char **)malloc(nodes.count * sizeof(char *));
    int count = 0;
    
    NSMutableSet *set = [NSMutableSet set];
    for (NSString *node in nodes) {
        if ([set containsObject:node]) {
            continue;
        }
        [set addObject:node];
        
        nodesPath[count] = (char *)malloc((node.length + 1) * sizeof(char *));
        strncpy(nodesPath[count], [node UTF8String], node.length);
        nodesPath[count++][node.length] = '\0';
    }
    
    bef_effect_result_t result = bef_effect_ai_composer_set_nodes(_renderMangerHandle, (const char **)nodesPath, count);
    if (result != BEF_RESULT_SUC) {
        NSLog(@"bef_effect_ai_composer_set_nodes error: %d", result);
    }
    
    for (int i = 0; i < count; i++) {
        free(nodesPath[i]);
    }
    free(nodesPath);
}

- (void)updateComposerNodeIntensity:(NSString *)node key:(NSString *)key intensity:(float)intensity {
    bef_effect_result_t result = bef_effect_ai_composer_update_node(_renderMangerHandle, (const char *)[node UTF8String], (const char *)[key UTF8String], intensity);
    if (result != BEF_RESULT_SUC) {
        NSLog(@"bef_effect_composer_update_node error: %d", result);
    }
}

- (NSArray<NSString *> *)availableFeatures {
    //Dynamic lookup feature availability
    char features[30][BEF_EFFECT_FEATURE_LEN];
    int feature_len = 30;
    int code = bef_effect_available_features(_renderMangerHandle, features, &feature_len);
    if (code == BEF_RESULT_SUC) {
        NSLog(@"Here is all features available:");
        for (int i = 0; i < feature_len; ++i) {
            NSLog(@"%s\n", features[i]);
        }
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:feature_len];
        for (int i = 0; i < feature_len; i++) {
            [array addObject:[NSString stringWithUTF8String:features[i]]];
        }
        return [array copy];
    } else {
        NSLog(@"dynamic lookup feature availability failed");
        if (code == BEF_RESULT_FAIL) {
             NSLog(@"feature size is more than you expected, there is %d features", feature_len);
        }
        else if (code == BEF_RESULT_INVALID_EFFECT_HANDLE) {
            NSLog(@"bef_effect_available_features must be called after bef_effect_ai_init");
        }
        return @[];
    }
}

- (NSString *)sdkVersion {
    char version[10];
    bef_effect_ai_get_version(version, 10);
    return [NSString stringWithUTF8String:version];
}

- (void)be_sendNotification:(NSString *)msg {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kBESdkErrorNotification"
                                                        object:nil
                                                      userInfo:@{
                                                          @"data": msg
                                                      }];
}

@end
