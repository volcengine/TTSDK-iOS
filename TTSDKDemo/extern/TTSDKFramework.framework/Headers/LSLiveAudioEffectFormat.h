//
//  LSLiveAudioEffectFormat.h
//  FMDB
//
//  Created by Gavinysj on 2018/7/8.
//

#import <Foundation/Foundation.h>


extern bool liveReCreateBuffer(float **out, int *currLength, int needLength);

#pragma mark - reverb format
@interface LSLiveAudioReverbFormat : NSObject <NSCopying>

/**
 * @brief value should be in range [0.0, 1.5].
 */
@property (nonatomic, assign) float roomSize;
/**
 * @brief alue should be in range [0.0, 1.5]
 */
@property (nonatomic, assign) float hfDamping;
/**
 * @brief value should be in range [0.0, 1.0].
 */
@property (nonatomic, assign) float stereoDepth;
/**
 * @brief dry Set the dry part in linear gain. negative value will revert the phase of dry part.
 */
@property (nonatomic, assign) float dry;
/**
 * @brief wet Set the wet part in linear gain. negative value will revert the phase of wet part.
 */
@property (nonatomic, assign) float wet;
/**
 * @brief dryGainDB Set the dry part in dB gain. Negative value will reduce the volume(in dB) in dry part and positive will boost it.
 */
@property (nonatomic, assign) float dryGainDB;
/**
 * @brief wetGainDB Set the wet part in dB gain. Negative value will reduce the volume(in dB) in wet part and positive will boost it.
 */
@property (nonatomic, assign) float wetGainDB;
/**
 * @brief dryOnly Will only gives the un-filtered dry audio.
 */
@property (nonatomic, assign) BOOL dryOnly;
/**
 * @brief wetOnly will only gives the filtered wet audio.
 */
@property (nonatomic, assign) BOOL wetOnly;


- (instancetype)init;

@end


#pragma mark - reverb2 format
@interface LSLiveAudioReverb2Format : NSObject <NSCopying>

/**
 * @brief input sample rate (samples per second)
 */
@property (nonatomic, assign) int sampleRate;
/**
 * @brief how much to oversample [1 to 4]
 */
@property (nonatomic, assign) int oversamplefactor;
/**
 * @brief early reflection amount [0 to 1]
 */
@property (nonatomic, assign) float ertolate;
/**
 * @brief dB, final wet mix [-70 to 10]
 */
@property (nonatomic, assign) float erefwet;
/**
 * @brief dB, final dry mix [-70 to 10]
 */
@property (nonatomic, assign) float dry;
/**
 * @brief early reflection factor [0.5 to 2.5]
 */
@property (nonatomic, assign) float ereffactor;
/**
 * @brief early reflection width [-1 to 1]
 */
@property (nonatomic, assign) float erefwidth;
/**
 * @brief width of reverb L/R mix [0 to 1]
 */
@property (nonatomic, assign) float width;
/**
 * @brief dB, reverb wetness [-70 to 10]
 */
@property (nonatomic, assign) float wet;
/**
 * @brief LFO wander amount [0.1 to 0.6]
 */
@property (nonatomic, assign) float wander;
/**
 * @brief bass boost [0 to 0.5]
 */
@property (nonatomic, assign) float bassb;
/**
 * @brief LFO spin amount [0 to 10]
 */
@property (nonatomic, assign) float spin;
/**
 * @brief Hz, lowpass cutoff for input [200 to 18000]
 */
@property (nonatomic, assign) float inputlpf;
/**
 * @brief Hz, lowpass cutoff for bass [50 to 1050]
 */
@property (nonatomic, assign) float basslpf;
/**
 * @brief Hz, lowpass cutoff for dampening [200 to 18000]
 */
@property (nonatomic, assign) float damplpf;
/**
 * @brief Hz, lowpass cutoff for output [200 to 18000]
 */
@property (nonatomic, assign) float outputlpf;
/**
 * @brief reverb time decay [0.1 to 30]
 */
