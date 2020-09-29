//
//  NavigationViewController.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/11.


#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:TT_FONT(20)};
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = TT_THEME_COLOR;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
}

/// MARK: - Autorotate

-(BOOL)shouldAutorotate {
    return [self.visibleViewController shouldAutorotate];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.visibleViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}

/// MARK: - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.visibleViewController preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden {
    return [self.visibleViewController prefersStatusBarHidden];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.visibleViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.visibleViewController;
}


@end
