//
//  TVLSettingsManager.h
//  TTVideoLive
//
//  Created by chenzhaojie on 2019/5/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyLiveSettingsState;
FOUNDATION_EXTERN NSString *TVLSettingsItemKeyIsH264HardwareDecodeEnabled;
FOUNDATION_EXTERN NSString *TVLSettingsItemKeyIsByteVC1HardwareDecodeEnabled;
FOUNDATION_EXTERN NSString *TVLSettingsItemKeyMaxCacheSeconds;
FOUNDATION_EXTERN NSString *TVLSettingsItemKeyShouldReportTimeSeries;
FOUNDATION_EXTERN NSString *TVLSettingsItemKeyShouldReportSessionStop;

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

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyIsByteVC1DegradeEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyIsResolutionDegradeEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyResolutionDegradeConditionStallCount;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyAudioRenderDeviceType;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyJXCodecDropNALUEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyTCPFastOpenEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyPlayerViewRenderType;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyHTTPDNSServerHost;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyVideoAutoCropEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyPacketDidReceiveCallbackEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyRepeatedDataDroppingEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyFrameWillRenderCallbackEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyShouldUseAudioPool;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyShouldUseAudioGraphPool;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyShouldConfigPlayerAsynchronously;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyDroppingRepeatingDataDTSMaxDiff;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyStartRenderIgnoreWindowSize;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeySuperResolutionEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeySRResolutionBlockList;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyShouldTryAllResolvedIPAddresses;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyPlayerLogCallbackEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyTTPlayerCanPlayAtBackgroundWhenInPictureInPictureWrapper;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyTTPlayerAudioVolumeBalanceEnable;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyTTPlayerAudioVolumeBalancePregain;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyTTPlayerAudioVolumeBalanceThreshold;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyTTPlayerAudioVolumeBalanceRatio;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyTTPlayerAudioVolumeBalancePredelay;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyPTSSyncedSEINotificationEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyNTPServerName;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyStartRenderCallbackTriggeringMode;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyUseRearPlayerCore;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyRTCFallbackThreshodInMilliseconds;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyAVStackEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyFormatFallbackList;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyStallRetryTimeIntervalInMilliseconds;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyDecodeMultiSEIEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyNotifySEIImmediatelyBeforeFirstFrameEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyMarkingParsedSEIEnabled;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyEnableCMAFFastMode;

FOUNDATION_EXTERN NSString *TVLSettingsItemKeyEnableCMAFVideoMPDRefresh;

// NTP. used to sync the clock between server
FOUNDATION_EXTERN NSString *TVLSettingsItemKeyClientServerTimeDiff;

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

- (BOOL)hasSettingsForKey:(NSString *)key;

@end

@interface TVLSettingsManager (Settings)

@property (nonatomic, copy, readonly) NSArray *recommendedResolutionDegradeSequence;

@property (nonatomic, assign, readonly) NSInteger resolutionDegradeConditionStallCount;

@property (nonatomic, assign, readonly) BOOL isResolutionDegradeEnabled;

@property (nonatomic, assign, readonly) BOOL isHTTPDNSEnabled;

@property (nonatomic, assign, readonly) BOOL isAdvancedBufferringCheckEnabled;

@property (nonatomic, assign, readonly) BOOL isByteVC1DegradeEnabled;

@property (nonatomic, assign, readonly) BOOL isHTTPKDegradeEnabled;

@property (nonatomic, assign, readonly) BOOL isFastOpenEnabled;

@property (nonatomic, assign, readonly) BOOL isH264HardwareDecodeEnabled;

@property (nonatomic, assign, readonly) BOOL isByteVC1HardwareDecodeEnabled;

@property (nonatomic, assign, readonly) BOOL isClockSynchronizationEnabled;

@property (nonatomic, assign, readonly) float ntpTimeDiffByApp;

@property (nonatomic, assign, readonly) BOOL shouldReportTimeSeries;

@property (nonatomic, assign, readonly) BOOL shouldReportSessionStop;

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

@property (nonatomic, assign, readonly) BOOL isVideoAutoCropEnabled;

