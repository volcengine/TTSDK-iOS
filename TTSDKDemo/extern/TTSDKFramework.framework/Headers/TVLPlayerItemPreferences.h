//
//  TVLPlayerItemPreferences.h
//  TTVideoLive
//
//  Created by chenzhaojie on 2018/12/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TVLPriority) {
    TVLPriorityLow = 0,
    TVLPriorityDefault = NSIntegerMax >> 1,
    TVLPriorityHigh = NSIntegerMax,
};

typedef NSString * TVLPlayerItemPreferencesProperty;

OBJC_EXTERN TVLPlayerItemPreferencesProperty const TVLPlayerItemPreferencesPropertySourceType;
OBJC_EXTERN TVLPlayerItemPreferencesProperty const TVLPlayerItemPreferencesPropertyVideoCodecType;
OBJC_EXTERN TVLPlayerItemPreferencesProperty const TVLPlayerItemPreferencesPropertyFormatType;
OBJC_EXTERN TVLPlayerItemPreferencesProperty const TVLPlayerItemPreferencesPropertyProtocolType;
OBJC_EXTERN TVLPlayerItemPreferencesProperty const TVLPlayerItemPreferencesPropertyResolutionType;
OBJC_EXTERN TVLPlayerItemPreferencesProperty const TVLPlayerItemPreferencesPropertyParams;

typedef NSString * TVLPreferencesDataKey;

OBJC_EXTERN const TVLPreferencesDataKey TVLPreferencesDataKeyID;
OBJC_EXTERN const TVLPreferencesDataKey TVLPreferencesDataKeyURL;
OBJC_EXTERN const TVLPreferencesDataKey TVLPreferencesDataKeyMediaSourceType;
OBJC_EXTERN const TVLPreferencesDataKey TVLPreferencesDataKeyMediaFormatType;
OBJC_EXTERN const TVLPreferencesDataKey TVLPreferencesDataKeyMediaResolutionType;
OBJC_EXTERN const TVLPreferencesDataKey TVLPreferencesDataKeySDKParams;
OBJC_EXTERN const TVLPreferencesDataKey TVLPreferencesDataKeyHTTPHeaders;

// MARK: -

typedef NSString *TVLMediaSourceType;

OBJC_EXTERN const TVLMediaSourceType TVLMediaSourceTypeMain;
OBJC_EXTERN const TVLMediaSourceType TVLMediaSourceTypeBackup;

// MARK: -

typedef NSString *TVLVideoCodecType;

OBJC_EXTERN const TVLVideoCodecType TVLVideoCodecTypeH264;
OBJC_EXTERN const TVLVideoCodecType TVLVideoCodecTypeByteVC1;

// MARK: -

typedef NSString *TVLMediaFormatType;

OBJC_EXTERN const TVLMediaFormatType TVLMediaFormatTypeFLV;
OBJC_EXTERN const TVLMediaFormatType TVLMediaFormatTypeM3U8;
OBJC_EXTERN const TVLMediaFormatType TVLMediaFormatTypeCMAF;
OBJC_EXTERN const TVLMediaFormatType TVLMediaFormatTypeDASH;
OBJC_EXTERN const TVLMediaFormatType TVLMediaFormatTypeLLASH;
OBJC_EXTERN const TVLMediaFormatType TVLMediaFormatTypeLLS;
OBJC_EXTERN const TVLMediaFormatType TVLMediaFormatTypeTSL;
OBJC_EXTERN const TVLMediaFormatType TVLMediaFormatTypeAVPH;

// MARK: -

typedef NSString *TVLMediaProtocolType;

OBJC_EXTERN const TVLMediaProtocolType TVLMediaProtocolTypeTCP;
OBJC_EXTERN const TVLMediaProtocolType TVLMediaProtocolTypeTLS;
OBJC_EXTERN const TVLMediaProtocolType TVLMediaProtocolTypeQUIC;
OBJC_EXTERN const TVLMediaProtocolType TVLMediaProtocolTypeQUICU;
OBJC_EXTERN const TVLMediaProtocolType TVLMediaProtocolTypeKCP;
OBJC_EXTERN const TVLMediaProtocolType TVLMediaProtocolTypeRTP;

