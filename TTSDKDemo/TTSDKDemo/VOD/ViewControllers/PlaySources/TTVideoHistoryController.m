//
//  TTVideoHistoryController.m
//  TTVideoEngineDemo
//
//  Created by 黄清 on 2018/12/24.
//  Copyright © 2018 bytedance. All rights reserved.
//

#import "TTVideoHistoryController.h"
#import "TTVideoHistoryVidModel.h"
#import "TTVideoHistoryURLModel.h"

@interface TTVideoHistoryController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *bottomBtn;
@end

@implementation TTVideoHistoryController

- (instancetype)init {
    if (self = [super init]) {
        _dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)setUpUI {
    [super setUpUI];
    
    self.tableView.contentInset = UIEdgeInsetsMake(NAVIGATIONBAR_BOTTOM, 0, self.bottomView.height, 0);
    _bottomBtn = [[UIButton alloc] initWithFrame:self.bottomView.frame];
    _bottomBtn.origin = CGPointZero;
    _bottomBtn.titleLabel.font = TT_FONT(16);
    [_bottomBtn addTarget:self action:@selector(_bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBtn setTitle:@"清除记录" forState:UIControlStateNormal];
    [_bottomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.bottomView addSubview:_bottomBtn];
}

- (void)buildUI {
    [super buildUI];
    
    self.navigationItem.title = @"历史记录";
}

- (void)assignDataArray:(NSArray<BaseListModelProtocol> *)data {
    if (data == nil || data.count < 1) {
        return;
    }
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:data];
    [super assignDataArray:(NSArray<BaseListModelProtocol> *)_dataArray];
}

/// MARK: - Private method

- (void)_bottomBtnClick {
    [_dataArray removeAllObjects];
    [self.tableView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteAllDatas:)]) {
        [self.delegate deleteAllDatas:self];
    }
}

- (void)_selectdHistoryData:(BaseListModel *)data {
    if (data == nil  || ![data isKindOfClass:[BaseListModel class]]) {
        return;
    }
    
    NSDictionary *temParam = nil;
    if ([data isKindOfClass:[TTVideoHistoryURLModel class]]) {
        TTVideoHistoryURLModel* temModel = (TTVideoHistoryURLModel *)data;
        temParam = @{SourceKeyURL:temModel.urlString?:@""};
    }
    if ([data isKindOfClass:[TTVideoHistoryVidModel class]]) {
        TTVideoHistoryVidModel *temModel = (TTVideoHistoryVidModel *)data;
        temParam = @{SourceKeyVid:temModel.vidString?:@"",SourceKeyAuth:temModel.authString?:@"",SourceKeyPtoken:temModel.ptokenString?:@""};
    }
    
    [self _sendToDelegate:temParam];
}

- (void)_sendToDelegate:(NSDictionary *)param {
    if (param == nil || param.count < 1) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(select:result:)]) {
        [self.delegate select:self result:param];
    }
}

/// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    BaseListModel *temModel = self.datas[indexPath.section];
    [self _selectdHistoryData:temModel];
    // back
    [self.navigationController popViewControllerAnimated:YES];
}


@end
