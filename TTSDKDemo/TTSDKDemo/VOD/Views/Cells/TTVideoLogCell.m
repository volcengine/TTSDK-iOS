//
//  TTVideoLogCell.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/10/8.


#import "TTVideoLogCell.h"
#import "TTVideoLogModel.h"

@interface TTVideoLogCell()

@property (nonatomic, strong) UILabel* textLab;
@property (nonatomic, strong) UILabel* dateLab;
@end

@implementation TTVideoLogCell

- (void)setupUI {
    [super setupUI];
    
    [self.contentView addSubview:self.textLab];
    [self.contentView addSubview:self.dateLab];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _dateLab.left = TT_EDGE;
    _dateLab.centerY = self.contentView.height * 0.5;
    _textLab.left = _dateLab.right + TT_BASE_375(10.0);
    _textLab.centerY = _dateLab.centerY;
}

- (void)assignValue:(id)model {
    [super assignValue:model];
    
    [self refreshView:model];
}

- (void)refreshView:(id)model {
    [super refreshView:model];
    if (model == nil) {
        return;
    }
    
    if (![model isKindOfClass:[TTVideoLogModel class]]) {
        return;
    }
    
    TTVideoLogModel* data = (TTVideoLogModel *)model;
    _dateLab.text = data.dataString;
    _textLab.text = data.logInfo;
    
    _dateLab.size = [_dateLab.text sizeForFont:_dateLab.font size:CGSizeMake(TT_BASE_375(120), self.contentView.height) mode:NSLineBreakByWordWrapping];
    _textLab.size = [_textLab.text sizeForFont:_textLab.font size:CGSizeMake(self.contentView.width - _dateLab.width - TT_BASE_375(40), self.contentView.height) mode:NSLineBreakByWordWrapping];
    
    [self setNeedsLayout];
}

/// MARK: - Getter

- (UILabel *)textLab {
    if (!_textLab) {
        _textLab = [[UILabel alloc] init];
        _textLab.font = TT_FONT(13.0f);
        _textLab.textColor = TT_COLOR_HEX(@"#8B4726");
        _textLab.textAlignment = NSTextAlignmentLeft;
        _textLab.backgroundColor = [UIColor clearColor];
        _textLab.numberOfLines = 0;
    }
    return _textLab;
}

- (UILabel *)dateLab {
    if (!_dateLab) {
        _dateLab = [[UILabel alloc] init];
        _dateLab.font = TT_FONT(12.0f);
        _dateLab.textColor = TT_COLOR_HEX(@"#363636");
        _dateLab.textAlignment = NSTextAlignmentLeft;
        _dateLab.backgroundColor = [UIColor clearColor];
        _dateLab.numberOfLines = 0;
    }
    return _dateLab;
}

@end
