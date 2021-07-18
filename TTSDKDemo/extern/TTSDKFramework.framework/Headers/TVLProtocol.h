//
//  TVLProtocol.h
//  Pods
//
//  Created by zhongshaofen on 2017/7/18.
//
//

#import <Foundation/Foundation.h>
#import "TVLConstDefine.h"
#import "TVLPlayerItem.h"

// TODO: Need a better delegate protocol declaration.

@class TVLManager;

NS_ASSUME_NONNULL_BEGIN

@protocol TVLAdvising <NSObject>

@optional

- (void)playerItem:(TVLPlayerItem *)playerItem didSwitchFromPreviousPreferences:(TVLPlayerItemPreferences *)previousPreferences toCurrentPreferences:(TVLPlayerItemPreferences *)currentPreferences;

- (void)playerItem:(TVLPlayerItem *)playerItem willSwitchFromPreferences:(TVLPlayerItemPreferences *)fromPreferences toPreferences:(TVLPlayerItemPreferences *)toPreferences;

- (void)playerItem:(TVLPlayerItem *)playerItem currentResolution:(TVLMediaResolutionType)currentResolution degradeFailedWithError:(NSError *)error;

- (BOOL)playerItem:(TVLPlayerItem *)playerItem shouldReplaceCurrentPreferencesWithSuggestedPreferences:(TVLPlayerItemPreferences * _Nonnull)suggestedPreferences DEPRECATED_MSG_ATTRIBUTE("Will be deprecated.");

- (TVLPlayerItemPreferences *)playerItem:(TVLPlayerItem *)playerItem customizedPreferencesWithUserInfo:(NSDictionary *)userInfo DEPRECATED_MSG_ATTRIBUTE("Will be deprecated.");;

@end

@protocol TVLABR <NSObject>

@optional

- (void)manager:(TVLManager *)manager didAutomaticallySwitchFromPreviousResolution:(TVLMediaResolutionType)previousResolution toCurrentResolution:(TVLMediaResolutionType)currentResolution;

@end

@protocol TVLNetworking <NSObject>

@optional

- (void)manager:(TVLManager *)manager performRequestWithURL:(NSString *)URL method:(NSString *)method headerField:(NSDictionary *)headerField params:(id)params completion:(TVLNetworkRequestCompletion)completion;

@end

@protocol TVLDelegate <TVLAdvising, TVLABR, TVLNetworking>

@required
- (void)recieveError:(NSError *)error;
- (void)startRender;
- (void)stallStart;
- (void)stallEnd;
- (void)onStreamDryup:(NSError *)error;
- (void)onMonitorLog:(NSDictionary*) event;

- (void)loadStateChanged:(NSNumber*)state;

@optional

- (void)manager:(TVLManager *)manager playerItemStatusDidChange:(TVLPlayerItemStatus)status;

- (void)manager:(TVLManager *)manager didReceiveSEI:(NSDictionary *)SEI;

- (void)manager:(TVLManager *)manager videoSizeDidChange:(CGSize)size;

- (void)manager:(TVLManager *)manager videoCropAreaDidAutomaticallyChange:(CGRect)frame;

- (void)manager:(TVLManager *)manager willOpenAudioRenderWithSampleRate:(int)sampleRate channels:(int)channels duration:(int)duration;

- (void)manager:(TVLManager *)manager willProcessAudioFrameWithRawData:(float **)rawData samples:(int)samples timeStamp:(int64_t)timestamp;

- (void)manager:(TVLManager *)manager didCloseInAsyncMode:(BOOL)isAsync;

- (void)itemStatusChanged:(NSNumber*)status DEPRECATED_MSG_ATTRIBUTE("Will be deprecated, use - manager:playerItemStatusDidChange: please.");

- (void)manager:(TVLManager *)manager videoCropAreaDidChange:(CGRect)frame DEPRECATED_MSG_ATTRIBUTE("Will be deprecated.");

@end

NS_ASSUME_NONNULL_END
