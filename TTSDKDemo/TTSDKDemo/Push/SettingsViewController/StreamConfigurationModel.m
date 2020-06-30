//
//  StreamConfigurationModel.m
//  LiveStreamSdkDemo
//
//  Created by 王可成 on 2018/7/11.

#import "StreamConfigurationModel.h"

@implementation StreamConfigurationModel

+ (instancetype)defaultConfigurationModel {
    StreamConfigurationModel *model = [[StreamConfigurationModel alloc] init];
    
    model.isFrontCamera = YES;
    model.captureResolution = CGSizeMake(720, 1280);
    model.streamResolution = CGSizeMake(540, 960);
    model.fps = 20;
    model.videoBitrate = 800;
    model.videoCodecType = 0;
    
    model.audioBitrate = 128;
    model.audioCodecType = 0;
    
    // DEBUG
    model.registExtension = NO;
    model.rtmpkOnly = NO;
    model.enableBFrame = NO;
    model.enableBackgroundMode = NO;
    model.glMultiThreaded = NO;
    model.enableAudioStream = NO;
    return model;
}

@end
