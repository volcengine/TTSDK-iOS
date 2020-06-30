//
//  ConfiguringViewController.m
//  TTVideoLive-iOS
//
//  Created by 陈昭杰 on 2019/1/24.
//

#import "ConfiguringViewController.h"

@interface ConfiguringViewController ()

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UISwitch *hardwareDecodeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *nodeOptimizingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *autoPlaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *audioDeviceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *settingsSwitch;
@property (weak, nonatomic) IBOutlet UITextField *retryTimeIntervalTextField;
@property (weak, nonatomic) IBOutlet UITextField *retryCountLimitTextField;
@property (weak, nonatomic) IBOutlet UITextField *retryTimeLimitTextField;
@property (weak, nonatomic) IBOutlet UISwitch *SDKDNSSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *DNSMethodSegmentedControl;
@property (weak, nonatomic) IBOutlet UISwitch *clockSynchronizationEnabledSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *netAdaptiveSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *archiveLogsSwitch;

@end

@implementation ConfiguringViewController

- (instancetype)init {
    if (self = [super init]) {
        _currentConfiguration = [PlayConfiguration defaultConfiguration];
    }
    return self;
}

- (instancetype)initWithConfiguration:(PlayConfiguration *)configuration {
    if (self = [self init]) {
        if (configuration) {
            _currentConfiguration = configuration;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.hardwareDecodeSwitch.on = self.currentConfiguration.isHardwareDecodeEnabled;
    self.archiveLogsSwitch.on = self.currentConfiguration.shouldArchiveLogs;
    self.nodeOptimizingSwitch.on = self.currentConfiguration.isNodeOptimizingEnabled;
    self.autoPlaySwitch.on = self.currentConfiguration.shouldAutoPlay;
    self.audioDeviceSwitch.on = self.currentConfiguration.allowsAudioRendering;
    self.SDKDNSSwitch.on = self.currentConfiguration.shouldUseLiveDNS;
    self.clockSynchronizationEnabledSwitch.on = self.currentConfiguration.isClockSynchronizationEnabled;
    self.settingsSwitch.on = !self.currentConfiguration.shouldIgnoreSettings;
    self.DNSMethodSegmentedControl.selectedSegmentIndex = self.currentConfiguration.isPreferredToHTTPDNS ? 1 : 0;
    self.netAdaptiveSwitch.on = self.currentConfiguration.isNetAdaptiveEnabled;
    self.retryTimeIntervalTextField.text = [NSString stringWithFormat:@"%ld", (long)self.currentConfiguration.retryTimeInternal];
    self.retryCountLimitTextField.text = [NSString stringWithFormat:@"%ld", (long)self.currentConfiguration.retryCountLimit];
    self.retryTimeLimitTextField.text = [NSString stringWithFormat:@"%ld", (long)self.currentConfiguration.retryTimeLimit];
    @weakify(self);
    [[self.hardwareDecodeSwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISwitch *aSwitch) {
        @strongify(self);
        self.currentConfiguration.hardwareDecodeEnabled = aSwitch.isOn;
    }];
    
    [[self.archiveLogsSwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISwitch *aSwitch) {
        @strongify(self);
        self.currentConfiguration.shouldArchiveLogs = aSwitch.isOn;
    }];
    
    [[self.netAdaptiveSwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISwitch *aSwitch) {
        @strongify(self);
        self.currentConfiguration.netAdaptiveEnabled = aSwitch.isOn;
    }];
    
    [[self.settingsSwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISwitch *aSwitch) {
        @strongify(self);
        self.currentConfiguration.shouldIgnoreSettings = !aSwitch.isOn;
    }];
    
    [[self.SDKDNSSwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISwitch *aSwitch) {
        @strongify(self);
        self.currentConfiguration.shouldUseLiveDNS = aSwitch.isOn;
        self.DNSMethodSegmentedControl.enabled = aSwitch.isOn;
    }];
    
    [[self.clockSynchronizationEnabledSwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISwitch *aSwitch) {
        @strongify(self);
        self.currentConfiguration.clockSynchronizationEnabled = aSwitch.isOn;
    }];
    
    [[self.DNSMethodSegmentedControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISegmentedControl *aSegmentedControl) {
        @strongify(self);
        self.currentConfiguration.preferredToHTTPDNS = aSegmentedControl.selectedSegmentIndex == 0 ? NO : YES;
    }];
    
    [[self.nodeOptimizingSwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISwitch *aSwitch) {
        @strongify(self);
        self.currentConfiguration.nodeOptimizingEnabled = aSwitch.isOn;
    }];
    
    [[self.autoPlaySwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISwitch *aSwitch) {
        @strongify(self);
        self.currentConfiguration.shouldAutoPlay = aSwitch.isOn;
    }];
    
    [[self.audioDeviceSwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISwitch *aSwitch) {
        @strongify(self);
        self.currentConfiguration.allowsAudioRendering = aSwitch.isOn;
    }];
    
    NSNumberFormatter *numberFormater = [[NSNumberFormatter alloc] init];
    numberFormater.numberStyle = NSNumberFormatterNoStyle;
    
    [[self.retryTimeIntervalTextField rac_textSignal] subscribeNext:^(NSString *text) {
        @strongify(self);
        self.currentConfiguration.retryTimeInternal = [numberFormater numberFromString:text] ? [[numberFormater numberFromString:text] integerValue] : self.currentConfiguration.retryTimeInternal;
    }];
    
    [[self.retryCountLimitTextField rac_textSignal] subscribeNext:^(NSString *text) {
        @strongify(self);
        self.currentConfiguration.retryCountLimit = [numberFormater numberFromString:text] ? [[numberFormater numberFromString:text] integerValue] : self.currentConfiguration.retryCountLimit;
    }];
    
    [[self.retryTimeLimitTextField rac_textSignal] subscribeNext:^(NSString *text) {
        @strongify(self);
        self.currentConfiguration.retryTimeLimit = [numberFormater numberFromString:text] ? [[numberFormater numberFromString:text] integerValue] : self.currentConfiguration.retryTimeLimit;
    }];
    
    self.confirmButton.rac_command = self.confirmCommand;
    
    self.cancelButton.rac_command = self.cancelCommand;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (RACCommand *)confirmCommand {
    if (!_confirmCommand) {
        @weakify(self);
        _confirmCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:self.currentConfiguration];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _confirmCommand;
}

- (RACCommand *)cancelCommand {
    if (!_cancelCommand) {
        _cancelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:[PlayConfiguration defaultConfiguration]];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _cancelCommand;
}

@end
