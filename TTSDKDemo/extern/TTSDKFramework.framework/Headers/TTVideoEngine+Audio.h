//
//  TTVideoEngine+Audio.h
//  Pods
//
//  Created by guikunzhi on 2019/11/1.
//
#import "TTVideoEngine.h"

typedef struct EngineAudioWrapper{
    void (*open)(void *context, int samplerate, int channels, int duration); //创建资源
    void (*process)(void *context, float **inout, int samples, int64_t timestamp); //处理函数
    void (*close)(void *context); //释放资源，须与open成对调用
    void (*release)(void *context); //在release里销毁PlayerAudioWrapper，只调用一次
    void *context;
}EngineAudioWrapper;

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoEngine (Audio)

- (nullable UIImage *)getCoverImage;

- (void)setAudioProcessor:(EngineAudioWrapper *)wrapper;

@end

NS_ASSUME_NONNULL_END
