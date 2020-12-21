//
//  TVLOption.h
//  TTVideoLive
//
//  Created by 陈昭杰 on 2019/7/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TVLOptionH265CodecType) {
    TVLOptionH265CodecTypeFFmpeg  = 0,
    TVLOptionH265CodecTypeKSY     = 1,
    TVLOptionH265CodecTypeJX      = 2,
};

typedef NS_ENUM(NSUInteger, TVLPlayerOption) {
    TVLPlayerOptionKeepDecodingFreezeSize,
    TVLPlayerOptionH265CodecType,
    TVLPlayerOptionIgnoreVideoBufferring,
    TVLPlayerOptionGetVideoResolutionFromSPS,
    TVLPlayerOptionFPSProbeSize,
    TVLPlayerOptionNetworkTimeout,
    TVLPlayerOptionEnableAdaptedWatermark,
    TVLPlayerOptionStartPlayAudioBufferThreshold,
    TVLPlayerOptionBufferingEndIgnoreVideo,
    TVLPlayerOptionAdvancedBufferringCheckEnabled,
    TVLPlayerOptionAudioRenderDeviceType,
    TVLPlayerOptionJXCodecDropNALUEnabled,
    TVLPlayerOptionTCPFastOpenEnabled,
};

typedef NS_ENUM(NSUInteger, TVLPlayerOptionValueType) {
    TVLPlayerOptionValueTypeUnknown,
    TVLPlayerOptionValueTypeInt,
    TVLPlayerOptionValueTypeInt64,
    TVLPlayerOptionValueTypeFloat,
    TVLPlayerOptionValueTypeString,
};

@interface TVLOption : NSObject

+ (nullable instancetype)optionWithValue:(id)value identifier:(id)identifier;

@property (nonatomic, assign, readonly, getter=isValid) BOOL valid;

@property (nonatomic, assign, readonly) TVLPlayerOptionValueType type;

@property (nonatomic, assign, readonly) NSInteger key;

@property (nonatomic, strong, readonly) id value;

@end

NS_ASSUME_NONNULL_END
