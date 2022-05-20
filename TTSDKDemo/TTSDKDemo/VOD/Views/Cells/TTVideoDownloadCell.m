//
//  TTVideoDownloadCell.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/11.


#import "TTVideoDownloadCell.h"

@interface TTVideoDownloadCell ()
@property(nonatomic, strong) UIImageView* imgView;
@property(nonatomic, strong) UILabel* titleLab;
@property(nonatomic, strong) UILabel* timeLab;
@end

@implementation TTVideoDownloadCell

- (void)setupUI {
    [super setupUI];
    
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.timeLab];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imgView.size = CGSizeMake(250, 200);
    _imgView.left = TT_EDGE;
    _imgView.top = TT_EDGE;
    
    
    [_timeLab sizeToFit];
    _titleLab.bottom = TT_BASE_375(10);
    _titleLab.right = TT_BASE_375(10);
    
    _titleLab.left = _imgView.right + TT_BASE_375(10.0);
}

- (void)assignValue:(id)model {
    [super assignValue:model];
}

- (void)refreshView:(id)model {
    [super refreshView:model];
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
        _timeLab.backgroundColor = [UIColor whiteColor];
        _timeLab.font = TT_FONT(12.0);
        _timeLab.textColor = TT_COLOR(50, 50, 50, 1.0);
        _timeLab.textAlignment = NSTextAlignmentRight;
    }
    return _timeLab;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.backgroundColor = TT_COLOR(50, 50, 50, 1.0);
        _titleLab.font = TT_FONT(16.0);
        _titleLab.backgroundColor = TT_COLOR(255, 255, 255, 1.0);
    }
    return _titleLab;
}

@end
