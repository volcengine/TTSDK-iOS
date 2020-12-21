//
//  TTVideoEngineModelDef.h
//  Article
//
//  Created by Chen Hong on 15/5/8.
//
//

#import "TTAVPreloaderItem.h"

typedef NS_ENUM(NSUInteger, TTVideoEnginePlayType) {
    TTVideoEnginePlayTypeDefault = 0, // 默认
    TTVideoEnginePlayTypeNormal = 1, // 点播
    TTVideoEnginePlayTypeLive = 2, // 直播
    TTVideoEnginePlayTypeLivePlayback = 3, // 直播回放
    TTVideoEnginePlayTypePasterAD = 100 // 贴片广告 (server不依赖该值)
};

typedef NS_ENUM(NSUInteger,TTVideoEngineDataLoaderErrorType) {
    TTVideoEngineDataLoaderErrorNone,
    TTVideoEngineDataLoaderErrorFetchVideoInfo, /// Fetch videoInfo error.
    TTVideoEngineDataLoaderErrorStart,          /// Start local server error.
    TTVideoEngineDataLoaderErrorFetchData,      /// Download data error.
    TTVideoEngineDataLoaderErrorWriteFile,      /// Write file error.
};


/**
 *  视频清晰度
 */
typedef NS_ENUM(NSUInteger, TTVideoEngineResolutionType) {
    /**
     *  标清
     */
    TTVideoEngineResolutionTypeSD = 0,
    /**
     *  高清
     */
    TTVideoEngineResolutionTypeHD = 1,
    /**
     *  超清
     */
    TTVideoEngineResolutionTypeFullHD = 2,
    /**
     *  1080P
     */
    TTVideoEngineResolutionType1080P = 3,
    /**
     *  4K
     */
    TTVideoEngineResolutionType4K = 4,
    /**
     *  自动调节
     */
    TTVideoEngineResolutionTypeAuto = 5,
    /**
     *  未知
     */
    TTVideoEngineResolutionTypeUnknown = 6,
    
    TTVideoEngineResolutionTypeSD_L = 7, // 240p
    TTVideoEngineResolutionTypeHD_H = 8, // 540p
};


NS_INLINE NSArray<NSNumber *> *TTVideoEngineAllResolutions(void) {
    return @[@(TTVideoEngineResolutionTypeSD_L),@(TTVideoEngineResolutionTypeSD),@(TTVideoEngineResolutionTypeHD),
             @(TTVideoEngineResolutionTypeHD_H),@(TTVideoEngineResolutionTypeFullHD),@(TTVideoEngineResolutionType1080P)
             ,@(TTVideoEngineResolutionType4K)];
}

/// Default video resolution map.
NS_INLINE NSDictionary *TTVideoEngineDefaultVideoResolutionMap(void) {
    return @{
             @"240p":@(TTVideoEngineResolutionTypeSD_L),
             @"360p":@(TTVideoEngineResolutionTypeSD),
             @"480p":@(TTVideoEngineResolutionTypeHD),
             @"540p":@(TTVideoEngineResolutionTypeHD_H),
             @"720p":@(TTVideoEngineResolutionTypeFullHD),
             @"1080p":@(TTVideoEngineResolutionType1080P),
             @"4k":@(TTVideoEngineResolutionType4K),
             };
}

/// Default audio resolution map.
NS_INLINE  NSDictionary *TTVideoEngineDefaultAudioResolutionMap(void) {
    return @{
             @"medium":@(TTVideoEngineResolutionTypeSD),
             @"higher":@(TTVideoEngineResolutionTypeHD),
             @"highest":@(TTVideoEngineResolutionTypeFullHD),
             @"original":@(TTVideoEngineResolutionType1080P),
             };
}


#ifndef isEmptyStringForVideoPlayer
#define isEmptyStringForVideoPlayer(str) (!str || ![str isKindOfClass:[NSString class]] || str.length == 0)
#endif
