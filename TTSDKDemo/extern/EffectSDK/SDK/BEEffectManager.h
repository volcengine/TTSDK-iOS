//  Copyright © 2019 ailab. All rights reserved.

#ifndef BEEffectManager_h
#define BEEffectManager_h

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/glext.h>

@interface BEEffectManager : NSObject

- (void)setFilterPath:(NSString*) path;
- (void)setFilterIntensity:(float)intensity;
- (void)setStickerPath:(NSString*) path;
- (void)setComposerMode:(int)mode;
- (void)updateComposerNodes:(NSArray<NSString *> *)nodes;
- (void)updateComposerNodeIntensity:(NSString *)node key:(NSString *)key intensity:(float)intensity;

- (void)setupEffectManagerWithLicense:(NSString *)license model:(NSString *)model composer:(NSString *)composer;
- (void)initEffectCompose:(NSString *)composer;
- (void)setWidth:(int) iWidth height:(int)iHeight orientation:(int)orientation;
- (GLuint)processInputTexture:(double) timeStamp;
- (void)genInputAndOutputTexture:(unsigned char*) buffer width:(int)iWidth height:(int)iHeigth;
- (GLuint)genOutputTexture:(unsigned char*)buffer width:(int)width height:(int)height;
- (void)releaseEffectManager;
- (NSArray<NSString *> *)availableFeatures;
- (NSString *)sdkVersion;
@end


#endif /* BEEffectManager_h */
