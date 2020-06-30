//
//  LSMainViewController.m
//  LiveStreamSdkDemo
//
//  Created by 赵凯 on 2019/5/28.

#import "LSMainViewController.h"
#import "LiveHelper.h"
#import "SettingsViewController.h"

@interface LSMainViewController ()

@end

@implementation LSMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat btnHeight = 50;
    CGFloat padding = 20;
    CGRect btnRect = CGRectMake(self.view.center.x - 140/2, self.view.center.y, 140, btnHeight);
    
    UIButton *mixButton = [LiveHelper createButton2:@"普通推流" target:self action:@selector(openLiveSettingVC)];
    mixButton.frame = btnRect;
    [self.view addSubview:mixButton];
        
    UILabel *verLabel = [LiveHelper createLable:[NSString stringWithFormat:@"%@\n%@",[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"DEMO_BUILD_INFO"] description],[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"DEMO_GIT_INFO"] description]]];
    verLabel.textColor = [UIColor lightGrayColor];
    verLabel.textAlignment = NSTextAlignmentCenter;
    verLabel.numberOfLines = 0;
    verLabel.font = [UIFont systemFontOfSize:13.];
    verLabel.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)-45, CGRectGetWidth(self.view.frame), 40);
    [self.view addSubview:verLabel];
}

- (void)openLiveSettingVC{
    SettingsViewController *vc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:[NSBundle mainBundle]];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
