//
//  TVLOption.h
//  TTVideoLive
//
//  Created by chenzhaojie on 2019/7/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TVLOptionByteVC1CodecType) {
    TVLOptionByteVC1CodecTypeFFmpeg  = 0,
    TVLOptionByteVC1CodecTypeKSY     = 1,
    TVLOptionByteVC1CodecTypeJX      = 2,
};

typedef NS_ENUM(NSUInteger, TVLPlayerOption) {
    TVLPlayerOptionKeepDecodingFreezeSize,
    TVLPlayerOptionByteVC1CodecType,
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
    TVLPlayerOptionVideoLastRenderTime,
    TVLPlayerOptionAudioLastRenderTime,
    TVLPlayerOptionVideoCropInfo,
    TVLPlayerOptionPlayerDidReceivePacketCallback,
    TVLPlayerOptionPlayerWillRenderFrameCallback,
    TVLPlayerOptionFrameDroppingTerminatedDTS,
    TVLPlayerOptionFrameDroppingDTSMaxDiff,
    TVLPlayerOptionEnableCacheSeiSI,
    TVLPlayerOptionUseAudioPool,
    TVLPlayerOptionEnableRenderStall,
    TVLPlayerOptionQuicConfigCached,
    TVLPlayerOptionQuicCHLOCount,
    TVLPlayerOptionNNSREnabled,
    TVLPlayerOptionVideoSRType,
    TVLPlayerOptionSRWidth,
    TVLPlayerOptionSRHeight,
    TVLPlayerOptionVideoSuperResolutionEnabled,
    TVLPlayerOptionVideoFrameWillProcessCallback,
    TVLPlayerOptionVideoProcessor,
    TVLPlayerOptionQuicSCFGPath,
    TVLPlayerOptionCheckSilenceInterval,
    TVLPlayerOptionQuicEnableCertVerify,
    TVLPlayerOptionVideoDeviceWaitStartTime,
    TVLPlayerOptionVideoDeviceWaitEndTime,
    TVLPlayerOptionStreamFormat,
    TVLPlayerOptionFLVABREnabled,
    TVLPlayerOptionABRPredictVideoBitrate,
    TVLPlayerOptionQuicOpenResult,
    TVLPlayerOptionStartRenderIgnoreWindowSize,
    TVLPlayerOptionQuicInitMtu, // 35
    TVLPlayerOptionQuicEnableDiscoveryMtu, //36
    TVLPlayerOptionQuicInitRtt,            
    TVLPlayerOptionQuicMaxCryptoRetransmissions,       
    TVLPlayerOptionQuicMaxCryptoRetransmissionTimeMs, 
    TVLPlayerOptionQuicMaxRetransmissions,
    TVLPlayerOptionQuicMaxRetransmissionTimeMs,
    TVLPlayerOptionQuicMaxAckDelay,
    TVLPlayerOptionQuicMinReceivedBeforeAckDecimation,
    TVLPlayerOptionQuicPadHello,
    TVLPlayerOptionQuicFixWillingAndAbleToWrite,
    TVLPlayerOptionQuicFixProcessTimer,
    TVLPlayerOptionQuicReadBlockTimeout,
    TVLPlayerOptionQuicReadBlockMode,
    TVLPlayerOptionQuicEnableUnreliable,
    TVLPlayerOptionQuicFixStreamFinAndRst,
    TVLPlayerOptionQuicVersion,
    TVLPlayerOptionQuicTimerVersion,
    TVLPlayerOptionQuicConfigOptimize,
    TVLPlayerOptionQuicInitSessionWindow,
    TVLPlayerOptionQuicInitStreamWindow,
    TVLPlayerOptionForceDecodeSwitch,
    TVLPlayerOptionForceDecodeMsGaps,
    TVLPlayerOptionForceRenderMsGaps,
    TVLPlayerOptionRadioModeEnabled,
    TVLPlayerOptionPlayerLogCallback,
    TVLPlayerOptionAudioVolumeBalanceEnable,
    TVLPlayerOptionAudioVolumeBalancePregainF,
    TVLPlayerOptionAudioVolumeBalanceThresholdF,
    TVLPlayerOptionAudioVolumeBalanceRatioF,
    TVLPlayerOptionAudioVolumeBalancePredelayF,
    TVLPlayerOptionPTSSyncedSEINotificationEnabled,
    TVLPlayerOptionVideoAreaFramePattern,
    TVLPlayerOptionVideoCropAreaFramePattern,
    TVLPlayerOptionStallCounterEnable,
    TVLPlayerOptionStallCounterInfoJson,
    TVLPlayerOptionLicenseModuleName,
    TVLPlayerOptionRTCPlayerEnabled,
    TVLPlayerOptionRTCPlayerInstance,
    TVLPlayerOptionRTCPlayerConfiguration,
    TVLPlayerOptionRTCPlayerSessionID,
    TVLPlayerOptionRTCStatisticsInfo,
    TVLPlayerOptionRTCInitedTimestamp,
    TVLPlayerOptionRTCOfferSentTimestamp,
    TVLPlayerOptionRTCAnswerReceivedTimestamp,
    TVLPlayerOptionRTCStartedTimestamp,
    TVLPlayerOptionRTCFallbackThreshod,
    TVLPlayerOptionRTCEnableHardwareDecode,
    TVLPlayerOptionRTCMinJitterBufferInMS,
    TVLPlayerOptionRTCMaxJitterBufferInMS,
    TVLPlayerOptionRTCEnableEarlyInitRender,
    TVLPlayerOptionRTCEnableRTCUinitLockFree,
    TVLPlayerOptionRTCEnableMiniSDP,
    TVLPlayerOptionRTCExpectServerIP,
    TVLPlayerOptionRTCTracePrintStr,
    TVLPlayerOptionSREnableAllResolution,
    TVLPlayerOptionSRFrameRateUpperBound,
    TVLPlayerOptionSRShouldSkipNextProcess,
    TVLPlayerOptionPlayerDidReceivePacketWithInfo,
    TVLPlayerOptionIsBufferingQueueFull,
    TVLPlayerOptionIsHurryMillisecond,
    TVLPlayerOptionIsSlowPlayMillisecond,
    TVLPlayerOptionIsAVStackEnabled,
    TVLPlayerOptionIsPlayerCoreOpenFailToTryEnabled,
    TVLPlayerOptionIsDecodeMultiSEIEnabled,
    TVLPlayerOptionNotifySEIImmediatelyBeforeFirstFrameEnabled,
    TVLPlayerOptionUseAudioGraphPool,
    TVLPlayerOptionMarkingParsedSEIEnabled,
    TVLPlayerOptionAVPHVideoProbeSize,
    TVLPlayerOptionAVPHVideoMaxDuration,
    TVLPlayerOptionAVPHAudioProbeSize,
    TVLPlayerOptionAVPHAudioMaxDuration,
    TVLPlayerOptionAVPHOpenVideoFirst,
    TVLPlayerOptionAVPHMaxAVDiff,
    TVLPlayerOptionAVPHEnableAutoReopen,
    TVLPlayerOptionAVPHAutoExit,
    TVLPlayerOptionAVPHVideoDiffThreshold,
    TVLPlayerOptionAVPHReadRetryCount,
    TVLPlayerOptionAVPHReadErrorExit,
    TVLPlayerOptionAVPHStreamInfo,
    TVLPlayerOptionEnableSkipFindUnnecessaryStream,
    TVLPlayerOptionEnableVideoProcessorMultiMode,
    TVLPlayerOptionVideoProcessorStartMode,
    TVLPlayerOptionVideoProcessorASFSceneMode,
    TVLPlayerOptionVideoProcessorASFAmount,
    TVLPlayerOptionVideoProcessorASFOverRatio,
    TVLPlayerOptionVideoProcessorASFEdgeWeightGamma,
    TVLPlayerOptionEnableCMAFFastMode,
    TVLPlayerOptionEnableCMAFVideoMPDRefresh,
    TVLPlayerOptionEnableSkipNullTag,
    TVLPlayerOptionEnableGetTimeOptimize,
    TVLPlayerOptionCmafMpdDnsAnalysisEnd,
    TVLPlayerOptionCmafMpdConnectTime,
    TVLPlayerOptionCmafMpdHttpReqFinishTime,
    TVLPlayerOptionCmafMpdTcpFirstPackageEnd,
    TVLPlayerOptionCmafMpdHttpResFinishTime,
    TVLPlayerOptionCmafMpdTcpConnectTime,
    TVLPlayerOptionCmafAudioDnsAnalysisEnd,
    TVLPlayerOptionCmafAudioTcpConnectTime,
    TVLPlayerOptionCmafAudioHttpReqFinishTime,
    TVLPlayerOptionCmafAudioTcpFirstPacketTime,
    TVLPlayerOptionCmafAudioHttpResFinishTime,
    TVLPlayerOptionCmafAudioFirstsegConnectTime,
    TVLPlayerOptionCmafVideoHttpReqFinishTime,
    TVLPlayerOptionCmafVideoHttpResFinishTime,
    TVLPlayerOptionCmafVideoFirstsegConnectTime,
    TVLPlayerOptionHurryType,
    TVLPlayerOptionHurryTime,
    TVLPlayerOptionCatchupSpeed,
    TVLPlayerOptionSlowPlayTime,
    TVLPlayerOptionSlowPlaySpeed,
    TVLPlayerOptionDroppingDTSRollbackFrameEnabled,
    TVLPlayerOptionHandleBackgroundInAvViewEnebled,
    TVLPlayerOptionSkipSetSameWindowEnabled,
    TVLPlayerOptionCacheVoiceIDEnabled,
    TVLPlayerOptionLLASHFastOpenEnabled,
    TVLPlayerOptionLLASHCheckEnhance,
    TVLPlayerOptionLLASHCheckIntervalInMilliseconds,
    TVLPlayerOptionLLASHMethod,
    TVLPlayerOptionLLASHNonKeyFrameSwitchBufferThreshold,
    TVLPlayerOptionLLASHSwitchCost,
    TVLPlayerOptionDecodeSEIEnabled,
    TVLPlayerOptionIgnoreBackgroundRenderStallEnabled,
    TVLPlayerOptionAudioProcessWrapper
};


