//
//  TVLPlayerItem.h
//  TTVideoLive
//
//  Created by 陈昭杰 on 2018/11/23.
//

#import <Foundation/Foundation.h>
#import "TVLPlayerItemPreferences.h"
#import <CoreGraphics/CGGeometry.h>

@class TVLPlayerItemAccessLog;
@class TVLPlayerItemAccessLogEvent;

typedef NS_ENUM(NSInteger, TVLPlayerItemStatus) {
    TVLPlayerItemStatusUnknown,
    TVLPlayerItemStatusReadyToPlay,
    TVLPlayerItemStatusReadyToRender,
    TVLPlayerItemStatusFailed,
    TVLPlayerItemStatusCompleted,
};

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
 Prepares a player item with given URL and preferences pairs.

 @param infoData Specific pairs of URL and preferences.
 @return A new player item, prepared to use pairs of URL and preferences. If info data is invalid, nil will return.
 */
- (instancetype)initWithInfoData:(NSDictionary<NSURL *, TVLPlayerItemPreferences *> *)infoData;

/**
 Returns a new player item, prepared to use given URL and preferences pairs.
 
 @param infoData Specific pairs of URL and preferences.
 @return A new player item, prepared to use pairs of URL and preferences. If info data is invalid, nil will return.
 */
+ (instancetype)playerItemWithInfoData:(NSDictionary<NSURL *, TVLPlayerItemPreferences *> *)infoData;

+ (instancetype)playerItemWithStreamData:(NSDictionary *)streamData;

- (TVLPlayerItemPreferences * __nullable)recommendedPreferencesWithResolution:(TVLMediaResolutionType)resolution;

@end

@interface TVLPlayerItem (TVLPlayerItemLogging)

- (nullable TVLPlayerItemAccessLog *)accessLog;

@end

@interface TVLPlayerItemAccessLog : NSObject

@property (nonatomic, readonly) NSArray<TVLPlayerItemAccessLogEvent *> *events;

@property (nonatomic, readonly, copy) NSDictionary *currentAccessLogInfo;

@property (nonatomic, readonly, copy) NSDictionary *currentAccessLogDebugInfo;

@end

@interface TVLPlayerItemAccessLogEvent : NSObject <NSCopying>

@property (nonatomic, readonly, nullable) NSString *serverAddress;

@end
