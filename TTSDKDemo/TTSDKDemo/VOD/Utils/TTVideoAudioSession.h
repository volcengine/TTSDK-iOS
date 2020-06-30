//
//  TTVideoAudioSession.h
//  TTVideoEngineDemo
//
//  Created by 黄清 on 2018/12/24.
//  Copyright © 2018 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoAudioSession : NSObject

+ (void)active;
+ (void)inActive;
+ (void)setCategory:(AVAudioSessionCategory)category;
+ (void)mixWithOther:(BOOL)isOn;

@end

NS_ASSUME_NONNULL_END
