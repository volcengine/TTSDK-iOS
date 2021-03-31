//
//  BaseViewController.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/13.


#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)loadView {
    UIScrollView *s = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    s.showsVerticalScrollIndicator = NO;
    s.showsHorizontalScrollIndicator = NO;
    s.bounces = NO;
    s.bouncesZoom = NO;
    s.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    if (@available(iOS 11.0, *)) {
        s.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.view = s;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = TT_THEME_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self setUpUI];
    [self buildUI];
}

- (void)setUpUI {
    
}

- (void)buildUI {
    
}

- (UIButton *)createButtonWithTitle:(NSString *)title {
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TT_BASE_375(100), TT_BASE_375(60))];
    button.backgroundColor = TT_COLOR(0, 0, 0, 0.5);
    button.titleLabel.font = TT_FONT(15);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:TT_COLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
    return button;
}

/// MARK: - Autorotate

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

/// MARK: - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
