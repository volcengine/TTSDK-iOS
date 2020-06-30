//
//  TVLPlayerItemPreferences.h
//  TTVideoLive
//
//  Created by 陈昭杰 on 2018/12/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TVLPriority) {
    TVLPriorityLow = 0,
    TVLPriorityDefault = NSIntegerMax >> 1,
    TVLPriorityHigh = NSIntegerMax,
};

// MARK: -

typedef NSString *TVLMediaSourceType;

OBJC_EXTERN const TVLMediaSourceType TVLMediaSourceTypeMain;
OBJC_EXTERN const TVLMediaSourceType TVLMediaSourceTypeBackup;

// MARK: -

typedef NSString *TVLVideoCodecType;

OBJC_EXTERN const TVLVideoCodecType TVLVideoCodecTypeH264;
OBJC_EXTERN const TVLVideoCodecType TVLVideoCodecTypeH265;

// MARK: -

typedef NSString *TVLMediaFormatType;

OBJC_EXTERN const TVLMediaFormatType TVLMediaFormatTypeFLV;
OBJC_EXTERN const TVLMediaFormatType TVLMediaFormatTypeM3U8;

// MARK: -

typedef NSString *TVLMediaResolutionType;

OBJC_EXTERN const TVLMediaResolutionType TVLMediaResolutionTypeOrigin;
OBJC_EXTERN const TVLMediaResolutionType TVLMediaResolutionTypeLD;
OBJC_EXTERN const TVLMediaResolutionType TVLMediaResolutionTypeSD;
OBJC_EXTERN const TVLMediaResolutionType TVLMediaResolutionTypeHD;
OBJC_EXTERN const TVLMediaResolutionType TVLMediaResolutionTypeUHD;
OBJC_EXTERN const TVLMediaResolutionType TVLMediaResolutionTypeMD;
OBJC_EXTERN const TVLMediaResolutionType TVLMediaResolutionTypeAudioOnly;

// MARK: -

typedef NSString *TVLPreferencesParams;

// MARK: -

/**
 A TVLPlayerItemPreferences object contains some resource info of a player item.
 */
@interface TVLPlayerItemPreferences : NSObject

@property (nonatomic, copy) TVLMediaSourceType sourceType;

@property (nonatomic, copy) TVLVideoCodecType videoCodecType;

@property (nonatomic, copy) TVLMediaFormatType formatType;

@property (nonatomic, copy) TVLMediaResolutionType resolutionType;

@property (nonatomic, copy) TVLPreferencesParams params;

@property (nonatomic, copy) NSDictionary *options;

@property (nonatomic, assign) TVLPriority priority;

/**
 A convenience method create a instance with all property undefined.

 @return A preferences object with default values.
 */
+ (instancetype)defaultPreferences;

- (void)updateOptionsWithData:(id)data;

@end

NS_ASSUME_NONNULL_END
