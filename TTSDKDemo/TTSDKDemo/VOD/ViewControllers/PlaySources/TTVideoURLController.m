//
//  TTVideoURLController.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/13.


#import "TTVideoURLController.h"
#import "TTVideoHistoryURLModel.h"

@interface TTVideoURLController ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *qrImageView;
@property (nonatomic, strong) UITextField *urlTextFiled;
@property (nonatomic, strong) NSMutableArray<TTVideoHistoryURLModel *> *historyDatas;

@end

@implementation TTVideoURLController

- (instancetype)init {
    if (self = [super init]) {
        _historyDatas = [NSMutableArray array];
    }
    return self;
}

- (void)setUpUI {
    [super setUpUI];
    
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.qrImageView];
    [self.view addSubview:self.urlTextFiled];
}

- (void)buildUI {
    [super buildUI];
    
    [self _loadHistoryDatas];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _titleLab.left = TT_EDGE;
    _titleLab.top = TT_BASE_375(60.0);
    _qrImageView.centerY = _titleLab.centerY;
    
    _urlTextFiled.left = TT_EDGE;
    _urlTextFiled.top = _titleLab.bottom + TT_BASE_375(10.0);
}

- (void)willDismiss {
    NSString *url = _urlTextFiled.text;
    if (url == nil || url.stringByTrim.length == 0) {
        return;
    }
    TTVideoHistoryURLModel *urlModel = [TTVideoHistoryURLModel new];
    urlModel.urlString = url;
    if ([self.historyDatas containsObject:urlModel]) {
        [self.historyDatas removeObject:urlModel];
    }
    [self.historyDatas insertObject:urlModel atIndex:0];
    [self _saveHistoryDatas];
    
    NSDictionary *result = @{SourceKeyURL:url};
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
    
    NSString *temUrl = sources[SourceKeyURL];
    self.urlTextFiled.text = temUrl;
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
        Log(@"url history load fail.");
    } @finally {
    }
}

- (NSString *)_archivePath {
    static NSString *temPath = nil;
    if (temPath == nil) {
        temPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ttvideo.url.history.com.d"];
    }
    return temPath;
}

- (void)_saveHistoryDatas {
    @try {
        NSData *temData = [NSKeyedArchiver archivedDataWithRootObject:self.historyDatas];
        [temData writeToFile:[self _archivePath] atomically:YES];
    } @catch (NSException *exception) {
        Log(@"url history save fail.");
    } @finally {
        
    }
}

/// MARK: - Getter

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TT_BASE_375(100), TT_BASE_375(20))];
        _titleLab.text = @"URL";
        _titleLab.textColor = TT_COLOR_HEX(@"#FFFFFF");
        _titleLab.font = TT_FONT(17);
    }
    return _titleLab;
}

- (UIImageView *)qrImageView {
    if (_qrImageView == nil) {
        _qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TT_BASE_375(30), TT_BASE_375(30))];
        _qrImageView.image = [UIImage imageNamed:@""];
    }
    return _qrImageView;
}

- (UITextField *)urlTextFiled {
    if (_urlTextFiled == nil) {
        _urlTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.width - TT_BASE_375(30), TT_BASE_375(50))];
        _urlTextFiled.keyboardType = UIKeyboardTypeURL;
        _urlTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _urlTextFiled.placeholder = @"请输入资源地址...";
        _urlTextFiled.font = TT_FONT(16.0);
#ifdef DEBUG
        _urlTextFiled.text = @"http://139.199.21.159:8080/Maisie/bunny.mp4";
#endif
    }
    return _urlTextFiled;
}

@end
