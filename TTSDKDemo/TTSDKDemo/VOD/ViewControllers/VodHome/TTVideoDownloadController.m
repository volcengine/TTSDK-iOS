//
//  TTVideoDownloadController.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/12.


#import "TTVideoDownloadController.h"
#import "BaseListModelProtocol.h"
#import "TTVideoDownloadModel.h"

@interface TTVideoDownloadController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation TTVideoDownloadController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _fetchData];
}

- (void)_fetchData {
#ifdef DEBUG
    _dataArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 30; i++) {
        TTVideoDownloadModel* item1 = [TTVideoDownloadModel new];
        item1.title = [NSString stringWithFormat: @"this title %zd",i + 1];
        item1.vid = [NSString stringWithFormat: @"this vid %zd",i + 1];
        item1.duration = [NSString stringWithFormat: @"00:12: %02zd",i + 1];
        item1.imageUrl = [NSString stringWithFormat: @"this imgUrl %zd",i + 1];
        [_dataArray addObject:item1];
    }
    
    [self assignDataArray:(NSArray<BaseListModelProtocol>*)_dataArray];
#endif
}

@end
