//
//  TVLSettingsManager.h
//  TTVideoLive
//
//  Created by 陈昭杰 on 2019/5/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyLiveSettingsState;
FOUNDATION_EXTERN NSString *TVLSettingsItemKeyIsH264HardwareDecodeEnabled;
FOUNDATION_EXTERN NSString *TVLSettingsItemKeyIsH265HardwareDecodeEnabled;
FOUNDATION_EXTERN NSString *TVLSettingsItemKeyMaxCacheSeconds;
FOUNDATION_EXTERN NSString *TVLSettingsItemKeyShouldReportTimeSeries;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyIsHurryEnabled;
FOUNDATION_EXTERN NSString *TVLSettingsItemKeyCatchupSpeed;
FOUNDATION_EXTERN NSString *TVLSettingsItemKeyHurryTime;
FOUNDATION_EXTERN NSString *TVLSettingsItemKeySlowPlaySpeed;
FOUNDATION_EXTERN NSString *TVLSettingsItemKeySlowPlayTime;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyIgnoreVideoBufferring;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyIsHTTPKDegradeEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyIsFastOpenEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyIsFPSProbeSize;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyIsNTPSyncEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyIsEnableAdaptedWatermark;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyIsStartPlayAudioBufferThreshold;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyIsBufferingEndIgnoreVideo;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyIsAdvancedBufferringCheckEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyIsHTTPDNSEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyIsH265DegradeEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyIsResolutionDegradeEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyResolutionDegradeConditionStallCount;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyAudioRenderDeviceType;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyJXCodecDropNALUEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyTCPFastOpenEnabled;

@protocol TVLSettingsManagerDataSource <NSObject>

- (NSDictionary *)currentSettings;

@end

@interface TVLSettingsManagerDataSource : NSObject <TVLSettingsManagerDataSource>

+ (instancetype)defaultDataSource;

@property (nonatomic, assign) BOOL allowsSettingsAutoUpdate;

- (void)updateSettings:(BOOL)forced;

@end

@interface TVLSettingsManager : NSObject

@property (nonatomic, weak) id<TVLSettingsManagerDataSource> dataSource;

@property (copy, readonly) NSDictionary *currentSettings;

+ (instancetype)defaultManager;

- (void)updateCurrentSettings;

@end

@interface TVLSettingsManager (Settings)

@property (nonatomic, assign, readonly) NSInteger resolutionDegradeConditionStallCount;

@property (nonatomic, assign, readonly) BOOL isResolutionDegradeEnabled;

@property (nonatomic, assign, readonly) BOOL isHTTPDNSEnabled;

@property (nonatomic, assign, readonly) BOOL isAdvancedBufferringCheckEnabled;

@property (nonatomic, assign, readonly) BOOL isH265DegradeEnabled;

@property (nonatomic, assign, readonly) BOOL isHTTPKDegradeEnabled;

@property (nonatomic, assign, readonly) BOOL isFastOpenEnabled;

@property (nonatomic, assign, readonly) BOOL isH264HardwareDecodeEnabled;

@property (nonatomic, assign, readonly) BOOL isH265HardwareDecodeEnabled;

@property (nonatomic, assign, readonly) BOOL isClockSynchronizationEnabled;

@property (nonatomic, assign, readonly) BOOL shouldReportTimeSeries;

@property (nonatomic, assign, readonly) BOOL shouldIgnoreVideoBufferring;

@property (nonatomic, assign, readonly) NSInteger maxCacheDurationInSeconds;

@property (nonatomic, assign, readonly, getter=isHurryEnabled) BOOL hurryEnabled;

@property (nonatomic, assign, readonly) NSInteger hurryTime;

@property (nonatomic, assign, readonly) NSInteger slowPlayTime;

@property (nonatomic, assign, readonly) float catchSpeed;

@property (nonatomic, assign, readonly) float slowSpeed;

@property (nonatomic, assign, readonly) NSInteger FPSProbeSize;

@property (nonatomic, assign, readonly) BOOL isAdaptedWatermarkEnabled;

@property (nonatomic, assign, readonly) NSInteger startPlayAudioBufferThresholdInMilliseconds;

@property (nonatomic, assign, readonly) BOOL isBufferingEndIgnoreVideo;

@property (nonatomic, assign, readonly) NSInteger audioRenderDeviceType;

@property (nonatomic, assign, readonly) BOOL isJXCodecDropNALUEnabled;

@property (nonatomic, assign, readonly) BOOL isTCPFastOpenEnabled;

@end

@interface TVLSettingsManager (Monitoring)

@property (nonatomic, strong, readonly) NSDictionary *settingsInfo;

@end

NS_ASSUME_NONNULL_END
