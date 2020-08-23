//
//  BDImageOptionView.m
//  BDWebImage_Example
//
//

#import "BDImageOptionView.h"
#import "BDImageAdapter.h"
#import <Masonry/Masonry.h>

typedef void (^block_item)(void);
typedef BOOL (^block_show)(void);

@interface BDImageOptionView()

@property(nonatomic, copy) void (^saveBlock)(void);
@property(nonatomic, strong) NSArray *itemNames;
@property(nonatomic, strong) NSArray *itemBlock;
@property(nonatomic, strong) NSArray *itemShow;
@property(nonatomic, strong) NSArray *items;

@end

@implementation BDImageOptionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *title = [UILabel new];
        title.text = @"加载配置";
        title.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        title.textAlignment = NSTextAlignmentLeft;
        [self addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).mas_offset(16);
            make.left.mas_equalTo(self).mas_offset(16);
            make.height.lessThanOrEqualTo(@(40));
        }];
        self.itemNames = @[@"预加载", @"预解码", @"动图边下边播"];
        self.itemBlock = @[^{
            [BDImageAdapter sharedAdapter].isPrefetch = ![BDImageAdapter sharedAdapter].isPrefetch;
        }, ^{
            [BDImageAdapter sharedAdapter].isDecodeForDisplay = ![BDImageAdapter sharedAdapter].isDecodeForDisplay;
        }, ^{
            [BDImageAdapter sharedAdapter].options ^= BDImageAnimatedImageProgressiveDownload;
        }];
        self.itemShow = @[^BOOL{
            return [BDImageAdapter sharedAdapter].isPrefetch;
        }, ^BOOL{
            return [BDImageAdapter sharedAdapter].isDecodeForDisplay;
        }, ^BOOL{
            return [BDImageAdapter sharedAdapter].options & BDImageAnimatedImageProgressiveDownload;
        }];
        UIView *item1 = [self addSelectItem:0 under:title];
        UIView *item2 = [self addSelectItem:1 under:item1];
        UIView *item3 = [self addSelectItem:2 under:item2];
        self.items = @[item1, item2, item3];
        UIButton *saveButton = [UIButton new];
        [saveButton setTitle:@"保存配置项" forState:(UIControlStateNormal)];
        saveButton.backgroundColor = [UIColor systemBlueColor];
        [saveButton addTarget:self action:@selector(saveOptions) forControlEvents:UIControlEventTouchUpInside];
        [self updateItems];
        [self addSubview:saveButton];
        [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(16);
            make.right.mas_equalTo(self).mas_offset(-16);
            make.top.mas_equalTo(item3.mas_bottom).mas_offset(40);
            make.height.mas_equalTo(40);
        }];
    }
    return self;
}

- (UIView *)addSelectItem:(NSInteger)index under:(UIView *)view {
    UILabel *title = [UILabel new];
    title.text = self.itemNames[index];
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:16];
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(36);
        make.top.mas_equalTo(view.mas_bottom).mas_offset(16);
    }];
    UISwitch *select = [UISwitch new];
    select.onTintColor = [UIColor systemBlueColor];
    [self addSubview:select];
    [select mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(-16);
        make.left.mas_equalTo(title.mas_right).mas_offset(16);
        make.top.mas_equalTo(title);
        make.bottom.mas_equalTo(title);
    }];
    select.tag = index;
    [select addTarget:self action:@selector(selectOptions:) forControlEvents:UIControlEventValueChanged];
    return select;
}

- (void)updateItems {
    [self.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block_show block = self.itemShow[idx];
        BOOL isON = block();
        ((UISwitch *)obj).on = isON;
    }];
}

- (void)selectOptions:(UISwitch *)select {
    NSInteger index = select.tag;
    block_item block = self.itemBlock[index];
    block();
}

- (void)setSaveAction:(void (^)(void))block {
    _saveBlock = block;
}

- (void)saveOptions {
    
    _saveBlock();
}

@end
