//
//  LSRecorderDefine.h
//  AudioMixer
//
//  Created by tianzhuo on 2018/5/25.
//  Copyright © 2018年 tianzhuo. All rights reserved.
//

#ifndef LSRecorderDefine_h
#define LSRecorderDefine_h

#define kBusZero 0
#define kBusOne 1

typedef NS_ENUM(NSUInteger, LSAudioRecorderMode) {
    /** play and record audio */
    LSAudioRecorderModePlayAndRecord,
    /** only play audio */
    LSAudioRecorderModePlayback,
};

typedef NS_ENUM(NSUInteger, LSAudioRecorderStatus) {
    /** default */
    LSAudioRecorderStatusIdle,
    /** processing */
    LSAudioRecorderStatusProcessing,
    /** paused */
    LSAudioRecorderStatusPaused,
    /** stop */
    LSAudioRecorderStatusStop
};

typedef NS_ENUM(NSUInteger, LSAudioConverterStatus) {
    /** unknown */
    LSAudioConverterStatusUnknown,
    /** ready to render */
    LSAudioConverterStatusReady,
    /** initialize failed */
    LSAudioConverterStatusFailed,
    /** has been destoryed */
    LSAudioConverterStatusDestory,
};

typedef struct LSRecorderDescription {
    /** music pitch */
    Float32 musicPitch;
    /** the volume of music route */
    Float32 musicVolume;
    /** the volume of MIC route */
    Float32 recordVolume;
    /** the start time of music */
    NSTimeInterval startTime;
    /** the timeoffset of music file */
    NSTimeInterval timeOffset;
} LSRecorderDescription;

typedef NS_ENUM(NSUInteger, LSMusicType) {
    LSMusicTypeAccompany = 0,
    LSMusicTypeOriginalSing = 1,
};

#endif /* LSRecorderDefine_h */
