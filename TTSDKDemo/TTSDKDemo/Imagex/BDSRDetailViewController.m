//
//  BDSRDetailViewController.m
//  ImageX
//
//  Created by 陈奕 on 2020/11/9.
//  Copyright © 2020 chenyi. All rights reserved.
//

#import "BDSRDetailViewController.h"
#import <Masonry/Masonry.h>
#import <BDSuperResolutionTransformer.h>

@interface BDSRDetailViewController ()

@property (nonatomic, strong) BDImageView *imageView1;
@property (nonatomic, strong) BDImageView *imageView2;
@property (nonatomic, assign) BOOL isImageFull;
@property (nonatomic, strong) BDWebImageRequest *request1;
@property (nonatomic, strong) BDWebImageRequest *request2;

@end

@implementation BDSRDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = self.view.bounds.size.width;
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"原图";
    label1.textColor = [UIColor blackColor];
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(self.navigationController.navigationBar.frame.size.height + CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]));
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(48);
    }];
    self.isImageFull = true;
    
    _imageView1 = [BDImageView new];
    _imageView1.frame = (CGRect){0, 0, width, width};
    _imageView1.center = self.view.center;
    _imageView1.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView1];
    [_imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(label1.mas_bottom);
        make.width.mas_equalTo(width * 2 / 3);
        make.height.mas_equalTo(width * 2 / 3);
    }];
    _imageView1.userInteractionEnabled = YES;
    __weak typeof(self) wself = self;
    [_imageView1 bd_setImageWithURL:[NSURL URLWithString:_url] placeholder:nil options:BDImageRequestIgnoreCache completion:^(BDWebImageRequest *request, UIImage *image, NSData *data, NSError *error, BDWebImageResultFrom from) {
        label1.text = [label1.text stringByAppendingFormat:@"(size:%@)", NSStringFromCGSize(image.size)];
        wself.request1 = request;
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"超分图片";
    label2.textColor = [UIColor blackColor];
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(_imageView1.mas_bottom);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(48);
    }];
    
    _imageView2 = [BDImageView new];
    _imageView2.frame = (CGRect){0, 0, width, width};
    _imageView2.center = self.view.center;
    _imageView2.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView2];
    [_imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(label2.mas_bottom);
        make.width.mas_equalTo(width * 2 / 3);
        make.height.mas_equalTo(width * 2 / 3);
    }];
    _imageView2.userInteractionEnabled = YES;
    [_imageView2 bd_setImageWithURL:[NSURL URLWithString:_url] placeholder:nil options:BDImageRequestIgnoreCache transformer:[BDSuperResolutionTransformer new] progress:NULL completion:^(BDWebImageRequest *request, UIImage *image, NSData *data, NSError *error, BDWebImageResultFrom from) {
        label2.text = [label2.text stringByAppendingFormat:@"(size:%@)", NSStringFromCGSize(image.size)];
        wself.request2 = request;
    }];
    
    UIButton *changeButton = [[UIButton alloc] init];
    [changeButton setTitle:@"点击切换图片展示详情" forState:UIControlStateNormal];
    [changeButton setBackgroundColor:[UIColor systemBlueColor]];
    [self.view addSubview:changeButton];
    [changeButton addTarget:self action:@selector(changeImageContentMode) forControlEvents:(UIControlEventTouchUpInside)];
    [changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_imageView2.mas_bottom).offset(20);
        make.width.mas_equalTo(width * 2 / 3);
        make.height.mas_equalTo(48);
    }];
    changeButton.layer.cornerRadius = 5;
}

- (void)changeImageContentMode {
    if (self.isImageFull) {
        UIImage *image1 = _imageView1.image;
        UIImage *image2 = _imageView2.image;
        CGFloat width1 = _imageView1.bounds.size.width / image1.size.width;
        CGFloat height1 = _imageView1.bounds.size.height / image1.size.height;
        CGFloat width2 = _imageView2.bounds.size.width / image2.size.width;
        CGFloat height2 = _imageView2.bounds.size.height / image2.size.height;
        _imageView1.layer.contentsRect = CGRectMake(0, 0, width1 > 1 ? 1 : width1, height1 > 1 ? 1 : height1);
        _imageView2.layer.contentsRect = CGRectMake(0, 0, width2 > 1 ? 1 : width2, height2 > 1 ? 1 : height2);
        _imageView1.contentMode = UIViewContentModeCenter;
        _imageView2.contentMode = UIViewContentModeCenter;
    } else {
        _imageView1.layer.contentsRect = CGRectMake(0, 0, 1, 1);
        _imageView2.layer.contentsRect = CGRectMake(0, 0, 1, 1);
        _imageView1.contentMode = UIViewContentModeScaleAspectFit;
        _imageView2.contentMode = UIViewContentModeScaleAspectFit;
    }
    self.isImageFull = !self.isImageFull;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
