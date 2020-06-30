//
//  LogViewController.m
//  TTVideoLive-iOS
//
//  Created by 陈昭杰 on 2019/2/28.
//

#import "LogViewController.h"

@interface LogViewController ()

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UITextView *logTextView;

@end

@implementation LogViewController {
    NSMutableString *_logText;
}

- (instancetype)init {
    if (self = [super init]) {
        _logText = [NSMutableString string];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = UIScreen.mainScreen.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateLogTextViewWithContent:_logText];
}

- (void)appendLogWithLogInfo:(NSDictionary *)info {
    [_logText appendString:[NSString stringWithFormat:@"\n%@", info]];
    [self updateLogTextViewWithContent:_logText];
}

- (void)clear {
    _logText = [NSMutableString string];
    [self updateLogTextViewWithContent:_logText];
}

- (void)updateLogTextViewWithContent:(NSString *)content {
    self.logTextView.text = content;
}

- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)closeButtonTouched:(id)sender {
    [self dismiss];
}

- (NSString *)currentLog {
    return _logText.copy;
}

@end
