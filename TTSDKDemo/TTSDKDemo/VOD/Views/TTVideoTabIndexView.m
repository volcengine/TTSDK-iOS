//
//  TTVideoTabIndexView.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/12.


#import "TTVideoTabIndexView.h"

static const CGFloat kBeforeAfterWidth = 20.0f;
static const CGFloat kFirstBeforeWidth = 10.0f;

@interface TTVideoTabIndexView ()
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIView *cursorView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,  copy) NSArray *titles;
@property (nonatomic,assign) CGFloat titleWidth;
@end

@implementation TTVideoTabIndexView

- (void)setUpUI {
    [super setUpUI];
    
    self.backgroundColor = TT_THEME_COLOR;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0.0;
    flowLayout.minimumInteritemSpacing = 0.0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.scrollsToTop = NO;
    _collectionView.dataSource = (id<UICollectionViewDataSource>)self;
    _collectionView.delegate = (id<UICollectionViewDelegate>)self;
    [_collectionView registerClass:[TTVideoTabIndexItem class] forCellWithReuseIdentifier:@"TTVideoTabIndexItem"];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.backgroundView = nil;
    [self addSubview:_collectionView];
    
    _cursorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 2)];
    _cursorView.backgroundColor = TT_COLOR_HEX(@"#5539C0");
    _cursorView.layer.cornerRadius = 1.5f;
    _cursorView.layer.masksToBounds = YES;
    _cursorView.size = CGSizeMake(10, 2);
    _cursorView.bottom = self.height - 6.0f;
    [_collectionView addSubview:_cursorView];
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - TT_ONE_PIXEL, SCREEN_WIDTH, TT_ONE_PIXEL)];
    _lineView.backgroundColor = TT_COLOR_HEX(@"#D6D6D6");
    [self addSubview:_lineView];
    _selectedIndex = 0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _lineView.left = 0;
    _lineView.width = self.width;
    _collectionView.width = MIN(self.width, self.titleWidth);
    _collectionView.left = (self.width- _collectionView.width)* 0.5;
}

- (void)updateTitles:(NSArray *)titles {
    _titles = titles;
    if (titles.count > 0) {
        self.selectedIndex = 0;
    }
    
    [self _titleTotalWidth];
}

- (void)setHiddenLineView:(BOOL)hiddenLineView {
    _lineView.hidden = hiddenLineView;
}

- (BOOL)hiddenLineView {
    return _lineView.hidden;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex >= _titles.count) {
        return;
    }
    _selectedIndex = selectedIndex;
    
    [_collectionView reloadData];
    
    if ([self _isOverFlow]) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
    [self _updateCusorView];
}

/// MARK: - Private method

- (void)_updateCusorView {
    if (_titles.count == 0) {
        return;
    }
    
    NSIndexPath* currentIndexPath = [NSIndexPath indexPathForItem:_selectedIndex inSection:0];
    UICollectionViewLayoutAttributes* attri = [_collectionView layoutAttributesForItemAtIndexPath:currentIndexPath];
    CGFloat centerX = CGRectGetMidX(attri.frame);
    if (_selectedIndex == 0) {
        centerX += (kFirstBeforeWidth-kBeforeAfterWidth)*0.5;
    }else if(_selectedIndex == _titles.count-1){
        centerX -= (kFirstBeforeWidth-kBeforeAfterWidth)*0.5;
    }
    _cursorView.centerX = centerX;
}

- (void)_titleTotalWidth {
    CGFloat totalWidth = 0.0;
    for (NSInteger i = 0; i < _titles.count; i++) {
        NSString* temTitle = [_titles objectAtIndex:i];
        CGFloat temWidth = [temTitle widthForFont:TT_FONT(15)];
        totalWidth += temWidth;
        totalWidth += 2 * kBeforeAfterWidth;
    }
    totalWidth += (kFirstBeforeWidth - kBeforeAfterWidth)*2;
    
    _titleWidth = totalWidth;
}

- (BOOL)_isOverFlow {
    return (self.titleWidth > SCREEN_WIDTH);
}

/// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTVideoTabIndexItem *cell = (TTVideoTabIndexItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TTVideoTabIndexItem" forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        [cell setTextLabelx:kFirstBeforeWidth];
    }else{
        [cell setTextLabelx:kBeforeAfterWidth];
    }
    
    NSString *value = _titles[indexPath.row];
    [cell setTitle:value selected:indexPath.row == _selectedIndex];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* title = [_titles objectAtIndex:indexPath.item];
    CGFloat temWidth = [title widthForFont:TT_FONT_BLOD(15)];
    
    CGFloat beforeWidth = kBeforeAfterWidth;
    CGFloat afterWidth = kBeforeAfterWidth;
    if (indexPath.item == 0) {
        beforeWidth = kFirstBeforeWidth;
    }
    if (indexPath.item == _titles.count-1) {
        afterWidth = kFirstBeforeWidth;
    }
    
    return CGSizeMake(temWidth+beforeWidth+afterWidth, self.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    
    if (self.clickCall) {
        self.clickCall(_selectedIndex);
    }
}

@end


@implementation TTVideoTabIndexItem {
    UILabel *_label;
    UIFont  *_selectedFont;
    UIFont  *_normalFont;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        _label = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _label.textAlignment = NSTextAlignmentCenter;
        _selectedFont = TT_FONT_BLOD(15);
        _normalFont = TT_FONT(15);
        _label.font = _normalFont;
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    _label.text = @"";
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _label.height = TT_BASE_375(17);
    _label.bottom = self.contentView.height - 12.0f;
}

- (void)setTitle:(NSString *)title selected:(BOOL)selected {
    _label.textColor = selected ? TT_COLOR_HEX(@"#5539C0") : TT_COLOR_HEX(@"#FFFFFF");
    _label.font = selected ? _selectedFont : _normalFont;
    _label.text = title;
    [_label sizeToFit];
    
    [self setNeedsLayout];
}

- (void)setTextLabelx:(CGFloat)labX {
    _label.left = labX;
    
    [self setNeedsLayout];
}

@end
