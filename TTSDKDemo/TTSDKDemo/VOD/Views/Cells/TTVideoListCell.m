//
//  TTVideoListCell.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/10/8.


#import "TTVideoListCell.h"
#import "UIImageView+TTVideo.h"
#import "TTVideoListModel.h"

@interface TTVideoListCell()
@property(nonatomic, strong) UIImageView* imgView;
@property(nonatomic, strong) UILabel* timeLab;
@property(nonatomic, strong) UILabel* titleLab;
@end

@implementation TTVideoListCell

- (void)setupUI {
    [super setupUI];
    
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.timeLab];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imgView.size = CGSizeMake(TT_BASE_375(120), TT_BASE_375(100));
    _imgView.left = TT_EDGE;
    _imgView.top = TT_EDGE;
    
    _timeLab.right = _imgView.right - TT_BASE_375(5);
    _timeLab.bottom = _imgView.bottom - TT_BASE_375(5);
    
    _titleLab.top = TT_BASE_375(15);
    _titleLab.left = _imgView.right + TT_BASE_375(10.0);
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
    
    if (![model isKindOfClass:[TTVideoListModel class]]) {
        return;
    }
    
    TTVideoListModel* data = (TTVideoListModel *)model;
    UIImage *holderImg = [UIImage imageWithColor:TT_COLOR(220, 220, 220, 1.0)] ;
#if DEBUG
    holderImg = data.img;
#endif
    [_imgView tt_setImageWithURL:data.imageUrl placeholderImage:holderImg];
    _timeLab.text = data.duration;
    _titleLab.text = data.title;
    
    _titleLab.size = [_titleLab.text sizeForFont:_titleLab.font size:CGSizeMake(self.width -_imgView.right - TT_BASE_375(10), self.height) mode:NSLineBreakByWordWrapping];
    _timeLab.size = [_timeLab.text sizeForFont:_timeLab.font size:CGSizeMake(TT_BASE_375(120), self.height) mode:NSLineBreakByWordWrapping];
    
    [self setNeedsLayout];
}

- (void)tryFresh {
    [super tryFresh];
}

- (void)willDisplay {
    [super willDisplay];
}

- (void)endDisplay {
    [super endDisplay];
}

/// MARK: - Getter

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = [UIColor whiteColor];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
    }
    return _imgView;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = TT_FONT(12.0);
        _timeLab.textColor = TT_COLOR_HEX(@"#FFFFFF");
        _timeLab.textAlignment = NSTextAlignmentRight;
        _timeLab.backgroundColor = TT_COLOR(0, 0, 0, 0.2);
    }
    return _timeLab;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.textColor = TT_COLOR_HEX(@"#111111");
        _titleLab.numberOfLines = 0;
        _titleLab.font = TT_FONT(16.0);
    }
    return _titleLab;
}

@end
