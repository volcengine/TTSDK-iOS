//
//  TTVideoDownloadModel.h
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/12.


#import "BaseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoDownloadModel : BaseListModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *vid;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, assign) NSInteger downloadStatus;

@end

NS_ASSUME_NONNULL_END
