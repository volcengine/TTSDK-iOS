//
//  VCABRConfig.h
//  test
//
//  Created by baidonghui on 2020/5/20.
//  Copyright © 2020 gkz. All rights reserved.
//

#ifndef VCABRConfig_h
#define VCABRConfig_h

typedef NS_ENUM(NSInteger, ABRModuleKey) {
    ABRKeyIsLogLevel = 0,
    ABRKeyIsSwitchSensitivity = 1,
    ABRKeyIs4GMaxBitrate = 2,
    ABRKeyIsSwitchModel = 3,
    ABRKeyIsFixedLevel = 4,
    ABRKeyIsStartupModel = 5,
    ABRKeyIsPlayerDisplayWidth = 6,
    ABRKeyIsPlayerDisplayHeight = 7
};

typedef NS_ENUM(NSInteger, ABRSwitchSensitivity) {
    ABRSwitchSensitivityNormal = 0,
    ABRSwitchSensitivityHigh = 1,
};

@interface VCABRConfig : NSObject

+ (void)set4GMaxBitrate:(NSInteger)maxbitrate;
   
+ (NSInteger)get4GMaxBitrate;

@end

#endif /* VCABRConfig_h */
