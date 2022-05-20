//
//  TTVideoHistoryVidCell.m
//  TTVideoEngineDemo
//
//  Created by 黄清 on 2018/12/24.
//  Copyright © 2018 bytedance. All rights reserved.
//

#import "TTVideoHistoryVidCell.h"
#import "TTVideoHistoryVidModel.h"

@interface TTVideoHistoryVidCell ()
@property (nonatomic, strong) UILabel *vidLab;
@property (nonatomic, strong) UILabel *authLab;
@property (nonatomic, strong) UILabel *ptokenLab;
@end

@implementation TTVideoHistoryVidCell

- (void)setupUI {
    [super setupUI];
    
    [self.contentView addSubview:self.vidLab];
    [self.contentView addSubview:self.authLab];
    [self.contentView addSubview:self.ptokenLab];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.vidLab.left = TT_EDGE;
    self.vidLab.width = self.contentView.width - 2 * TT_EDGE;
    self.vidLab.top = TT_BASE_375(5.0);
    
    self.authLab.left = self.vidLab.left;
    self.authLab.width = self.vidLab.width;
    self.authLab.top =self.vidLab.bottom + TT_BASE_375(5.0);
    
    self.ptokenLab.left = self.vidLab.left;
    self.ptokenLab.width = self.vidLab.width;
    self.ptokenLab.top =self.authLab.bottom + TT_BASE_375(5.0);
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
    
    if (![model isKindOfClass:[TTVideoHistoryVidModel class]]) {
        return;
    }
    
    TTVideoHistoryVidModel *data = (TTVideoHistoryVidModel *)model;
    self.vidLab.text = [NSString stringWithFormat:@"Vid: %@",data.vidString];
    self.authLab.text = [NSString stringWithFormat:@"Auth: %@",data.authString];
    self.ptokenLab.text = [NSString stringWithFormat:@"Ptoken: %@",data.ptokenString];
    self.vidLab.size = [self.vidLab.text sizeForFont:self.vidLab.font size:CGSizeMake(self.contentView.width - 2 * TT_EDGE, 1000) mode:NSLineBreakByWordWrapping];
    self.authLab.size = [self.authLab.text sizeForFont:self.authLab.font size:CGSizeMake(self.contentView.width - 2 * TT_EDGE, 1000) mode:NSLineBreakByWordWrapping];
    self.ptokenLab.size = [self.ptokenLab.text sizeForFont:self.ptokenLab.font size:CGSizeMake(self.contentView.width - 2 * TT_EDGE, 1000) mode:NSLineBreakByWordWrapping];
    [self setNeedsLayout];
}

/// MARK: - Getter

- (UILabel *)vidLab {
    if (!_vidLab) {
        _vidLab = [[UILabel alloc] init];
        _vidLab.textColor = TT_COLOR_HEX(@"#000000");
        _vidLab.font = TT_FONT(16);
        _vidLab.textAlignment = NSTextAlignmentLeft;
        _vidLab.numberOfLines = 0;
    }
    return _vidLab;
}

- (UILabel *)authLab {
    if (!_authLab) {
        _authLab = [[UILabel alloc] init];
        _authLab.textColor = TT_COLOR_HEX(@"#000000");
        _authLab.font = TT_FONT(14);
        _authLab.textAlignment = NSTextAlignmentLeft;
        _authLab.numberOfLines = 0;
    }
    return _authLab;
}

- (UILabel *)ptokenLab {
    if (!_ptokenLab) {
        _ptokenLab = [[UILabel alloc] init];
        _ptokenLab.textColor = TT_COLOR_HEX(@"#000000");
        _ptokenLab.font = TT_FONT(14);
        _ptokenLab.textAlignment = NSTextAlignmentLeft;
        _ptokenLab.numberOfLines = 0;
    }
    return _ptokenLab;
}

@end
