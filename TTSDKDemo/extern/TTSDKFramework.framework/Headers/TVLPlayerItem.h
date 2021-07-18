//
//  TVLPlayerItem.h
//  TTVideoLive
//
//  Created by chenzhaojie on 2018/11/23.
//

#import <Foundation/Foundation.h>
#import "TVLPlayerItemPreferences.h"
#import <CoreGraphics/CGGeometry.h>

NS_ASSUME_NONNULL_BEGIN

@class TVLPlayerItemAccessLog;
@class TVLPlayerItemAccessLogEvent;

typedef NS_ENUM(NSInteger, TVLPlayerItemStatus) {
    TVLPlayerItemStatusUnknown,
    TVLPlayerItemStatusReadyToPlay,
    TVLPlayerItemStatusReadyToRender,
    TVLPlayerItemStatusFailed,
    TVLPlayerItemStatusCompleted,
};

FOUNDATION_EXTERN NSString * const TVLPlayerItemSuggestedPreferencesUserInfoItemError;
FOUNDATION_EXTERN NSString * const TVLPlayerItemSuggestedPreferencesUserInfoItemFallbackInfo;

@interface TVLPlayerItem : NSObject

/**
 The size at which the visual portion of the item is presented by the player. It will return CGSizeZero prior to the player item becoming ready to play.
 */
@property (nonatomic, readonly) CGSize presentationSize;

/**
 The player item’s current preferences.
 */
@property (nonatomic, strong, nonnull) TVLPlayerItemPreferences *preferences;

/**
 Preferences that the player item’s supported.
 */
@property (nonatomic, copy, readonly) NSArray<TVLPlayerItemPreferences *> *supportedPreferences;

/**
 Resolutions that the player item’s supported.
 */
@property (nonatomic, copy, readonly) NSArray<TVLMediaResolutionType> *supportedResolutionTypes;

/**
 Prepares a player item with a given URL.

 @param URL A URL identifying the media resource to be played.
 @return A new player item, prepared to use URL. If URL is invalid, nil will return.
 */
- (instancetype)initWithURL:(NSURL *)URL;

/**
 Returns a new player item, prepared to use a given URL.

 @param URL A URL identifying the media resource to be played.
 @return A new player item, prepared to use URL. If URL is invalid, nil will return.
 */
+ (instancetype)playerItemWithURL:(NSURL *)URL;

/**
 Prepares a player item with stream data.

 @param streamData Stream related information.
 @return A new player item, initialized with stream data. If info data is invalid, nil will return.
 */
+ (instancetype)playerItemWithStreamData:(NSDictionary *)streamData;

- (nullable TVLPlayerItemPreferences *)recommendedPreferencesWithResolution:(TVLMediaResolutionType)resolution DEPRECATED_MSG_ATTRIBUTE("Will be deprecated.");

- (nullable TVLPlayerItemPreferences *)suggestedPreferencesWithPreferences:(TVLPlayerItemPreferences *)preferences userInfo:(nullable NSDictionary *)userInfo;

@end

@interface TVLPlayerItem (TVLPlayerItemLogging)

- (nullable TVLPlayerItemAccessLog *)accessLog;

@end

@interface TVLPlayerItemAccessLog : NSObject

@property (nonatomic, readonly, nullable) NSArray<TVLPlayerItemAccessLogEvent *> *events;

@property (nonatomic, readonly, copy) NSDictionary *currentAccessLogInfo;

@property (nonatomic, readonly, copy) NSDictionary *currentAccessLogDebugInfo;

@property (nonatomic, readonly, assign) NSInteger currentVideoBufferInMilliSeconds;

@property (nonatomic, readonly, assign) NSInteger currentAudioBufferInMilliSeconds;

@property (nonatomic, readonly, assign) NSInteger currentStallCount;

@end

NS_ASSUME_NONNULL_END
