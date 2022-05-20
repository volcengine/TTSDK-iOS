//
//  PreferencesViewController.m
//  TTVideoLive-iOS
//
//  Created by 陈昭杰 on 2018/12/13.
//

#import "PreferencesViewController.h"

@interface PreferencesViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *sourceTypeSegments;

@property (weak, nonatomic) IBOutlet UISegmentedControl *resolutionTypeSegments;

@property (weak, nonatomic) IBOutlet UISegmentedControl *videoCodecTypeSegments;

@property (weak, nonatomic) IBOutlet UISegmentedControl *formatTypeSegments;

@end

@implementation PreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = UIScreen.mainScreen.bounds;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
}

- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)updateWithPlayerItemPreferences:(TVLPlayerItemPreferences *)preferences {
    if ([preferences.sourceType isEqualToString:TVLMediaSourceTypeMain]) {
        [self.sourceTypeSegments setSelectedSegmentIndex:0];
    } else if ([preferences.sourceType isEqualToString:TVLMediaSourceTypeBackup]) {
        [self.sourceTypeSegments setSelectedSegmentIndex:1];
    }
    
    if ([preferences.resolutionType isEqualToString:TVLMediaResolutionTypeLD]) {
        [self.resolutionTypeSegments setSelectedSegmentIndex:0];
    } else if ([preferences.resolutionType isEqualToString:TVLMediaResolutionTypeSD]) {
        [self.resolutionTypeSegments setSelectedSegmentIndex:1];
    } else if ([preferences.resolutionType isEqualToString:TVLMediaResolutionTypeHD]) {
        [self.resolutionTypeSegments setSelectedSegmentIndex:2];
    } else if ([preferences.resolutionType isEqualToString:TVLMediaResolutionTypeOrigin]) {
        [self.resolutionTypeSegments setSelectedSegmentIndex:3];
    }
    
    if ([preferences.videoCodecType isEqualToString:TVLVideoCodecTypeH264]) {
        [self.videoCodecTypeSegments setSelectedSegmentIndex:0];
    } else if ([preferences.videoCodecType isEqualToString:TVLVideoCodecTypeByteVC1]) {
        [self.videoCodecTypeSegments setSelectedSegmentIndex:1];
    }
    
    if ([preferences.formatType isEqualToString:TVLMediaFormatTypeFLV]) {
        [self.formatTypeSegments setSelectedSegmentIndex:0];
    } else if ([preferences.formatType isEqualToString:TVLMediaFormatTypeM3U8]) {
        [self.formatTypeSegments setSelectedSegmentIndex:1];
    }
}

@end
