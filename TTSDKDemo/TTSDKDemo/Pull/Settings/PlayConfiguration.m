//
//  PlayConfiguration.m
//  TTVideoLive-iOS
//
//  Created by 王可成 on 2018/8/23.
//

#import "PlayConfiguration.h"

@implementation PlayConfiguration
static NSString *IP_ADDRESS = @"IPAddressUserDefaultKey";
static NSString *DOMAIN_NAME = @"DomainNameUserDefaultKey";

+ (instancetype)defaultConfiguration {
    PlayConfiguration *defaultConfiguration = [[PlayConfiguration alloc] init];
    defaultConfiguration.projectKey = @"xigua_live";
    defaultConfiguration.commonTag = @"test";
    defaultConfiguration.previewFlag = YES;
    defaultConfiguration.retryTimeInternal = 5;
    defaultConfiguration.retryCountLimit = INT_MAX;
    defaultConfiguration.retryTimeLimit = INT_MAX;
    defaultConfiguration.shouldAutoPlay = YES;
    defaultConfiguration.shouldUseLiveDNS = YES;
    defaultConfiguration.nodeOptimizingEnabled = NO;
    defaultConfiguration.hardwareDecodeEnabled = YES;
    defaultConfiguration.allowsAudioRendering = YES;
    defaultConfiguration.fillMode = TVLViewScalingModeAspectFit;
    defaultConfiguration.preferredToHTTPDNS = NO;
    defaultConfiguration.shouldUseLiveDNS = YES;
    defaultConfiguration.clockSynchronizationEnabled = NO;
    defaultConfiguration.shouldIgnoreSettings = NO;
    defaultConfiguration.netAdaptiveEnabled = NO;
    defaultConfiguration.nodeOptimizeInfo = @{};
    defaultConfiguration.settingsData = @{
//                                          TVLSettingsItemKeyIgnoreVideoBufferring: @(1),
//                                          TVLSettingsItemKeyShouldReportTimeSeries: @(1),
//                                          TVLSettingsItemKeyIsHurryEnabled: @(self.playConfiguration.isNetAdaptiveEnabled ? 1 : 0),
//                                          TVLSettingsItemKeyHurryTime: @(6),
//                                          TVLSettingsItemKeyCatchupSpeed: @(1.5),
//                                          TVLSettingsItemKeySlowPlayTime: @(2),
//                                          TVLSettingsItemKeySlowPlaySpeed: @(0.5),
//                                          TVLSettingsItemKeyIsH264HardwareDecodeEnabled: @(1),
//                                          TVLSettingsItemKeyIsH265HardwareDecodeEnabled: @(0),
//                                          TVLSettingsItemKeyIsFastOpenEnabled: @(1),
                                          };
    defaultConfiguration.ipAddress = [[NSUserDefaults standardUserDefaults] stringForKey:IP_ADDRESS];
    defaultConfiguration.domainName = [[NSUserDefaults standardUserDefaults] stringForKey:DOMAIN_NAME];
    defaultConfiguration.shouldArchiveLogs = YES;
    return defaultConfiguration;
}

- (NSDictionary *)ipMapping {
    if (self.ipAddress.length > 0 && self.domainName.length > 0) {
        return @{ self.ipAddress : self.domainName };
    }
    return @{};
}

- (void)saveConfiguration {
    if (self.ipAddress.length > 0) {
        [[NSUserDefaults standardUserDefaults] setValue:[self.ipAddress copy] forKey:IP_ADDRESS];
    }
    if (self.domainName.length > 0) {
        [[NSUserDefaults standardUserDefaults] setValue:[self.domainName copy] forKey:DOMAIN_NAME];
    }
}


@end
