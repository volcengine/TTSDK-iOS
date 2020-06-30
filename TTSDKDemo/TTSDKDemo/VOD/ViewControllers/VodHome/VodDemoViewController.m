//
//  VodDemoViewController.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/11.


#import "VodDemoViewController.h"
#import "TTVideoContainerController.h"
#import "TTVideoPlayerController.h"

#define K_TOP_INSET (NAVIGATIONBAR_BOTTOM + (SCREEN_WIDTH * 9.0 / 16.0))

@interface VodDemoViewController ()

@property (nonatomic, strong) TTVideoContainerController *infoViewController;
@property (nonatomic, strong) TTVideoPlayerController *playerController;

@end

@implementation VodDemoViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (self.view.window && self.view.window.height > self.view.window.width) {
        _infoViewController.view.top = K_TOP_INSET;
        _infoViewController.view.height = self.view.height - K_TOP_INSET - SAFE_AREA_BOTTOM;
    }
}

- (void)setUpUI {
    [super setUpUI];
    
    self.view.backgroundColor = TT_THEME_COLOR;
    _infoViewController = [[TTVideoContainerController alloc] init];
    _infoViewController.view.top = K_TOP_INSET;
    _infoViewController.view.left = 0.0f;
    _infoViewController.view.width = self.view.width;
    _infoViewController.view.height = self.view.height - K_TOP_INSET - NAVIGATIONBAR_BOTTOM;
    _infoViewController.delegate = (id<TTVideoContainerControllerDelegate>) self;
    [self.view addSubview:_infoViewController.view];
    [self addChildViewController:_infoViewController];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"DebugView" style:UIBarButtonItemStylePlain target:self action:@selector(_showVideoDebugView:)];
    
    self.playerController = [[TTVideoPlayerController alloc] init];
    self.playerController.view.frame = CGRectMake(0, NAVIGATIONBAR_BOTTOM, self.view.frame.size.width, K_TOP_INSET - NAVIGATIONBAR_BOTTOM);
    [self.view addSubview: self.playerController.view];
    [self addChildViewController:self.playerController];
}

- (void)buildUI {
    [super buildUI];
    
    self.navigationItem.title = @"视频播放";
    NSString *localFile = [[NSBundle mainBundle] pathForResource:@"test.mp4" ofType:nil];
    if (localFile) {
        NSDictionary *params = @{SourceKeyURL:localFile};
        self.playerController.params = params;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationDidBecomeActive:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

/// MARK: - Private method

- (void)_applicationDidBecomeActive:(NSNotification *)notify {
    if (_infoViewController.view.top != K_TOP_INSET) {
        _infoViewController.view.top = K_TOP_INSET;
        _infoViewController.view.height = self.view.height - K_TOP_INSET - SAFE_AREA_BOTTOM;
    }
}

- (void)_showVideoDebugView:(UIBarButtonItem *)btnItem {
    btnItem.tag = btnItem.tag > 0 ? 0 : 1;
    [self.playerController updateDebugViewStatus:btnItem.tag == 1];
}

/// MARK: - TTVideoContainerControllerDelegate

- (void)changeSource:(TTVideoContainerController *)listVC source:(NSDictionary<SourceKey,SourceValue> *)source {
    if (source == nil || source.count == 0) {
        return;
    }
    
    self.playerController.params = source;
}


@end