@property (nonatomic, assign) float rt60;
/**
 * @brief seconds, amount of delay [-0.5 to 0.5]
 */
@property (nonatomic, assign) float delay;

- (instancetype)init;

@end

#pragma mark - equalizer format
/**
 * @brief value should be in range [-20, 20].
 */
@interface LSLiveAudioEqualizerFormat : NSObject <NSCopying>

@property (nonatomic) CGFloat preamp;

//31HZ
@property (nonatomic) CGFloat amp31;

//63HZ
@property (nonatomic) CGFloat amp63;

//125HZ
@property (nonatomic) CGFloat amp125;

//250HZ
@property (nonatomic) CGFloat amp250;

//500HZ
@property (nonatomic) CGFloat amp500;

//1kHZ
@property (nonatomic) CGFloat amp1000;

//2kHZ
@property (nonatomic) CGFloat amp2000;

//4kHZ
@property (nonatomic) CGFloat amp4000;

//8kHZ
@property (nonatomic) CGFloat amp8000;

//16kHZ
@property (nonatomic) CGFloat amp16000;

//EQ 宽度调节 [0,1]
//31HZ
@property (nonatomic) CGFloat freqWidth31;

//63HZ
@property (nonatomic) CGFloat freqWidth63;

//125HZ
@property (nonatomic) CGFloat freqWidth125;

//250HZ
@property (nonatomic) CGFloat freqWidth250;

//500HZ
@property (nonatomic) CGFloat freqWidth500;

//1kHZ
@property (nonatomic) CGFloat freqWidth1000;

//2kHZ
@property (nonatomic) CGFloat freqWidth2000;

//4kHZ
@property (nonatomic) CGFloat freqWidth4000;

//8kHZ
@property (nonatomic) CGFloat freqWidth8000;

//16kHZ
@property (nonatomic) CGFloat freqWidth16000;

- (instancetype)init;

@end

#pragma mark - audio cleaner format
//AudioCleaner(int sampleRate, Transform::Type nTransformType = Transform::MDFT_32X32X12, bool bAGC = true,  bool bANS = true, bool bAEC = false, bool blimiter = true, bool bHighNoiseMode = false, bool bBeam = false);
typedef NS_ENUM(NSUInteger, LSAudioCleanerTransformType) {
    MDCT_320X18 = 0,
    MDFT_512X320X18,
    MDFT_512X320X36,
    MDFT_512X384X36,
    MDFT_256X56X24,
    MDFT_32X32X12
};

@interface LSLiveAudioCleanerFormat : NSObject <NSCopying>

@property (nonatomic, assign) double sampleRate;

@property (nonatomic, assign) LSAudioCleanerTransformType transformType;

@property (nonatomic, assign) BOOL bAGC;

@property (nonatomic, assign) BOOL bANS;

@property (nonatomic, assign) BOOL bAEC;

@property (nonatomic, assign) BOOL bLimiter;

@property (nonatomic, assign) BOOL bHighNoiseMode;

@property (nonatomic, assign) BOOL bBeam;

- (instancetype)init;

@end

@interface LSLiveAudioExciterFormat : NSObject <NSCopying>

@property (nonatomic, assign) CGFloat gain;

@property (nonatomic, assign) NSInteger highpassfreq;

@end


/**
 *  @brief 单例，用于在编辑与转码模块之间共享音效数据
 */
@interface LSLiveAudioEffectData : NSObject

@property (nonatomic) LSLiveAudioReverbFormat*     reverbFormat;
@property (nonatomic) LSLiveAudioEqualizerFormat*  equalizerFormat;
@property (nonatomic) int                       stereoWidenWeightID;
@property (nonatomic) LSLiveAudioReverb2Format*    reverb2Format;
//TODO
@property (nonatomic) NSTimeInterval            musicStartTime;
@property (nonatomic, assign)BOOL               enableCleaner;
@property (nonatomic, assign)BOOL               enableExciter;
@property (nonatomic, assign)BOOL               enableCompressor;
+ (instancetype) sharedInstance;

- (instancetype) init;

@end