// MARK: -

typedef NSString *TVLMediaResolutionType;

OBJC_EXTERN const TVLMediaResolutionType TVLMediaResolutionTypeAuto;
OBJC_EXTERN const TVLMediaResolutionType TVLMediaResolutionTypeOrigin;
OBJC_EXTERN const TVLMediaResolutionType TVLMediaResolutionTypeLD;
OBJC_EXTERN const TVLMediaResolutionType TVLMediaResolutionTypeSD;
OBJC_EXTERN const TVLMediaResolutionType TVLMediaResolutionTypeHD;
OBJC_EXTERN const TVLMediaResolutionType TVLMediaResolutionTypeUHD;
OBJC_EXTERN const TVLMediaResolutionType TVLMediaResolutionTypeMD;
OBJC_EXTERN const TVLMediaResolutionType TVLMediaResolutionTypeAudioOnly;

// MARK: -

typedef NSString *TVLPreferencesParams;
typedef NSString *TVLPreferencesSuggestProtocol;

// MARK: -

/**
 A TVLPlayerItemPreferences object contains some resource info of a player item.
 */
@interface TVLPlayerItemPreferences : NSObject

@property (nonatomic, assign, readonly) NSUInteger ID;

@property (nonatomic, copy, readonly) TVLMediaSourceType sourceType;

@property (nonatomic, copy, readonly) TVLVideoCodecType videoCodecType;

@property (nonatomic, copy, readonly) TVLMediaFormatType formatType;

@property (nonatomic, copy, readonly) TVLMediaProtocolType protocolType;

@property (nonatomic, copy, readonly) TVLMediaResolutionType resolutionType;

@property (nonatomic, copy, readonly) TVLPreferencesParams params;

/// sdk_params
@property (nonatomic, copy, readonly) NSDictionary *options;

@property (nonatomic, copy, readonly) NSDictionary *HTTPHeaders;

@property (nonatomic, assign) TVLPriority priority;

@property (nonatomic, assign, getter=isHidden) BOOL hidden;

@property (nonatomic, assign, getter=isAdaptiveEnabled) BOOL adaptiveEnabled;

@property (nonatomic, assign, getter=isDefaultSelectd) BOOL defaultSelectd;

@property (nonatomic, assign, readonly) NSInteger defaultVideoBitrateForLLASH;

@property (nonatomic, assign, readonly) NSInteger defaultVideoBitrateInKbps;

@property (nonatomic, assign, readonly) NSInteger defaultVideoBitrate;

@property (nonatomic, assign, readonly) NSInteger GOPDurationInMillseconds;

@property (nonatomic, copy, readonly) TVLMediaFormatType suggestedFormatType;

@property (nonatomic, assign, readonly) BOOL supportsTimeShift;

@property (nonatomic, assign, readonly) BOOL allowsMainBackupSwitch;

@property (nonatomic, assign, readonly) BOOL allowsFormatFallback;

@property (nonatomic, assign, readonly) NSInteger timeShiftLowerBoundInSeconds;

@property (nonatomic, assign) NSInteger timeShiftInSeconds;

/**
 A convenience method create a instance with all property undefined.

 @return A preferences object with default values.
 */
+ (instancetype)defaultPreferences;

+ (instancetype)preferencesWithData:(NSDictionary<TVLPreferencesDataKey, id> *)data;

- (void)updateOptionsWithData:(id)data;


- (NSArray<NSURLQueryItem *> *)getUncommonQueryWithSDKParams;

- (BOOL)isEqualToPreferences:(TVLPlayerItemPreferences *)preferences requiredProperties:(NSArray<TVLPlayerItemPreferencesProperty> *)requiredProperties;

- (BOOL)isEqualToPreferences:(TVLPlayerItemPreferences *)preferences ignoreProperties:(nullable NSArray<TVLPlayerItemPreferencesProperty> *)ignoreProperties;

@end

NS_ASSUME_NONNULL_END
