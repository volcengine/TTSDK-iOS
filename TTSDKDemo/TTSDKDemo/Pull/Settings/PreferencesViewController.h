//
//  PreferencesViewController.h
//  TTVideoLive-iOS
//
//  Created by 陈昭杰 on 2018/12/13.
//

#import <UIKit/UIKit.h>

@class TVLPlayerItemPreferences;

NS_ASSUME_NONNULL_BEGIN

@interface PreferencesViewController : UIViewController

@property (nonatomic, strong) TVLPlayerItemPreferences *preferences;

- (void)updateWithPlayerItemPreferences:(TVLPlayerItemPreferences *)preferences;

@end

NS_ASSUME_NONNULL_END
