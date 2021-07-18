// by baohonglai 用ExtAuidofile来写文件

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

extern NSString * const LSLiveExtAudioFileWriterErrorDomain;

typedef void (^LSExtAudioFileRecordCompletionHandler)(NSString *audioURL, NSInteger ticketId, NSError *error);

enum {
    kLSExtAudioFileWriterFormatError
};

@interface LSLiveExtAudioFileWriter : NSObject

@property (nonatomic) NSTimeInterval duration;
@property (nonatomic, strong) NSURL *recordUrl;

//是否保存为wav格式？
@property (nonatomic, assign) BOOL  wavFormat;


- (instancetype)initWithAudioDescription:(AudioStreamBasicDescription)audioDescription;

- (void)pauseWriting;

/*
 如果filename为nil，则内部会自定义一个文件名
 */
- (void)startWriting:(NSString *)filename ticketId:(NSInteger) ticketId maxRecordingDuration:(float) recordingSeconds withCompleteHandler:(LSExtAudioFileRecordCompletionHandler)completion;

- (OSStatus)processAudioBufferList:(AudioBufferList *)ioData inNumberFrames:(UInt32)inNumberFrames bufferDuration:(NSTimeInterval)duration;

- (void)finishWritingComplete:(LSExtAudioFileRecordCompletionHandler)completion;



@end
