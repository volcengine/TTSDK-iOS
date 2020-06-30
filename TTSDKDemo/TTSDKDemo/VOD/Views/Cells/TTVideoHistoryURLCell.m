//
//  TTVideoHistoryURLCell.m
//  TTVideoEngineDemo
//
//  Created by 黄清 on 2018/12/24.
//  Copyright © 2018 bytedance. All rights reserved.
//

#import "TTVideoHistoryURLCell.h"
#import "TTVideoHistoryURLModel.h"

@interface TTVideoHistoryURLCell ()

@property (nonatomic, strong) UILabel *textLab;

@end

@implementation TTVideoHistoryURLCell

- (void)setupUI {
    [super setupUI];
    
    [self.contentView addSubview:self.textLab];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLab.left = TT_EDGE;
    self.textLab.top = TT_BASE_375(5);
    self.textLab.width = self.contentView.width - 2 * TT_EDGE;
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
    
    if (![model isKindOfClass:[TTVideoHistoryURLModel class]]) {
        return;
    }
    TTVideoHistoryURLModel *data = (TTVideoHistoryURLModel *)model;
    self.textLab.text = [NSString stringWithFormat:@"URL: %@",data.urlString];
    self.textLab.size = [self.textLab.text sizeForFont:self.textLab.font size:CGSizeMake(self.contentView.width - 2 * TT_EDGE, 1000) mode:NSLineBreakByWordWrapping];
    [self setNeedsLayout];
}

/// MARK: - Getter

- (UILabel *)textLab {
    if (!_textLab) {
        _textLab = [[UILabel alloc] init];
        _textLab.textColor = TT_COLOR_HEX(@"#000000");
        _textLab.font = TT_FONT(15);
        _textLab.textAlignment = NSTextAlignmentLeft;
        _textLab.numberOfLines = 0;
    }
    return _textLab;
}

@end
