//
//  StreamingViewController+_MTV.m
//  TTSDKDemo
//
//  Created by guojieyuan on 2022/1/28.
//  Copyright © 2022 ByteDance. All rights reserved.
//

#import "StreamingViewController+MTV.h"
#define kMVStart               @"开mv"
#define kMVStop                @"关mv"

@interface StreamingViewController (MTV)

@property (nonatomic, strong) LCKaraokeMovie *karaokeMovieInstance;
@property (nonatomic, strong) UIView *mvView;
@property (nonatomic, strong) LSPlayController *playerController;

@end

@implementation StreamingViewController (MTV)
@dynamic karaokeMovieInstance;
@dynamic playerController;

-(LCKaraokeMovie *)karaokeMovieInstance {
    return (LCKaraokeMovie *)objc_getAssociatedObject(self, @selector(karaokeMovieInstance));
}

-(void)setKaraokeMovieInstance:(LCKaraokeMovie *)karaokeMovieInstance {
    objc_setAssociatedObject(self, @selector(karaokeMovieInstance), karaokeMovieInstance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(LSPlayController *)playerController {
    return (LSPlayController *)objc_getAssociatedObject(self, @selector(playerController));
}

-(void)setPlayerController:(LSPlayController *)playerController {
    objc_setAssociatedObject(self, @selector(playerController), playerController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIView *)mvView {
    return (UIView *)objc_getAssociatedObject(self, @selector(mvView));
}

-(void)setMvView:(UIView *)mvView {
    objc_setAssociatedObject(self, @selector(mvView), mvView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void) p_startMVPlay:(NSURL *)url
{
    self.playerController = [[LSPlayController alloc] initWithURL:url];
    self.karaokeMovieInstance = [[LCKaraokeMovie alloc] initWithLiveCore:self.engine player:self.playerController];
//    self.mvView = [[UIView alloc] initWithFrame: self.view.bounds];
    CGRect superRect = self.view.bounds;
    CGRect region = CGRectMake(0.5, 0.2, 0.5, 0.5);
    int x = superRect.size.width * region.origin.x;
    int y = superRect.size.height * region.origin.y;
    int w = superRect.size.width * region.size.width;
    int h = superRect.size.width / 16 * 9 * region.size.height;
//    self.mvView.frame = CGRectMake(x, y, w, h);
//    [self.karaokeMovieInstance setMovieRenderView:self.mvView];
//    [self.view addSubview:self.mvView];
    [self.engine setPreviewMode:LCPreviewMode_GameInteract];
    [self.karaokeMovieInstance play];
  
    [self.karaokeMovieInstance setKaraokeVideoMixerDescription:0 zOrder:0 withPosition:CGRectMake( 0, 0, 1, 1)];
    [self.karaokeMovieInstance setKaraokeVideoMixerDescription:1 zOrder:1 withPosition:CGRectMake(0.5, 0, 0.5, 0.5)];
}

- (void) p_stopMVInternal:(UIButton *)sender
{
    if (!self.isMixPicRunning) {
        [self.engine setPreviewMode:LCPreviewMode_Normal];
    }
    [sender setTitle:kMVStart forState:UIControlStateNormal];
    [self.karaokeMovieInstance stop];
    [self.karaokeMovieInstance close];
    [self.karaokeMovieInstance setKaraokeVideoMixerDescription:0 zOrder:0 withPosition:CGRectMake(0, 0, 1, 1)];
    self.karaokeMovieInstance = nil;
    [self.mvView removeFromSuperview];
    self.mvView = nil;
    self.playerController = nil;
}

- (void)mvButtonClicked:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqual:kMVStart]) {
        NSURL *url =  [[NSBundle mainBundle] URLForResource:@"wenlouhaifeng.mp4" withExtension:nil];
        [self p_startMVPlay:url];
        [sender setTitle:kMVStop forState:UIControlStateNormal];
    } else if ([sender.titleLabel.text isEqual:kMVStop]) {
        [self p_stopMVInternal:sender];
    }
}

- (BOOL)isMVRunning {
    return (self.karaokeMovieInstance != nil);
}

@end
