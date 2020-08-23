//
//  BDRootViewController.m
//  BDWebImage_Example
//
//

#import "BDRootViewController.h"
#import "BDImageCollectionViewController.h"
#import "BDSettingsViewController.h"
#import "BDImageOptionView.h"
#import "BDImageSettingModel.h"
#import "BDImageAdapter.h"
#import <Masonry/Masonry.h>

#define kStatusBarHeight      CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame])

@interface BDRootViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UIPageViewController *pageViewControl;
@property (nonatomic, strong) BDImageOptionView *optionsView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong, nonnull) NSMapTable *weakCache; // strong-weak cache

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) NSUInteger nextIndex;

@end

@implementation BDRootViewController

- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    _titles = [[BDImageAdapter sharedAdapter].urls.allKeys mutableCopy];
    [_titles removeObject:@"全部"];
    [_titles insertObject:@"全部" atIndex:0];
    
    // 初始化UISegmentedControl
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:_titles];
    self.segmentControl.tintColor = [UIColor clearColor];
    self.segmentControl.backgroundColor = [UIColor clearColor];
    if (@available(iOS 13.0, *)) {
        [self.segmentControl setSelectedSegmentTintColor:[UIColor clearColor]];
        [self.segmentControl setBackgroundImage:[self imageFromColor:[UIColor clearColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self.segmentControl setDividerImage:[self imageFromColor:[UIColor clearColor]] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    [self.segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [self.segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:18], NSForegroundColorAttributeName:[UIColor systemBlueColor]} forState:UIControlStateSelected];
    [self.segmentControl setSelectedSegmentIndex:0];
    // 添加监听
    [self.segmentControl addTarget:self action:@selector(didClickSegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentControl];
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHeight);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(self.view).multipliedBy(66 * _titles.count / self.view.bounds.size.width);
    }];
    
    // 初始化 pageView
    self.pageViewControl = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewControl.delegate = self;
    self.pageViewControl.dataSource = self;
    self.weakCache = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory capacity:6];
    BDImageCollectionViewController *vc = [BDImageCollectionViewController new];
    vc.index = 0;
    vc.imageUrls = [BDImageAdapter sharedAdapter].urls[_titles[0]];
    [self.weakCache setObject:vc forKey:@(vc.index)];
    [self.pageViewControl setViewControllers:@[vc]
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:YES
                             completion:nil];
    [self addChildViewController:self.pageViewControl];
    [self.view addSubview:self.pageViewControl.view];
    [self.pageViewControl.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.segmentControl.mas_bottom).with.offset(10);
        make.bottom.equalTo(self.view);
    }];
    
    // 初始化 option button
    CGFloat top = self.view.bounds.size.height - 100;
    CGFloat left = self.view.bounds.size.width - 70;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(left, top, 46, 46)];
    button.layer.cornerRadius = button.frame.size.width / 2;
    button.layer.masksToBounds = YES;
    button.backgroundColor = [UIColor systemBlueColor];
    [button setImage:[UIImage imageNamed:@"配置"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showOptions) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
    // 初始化 back button
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(left, top - 70, 46, 46)];
    backButton.layer.cornerRadius = backButton.frame.size.width / 2;
    backButton.layer.masksToBounds = YES;
    backButton.backgroundColor = [UIColor redColor];
    [backButton setTitle:@"back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:backButton];
    
    // 初始化 setting button
    UIButton *setting = [[UIButton alloc] init];
    [setting setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [setting addTarget:self action:@selector(showSetting) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:setting];
    [setting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-10);
        make.top.equalTo(_segmentControl).with.offset(10);
        make.bottom.equalTo(_segmentControl).with.offset(-10);
        make.width.mas_equalTo(22);
    }];
    
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [_maskView setTag:108];
    [_maskView setBackgroundColor:[UIColor blackColor]];
    [_maskView setAlpha:0.5];
    UITapGestureRecognizer *maskGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeOptions)];
    [_maskView addGestureRecognizer:maskGesture];
    _maskView.userInteractionEnabled = YES;
    [_maskView setHidden:YES];
    [self.view addSubview:_maskView];
    
    _optionsView = [[BDImageOptionView alloc] initWithFrame:(CGRect){0, self.view.bounds.size.height, self.view.bounds.size.width, 300}];
    _optionsView.backgroundColor = [UIColor whiteColor];
    [_optionsView setHidden:YES];
    __weak typeof(self) weakSelf = self;
    [_optionsView setSaveAction:^{
        [weakSelf closeOptions];
    }];
    [self.view addSubview:_optionsView];
}

#pragma mark UISegmentedControl

- (UIViewController *)viewControllerFormIndex:(NSInteger)index {
    if (index < 0 || index > _titles.count - 1 || index == NSNotFound) {
        return nil;
    }
    UIViewController *vc = [self.weakCache objectForKey:@(index)];
    if (vc == nil) {
        BDImageCollectionViewController *vc1 = [BDImageCollectionViewController new];
        vc1.index = index;
        vc1.imageUrls = [BDImageAdapter sharedAdapter].urls[_titles[index]];
        [self.weakCache setObject:vc1 forKey:@(index)];
        vc = vc1;
    }
    return vc;
}

- (void)didClickSegmentedControlAction:(UISegmentedControl *)segmentControl
{
    NSInteger index = segmentControl.selectedSegmentIndex;
    [self.pageViewControl setViewControllers:@[[self viewControllerFormIndex:index]]
                                   direction:UIPageViewControllerNavigationDirectionForward
                                    animated:NO
                                  completion:nil];
}

#pragma mark UIPageViewController

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerAfterViewController:(nonnull UIViewController *)viewController {
    // 返回下一个视图控制器。
    NSUInteger index = ((BDImageCollectionViewController *)viewController).index;
    ++index;
    return [self viewControllerFormIndex:index];
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController {
    // 返回上一个视图控制器。
    NSUInteger index = ((BDImageCollectionViewController *)viewController).index;
    --index;
    return [self viewControllerFormIndex:index];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return -1;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return _titles.count;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    // 如果用户终止了滑动导航，transition将不能完成，页面也将保持不变。
    
    BDImageCollectionViewController *vc = (BDImageCollectionViewController *)pendingViewControllers.firstObject;
    if (vc) {
        self.nextIndex = vc.index;
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    // 使用completed参数区分成功导航和中止导航。
    if (completed) {
        self.currentIndex = self.nextIndex;
        [self.segmentControl setSelectedSegmentIndex:self.currentIndex];
    }
}

#pragma mark

- (void)showSetting {
    BDSettingsViewController *vc = [BDSettingsViewController new];
    vc.navigationItem.title = @"配置";
    vc.settings = [BDImageSettingModel defaultSettingModels];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showOptions {
    [_optionsView updateItems];
    [self ViewAnimation:_optionsView willHidden:NO];
}

- (void)closeOptions {
    [self ViewAnimation:_optionsView willHidden:YES];
}

- (void)ViewAnimation:(UIView*)view willHidden:(BOOL)hidden {
      
    [UIView animateWithDuration:0.3 animations:^{
        if (hidden) {
            view.frame = (CGRect){0, self.view.bounds.size.height, self.view.bounds.size.width, 300};
        } else {
            view.frame = (CGRect){0, self.view.bounds.size.height - 300, self.view.bounds.size.width, 300};
            [view setHidden:hidden];
        }
    } completion:^(BOOL finished) {
        [view setHidden:hidden];
        [self->_maskView setHidden:hidden];
    }];
}

@end
