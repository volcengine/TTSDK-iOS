//
//  LSLiveAuidoBufferUtils.h
//  LSVideoEditor
//
//  Created by baohonglai on 2019/3/17.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct AudioBufferQueue {
    UInt8    *bufferData;
    UInt32   dataSize;
}AudioBufferQueue;

@interface LSLiveAudioBufferUtils : NSObject

+ (AudioBufferList *)createBufferList:(AudioStreamBasicDescription)audioFormat frameCount:(UInt32)frameCount;
+ (void)freeBufferList:(AudioBufferList*)bufferList;
/**
 深度copy一个bufferlist，两个bufferlist里面的buffer数量必须相同
 */
+ (void)copyBufferList:(AudioBufferList *)dstBufferList srcBufferList:(AudioBufferList *)srcBufferList;

/**
 创建一个AudioBufferQueue，用于临时存储数据，最大的容量size为10K
 */
+ (void)createBufferQueue:(AudioBufferQueue *)bufferQueue;

+ (void)freeBufferQueue:(AudioBufferQueue *)bufferQueue;

+ (void)resetBufferQueue:(AudioBufferQueue *)bufferQueue;

+ (void)pushQueue:(AudioBufferQueue *)bufferQueue srcData:(UInt8 *)srcData dataSize:(UInt32)dataSize;

+ (int)dequeue:(AudioBufferQueue *)bufferQueue dstData:(UInt8 *)dstData outputSize:(UInt32)outputSize;

+ (void)resetAudioBufferList:(AudioBufferList *)bufferList;
@end

NS_ASSUME_NONNULL_END
