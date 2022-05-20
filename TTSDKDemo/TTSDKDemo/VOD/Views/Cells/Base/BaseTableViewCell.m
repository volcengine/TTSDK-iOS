//
//  BaseTableViewCell.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/10/8.


#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
}

- (void)assignValue:(id)model {
    _dataModel = model;
}

- (void)refreshView:(id)model {
    _dataModel = model;
}

- (void)tryFresh {
    [self refreshView:_dataModel];
}

- (void)willDisplay {
    
}

- (void)endDisplay {
    
}

@end
