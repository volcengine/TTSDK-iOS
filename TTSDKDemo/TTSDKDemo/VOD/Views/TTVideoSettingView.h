//
//  TTVideoSettingView.h
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/11.


#import "BaseView.h"

@class TTVideoSettingView;
@protocol TTVideoSettingViewDelegate <NSObject>

- (void)settingView:(TTVideoSettingView *)moreView downloadBtn:(UIButton *)downloadBtn;
- (void)settingView:(TTVideoSettingView *)moreView airPlayBtn:(UIButton *)airPlayBtn;
- (void)settingView:(TTVideoSettingView *)moreView barrageBtn:(UIButton *)barrageBtn;
- (void)settingView:(TTVideoSettingView *)moreView speed:(CGFloat)speedValue;
- (void)settingView:(TTVideoSettingView *)moreView muted:(BOOL)isMuted;
- (void)settingView:(TTVideoSettingView *)moreView mixWithOther:(BOOL)isOn;

@end
@interface TTVideoSettingView : BaseView

@property (nonatomic, weak) id<TTVideoSettingViewDelegate>delegate;
@property (nonatomic, assign) BOOL verticalScreen;

- (void)show;

@end
