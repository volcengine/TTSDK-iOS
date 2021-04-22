//
//  StreamingViewController+KTV.h
//  TTSDKDemo
//
//  Created by guojieyuan on 2021/4/9.
//  Copyright © 2021 ByteDance. All rights reserved.
//

#ifndef StreamingViewController_KTV_h
#define StreamingViewController_KTV_h
#import "StreamingViewController.h"

@interface StreamingViewController (KTV)
- (void)switchAudioEffectButtonClicked:(UIButton *)sender;
- (void)onMusicTypeButtonClicked:(UIButton *)sender;
- (void)onKaraokeButtonClicked:(UIButton *)sender;
- (void)longPressKaraokeAction;
//- (void)startKTVWithStartTime:(NSTimeInterval)startTime musicType:(LCKTVMusicType)musicType;

@end

#endif /* StreamingViewController_KTV_h */
