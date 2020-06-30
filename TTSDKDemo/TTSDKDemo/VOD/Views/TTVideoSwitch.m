//
//  TTVideoSwitch.m
//  TTVideoEngineDemo
//
//  Created by 黄清 on 2018/12/24.
//  Copyright © 2018 bytedance. All rights reserved.
//

#import "TTVideoSwitch.h"

@interface TTVideoSwitch ()
@property (nonatomic, strong) UILabel *textLab;
@property (nonatomic,   copy) NSString *title;
@property (nonatomic, strong) UISwitch *innerSwitch;
@end

@implementation TTVideoSwitch

+ (instancetype)switchWithTitle:(NSString *)titile {
    TTVideoSwitch *sw = [[TTVideoSwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    sw.title = titile;
    sw.textLab.text = titile;
    return sw;
}

- (void)setUpUI {
    [super setUpUI];
    
    [self addSubview:self.textLab];
    [self addSubview:self.innerSwitch];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLab.frame = CGRectMake(0, 0, self.textLab.width, self.height);
    self.innerSwitch.left = self.textLab.right + TT_BASE_375(5.0);
    self.innerSwitch.centerY = self.height * 0.5;
}

- (void)sizeToFit {
    [super sizeToFit];
    
    [self.textLab sizeToFit];
    [self.innerSwitch sizeToFit];
    
    self.width = self.textLab.width + TT_BASE_375(5) + self.innerSwitch.width;
    self.height = MAX(self.textLab.height, self.innerSwitch.height);
}

/// MARK: - Private method

- (void)_switchClickEvent:(UISwitch *)sw {
    !self.switchCall ?: self.switchCall(sw.on ? ButtonClickTypeOn : ButtonClickTypeOff);
}

/// MARK: - Getter

- (UILabel *)textLab {
    if (!_textLab) {
        _textLab = [[UILabel alloc] init];
        _textLab.textAlignment = NSTextAlignmentLeft;
        _textLab.text = @"开关";
        _textLab.textColor = TT_COLOR_HEX(@"#FFFFFF");
        _textLab.font = TT_FONT(15);
        _textLab.frame = CGRectMake(0, 0, TT_BASE_375(70), TT_BASE_375(20));
    }
    return _textLab;
}

- (UISwitch *)innerSwitch {
    if (_innerSwitch == nil) {
        _innerSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, TT_BASE_375(40), TT_BASE_375(20))];
        _innerSwitch.tintColor = TT_COLOR(0, 0, 0, 0.5);
        _innerSwitch.onTintColor = TT_THEME_COLOR;
        _innerSwitch.thumbTintColor = TT_COLOR(255, 255, 255, 1.0);
        [_innerSwitch addTarget:self action:@selector(_switchClickEvent:) forControlEvents:UIControlEventValueChanged];
    }
    return _innerSwitch;
}

@end
