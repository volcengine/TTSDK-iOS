//
//  LivePlaySettingsViewController.m
//  TTVideoLive-iOS
//
//  Created by 王可成 on 2018/8/23.
//

#import "LivePlaySettingsViewController.h"
#import "LivePlayViewController.h"
#import "ConfiguringViewController.h"
#import "PlayConfiguration.h"
#import <ReactiveCocoa.h>
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>
#import "UIColor+Hex.h"
#import <UIView+Toast.h>

@interface LivePlaySettingsViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UILabel *IndustryName;
@property (weak, nonatomic) IBOutlet UIImageView *IndustryIcon;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UIImageView *productIcon;
@property (weak, nonatomic) IBOutlet UITextField *playURLTextField;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *QRScanButton;

/** 输入数据源 */
@property (nonatomic, strong) AVCaptureDeviceInput *input;
/** 输出数据源 */
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureLayer;

@property (nonatomic, strong) PlayConfiguration *config;

@end

@implementation LivePlaySettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.config = [PlayConfiguration defaultConfiguration];
    
    _playURLTextField.text = @"http://pull-flv-l1.douyincdn.com/stage/stream-682847493605556254.flv";
//    _playURLTextField.text = @"请输入或扫码获取播放地址";
    [self setupUIComponent];
}

// 与产品确认后该页面只支持竖屏正立，-shouldAutorotate和-supportedInterfaceOrientations用以保证转场与设备旋转中的正确朝向
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)setupUIComponent {
    self.view.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    [_startButton setBackgroundColor:[UIColor colorWithHexString:@"03B0FE"]];
    _startButton.layer.cornerRadius = 24;
    _startButton.clipsToBounds = YES;
    
    UIView *industryInfoContainer = [[UIView alloc] init];
    [self.view addSubview:industryInfoContainer];
    [industryInfoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(140);
        make.centerX.mas_equalTo(self.view);
    }];
    
