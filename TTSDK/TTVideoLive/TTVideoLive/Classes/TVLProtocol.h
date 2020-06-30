//
//  TVLProtocol.h
//  Pods
//
//  Created by 钟少奋 on 2017/7/18.
//
//

#import <Foundation/Foundation.h>
#import "TVLConstDefine.h"
#import "TVLPlayerItem.h"

// TODO: Need a better delegate protocol declaration.

@class TVLManager;

@protocol TVLAdvising <NSObject>

- (BOOL)playerItem:(TVLPlayerItem *)playerItem shouldReplaceCurrentPreferencesWithSuggestedPreferences:(TVLPlayerItemPreferences * _Nonnull)suggestedPreferences;

- (TVLPlayerItemPreferences *)playerItem:(TVLPlayerItem *)playerItem customizedPreferencesWithUserInfo:(NSDictionary *)userInfo;

- (void)playerItem:(TVLPlayerItem *)playerItem didSwitchFromPreviousPreferences:(TVLPlayerItemPreferences *)previousPreferences toCurrentPreferences:(TVLPlayerItemPreferences *)currentPreferences;

- (void)playerItem:(TVLPlayerItem *)playerItem willSwitchFromPreferences:(TVLPlayerItemPreferences *)fromPreferences toPreferences:(TVLPlayerItemPreferences *)toPreferences;

- (void)playerItem:(TVLPlayerItem *)playerItem currentResolution:(TVLMediaResolutionType)currentResolution degradeFailedWithError:(NSError *)error;

@end

@protocol TVLDelegate <TVLAdvising>

@required
- (void)recieveError:(NSError *)error;
- (void)startRender;
- (void)stallStart;
- (void)stallEnd;
- (void)onStreamDryup:(NSError *)error;
- (void)liveStatusResponse:(TVLLiveStatus)status;
- (void)onMonitorLog:(NSDictionary*) event;

- (void)loadStateChanged:(NSNumber*)state;
- (void)itemStatusChanged:(NSNumber*)status DEPRECATED_MSG_ATTRIBUTE("Will be deprecated, use - manager:playerItemStatusDidChange: please.");

@optional

- (void)manager:(TVLManager *)manager playerItemStatusDidChange:(TVLPlayerItemStatus)status;

- (void)manager:(TVLManager *)manager didReceiveSEI:(NSDictionary *)SEI;

- (void)manager:(TVLManager *)manager videoSizeDidChange:(CGSize)size;

- (void)manager:(TVLManager *)manager didCloseInAsyncMode:(BOOL)isAsync;

@end
