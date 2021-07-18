//
//  LSMMAudioCompressor.h
//  LSVideoEditor
//
//  Created by kyle on 2018/12/26.
//

#import <Foundation/Foundation.h>
#import <CoreAudioKit/CoreAudioKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface LSLiveAudioCompressorFormat : NSObject <NSCopying>
@property (nonatomic, assign)float pregain;
@property (nonatomic, assign)float threshold;
@property (nonatomic, assign)float knee;
@property (nonatomic, assign)float ratio;
@property (nonatomic, assign)float attack;
@property (nonatomic, assign)float relea;
@property (nonatomic, assign)float predelay;
@property (nonatomic, assign)float releasezone1;
@property (nonatomic, assign)float releasezone2;
@property (nonatomic, assign)float releasezone3;
@property (nonatomic, assign)float releasezone4;
@property (nonatomic, assign)float postgain;
@property (nonatomic, assign)float wet;
@end
@interface LSLiveMMAudioCompressor : NSObject

- (instancetype)initWithSample:(int)samplerate channels:(int)channels withFormat:(LSLiveAudioCompressorFormat *)format;
- (BOOL)processBufferList:(AudioBufferList *)ioData;
- (void)processAudio:(float *)input output:(float *_Nonnull*_Nonnull)output samples:(int)samples;
- (void)updateFormat:(LSLiveAudioCompressorFormat *)format;
@end

NS_ASSUME_NONNULL_END
