// Copyright (C) 2018 Beijing Bytedance Network Technology Co., Ltd.
#import <GLKit/GLKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import "BEResourceHelper.h"

@class BEFrameProcessor;

@interface BEProcessResult : NSObject
@property (nonatomic, assign) GLuint texture;
@property (nonatomic, assign) unsigned char *rawData;
@property (nonatomic, assign) CVPixelBufferRef pixelBuffer;
@property (nonatomic, assign) CGSize size;
@end

@interface BEFrameProcessor : NSObject

@property (nonatomic, assign) AVCaptureDevicePosition cameraPosition;
@property (nonatomic, assign) CGSize videoDimensions;
@property (nonatomic, readonly) NSString *triggerAction;
@property (nonatomic, readonly) int composerMode;

- (instancetype)initWithContext:(EAGLContext *)context resourceDelegate:(id<BEResourceHelperDelegate>)delegate;
- (BEProcessResult *)process:(CVPixelBufferRef)pixelBuffer timeStamp:(double)timeStamp;
- (void)dealloc;

- (void)setFilterPath:(NSString *)path;
- (void)setFilterIntensity:(float)intensity;
- (void)setStickerPath:(NSString *)path;
- (void)setComposerMode:(int)mode;
- (void)updateComposerNodes:(NSArray<NSString *> *)nodes;
- (void)updateComposerNodeIntensity:(NSString *)node key:(NSString *)key intensity:(CGFloat)intensity;
- (void)setEffectOn:(BOOL)on;
- (NSArray<NSString *> *)availableFeatures;
- (NSString *)sdkVersion;

- (BEResourceHelper *)resourceHelper;

@end
