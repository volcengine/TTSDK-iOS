//
//  TTVideoHistoryVidModel.h
//  TTVideoEngineDemo
//
//  Created by 黄清 on 2018/12/24.
//  Copyright © 2018 bytedance. All rights reserved.
//

#import "BaseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoHistoryVidModel : BaseListModel
@property (nonatomic, copy) NSString *vidString;
@property (nonatomic, copy) NSString *authString;
@property (nonatomic, copy) NSString *ptokenString;
@end

NS_ASSUME_NONNULL_END
