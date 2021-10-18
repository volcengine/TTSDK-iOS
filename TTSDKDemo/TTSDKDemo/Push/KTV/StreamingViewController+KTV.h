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

@interface StreamingKTVControllBox : UIView

@end

@interface StreamingViewController (KTV)
@property (nonatomic, strong) StreamingKTVControllBox *karaokeControllersContainer;
- (void)initKTVView;
- (void)switchAudioEffectButtonClicked:(UIButton *)sender;

@end

#endif /* StreamingViewController_KTV_h */