//    _IndustryIcon.image = [UIImage imageNamed:@"Icon"];
    [_IndustryIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(industryInfoContainer);
    }];
    
    CGFloat margin = self.IndustryIcon.image ? 10.f : 0.f;
    [_IndustryName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(industryInfoContainer);
        make.left.mas_equalTo(self.IndustryIcon.mas_right).mas_offset(margin);
        make.centerY.mas_equalTo(self.IndustryIcon);
    }];
    
    UIView *productInfoContainer = [[UIView alloc] init];
    [self.view addSubview:productInfoContainer];
    [productInfoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(industryInfoContainer.mas_bottom).mas_offset(15);
        make.centerX.mas_equalTo(industryInfoContainer);
    }];
    
    [_productIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(productInfoContainer);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(18);
    }];
    
    [_productName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(productInfoContainer);
        make.centerY.mas_equalTo(self.productIcon);
        make.left.mas_equalTo(self.productIcon.mas_right).mas_offset(10);
    }];
    
    UIView *playURLInputContainer = [[UIView alloc] init];
    [self.view addSubview:playURLInputContainer];
    [playURLInputContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.productName.mas_bottom).offset(60);
        make.width.mas_equalTo(344);
        make.height.mas_equalTo(40);
    }];
    [self.view sendSubviewToBack:playURLInputContainer];
    playURLInputContainer.backgroundColor = [UIColor colorWithHexString:@"FFFCFC"];
    playURLInputContainer.layer.borderColor = [UIColor colorWithHexString:@"CBCBCB"].CGColor;
    playURLInputContainer.layer.borderWidth = 1.f;
    playURLInputContainer.layer.cornerRadius = 20.f;
    playURLInputContainer.clipsToBounds = YES;
    
    [_QRScanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(playURLInputContainer).mas_offset(0);
        make.centerY.equalTo(playURLInputContainer);
        make.width.height.mas_equalTo(40);
    }];
    
    [_playURLTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(playURLInputContainer);
        make.left.equalTo(playURLInputContainer).offset(20);
        make.right.mas_equalTo(self.QRScanButton.mas_left).mas_offset(-5);
    }];
    
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton addTarget:self action:@selector(didTouchSettingsButton) forControlEvents:UIControlEventTouchUpInside];
    [settingsButton setTitle:@"设置" forState:UIControlStateNormal];
    [settingsButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [settingsButton setBackgroundColor:[UIColor colorWithHexString:@"03B0FE"]];
    settingsButton.layer.cornerRadius = 24;
    settingsButton.clipsToBounds = YES;
    [self.view addSubview:settingsButton];
    [settingsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.playURLTextField.mas_bottom).offset(54);
        make.width.mas_equalTo(245);
        make.height.mas_equalTo(48);
    }];
    
    [_startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(settingsButton.mas_bottom).offset(38);
        make.width.mas_equalTo(245);
        make.height.mas_equalTo(48);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(didTouchBackButton) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [backButton setBackgroundColor:[UIColor colorWithHexString:@"03B0FE"]];
    backButton.layer.cornerRadius = 24;
    backButton.clipsToBounds = YES;
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.startButton.mas_bottom).offset(38);
        make.width.mas_equalTo(245);
        make.height.mas_equalTo(48);
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didTouchBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didTouchSettingsButton {
    ConfiguringViewController *configuringViewController = [[ConfiguringViewController alloc] initWithConfiguration:self.config];
    @weakify(self);
    [configuringViewController.confirmCommand.executionSignals.switchToLatest subscribeNext:^(PlayConfiguration *configuration) {
        @strongify(self);
        self.config = configuration;
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [configuringViewController.cancelCommand.executionSignals.switchToLatest subscribeNext:^(PlayConfiguration *configuration) {
        @strongify(self);
        self.config = configuration;
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:configuringViewController animated:YES completion:^{}];
}

- (IBAction)didClickStartButton:(UIButton *)sender {
    PlayConfiguration *config = self.config ?: [PlayConfiguration defaultConfiguration];
    config.playURL = _playURLTextField.text;
    
    // Configure player item.
    LivePlayViewController *vc = [[LivePlayViewController alloc] initWithConfiguration:config];
    NSString *playURL = config.playURL;
    if ([[playURL lowercaseString] hasPrefix:@"http"] || [[playURL lowercaseString] hasPrefix:@"rtmp"] || [playURL hasPrefix:@"/"]) {
        // Basic usage.
        config.playerItem = [TVLPlayerItem playerItemWithURL:[NSURL URLWithString:playURL]];
    }
    
    if (config.playerItem) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)ScanQRCode:(id)sender {
    if ([self.captureLayer superlayer]) {
        return;
    }
    [self creatQRCodeCapture];
    //添加拍摄图层
    [self.view.layer addSublayer:self.captureLayer];
    //开始二维码
    [self.session startRunning];
}

-(void)creatQRCodeCapture{
    /** 创建输入数据源 */
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];  //获取摄像设备
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];  //创建输出流
    
    /** 创建输出数据源 */
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];  //设置代理 在主线程里刷新
    
    /** Session设置 */
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];   //高质量采集
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    //设置扫码支持的编码格式
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                        AVMetadataObjectTypeEAN13Code,
                                        AVMetadataObjectTypeEAN8Code,
                                        AVMetadataObjectTypeCode128Code];
    /** 扫码视图 */
    //扫描框的位置和大小
    self.captureLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.captureLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.captureLayer.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
}

#pragma mark - 实现代理方法, 完成二维码扫描
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count > 0) {
        
        // 停止动画, 看完全篇记得打开注释, 不然扫描条会一直有动画效果
        //[self.shadowView stopTimer];
        
        //停止扫描
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        NSString *capturedContent = metadataObject.stringValue;
        NSError *error = nil;
        NSDictionary *capturedContentData = [NSJSONSerialization JSONObjectWithData:[capturedContent dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        NSDictionary *settingsData = [capturedContentData objectForKey:@"settings_data"];
        NSDictionary *nodeOptimizeInfo = [capturedContentData objectForKey:@"node_optimize_info"];
        if (!error && (settingsData || nodeOptimizeInfo)) {
            self.config.settingsData = settingsData;
            self.config.nodeOptimizeInfo = nodeOptimizeInfo;
        } else {
            self.playURLTextField.text = capturedContent;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^() {
        
        self.captureLayer.frame = CGRectMake(0, 1, 2, 2);
        [self.captureLayer removeFromSuperlayer];
        
        self.session = nil;
    });
}

@end
