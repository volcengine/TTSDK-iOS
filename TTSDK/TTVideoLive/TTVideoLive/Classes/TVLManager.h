//
//  TVLManager.h
//  Pods
//
//  Created by 钟少奋 on 2017/7/18.
//
//

#import <Foundation/Foundation.h>
#import "TVLProtocol.h"
#import "TVLPlayerItem.h"
#import "TVLConstDefine.h"

@class UIView;
@class UIImage;

@interface TVLManager : NSObject

/**
 This method is used to activate the render
 You should call this method in app delegate's applicationDidBecomeActive: method, or it may result
 in black screen bug
 */
+ (void)startOpenGLESActivity;

/**
 This method is used to deactive the render
 You should call this method in app delegate's applicationWillResignActive: method, or it may leads
 to crash
 */
+ (void)stopOpenGLESActivity;

/**
 The delegate of a TVLManager instance to respond to playback related messages.
 */
@property (nonatomic, weak) id<TVLDelegate> delegate;

/**
 Container of video content.
 */
@property (nonatomic, strong, readonly) UIView *playerView;

/**
 Align mode of player view. Default is TVLPlayerViewAlignModeCenter.
 */
@property (nonatomic, assign) TVLPlayerViewAlignMode playerViewAlignMode;

/**
 Load state of player.
*/
@property (nonatomic, assign, readonly) TVLPlayerLoadState playerLoadState;

/**
 This property indicates the media is playing or not.
 */
@property (nonatomic, assign, readonly) BOOL isPlaying;

/**
 SDK provides DNS resolution and caching， and you can choose to use it or not. Default is YES.
 */
@property (nonatomic, assign) BOOL shouldUseLiveDNS;

/**
 Apply HTTP DNS. Default is NO.
 */
@property (nonatomic, assign, getter=isPreferredToHTTPDNS) BOOL preferredToHTTPDNS;

/**
 Indicates the player decodes with hardware or software. Default is NO, that says software decoding is default.
 */
@property (nonatomic, assign, getter=isHardwareDecode) BOOL hardwareDecode;

/**
 Allows audio rendering or not. Works for self-developed player only. Default is YES;
 */
@property (nonatomic, assign) BOOL allowsAudioRendering;

/**
 Optimum node info provided by this property, and default is nil. If you want to use node optimum, you are supposed to import NodeProber.
 */
@property (nonatomic, copy) TVLOptimumNodeInfoRequest optimumNodeInfoRequest;

/**
 The player’s current player item.
 */
@property (nonatomic, strong, readonly) TVLPlayerItem *currentItem;

/**
 The value of this property is an error object that describes what caused the receiver to no longer be able to play items. The value of this property is nil if no error happened.
 */
@property (nonatomic, strong, readonly) NSError *error;

/**
 The current playback state of the player.
 */
@property (nonatomic, assign, readonly) TVLPlayerPlaybackState playbackState;

/**
 Synchronize clock with NTP is enabled or not. Default is NO.
 */
@property (nonatomic, assign, getter=isClockSynchronizationEnabled) BOOL clockSynchronizationEnabled;

/**
 The designated initializer. Returns a newly initialized TVLManager object with the specific player type.

 @param isOwn Use own self-developed player.
 @return A newly initialized TVLManager object.
 */
- (instancetype)initWithOwnPlayer:(BOOL)isOwn NS_DESIGNATED_INITIALIZER;

/**
 Replaces the current player item with a new player item that   referenced by the given URL.

 @param URL A URL that identifies an audiovisual resource.
 */
- (void)replaceCurrentItemWithURL:(NSURL *)URL;

/**
 Replaces the current player item with a new player item.

 @param item A player item.
 */
- (void)replaceCurrentItemWithPlayerItem:(TVLPlayerItem *)item;

- (void)switchCurrentItemResolution:(TVLMediaResolutionType)newResolution;

- (void)switchCurrentItemPreferencesWithSupportedPreferences:(TVLPlayerItemPreferences *)preferences;

/**
 Retry maximum time limit when get stalled. Default is 60 seconds.
 */
- (void)setRetryTimeLimit:(NSUInteger)timeLimit;

/**
 Retry time interval when get stalled. That says player will do retry after stall start with specific time interval till play resume. Default is 5 seconds.
 */
- (void)setRetryTimeInternal:(NSTimeInterval)retryTimeInternal;

/**
 Retry maximum count limit when get stalled. Default is 5 times.
 */
- (void)setRetryCountLimit:(NSInteger)retryCountLimit;

/**
 Configure player with specific options provided with SDK.
 
 @param value The new value for the player's option specified by key.
 @param key The identifier of the option.
 */
- (void)setOptionValue:(id)value forIdentifier:(id)identifier;

/**
 You can do some settings to player directly. Not recommend.

 @param value The new value for the player's setting specified by key.
 @param key The name of one of the player's settings.
 */
- (void)setValue:(int)value forKey:(int)key;

/**
 You can do some settings to player directly. Not recommend.
 
 @param value The new value for the player's setting specified by key.
 @param key The name of one of the player's settings.
 */
- (void)setFloatValue:(float)value forKey:(int)key;

/**
 The image layout of player view. Default is TVLLayoutTypeAspectFit.
 */
- (void)setImageLayoutType:(TVLImageLayoutType)imageLayoutType;

/**
 The scale mode of player view. Default is TVLViewScalingModeAspectFit.
 */
- (void)setPlayerViewScaleMode:(TVLViewScalingMode)scaleMode;

/**
 Indicates the player is muted or not. Default is NO.
 */
- (void)setMuted:(BOOL)muted;

/**
 You can take screen shot with this method, and you will get the screen shot in the completion block.

 @param completionBlock Completion after screen shot got.
 */
- (void)takeScreenShot:(void(^)(UIImage *image))completionBlock;

/**
 Begins playback of the current item.
 */
- (void)play;

/**
 Pauses playback of the current item.
 */
- (void)pause;

/**
 Stop playback of the current item.
 */
- (void)stop;

/**
 Close player process.
 */
- (void)close;

/**
 Close player process asynchronously.
*/
- (void)closeAsync;

/**
 Reset the player.
 */
- (void)reset;

@end

@interface TVLManager (Strategy)

/**
 Try all IP addresses resolved by DNS or not. You are supposed to set this YES when single play URL only. Default is NO;
 */
@property (nonatomic, assign) BOOL shouldTryAllResolvedIPAddresses;

/**
 Allows resolution degrade or not. Default is NO;
 */
@property (nonatomic, assign) BOOL allowsResolutionDegrade;

/**
 Stall count that triggerring resolution degrade during a stream playing. Default is 4;
 */
@property (nonatomic, assign) NSInteger resolutionDegradeConditionStallCount;

/**
 Allows H.265 degrade to H.264 if possible or not. Default is NO;
 */
@property (nonatomic, assign) BOOL allowsH265Degrade;

/**
 Recommended degrade sequence of resolution.
 */
+ (NSArray<TVLMediaResolutionType> *)recommendedrResolutionDegradeSequence;

@end

@interface TVLManager (Debugging)

@property (nonatomic, readonly, copy) NSDictionary *debugInfoItems;

@property (nonatomic, readonly, copy) NSDictionary *formattedDebugInfoItems;

@property (nonatomic, readonly, copy) NSString *formattedDebugInfo;

@end

@interface TVLManager (Monitoring)

@property (nonatomic, assign) BOOL shouldReportTimeSeries;

@property (nonatomic, copy) NSString *commonTag;

- (void)setProjectKey:(NSString *)projectKey;

- (void)setPreviewFlag:(BOOL)isPreview;

@end