@property (nonatomic, assign, readonly) BOOL shouldUseAudioPool;

@property (nonatomic, assign, readonly) BOOL shouldUseAudioGraphPool;

@property (nonatomic, assign, readonly) BOOL shouldEnableRenderStall;

@property (nonatomic, assign, readonly) BOOL shouldConfigPlayerAsynchronously;

@property (nonatomic, assign, readonly) NSInteger playerViewRenderType;

@property (nonatomic, assign, readonly) NSString *HTTPDNSServerHost;

@property (nonatomic, assign, readonly) BOOL isPacketDidReceiveCallbackEnabled;

@property (nonatomic, assign, readonly) BOOL isRepeatedDataDroppingEnabled;

@property (nonatomic, assign, readonly) BOOL isFrameWillRenderCallbackEnabled;

@property (nonatomic, assign, readonly) NSInteger droppingRepeatingDataDTSMaxDiff;

@property (nonatomic, assign, readonly) BOOL startRenderIgnoreWindowSize;

@property (nonatomic, assign, readonly) BOOL isSuperResolutionEnabled;

@property (nonatomic, copy, readonly) NSArray<NSString *> *SRResolutionBlockList;

@property (nonatomic, assign, readonly) BOOL isPlayerLogCallbackEnabled;

@property (nonatomic, assign, readonly) BOOL shouldTryAllResolvedIPAddresses;

@property (nonatomic, assign, readonly) BOOL isTTPlayerCanPlayAtBackgroundWhenInPictureInPictureWrapper;

@property (nonatomic, assign, readonly) BOOL isAudioVolumeBalanceEnable;

@property (nonatomic, assign, readonly) float audioVolumeBalancePregain;

@property (nonatomic, assign, readonly) float audioVolumeBalanceThreshold;

@property (nonatomic, assign, readonly) float audioVolumeBalanceRatio;

@property (nonatomic, assign, readonly) float audioVolumeBalancePredelay;

@property (nonatomic, assign, readonly) BOOL isPTSSyncedSEINotificationEnabled;

@property (nonatomic, assign, readonly) NSString *NTPServerName;

@property (nonatomic, assign, readonly) NSInteger startRenderCallbackTriggeringMode;

@property (nonatomic, assign, readonly) BOOL useRearPlayerCore;

@property (nonatomic, assign, readonly) NSInteger RTCFallbackThreshodInMilliseconds;

@property (nonatomic, assign, readonly) BOOL isAVStackEnabled;

@property (nonatomic, copy, readonly) NSArray<NSString *> *formatFallbackList;

@property (nonatomic, assign, readonly) NSInteger stallRetryTimeIntervalInMilliseconds;

@property (nonatomic, assign, readonly) BOOL isDecodeMultiSEIEnabled;

@property (nonatomic, assign, readonly) BOOL isNotifySEIImmediatelyBeforeFirstFrameEnabled;

@property (nonatomic, assign, readonly) BOOL isMarkingParsedSEIEnabled;

@property (nonatomic, assign, readonly) BOOL isCMAFFastModeEnabled;

@property (nonatomic, assign, readonly) BOOL isCMAFVideoMPDRefreshEnabled;

@property (nonatomic, assign, readonly) BOOL isDroppingDTSRollbackFrameEnabled;

@property (nonatomic, copy, readonly) NSDictionary *lowLatencyFLVDefaultStrategyMap;

@property (nonatomic, assign, readonly) BOOL isHandleBackgroundInAvViewEnebled;

@property (nonatomic, assign, readonly) BOOL isSkipSetSameWindowEnabled;

@property (nonatomic, assign, readonly) BOOL isAvoidUnnecessarySettingsConfigureEnabled;

@property (nonatomic, assign, readonly) BOOL isCacheVoiceIDEnabled;

@property (nonatomic, assign, readonly) BOOL isIgnoreBackgroundRenderStallEnabled;

@end

@interface TVLSettingsManager (Monitoring)

@property (nonatomic, strong, readonly) NSDictionary *settingsInfo;

@end

NS_ASSUME_NONNULL_END
