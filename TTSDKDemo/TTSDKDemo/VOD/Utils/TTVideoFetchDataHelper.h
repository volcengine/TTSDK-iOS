//
//  TTVideoFetchDataHelper.h
//  TTVideoEngineDemo
//
//  Created by 黄清 on 2019/2/21.
//  Copyright © 2019 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@class TTVideoListModel;
typedef void(^FetchTestDataResult)(NSArray<TTVideoListModel *> *_Nullable listData, NSError *_Nullable error);

@interface TTVideoFetchDataHelper : NSObject

+ (instancetype)helper;

- (void)startFetchTestListData;

- (void)getTestListData:(FetchTestDataResult) result;

@end

NS_ASSUME_NONNULL_END
