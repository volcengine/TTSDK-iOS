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

typedef NS_ENUM(NSInteger, TTVideoEngineVideoModelSourceType) {
    TTVideoEngineVideoModelSourceTypeUnkonw    = 0,
    TTVideoEngineVideoModelSourceTypeMp4       = 1,
    TTVideoEngineVideoModelSourceTypeDash      = 10,
    TTVideoEngineVideoModelSourceTypeBash      = 11,
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

    /**由服务推荐的分辨率*/
    TTVideoEngineResolutionTypeAuto = 5,
    /**
     *  未知
     */
    TTVideoEngineResolutionTypeUnknown = 6,
    TTVideoEngineResolutionTypeSD_L = 7, // 240p
    TTVideoEngineResolutionTypeHD_H = 8, // 540p
    /**
     *  HDR
     */
    TTVideoEngineResolutionTypeHDR = 9,
    /**
     *  2K
     */
    TTVideoEngineResolutionType2K = 10,
    /**
     *  50Fps
     */
    TTVideoEngineResolutionType1080P_50F = 11,
    TTVideoEngineResolutionType2K_50F = 12,
    TTVideoEngineResolutionType4K_50F = 13,
    /**
     *  60Fps
     */
    TTVideoEngineResolutionType1080P_60F = 14,
    TTVideoEngineResolutionType2K_60F = 15,
    TTVideoEngineResolutionType4K_60F = 16,
    /**
     *  120Fps
     */
    TTVideoEngineResolutionType1080P_120F = 17,
    TTVideoEngineResolutionType2K_120F = 18,
    TTVideoEngineResolutionType4K_120F = 19,
    
    /**ABR自动档位通过configResolutin设置这个档位开启abr，但是本质和resoluttion不同，所以lastResolution,currentResoulution不应该设置这个值*/
    TTVideoEngineResolutionTypeABRAuto = 500,
 
};


NS_INLINE NSArray<NSNumber *> *TTVideoEngineAllResolutions(void) {
    return @[@(TTVideoEngineResolutionTypeSD_L),
             @(TTVideoEngineResolutionTypeSD),
             @(TTVideoEngineResolutionTypeHD),
             @(TTVideoEngineResolutionTypeHD_H),
             @(TTVideoEngineResolutionTypeFullHD),
             @(TTVideoEngineResolutionType1080P),
             @(TTVideoEngineResolutionType1080P_50F),
             @(TTVideoEngineResolutionType1080P_60F),
             @(TTVideoEngineResolutionType1080P_120F),
             @(TTVideoEngineResolutionTypeHDR),
             @(TTVideoEngineResolutionType2K),
             @(TTVideoEngineResolutionType2K_50F),
             @(TTVideoEngineResolutionType2K_60F),
             @(TTVideoEngineResolutionType2K_120F),
             @(TTVideoEngineResolutionType4K),
             @(TTVideoEngineResolutionType4K_50F),
             @(TTVideoEngineResolutionType4K_60F),
             @(TTVideoEngineResolutionType4K_120F)];
}
/// Default video resolution map.
NS_INLINE NSDictionary *TTVideoEngineDefaultVideoResolutionMap(void) {
    static dispatch_once_t onceToken;
    static NSDictionary *s_video_resolution_map = nil;
    dispatch_once(&onceToken, ^{
        s_video_resolution_map = @{
                                  @"240p":@(TTVideoEngineResolutionTypeSD_L),
                                  @"360p":@(TTVideoEngineResolutionTypeSD),
                                  @"480p":@(TTVideoEngineResolutionTypeHD),
                                  @"540p":@(TTVideoEngineResolutionTypeHD_H),
                                  @"720p":@(TTVideoEngineResolutionTypeFullHD),
                                  @"1080p":@(TTVideoEngineResolutionType1080P),
                                  @"1080p 50fps":@(TTVideoEngineResolutionType1080P_50F),
                                  @"1080p 60fps":@(TTVideoEngineResolutionType1080P_60F),
                                  @"1080p 120fps":@(TTVideoEngineResolutionType1080P_120F),
                                  @"hdr":@(TTVideoEngineResolutionTypeHDR),
                                  @"2k":@(TTVideoEngineResolutionType2K),
                                  @"2k 50fps":@(TTVideoEngineResolutionType2K_50F),
                                  @"2k 60fps":@(TTVideoEngineResolutionType2K_60F),
                                  @"2k 120fps":@(TTVideoEngineResolutionType2K_120F),
                                  @"4k":@(TTVideoEngineResolutionType4K),
                                  @"4k 50fps":@(TTVideoEngineResolutionType4K_50F),
                                  @"4k 60fps":@(TTVideoEngineResolutionType4K_60F),
                                  @"4k 120fps":@(TTVideoEngineResolutionType4K_120F),
                                  };
    });
    return s_video_resolution_map;
}

/// Default audio resolution map.
NS_INLINE NSDictionary *TTVideoEngineDefaultAudioResolutionMap(void) {
    static dispatch_once_t onceToken;
    static NSDictionary *s_audio_resolution_map = nil;
    dispatch_once(&onceToken, ^{
        s_audio_resolution_map = @{
                                   @"medium":@(TTVideoEngineResolutionTypeSD),
                                   @"higher":@(TTVideoEngineResolutionTypeHD),
                                   @"highest":@(TTVideoEngineResolutionTypeFullHD),
                                   @"original":@(TTVideoEngineResolutionType1080P),
                                   };
    });
    return s_audio_resolution_map;
}

