//
//  TVLManager.h
//  Pods
//
//  Created by zhongshaofen on 2017/7/18.
//
//

#import <Foundation/Foundation.h>
#import "TVLProtocol.h"
#import "TVLPlayerItem.h"
#import "TVLConstDefine.h"

@interface TVLManager : NSObject

/**
 This method is used to activate the render
 You should call this method in app delegate's applicationDidBecomeActive: method, or it may result
 in no picture.
 */
+ (void)startOpenGLESActivity;

/**
 This method is used to deactive the render
 You should call this method in app delegate's applicationWillResignActive: method, or it may leads
 to crash
 */
+ (void)stopOpenGLESActivity;

/**
 Callback to get log of SDK. Considering efficiency, this property dosen't importIt any lock, and it is supposed to be set only once. Default is nil.
 */
@property (class, nonatomic, copy) TVLLogCallback logCallback;

/**
 The delegate of a TVLManager instance to respond to playback related messages.
 */
@property (nonatomic, weak) id<TVLDelegate> delegate;

/**
 Container of video content.
 */
@property (nonatomic, strong, readonly) UIView *playerView;

/**
 Render type. Default is TVLPlayerViewRenderTypeOpenGLES.
 */
@property (nonatomic, assign) TVLPlayerViewRenderType playerViewRenderType;

/**
 Video crop area. Default is CGRectNull, which means no crop.
 */
@property (nonatomic, assign) CGRect videoCropAreaFrame;

/**
 Video content area. Which depends on the scale mode of player view.
 */
@property (nonatomic, assign, readonly) CGRect videoAreaFrame;

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
 SDK provides DNS resolution and caching, and you can choose to use it or not.
 This strategy is well supported with HTTP streaming, but might failed with RTMP because not all media sever supports IP direct access. Default is YES.
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
 Allows video rendering or not. Works for self-developed player only and set before -play method called. Default is YES;
 */
@property (nonatomic, assign) BOOL allowsVideoRendering;

/**
 Optimum node info provided by this property, and default is nil. If you want to use node optimum, you are supposed to import NodeProber.
 */
@property (nonatomic, copy) TVLOptimumNodeInfoRequest optimumNodeInfoRequest;

/**
 SDK gets strategy via this block , and default is nil. If you want to use it, you are supposed to import NodeProber.
 */
@property (nonatomic, copy) TVLStrategyInfoRequest strategyInfoRequest;

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
@property (nonatomic, assign, getter=isClockSynchronizationEnabled) BOOL clockSynchronizationEnabled DEPRECATED_MSG_ATTRIBUTE("Own ClockSync has been deprecated.");

/**
 A NTP provide by app (middle). Default is NO.
 */
@property (nonatomic, assign, getter=isAppNTPEnabled) BOOL appNTPEnabled;

/**
 A NTP time provide by app.
 */
@property (nonatomic, assign) float ntpTimeDiffByApp;

/**
 The scale mode of player view. Default is TVLViewScalingModeAspectFit.
 */
@property (nonatomic, assign) TVLViewScalingMode playerViewScaleMode;

/**
 Media volume.
 */
@property (nonatomic, assign) float volume;
/**
 warning: this feature only support on sys ver > iOS 14.0
 default is NO , if your player will on a  PictureInPicture wrapper  at sometime , you can set this YES
 if set this YES , playerView will check if itSelf  on a PictureInPicture wrapper or not , if the result is true , the player can still play on background  app mode ,
 so this prop is just a config that determin if  playerView should check or not , this prop cannot determin if the player can still play on background  app mode
 Only condition
 */
@property (nonatomic, assign) BOOL supportPictureInPictureMode API_AVAILABLE(ios(14.0));

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
 Reset the player.
 */
- (void)reset;

/**
 Get current pixel buffer. Hardware decode valid only.
 */
- (CVPixelBufferRef)copyPixelBuffer;

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
 Allows ByteVC1 degrade to H.264 if possible or not. Default is NO;
 */
@property (nonatomic, assign) BOOL allowsByteVC1Degrade;

/**
 Recommended degrade sequence of resolution.
 */
+ (NSArray<TVLMediaResolutionType> *)recommendedResolutionDegradeSequence;

/**
 Provide a mapping table of IP <-> origin host. Only when user resolve domain themselves and use IP address to play dircetly.
 */
@property (nonatomic, strong) NSDictionary *ipMappingTable;

@end

@interface TVLManager (SEI)

/**
 Delay calculated by timestamp of SEI. This property is key-value observable. Default is 0, and will not change if there is no timestamp info in SEI.
 */
@property (nonatomic, readonly, assign) NSInteger delay;

@end

@interface TVLManager (HTTPAdaptiveStreaming)

/**
 Switch resolution without interrupting current streaming. HAS valid only.
 */
- (void)switchToResolution:(TVLMediaResolutionType)resolution completion:(TVLHTTPAdaptiveStreamingSwitchCompletion)completion;

@end

@interface TVLManager (Debugging)

@property (nonatomic, readonly, assign) CGFloat renderingFPS;

@property (nonatomic, readonly, copy) NSDictionary *debugInfoItems;

@property (nonatomic, readonly, copy) NSDictionary *formattedDebugInfoItems;

@property (nonatomic, readonly, copy) NSString *formattedDebugInfo;

/**
  thread safe
 */
@property (nonatomic, readonly, copy) NSDictionary *liveInfoItems;

@end

@interface TVLManager (Monitoring)

/**
 The  bigger one of current audio and video buffer.
 */
@property (nonatomic, readonly, assign) NSInteger currentBufferInMilliSeconds;

@property (nonatomic, readonly, assign) NSInteger maxCacheDurationInSeconds;

@property (nonatomic, readonly, assign) BOOL isBufferingQueueFull;

@property (nonatomic, assign) BOOL shouldReportTimeSeries;

@property (nonatomic, assign) BOOL shouldReportAudioFrame;

@property (nonatomic, copy) NSString *commonTag;

- (void)setProjectKey:(NSString *)projectKey;

- (void)setPreviewFlag:(BOOL)isPreview;

@end

@interface TVLManager (Deprecating)

+ (NSArray<TVLMediaResolutionType> *)recommendedrResolutionDegradeSequence DEPRECATED_MSG_ATTRIBUTE("Will be deprecated.");

- (void)closeAsync DEPRECATED_MSG_ATTRIBUTE("Will be deprecated, and you are highly recommended to close sasynchronously with GCD methods as this method does.");

- (BOOL)isManagerOfPlayer:(id)player;

@end
