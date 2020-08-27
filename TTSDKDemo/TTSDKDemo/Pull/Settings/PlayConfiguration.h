//
//  PlayConfiguration.h
//  TTVideoLive-iOS
//
//  Created by 王可成 on 2018/8/23.
//

#import <Foundation/Foundation.h>

@interface PlayConfiguration : NSObject

@property (nonatomic, copy) NSString *playURL;
@property (nonatomic, assign) BOOL shouldAutoPlay;
@property (nonatomic, assign) BOOL enableLoopPlay;
@property (nonatomic, strong) TVLPlayerItem *playerItem;

@property (nonatomic, assign, getter=isHardwareDecodeEnabled) BOOL hardwareDecodeEnabled;
@property (nonatomic, assign, getter=isNodeOptimizingEnabled) BOOL nodeOptimizingEnabled;
@property (nonatomic, assign, getter=isPreferredToHTTPDNS) BOOL preferredToHTTPDNS;
@property (nonatomic, assign) BOOL shouldIgnoreSettings;
@property (nonatomic, assign) TVLViewScalingMode fillMode;
@property (nonatomic, copy) NSString *projectKey;
@property (nonatomic, copy) NSString *commonTag;
@property (nonatomic, assign) NSInteger retryTimeInternal;
@property (nonatomic, assign) NSInteger retryCountLimit;
@property (nonatomic, assign) NSInteger retryTimeLimit;
@property (nonatomic, assign) BOOL previewFlag;
@property (nonatomic, assign) BOOL shouldUseLiveDNS;
@property (nonatomic, assign) BOOL allowsAudioRendering;
@property (nonatomic, assign, getter=isClockSynchronizationEnabled) BOOL clockSynchronizationEnabled;
@property (nonatomic, assign, getter=isNetAdaptiveEnabled) BOOL netAdaptiveEnabled;
@property (nonatomic, assign) BOOL shouldArchiveLogs;
@property (nonatomic, copy) NSDictionary *settingsData;
@property (nonatomic, copy) NSDictionary *nodeOptimizeInfo;

+ (instancetype)defaultConfiguration;

@end
