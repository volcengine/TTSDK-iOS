//
//  TTVideoLogController.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/12.


#import "TTVideoLogController.h"
#import "BaseListModelProtocol.h"
#import "TTVideoLogModel.h"
@interface TTVideoLogController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *bottomBtn;
@end

@implementation TTVideoLogController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_engineEvent:) name:kTTVideoEngineEventNotification object:nil];
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)setUpUI {
    [super setUpUI];
    
    _bottomBtn = [[UIButton alloc] initWithFrame:self.bottomView.frame];
    _bottomBtn.origin = CGPointZero;
    [_bottomBtn addTarget:self action:@selector(_bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBtn setTitle:@"清除 logs" forState:UIControlStateNormal];
    [_bottomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _bottomBtn.titleLabel.font = TT_FONT(16);
    [self.bottomView addSubview:_bottomBtn];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _bottomBtn.frame = self.bottomView.bounds;
}

/// MARK: - Private method

- (void)_engineEvent:(NSNotification *)notify {
    NSString* logInfo = (NSString*)notify.object;
    
    if (!tt_valid_string(logInfo)) {
        return;
    }
    
    [self _addLog:[TTVideoLogModel item:logInfo]];
}

- (void)_addLog:(TTVideoLogModel *)log {
    [self.dataArray addObject:log];
    
    [self assignDataArray:(NSArray<BaseListModelProtocol>*)self.dataArray];
}

- (void)_bottomBtnClick {
    [_dataArray removeAllObjects];
    [self.tableView reloadData];
}

@end
