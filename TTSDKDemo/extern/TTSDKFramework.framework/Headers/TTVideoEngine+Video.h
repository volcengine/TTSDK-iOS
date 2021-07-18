//
//  TTVideoEngine+Video.h
//  Pods
//
//  Created by liujiangnan.south on 2020/12/9.
//

#ifndef TTVideoEngine_Video_h
#define TTVideoEngine_Video_h

#import "TTVideoEngine.h"

typedef struct EngineVideoWrapper{
    void (*process)(void *context, CVPixelBufferRef frame, int64_t timestamp);
    void (*release)(void *context);
    void *context;
}EngineVideoWrapper;

@interface TTVideoEngine (Video)

- (void)setVideoWrapper:(EngineVideoWrapper *)wrapper;

@end

#endif /* TTVideoEngine_Video_h */
