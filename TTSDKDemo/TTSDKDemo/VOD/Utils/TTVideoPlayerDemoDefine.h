//
//  TTVideoPlayerDemoDefine.h
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/18.


#ifndef TTVideoPlayerDemoDefine_h
#define TTVideoPlayerDemoDefine_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ButtonClickType) {
    ButtonClickTypeMore,
    ButtonClickTypeBack,
    ButtonClickTypeOff,
    ButtonClickTypeOn,
};

typedef void(^ButtonClick)(ButtonClickType clickType);
typedef void(^IndexClick)(NSInteger index);
typedef void(^SingleParamBlock)(id param);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"
static NSArray* tt_resolution_strings(void) {
    return @[@"360p", @"480p", @"720p", @"1080p", @"4k"];
}

/// Account
static NSString *const kTestAppId = @"test_appId";
static NSString *const kTestAppName = @"test_appName";

static inline BOOL tt_valid_string(NSString *string) {
    if ([string isKindOfClass:[NSString class]]) {
        return string.length > 0;
    }
    return NO;
}
#pragma clang diagnostic pop

FOUNDATION_EXTERN NSString *const kTTVideoEngineEventNotification;

#endif /* TTVideoPlayerDemoDefine_h */
