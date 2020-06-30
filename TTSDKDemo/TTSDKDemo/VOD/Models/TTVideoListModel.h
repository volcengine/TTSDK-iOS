//
//  TTVideoListModel.h
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/12.


#import "BaseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoListModel : BaseListModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *vid;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *pToken;
@property (nonatomic, copy) NSString *playAuthToken;
@property (nonatomic, copy) NSString *playAuthTokenWithHost;

#if DEBUG
@property (nonatomic, strong) UIImage *img;
#endif

+ (NSArray<TTVideoListModel *> *)debugData;

@end

NS_ASSUME_NONNULL_END
