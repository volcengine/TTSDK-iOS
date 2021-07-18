//
//  LSLiveAudioSysEffectFmt.h
//  LSVideoEditor
//
//  Created by tangzhixin on 2018/9/17.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface LSLiveReverbModel : NSObject

// range is from 0 to 100 (percentage). Default is 0.
@property (nonatomic) double dryWetMix;

// range is from -20dB to 20dB. Default is 0dB.
@property (nonatomic) double gain;

// range is from 0.0001 to 1.0 seconds. Default is 0.008 seconds.
@property (nonatomic) double minDelayTime;

// range is from 0.0001 to 1.0 seconds. Default is 0.050 seconds.
@property (nonatomic) double maxDelayTime;

// range is from 0.001 to 20.0 seconds. Default is 1.0 seconds.
@property (nonatomic) double decayTimeAt0Hz;

// range is from 0.001 to 20.0 seconds. Default is 0.5 seconds.
@property (nonatomic) double decayTimeAtNyquist;

// range is from 1 to 1000 (unitless). Default is 1.
@property (nonatomic) double randomizeReflections;

// range is from 10Hz to 20000Hz. Default is 800Hz.
@property (nonatomic) double filterFrequency;

// range is from 0.05 to 4.0 octaves. Default is 3.0 octaves.
@property (nonatomic) double filterBandwidth;

// range is from -18dB to 18dB. Default is 0.0dB.
@property (nonatomic) double filterGain;

@end

@interface LSLiveDynamicsProcessorModel : NSObject

// range is from -40dB to 20dB. Default is -20dB.
@property (nonatomic) double threshold;

// range is from 0.1dB to 40dB. Default is 5dB.
@property (nonatomic) double headRoom;

// range is from 1 to 50 (rate). Default is 2.
@property (nonatomic) double expansionRatio;

// Value is in dB.
@property (nonatomic) double expansionThreshold;

// range is from 0.0001 to 0.2. Default is 0.001.
@property (nonatomic) double attackTime;

// range is from 0.01 to 3. Default is 0.05.
@property (nonatomic) double releaseTime;

// range is from -40dB to 40dB. Default is 0dB.
@property (nonatomic) double masterGain;


@end


