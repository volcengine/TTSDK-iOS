//
//  SettingsViewController.m
//  LiveStreamSdkDemo
//
//  Created by 王可成 on 2018/7/11.

#import <AVFoundation/AVFoundation.h>

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define customShowSize CGSizeMake(200, 200);


#import "SettingsViewController.h"
#import "StreamConfigurationModel.h"
#import "StreamingViewController.h"
#import "TTLogerHelper.h"
#import "LiveHelper.h"

@interface SettingsViewController ()<UIPickerViewDelegate, UIPickerViewDataSource, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *pushURLTextField;

- (IBAction)ScanQRCode:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *startStreamingButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *cameraSegControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *captureResolutionSegControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *streamingResolutionSegControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *encodeProfileLevelSegControl;
@property (weak, nonatomic) IBOutlet UITextField *fpsTextField;
@property (weak, nonatomic) IBOutlet UITextField *videoBitrateTextField;

@property (weak, nonatomic) IBOutlet UITextField *audioBitrateTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *audioCodecTypeSegControl;
@property (weak, nonatomic) IBOutlet UIPickerView *filterPicker;
@property (weak, nonatomic) IBOutlet UISwitch *glMultiThreaded;

@property (weak, nonatomic) IBOutlet UISwitch *ExtensionSwitcher;
@property (weak, nonatomic) IBOutlet UISegmentedControl *videoCodecSegControl;
@property (weak, nonatomic) IBOutlet UISwitch *rtmpkOnlySwitcher;
@property (weak, nonatomic) IBOutlet UISwitch *enableBFrameswitcher;

@property (weak, nonatomic) IBOutlet UISwitch *backgrounModeBtn;

@property (weak, nonatomic) IBOutlet UISwitch *audioStreamSwitcher;


@property (weak, nonatomic) IBOutlet UISwitch *ntpSwitcher;

/** 输入数据源 */
@property (nonatomic, strong) AVCaptureDeviceInput *input;
/** 输出数据源 */
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
/** 输入输出的中间桥梁 负责把捕获的音视频数据输出到输出设备中 */
@property (nonatomic, strong) AVCaptureSession *session;
/** 相机拍摄预览图层 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *layerView;
/** 预览图层尺寸 */
@property (nonatomic, assign) CGSize layerViewSize;
/** 有效扫码范围 */
@property (nonatomic, assign) CGSize showSize;
/** 作者自定义的View视图 */
//@property (nonatomic, strong) ShadowView *shadowView;
@property (nonatomic, assign) BOOL isURLCodeSigned;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.lightGrayColor;
    self.navigationController.navigationBar.hidden = YES;
    _pushURLTextField.text = @"rtmp://push-rtmp-l6-ixiguatest.ixigua.com/kslive/testabcs?k=0c52a6e0964a90cc&t=1608287377";
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://bytedance.com"]] resume];
    [self disableCodeSign];
}

- (void)disableCodeSign {
    [self.startStreamingButton setTitle:@"开始推流" forState:UIControlStateNormal];
    [self.startStreamingButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

- (IBAction)onStartStreamingButtonClicked:(UIButton *)sender {
    StreamConfigurationModel *model = [StreamConfigurationModel defaultConfigurationModel];
    // stream url
    model.streamURL = _pushURLTextField.text;
    
    // video
    model.isFrontCamera = (_cameraSegControl.selectedSegmentIndex == 0);
    model.captureResolution = [self getCaptureResolution];
    model.streamResolution = [self getStreamResolution];
    model.fps = (int)[_fpsTextField.text integerValue];
    model.videoBitrate = (int)[_videoBitrateTextField.text integerValue];
    model.profileLevel = (int)_encodeProfileLevelSegControl.selectedSegmentIndex;
    model.videoCodecType = (int)_videoCodecSegControl.selectedSegmentIndex;
    
    // audio
    model.audioBitrate = (int)[_audioBitrateTextField.text integerValue];
    model.audioCodecType = (int)_audioCodecTypeSegControl.selectedSegmentIndex;
    
    // debug
    model.registExtension = _ExtensionSwitcher.isOn;
    model.rtmpkOnly = _rtmpkOnlySwitcher.isOn;
    model.enableBFrame = _enableBFrameswitcher.isOn;
    model.enableBackgroundMode = _backgrounModeBtn.isOn;
    model.ntpEnabled = _ntpSwitcher.isOn;
    model.glMultiThreaded = _glMultiThreaded.isOn;
    model.enableAudioStream = _audioStreamSwitcher.isOn;
    StreamingViewController *streamVC = [[StreamingViewController alloc] initWithConfiguration:model];
    
#if ENABLE_TEST_LOG && !DEBUG
    [TTLogerHelper redirectLogToFile];
#endif
    streamVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:streamVC animated:YES completion:nil];
}

- (CGSize)getCaptureResolution {
    return [self getSizeWithResolutionIndex:_captureResolutionSegControl.selectedSegmentIndex];
}

- (CGSize)getStreamResolution {
    return [self getSizeWithResolutionIndex:_streamingResolutionSegControl.selectedSegmentIndex];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)onExits:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGSize)getSizeWithResolutionIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return CGSizeMake(360, 640);
            break;
        case 1:
            return CGSizeMake(480, 854);
            break;
        case 2:
            return CGSizeMake(540, 960);
            break;
        case 3:
            return CGSizeMake(720, 1280);
            break;
        case 4:
            return CGSizeMake(1080, 1920);
            break;
        default:
            return CGSizeMake(360, 640);
            break;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 6;
}

- (IBAction)ScanQRCode:(id)sender {
    if ([self.layerView superlayer]) {
        return;
    }
    [self creatScanQR];
    //添加拍摄图层
    [self.view.layer addSublayer:self.layerView];
    //开始二维码
    [self.session startRunning];
}

-(void)creatScanQR{
    
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
    self.layerView = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.layerView.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.layerView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    // 将扫描框大小定义为属行, 下面会有调用
    self.layerViewSize = CGSizeMake(_layerView.frame.size.width, _layerView.frame.size.height);
    
}

- (IBAction)handleSwitchVideoCodecType:(UISegmentedControl *)sender {
    [UIView animateWithDuration:0.25 animations:^{
        [_encodeProfileLevelSegControl removeAllSegments];
        if (sender.selectedSegmentIndex == 0) {
            [_encodeProfileLevelSegControl insertSegmentWithTitle:@"Baseline" atIndex:0 animated:NO];
            [_encodeProfileLevelSegControl insertSegmentWithTitle:@"Main" atIndex:1 animated:NO];
            [_encodeProfileLevelSegControl insertSegmentWithTitle:@"High" atIndex:2 animated:NO];
            [_encodeProfileLevelSegControl setSelectedSegmentIndex:1];
        } else {
            [_encodeProfileLevelSegControl insertSegmentWithTitle:@"Main" atIndex:0 animated:NO];
            [_encodeProfileLevelSegControl insertSegmentWithTitle:@"Main10" atIndex:1 animated:NO];
            [_encodeProfileLevelSegControl setSelectedSegmentIndex:0];
        }
    }];
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
        NSLog(@"%@",metadataObject.stringValue);
        
        _pushURLTextField.text = metadataObject.stringValue;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^() {
        
        self.layerView.frame = CGRectMake(0, 1, 2, 2);
        // 将扫描框大小定义为属行, 下面会有调用
        self.layerViewSize = CGSizeMake(0, 0);
    
        [self.layerView removeFromSuperlayer];
        
        self.session = nil;
    });
}

@end
