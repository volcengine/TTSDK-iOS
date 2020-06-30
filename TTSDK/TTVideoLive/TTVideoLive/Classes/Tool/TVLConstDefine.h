//
//  TVLConstDefine.h
//  Pods
//
//  Created by 钟少奋 on 2017/7/19.
//
//

#pragma once

// TODO: Divide into related modules.

typedef NSDictionary *(^TVLOptimumNodeInfoRequest)(NSString *playURL);

typedef NS_ENUM(NSInteger, TVLPlayerLoadState) {
    TVLPlayerLoadStateUnknown,
    TVLPlayerLoadStateStalled,
    TVLPlayerLoadStatePlayable,
    TVLPlayerLoadStateError,
};

typedef NS_ENUM(NSInteger, TVLPlayerStallReason) {
    TVLPlayerStallNone = -1,
    TVLPlayerStallNetwork,
    TVLPlayerStallDecoder,
};

typedef NS_ENUM(NSUInteger, TVLLiveStatus) {
    TVLLiveStatusUnknow,
    TVLLiveStatusEnd,
    TVLLiveStatusWaiting,
    TVLLiveStatusOngoing,
    TVLLiveStatusFail,
    TVLLiveStatusPulling
};

typedef NS_ENUM(NSInteger, TVLPlayerPlaybackState) {
    TVLPlayerPlaybackStateUnknown,
    TVLPlayerPlaybackStateStopped,   //播放停止
    TVLPlayerPlaybackStatePlaying,   //正在播放
    TVLPlayerPlaybackStatePaused,    //播放暂停
    TVLPlayerPlaybackStateError,     //播放出错
};

typedef NS_ENUM(NSInteger, TVLRetryReason) {
    TVLRetryReasonStall = -1001,
    TVLRetryReasonError = -1002,
    TVLRetryReasonBackgroundSwitch = -1003,
};

typedef NS_ENUM(NSInteger, TVLRetryStrategy) {
    TVLRetryReportOut = -1,
    TVLRetryFetchLiveInfo = 0,
    TVLRetryNextURL = 1,
    TVLRetryResetPlayer = 2,
    TVLRetryDirectRetry = 3,
};

typedef NS_ENUM(NSInteger, TVLSourceType) {
    TVLSourceUnknown = 0,
    TVLSourceLiveID  = 1,
    TVLSourceDirectURL = 2,
    TVLSourceStreamID = 3,
};

typedef NS_ENUM(NSUInteger, TVLImageLayoutType) {
    TVLLayoutTypeAspectFit,
    TVLLayoutTypeToFill,
    TVLLayoutTypeAspectFill
};

typedef NS_ENUM(NSInteger, TVLViewScalingMode) {
    TVLViewScalingModeNone,       // No scaling
    TVLViewScalingModeAspectFit,  // Uniform scale until one dimension fits
    TVLViewScalingModeAspectFill, // Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents
    TVLViewScalingModeFill        // Non-uniform scale. Both render dimensions will exactly match the visible bounds
};

typedef NS_ENUM(NSInteger, TVLPlayerViewAlignMode) {
    TVLPlayerViewAlignModeCenter = 0,
    TVLPlayerViewAlignModeLeftTop = 1,
    TVLPlayerViewAlignModeLeftCenter = 2,
    TVLPlayerViewAlignModeLeftBottom = 3,
    TVLPlayerViewAlignModeTopCenter = 4,
    TVLPlayerViewAlignModeBottomCenter = 5,
    TVLPlayerViewAlignModeRightTop = 6,
    TVLPlayerViewAlignModeRightCenter = 7,
    TVLPlayerViewAlignModeRightBottom = 8,
};

typedef NS_ENUM(NSInteger, TVLStreamResolution) {
    TVLStreamResolutionHigh = 0,
    TVLStreamResolutionMedium = 1,
    TVLStreamResolutionLow = 2,
    TVLStreamResolutionOrigin = 3,
};

typedef NS_ENUM(NSInteger, TVLStreamVideoFormat) {
    TVLStreamFLVFormat = 0,
    TVLStreamHLSFormat = 1,
    TVLStreamRTMPFormat = 2,
};

extern NSString *const kLiveErrorMessageKey;
extern NSErrorDomain const kLiveErrorDomain;

