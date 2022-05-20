//
//  TTVideoLogModel.h
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/12.


#import "BaseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoLogModel : BaseListModel

@property (nonatomic, copy) NSString *dataString;
@property (nonatomic, copy) NSString *logInfo;

+ (instancetype)item:(NSString *)logInfo;

@end

NS_ASSUME_NONNULL_END
