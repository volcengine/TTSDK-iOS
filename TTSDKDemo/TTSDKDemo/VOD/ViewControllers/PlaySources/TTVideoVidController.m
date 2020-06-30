//
//  TTVideoVidController.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/13.


#import "TTVideoVidController.h"
#import "TTVideoHistoryVidModel.h"

@interface TTVideoVidController ()
@property (nonatomic, strong) UILabel *vidLab;
@property (nonatomic, strong) UITextField *vidTextFiled;
@property (nonatomic, strong) UILabel *authLab;
@property (nonatomic, strong) UITextField *authTextFiled;
@property (nonatomic, strong) UILabel *ptokenLab;
@property (nonatomic, strong) UITextField *ptokenTextFiled;
@property (nonatomic, strong) NSMutableArray<TTVideoHistoryVidModel *> *historyDatas;
@end

@implementation TTVideoVidController

- (instancetype)init {
    if (self = [super init]) {
        _historyDatas = [NSMutableArray array];
    }
    return self;
}

- (void)setUpUI {
    [super setUpUI];
    
    [self.view addSubview:self.vidLab];
    [self.view addSubview:self.vidTextFiled];
    [self.view addSubview:self.authLab];
    [self.view addSubview:self.authTextFiled];
    //[self.view addSubview:self.ptokenLab];
    //[self.view addSubview:self.ptokenTextFiled];
}

- (void)buildUI {
    [super buildUI];
    
    [self _loadHistoryDatas];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _vidLab.left = TT_EDGE;
    _vidLab.top = TT_BASE_375(60.0);
    _vidTextFiled.left = _vidLab.left;
    _vidTextFiled.top = _vidLab.bottom + TT_BASE_375(10.0);
    
    _authLab.left = _vidLab.left;
    _authLab.top = _vidTextFiled.bottom + TT_BASE_375(10.0);
    _authTextFiled.left = _vidLab.left;
    _authTextFiled.top = _authLab.bottom + TT_BASE_375(10.0);
    
    _ptokenLab.left = _vidLab.left;
    _ptokenLab.top = _authTextFiled.bottom + TT_BASE_375(10.0);
    _ptokenTextFiled.left = _vidLab.left;
    _ptokenTextFiled.top = _ptokenLab.bottom + TT_BASE_375(10.0);
}

- (void)willDismiss {
    NSString *vid = _vidTextFiled.text;
    if (vid == nil || vid.stringByTrim.length == 0) {
        return;
    }
    NSString *auth = self.authTextFiled.text;
    NSString *ptoken = self.ptokenLab.text;
    
    TTVideoHistoryVidModel *vidModel = [TTVideoHistoryVidModel new];
    vidModel.vidString = vid;
    vidModel.authString = auth;
    vidModel.ptokenString = ptoken;
    if ([self.historyDatas containsObject:vidModel]) {
        [self.historyDatas removeObject:vidModel];
    }
    [self.historyDatas insertObject:vidModel atIndex:0];
    [self _saveHistoryDatas];
    
    NSDictionary *result = @{SourceKeyVid:vid,SourceKeyAuth:auth?:@"",SourceKeyPtoken:ptoken?:@""};
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismiss:result:)]) {
        [self.delegate dismiss:self result:result];
    }
}

- (NSArray *)historyInfos {
    return self.historyDatas;
}

- (void)deleteHistoryInfos {
    [self.historyDatas removeAllObjects];
}

- (void)setSources:(NSDictionary<SourceKey,SourceValue> *)sources {
    if (sources == nil || sources.count < 1) {
        return;
    }
    
    NSString *temVid = sources[SourceKeyVid];
    NSString *temAuth = sources[SourceKeyAuth];
    NSString *temPtoken = sources[SourceKeyPtoken];
    self.vidTextFiled.text = temVid;
    self.authTextFiled.text = temAuth;
    self.ptokenTextFiled.text = temPtoken;
}

/// MARK: - Private method

