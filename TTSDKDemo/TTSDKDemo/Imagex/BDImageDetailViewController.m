//
//  BDImageDetailViewController.m
//  BDWebImage_Example
//
//

#import "BDImageDetailViewController.h"
#import <TTSDK/BDWebImage.h>
#import <Masonry/Masonry.h>

@interface BDImageDetailViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) BDImageView *imageView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) NSInteger loopCount;
@property (nonatomic, strong) UIView *maskView;
@end

@implementation BDImageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _imageView = [BDImageView new];
    CGFloat width = self.view.bounds.size.width;
    _imageView.frame = (CGRect){0, 0, width, width};
    _imageView.center = self.view.center;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    
    BDImageDetailType showType = self.showType;
    [_imageView bd_setImageWithURL:[NSURL URLWithString:_url] placeholder:nil options:0 completion:^(BDWebImageRequest *request, UIImage *image, NSData *data, NSError *error, BDWebImageResultFrom from) {
        if (((BDImage *)image).isAnimateImage && showType == BDImageDetailTypeStatic) {
            [self showAnimItem];
        }
    }];
    if (self.showType == BDImageDetailTypeAnim) {
        [self showAnimItem];
    }
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    if (_showType == BDImageDetailTypeStatic) {
        return;
    }
    [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
    }];
    if (@available(iOS 11.0, *)) {
        [_toolBar.lastBaselineAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
    } else {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_toolBar
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0]];
    }
}

- (void)showAnimItem {
    _toolBar = [[UIToolbar alloc] init];
    UIBarButtonItem *adjustItem = [[UIBarButtonItem alloc] initWithTitle:@"自定循环" style:UIBarButtonItemStylePlain target:self action:@selector(animLoop)];
    UIBarButtonItem *cycleItem = [[UIBarButtonItem alloc] initWithTitle:@"永久循环" style:UIBarButtonItemStylePlain target:self action:@selector(playAnimAlways)];
    UIBarButtonItem *playItem = [[UIBarButtonItem alloc] initWithTitle:@"手动播放" style:UIBarButtonItemStylePlain target:self action:@selector(playAnim)];
    UIBarButtonItem *stopItem = [[UIBarButtonItem alloc] initWithTitle:@"手动暂停" style:UIBarButtonItemStylePlain target:self action:@selector(stopAnim)];
    UIBarButtonItem *flexibleitem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:self action:nil];
    [_toolBar setItems:@[adjustItem, flexibleitem, cycleItem, flexibleitem, playItem, flexibleitem, stopItem] animated:YES];
    [self.view addSubview:_toolBar];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick:)];
    [_imageView addGestureRecognizer:tapGesture];
    _imageView.userInteractionEnabled = YES;
    
    _button = [[UIButton alloc] initWithFrame:(CGRect){0, 0, 60, 60}];
    _button.center = self.view.center;
    [_button setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_button setHidden:YES];
    [self.view addSubview:_button];
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [_maskView setTag:108];
    [_maskView setBackgroundColor:[UIColor blackColor]];
    [_maskView setAlpha:0.5];
    UITapGestureRecognizer *maskGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePicker)];
    [_maskView addGestureRecognizer:maskGesture];
    _maskView.userInteractionEnabled = YES;
    [_maskView setHidden:YES];
    [self.view addSubview:_maskView];
    
    _loopCount = 0;
    
    _pickerView = [UIPickerView new];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.frame = (CGRect){0, self.view.bounds.size.height, self.view.bounds.size.width, 230};
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_pickerView setHidden:YES];
    [self.view addSubview:_pickerView];
    
}

- (void)btnClick:(UIView *)sender {
    if ([_imageView.player isPlaying]) {
        [self stopAnim];
    } else {
        [self playAnim];
    }
}

- (void)playAnimAlways {
    _imageView.player.loopCount = 0;
    [self playAnim];
}

- (void)playAnim {
    if ([_imageView.player isPlaying]) {
        return;
    }
    [_imageView.player startPlay];
    [_button setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    [_button setHidden:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self->_imageView.player isPlaying]) {
            [self->_button setHidden:YES];
        }
    });
}

- (void)stopAnim {
    if (![_imageView.player isPlaying]) {
        return;
    }
    [_imageView.player stopPlay];
    [_button setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [_button setHidden:NO];
}

- (void)animLoop {
    [self ViewAnimation:_pickerView willHidden:NO];
}

- (void)ViewAnimation:(UIView*)view willHidden:(BOOL)hidden {
      
    [UIView animateWithDuration:0.3 animations:^{
        if (hidden) {
            view.frame = (CGRect){0, self.view.bounds.size.height, self.view.bounds.size.width, 230};
        } else {
            view.frame = (CGRect){0, self.view.bounds.size.height - 230, self.view.bounds.size.width, 230};
            [view setHidden:hidden];
        }
    } completion:^(BOOL finished) {
        [view setHidden:hidden];
        [self->_maskView setHidden:hidden];
    }];
}

- (void)closePicker {
    [self ViewAnimation:_pickerView willHidden:YES];
}

#pragma mark --- UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 20;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @(row + 1).stringValue;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _loopCount = row + 1;
    _imageView.player.loopCount = _loopCount;
    [self playAnim];
    [self ViewAnimation:_pickerView willHidden:YES];
}

@end
