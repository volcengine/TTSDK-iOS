//
//  TTControlsBox.m
//  TTSDKDemo
//
//  Created by 陈昭杰 on 2020/1/19.
//  Copyright © 2020 ByteDance. All rights reserved.
//

#import "TTControlsBox.h"

CGFloat(^RandomValue)(void) = ^ CGFloat {
    return arc4random() % 256 / 255.0;
};

static NSString * const kTTControlsBoxCellIdentifier = @"TTControlsBoxCellIdentifier";
static NSString * const kTTControlsBoxHeaderIdentifier = @"TTControlsBoxHeaderIdentifier";
static const CGFloat kSliderHeight = 48;
static const CGFloat kSliderHorizontalMargin = 24;
static const CGFloat kCategoryControlHeight = 48;
static const CGFloat kControlsContainerHeight = 100;
static const CGFloat kControlsCellHeight = kControlsContainerHeight;
static const CGFloat kControlsCellWidth = kControlsCellHeight;

// MARK: - TTControlsBoxCell

@interface TTControlsBoxCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIImageView *imageView;

- (void)updateWithTitle:(NSString *)title image:(UIImage *)image userInfo:(NSDictionary *)userInfo;

@end

@implementation TTControlsBoxCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = UIColor.whiteColor;
        [self addSubview:_label];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.bounds;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self handleSelectStateChange:selected];
}

- (void)updateWithTitle:(NSString *)title image:(UIImage *)image userInfo:(NSDictionary *)userInfo {
    self.label.text = title;
}

- (void)handleSelectStateChange:(BOOL)selected {
    self.backgroundColor = selected ? UIColor.lightGrayColor : UIColor.darkGrayColor;
}

@end

// MARK: - TTControlsBox

@interface TTControlsBox () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) TTEffectsViewModel *viewModel;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UICollectionView *controlsCollectionView;

@property (nonatomic, strong) UISegmentedControl *categoryControl;

@property (nonatomic, strong) UISlider *slider;

@end

@implementation TTControlsBox

- (instancetype)initWithViewModel:(TTEffectsViewModel *)viewModel {
    if (self = [self init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.clearColor;
    
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectZero];
    [maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    maskView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:maskView];
    self.maskView = maskView;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *controlsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [controlsCollectionView registerClass:TTControlsBoxCell.class forCellWithReuseIdentifier:kTTControlsBoxCellIdentifier];
    controlsCollectionView.delegate = self;
    controlsCollectionView.dataSource = self;
    controlsCollectionView.showsHorizontalScrollIndicator = NO;
    controlsCollectionView.backgroundColor = UIColor.darkGrayColor;
    [self.view addSubview:controlsCollectionView];
    self.controlsCollectionView = controlsCollectionView;
    
    UISegmentedControl *categoryControl = [[UISegmentedControl alloc] initWithItems:self.viewModel.currentCategories];
    [categoryControl addTarget:self action:@selector(selectedCategoryChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:categoryControl];
    self.categoryControl = categoryControl;
    
    UISlider *slider = [[UISlider alloc] init];
    slider.maximumValue = 1;
    slider.minimumValue = 0;
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    self.slider = slider;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.frame = UIScreen.mainScreen.bounds;
    self.maskView.frame = self.view.bounds;
    CGFloat height = CGRectGetHeight(self.view.frame);
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat originY = height - kControlsContainerHeight;
    self.controlsCollectionView.frame = CGRectMake(0, originY, width, kControlsContainerHeight);
    
    originY -= kCategoryControlHeight;
    self.categoryControl.frame = CGRectMake(0, originY, width, kCategoryControlHeight);
    
    originY -= kSliderHeight;
    self.slider.frame = CGRectMake(kSliderHorizontalMargin, originY, width - kSliderHorizontalMargin * 2, kSliderHeight);
}

- (BOOL)shouldAutorotate {
    return NO;
}

// MARK: Public Methods

- (void)present {
    self.view.hidden = NO;
    [self update];
}

- (void)dismiss {
    self.view.hidden = YES;
}

// MARK: Private Methods

- (void)update {
    [self.categoryControl removeAllSegments];
    for (NSInteger index = 0; index < self.viewModel.currentCategories.count; index++) {
        NSString *title = [self.viewModel.currentCategories objectAtIndex:index];
        [self.categoryControl insertSegmentWithTitle:title atIndex:index animated:NO];
    }
    self.categoryControl.selectedSegmentIndex = 0;
    self.categoryControl.hidden = self.categoryControl.numberOfSegments <= 1;
    self.slider.hidden = YES;
    [self updateControlsCollectionView];
}

- (void)selectedCategoryChanged:(UISegmentedControl *)sender {
    NSLog(@"%ld selected", (long)sender.selectedSegmentIndex);
    self.slider.hidden = YES;
    [self updateControlsCollectionView];
}

- (void)sliderValueChanged:(UISlider *)sender {
    [self.viewModel updaetIntensityOfItemWithValue:sender.value
                                             index:[NSIndexPath indexPathForRow:self.controlsCollectionView.indexPathsForSelectedItems.firstObject.row - 1
                                                                      inSection:self.categoryControl.selectedSegmentIndex]];
}

- (void)updateControlsCollectionView {
    [self.controlsCollectionView reloadData];
    [self.controlsCollectionView layoutIfNeeded];
}

// MARK: UICollectionView Related MDelegate Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kControlsCellWidth, kControlsCellHeight);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.viewModel itemsOfCategoryWithIndex:self.categoryControl.selectedSegmentIndex] count] + 1;
}

- (UICollectionViewCell *)collectionView:collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TTControlsBoxCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTTControlsBoxCellIdentifier forIndexPath:indexPath];
    NSString *title = indexPath.row == 0 ? @"关闭" : [[self.viewModel itemsOfCategoryWithIndex:self.categoryControl.selectedSegmentIndex] objectAtIndex:indexPath.row - 1];
    [cell updateWithTitle:title image:nil userInfo:nil];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", indexPath.row);
    if (indexPath.row == 0) {
        [self.viewModel removeComposerNodesOfCategoryWithIndex:self.categoryControl.selectedSegmentIndex];
        self.slider.hidden = YES;
    } else {
        NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:self.categoryControl.selectedSegmentIndex];
        if ([self.viewModel typeOfItemWithIndex:index] == TTEffectsItemTypeAdjustable) {
            self.slider.value = [self.viewModel intensityOfItemWithIndex:index];
            self.slider.hidden = NO;
        } else {
            [self.viewModel updaetIntensityOfItemWithValue:1 index:index];
            self.slider.hidden = YES;
        }
    }
}

@end
