//
//  TTVideoAudioSession.m
//  TTVideoEngineDemo
//
//  Created by 黄清 on 2018/12/24.
//  Copyright © 2018 bytedance. All rights reserved.
//

#import "TTVideoAudioSession.h"

@implementation TTVideoAudioSession

+ (void)active {
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    if (error) {
        Log(@"fail: [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error]");
    }
}

+ (void)inActive {
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    if (error) {
        Log(@"fail: [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];");
    }
}

+ (void)setCategory:(AVAudioSessionCategory)category {
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:category error:&error];
    if (error) {
        Log(@"fail: [[AVAudioSession sharedInstance] setCategory:category error:&error];");
    }
}

+ (void)mixWithOther:(BOOL)isOn {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self inActive];/// 需要 setActive:NO
        NSError *error = nil;
        AVAudioSessionCategoryOptions option = isOn ? AVAudioSessionCategoryOptionMixWithOthers : 0;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:option error:&error];
        if (error) {
            Log(@"fail: [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:option error:&error];");
        }
    });
}

@end
