//
//  TTVideoResolutionOptionsView.m
//  TTVideoEngineDemo
//
//  Created by 黄清 on 2018/12/19.
//  Copyright © 2018 bytedance. All rights reserved.
//

#import "TTVideoResolutionOptionsView.h"

#define ITEM_HEIGHT TT_BASE_375(30)
#define ITEM_WIDTH  TT_BASE_375(80)
@interface TTVideoResolutionOptionsView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isOverHeight;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation TTVideoResolutionOptionsView

- (void)dealloc {
    [self removeGestureRecognizer:_tapGesture];
}

- (void)setUpUI {
    [super setUpUI];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0.0;
    flowLayout.minimumInteritemSpacing = 0.0;
    flowLayout.itemSize = CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
    flowLayout.estimatedItemSize = flowLayout.itemSize;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.scrollsToTop = NO;
    self.collectionView.dataSource = (id<UICollectionViewDataSource>)self;
    self.collectionView.delegate = (id<UICollectionViewDelegate>)self;
    [self.collectionView registerClass:[TTVideoResolutionOptionsItem class] forCellWithReuseIdentifier:@"TTVideoResolutionOptionsItem"];
    [self addSubview:self.collectionView];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tap:)];
    [self addGestureRecognizer:self.tapGesture];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.width = ITEM_WIDTH;
    if ([self _isPortrait]) {
        self.hidden = YES;
    }
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    
    [self.collectionView reloadData];
}

- (void)showAtPoint:(CGPoint)point {
    if ([self _isPortrait]) {
        self.hidden = YES;
        return;
    }
    
    self.hidden = NO;
    self.collectionView.hidden = NO;
    
    CGFloat totalHeight = ITEM_HEIGHT * self.titles.count;
    if (point.y > self.height * 0.5) {
        CGFloat maxHeight = point.y - TT_BASE_375(60) ;
        self.isOverHeight = totalHeight > maxHeight;
        self.collectionView.height = MIN(maxHeight, totalHeight);
        self.collectionView.bottom = point.y;
    } else {
        CGFloat maxHeight = (self.height - point.y) - TT_BASE_375(60);
        self.isOverHeight = totalHeight > maxHeight;
        self.collectionView.height = MIN(maxHeight, totalHeight);
        self.collectionView.top = point.y;
    }
    self.collectionView.left = point.x - (self.collectionView.width * 0.5);
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex >= _titles.count) {
        return;
    }
    _selectedIndex = selectedIndex;
    
    [_collectionView reloadData];
    
    if (self.isOverHeight) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

/// MARK: - Private method

- (BOOL)_isPortrait {
    return self.width < SCREEN_HEIGHT && !self.verticalScreen;
}

- (void)_hiddenShow:(void(^)(BOOL finished))end {
    [UIView animateWithDuration:0.3 animations:^{
        self.collectionView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.collectionView.hidden = YES;
        self.collectionView.alpha = 1.0;
        self.hidden = YES;
        !end ?: end(finished);
    }];
}

- (void)_tap:(UITapGestureRecognizer *)gesture {
    [self _hiddenShow:^(BOOL finished) {
    }];
}

- (void)_didSelected:(NSInteger)index {
    if (index == self.selectedIndex) {
        return;
    }
    
    self.selectedIndex = index;
    [self _hiddenShow:^(BOOL finished) {
        if (self.clickCall) {
            self.clickCall(self.selectedIndex);
        }
    }];
}

/// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTVideoResolutionOptionsItem *cell = (TTVideoResolutionOptionsItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TTVideoResolutionOptionsItem" forIndexPath:indexPath];
    cell.tag = indexPath.item;
    NSString *value = self.titles[indexPath.row];
    [cell setTitle:value selected:indexPath.row == self.selectedIndex];
    @weakify(self)
    @weakify(cell)
    [cell setClickCall:^(NSInteger index) {
        @strongify(self)
        @strongify(cell)
        if (!self || !cell) {
            return;
        }
        
        [self _didSelected:cell.tag];
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self _didSelected:indexPath.item];
}

@end

/// MARK: - TTVideoResolutionOptionsItem

@implementation TTVideoResolutionOptionsItem {
    UIButton *_textBtn;
    UIFont  *_selectedFont;
    UIFont  *_normalFont;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textBtn = [[UIButton alloc] initWithFrame:self.contentView.bounds];
        _textBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _textBtn.titleLabel.font = _normalFont;
        [_textBtn addTarget:self action:@selector(_btnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_textBtn];
        _textBtn.titleLabel.backgroundColor = TT_COLOR(0, 0, 0, 0.2);
        _selectedFont = TT_FONT_BLOD(15);
        _normalFont = TT_FONT(15);
    }
    return self;
}

- (void)setTitle:(NSString *)title selected:(BOOL)selected {
    [_textBtn setTitleColor:selected ? TT_COLOR_HEX(@"#5539C0") : TT_COLOR_HEX(@"#FFFFFF") forState:UIControlStateNormal];
    _textBtn.titleLabel.font = selected ? _selectedFont : _normalFont;
    [_textBtn setTitle:title forState:UIControlStateNormal];
    
    [self setNeedsLayout];
}

- (void)_btnClickEvent:(UIButton *)btn {
    !self.clickCall ?: self.clickCall(self.tag);
}

@end