typedef NS_ENUM(NSUInteger, TVLPlayerOptionValueType) {
    TVLPlayerOptionValueTypeUnknown,
    TVLPlayerOptionValueTypeInt,
    TVLPlayerOptionValueTypeInt64,
    TVLPlayerOptionValueTypeFloat,
    TVLPlayerOptionValueTypeString,
    TVLPlayerOptionValueTypeVoidPtr,
};

typedef NS_ENUM(NSUInteger, TVLOptionDomain) {
    TVLOptionDomainUndefined,
    TVLOptionDomainCore,
};

@interface TVLOption : NSObject

+ (TVLOptionDomain)optionDomainForIdentifier:(id)identifier;

+ (TVLPlayerOptionValueType)valueTypeForIdentifier:(id)identifier;

+ (NSInteger)keyForIdentifier:(id)identifier;

+ (nullable instancetype)optionWithValue:(id)value identifier:(id)identifier;

@property (nonatomic, assign, readonly, getter=isValid) BOOL valid;

@property (nonatomic, assign, readonly, getter=isAsync) BOOL async;

@property (nonatomic, assign, readonly) TVLPlayerOptionValueType type;
/**
 Is take effect immediately?
 If the key is as follows, return YES, otherwise NO.
 
 TVLPlayerOptionNNSREnabled
 TVLPlayerOptionAudioRenderDeviceType
 TVLPlayerOptionSRShouldSkipNextProcess
 TVLPlayerOptionRadioModeEnabled
 */
@property (nonatomic, assign, readonly) BOOL shouldTakeEffectImmediately;

@property (nonatomic, assign, readonly) NSInteger key;

@property (nonatomic, strong, readonly) id identifier;

@property (nonatomic, strong, readonly) id value;

@end

NS_ASSUME_NONNULL_END
