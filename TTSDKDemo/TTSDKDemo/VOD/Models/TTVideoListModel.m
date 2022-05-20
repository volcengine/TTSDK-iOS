//
//  TTVideoListModel.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/12.


#import "TTVideoListModel.h"

@implementation TTVideoListModel

- (CGFloat)cellHeight {
    return TT_BASE_375(130);
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"duration":@"Duration",
             @"pToken":@"PToken",
             @"playAuthToken":@"PlayAuthToken",
             @"title":@"Title",
             @"vid":@"Vid",
             @"playAuthTokenWithHost":@"PlayAuthTokenWithHost"
             };
}

- (void)mj_keyValuesDidFinishConvertingToObject {
#if DEBUG
    static NSInteger i = 1;
    i++;
    NSString *imgName = [NSString stringWithFormat:@"img_%03zd",(i % 5)];
    self.img = [UIImage imageNamed:imgName];
    self.imageUrl = @"debug";
#endif
}

+ (NSArray<TTVideoListModel *> *)debugData {
    NSMutableArray *tem = [NSMutableArray array];
    NSArray *vids = @[@"aa29c33b79aa48a6a20b677feb79725b", @"f6fe80b2cfee4ba38b7c5c3429899142",@"42b4919e7b3d433c8dadc529b8f849b5", @"570cad87fc0046b78c980d57179516f9", @"841d629c99774dd29c1b2354906b5a83", @"edc4f5fb784c4eb69b2ae2b07c728929", @"0775a86479eb4afdaa9bef1c53211db8", @"b399958f5d4b4f0a938f673c226299b0"];
    for (NSInteger i = 0; i < vids.count; i++) {
        TTVideoListModel *item = [TTVideoListModel new];
        item.title = [NSString stringWithFormat:@"这个视频的 vid 是:%@",vids[i]];
        item.vid = vids[i];
#if DEBUG
        NSString *imgName = [NSString stringWithFormat:@"img_%03zd",(i % 5) + 1];
        item.img = [UIImage imageNamed:imgName];
        item.imageUrl = @"debug";
#endif
        item.duration = @"00:00";
        [tem addObject:item];
    }
    return tem;
}

@end