- (void)_loadHistoryDatas {
    @try {
        NSData *temData = [NSData dataWithContentsOfFile:[self _archivePath]];
        if (temData == nil) {
            return;
        }
        NSArray *temArray = [NSKeyedUnarchiver unarchiveObjectWithData:temData];
        if (temArray == nil || ![temArray isKindOfClass:[NSArray class]] || temArray.count < 1) {
            return;
        }
        
        [self.historyDatas addObjectsFromArray:temArray];
    } @catch (NSException *exception) {
         Log(@"vid history load fail.");
    } @finally {
    }
}

- (NSString *)_archivePath {
    static NSString *temPath = nil;
    if (temPath == nil) {
       temPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ttvideo.vid.history.com.d"];
    }
    return temPath;
}

- (void)_saveHistoryDatas {
    @try {
        NSData *temData = [NSKeyedArchiver archivedDataWithRootObject:self.historyDatas];
        [temData writeToFile:[self _archivePath] atomically:YES];
    } @catch (NSException *exception) {
        Log(@"vid history save fail.");
    } @finally {
        
    }
}

/// MARK: - Getter

- (UILabel *)vidLab {
    if (_vidLab == nil) {
        _vidLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TT_BASE_375(100), TT_BASE_375(20))];
        _vidLab.text = @"Vid";
        _vidLab.textColor = TT_COLOR_HEX(@"#FFFFFF");
        _vidLab.font = TT_FONT(17);
    }
    return _vidLab;
}

- (UITextField *)vidTextFiled {
    if (_vidTextFiled == nil) {
        _vidTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.width - TT_BASE_375(30), TT_BASE_375(50))];
        _vidTextFiled.keyboardType = UIKeyboardTypeURL;
        _vidTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _vidTextFiled.placeholder = @"请输入Vid...";
        _vidTextFiled.font = TT_FONT(16.0);
#ifdef DEBUG
        _vidTextFiled.text = @"v02004320000bdttehrpqv6be0vr6gfg";
#endif
    }
    return _vidTextFiled;
}

- (UILabel *)authLab {
    if (_authLab == nil) {
        _authLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TT_BASE_375(100), TT_BASE_375(20))];
        _authLab.text = @"Auth";
        _authLab.textColor = TT_COLOR_HEX(@"#FFFFFF");
        _authLab.font = TT_FONT(17);
    }
    return _authLab;
}

- (UITextField *)authTextFiled {
    if (_authTextFiled == nil) {
        _authTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.width - TT_BASE_375(30), TT_BASE_375(50))];
        _authTextFiled.keyboardType = UIKeyboardTypeDefault;
        _authTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _authTextFiled.placeholder = @"请输入Auth...";
        _authTextFiled.font = TT_FONT(16.0);
#ifdef DEBUG
        _authTextFiled.text = @"HMAC-SHA1:1.0:1530694379100284:3413ace7e2a9a235a9d5807ad78d9bac:t4UbSxEQEvKRcZHwhl2FAPIhBCY=";
#endif
    }
    return _authTextFiled;
}

- (UILabel *)ptokenLab {
    if (_ptokenLab == nil) {
        _ptokenLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TT_BASE_375(100), TT_BASE_375(20))];
        _ptokenLab.text = @"Ptoken";
        _ptokenLab.textColor = TT_COLOR_HEX(@"#FFFFFF");
        _ptokenLab.font = TT_FONT(17);
    }
    return _ptokenLab;
}

- (UITextField *)ptokenTextFiled {
    if (_ptokenTextFiled == nil) {
        _ptokenTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.width - TT_BASE_375(30), TT_BASE_375(50))];
        _ptokenTextFiled.keyboardType = UIKeyboardTypeDefault;
        _ptokenTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _ptokenTextFiled.placeholder = @"请输入Ptoken...";
        _ptokenTextFiled.font = TT_FONT(16.0);
    }
    return _ptokenTextFiled;
}

@end
