//
//  StreamConfigurationModel.h
//  LiveStreamSdkDemo
//
//  Created by 王可成 on 2018/7/11.

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

@interface StreamConfigurationModel : NSObject

+ (instancetype)defaultConfigurationModel;

// default is nil
@property (nonatomic) NSString *streamURL;
// default is YES
@property (nonatomic, assign) BOOL isFrontCamera;
// default is (720, 1280)
@property (nonatomic, assign) CGSize captureResolution;
// default is (540, 960)
@property (nonatomic, assign) CGSize streamResolution;
// default is 0  0: baseline 1: main 2: high
@property (nonatomic, assign) int profileLevel;
// default is 25 frame/sec
@property (nonatomic, assign) int fps;
// defaulte is 800 kbps
@property (nonatomic, assign) int videoBitrate;
// 0: VT_264 1: VT_265
@property (nonatomic, assign) int videoCodecType;

// 0: ATAAC 1: FDKAAC
@property (nonatomic, assign) int audioCodecType;
// default 128 kbps
@property (nonatomic, assign) int audioBitrate;

// DEBUG
@property (nonatomic, assign) BOOL registExtension;
@property (nonatomic, assign) BOOL rtmpkOnly;
@property (nonatomic, assign) BOOL enableBFrame;
@property (nonatomic, assign) BOOL enableBackgroundMode;
@property (nonatomic, assign) BOOL ntpEnabled;
@property (nonatomic, assign) BOOL glMultiThreaded;
@property (nonatomic, assign) BOOL enableAudioStream;
@end
