//
//  TTVideoFetchDataHelper.m
//  TTVideoEngineDemo
//
//  Created by 黄清 on 2019/2/21.
//  Copyright © 2019 bytedance. All rights reserved.
//

#import "TTVideoFetchDataHelper.h"
#import <AFHTTPSessionManager.h>
#import "TTVideoListModel.h"

static NSString *const s_kTestDataApiString = @"http://vod-sdk-playground.snssdk.com/api/v1/get_list_vids";
// ErrorDomain
static NSString *const _TTVideoErrorDomainTestListData = @"_TTVideoErrorDomainTestListData.implement";
// ErrorCode
static const NSInteger _TTVideoErorCodeTestListDataResultFormat = -999;
static const NSInteger _TTVideoErorCodeTestListDataResultEmpty  = -998;

@interface TTVideoFetchDataHelper ()
@property (nonatomic, copy) NSArray *testListData;
@property (nonatomic, strong) NSError *testListDataError;
@end

@implementation TTVideoFetchDataHelper

+ (instancetype)helper {
    static dispatch_once_t onceToken;
    static TTVideoFetchDataHelper *s_helper = nil;
    dispatch_once(&onceToken, ^{
        s_helper = [[TTVideoFetchDataHelper alloc] init];
    });
    return s_helper;
}

- (void)_startFetchTestListData:(FetchTestDataResult)result {
    [[AFHTTPSessionManager manager] GET:s_kTestDataApiString
                             parameters:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Log(@"testtesk = %@, responseObject = %@",task,responseObject);
        //
        NSError *error = nil;
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *info = @{@"reslutFormat":@"responseObject is not NSDictionary",
                                   @"responseObject":responseObject?:@""
                                   };
            error = [NSError errorWithDomain:_TTVideoErrorDomainTestListData code:_TTVideoErorCodeTestListDataResultFormat userInfo:info];
            self.testListDataError = error;
            !result ?: result(nil,error);
            return;
        }
        //
        NSDictionary *temResult = responseObject[@"Result"];
        NSArray* resultDataList = temResult[@"lists"];
        if (![resultDataList isKindOfClass:[NSArray class]]) {
            NSDictionary *info = @{@"reslutFormat":@"responseObject[@\"lists\"] is not NSArray",
                                   @"responseObject":responseObject?:@""
                                   };
            error = [NSError errorWithDomain:_TTVideoErrorDomainTestListData code:_TTVideoErorCodeTestListDataResultFormat userInfo:info];
            self.testListDataError = error;
            !result ?: result(nil,error);
            return;
        }
        //
        if (resultDataList.count < 1) {
            Log(@"Test list data is empty.");
            NSDictionary *info = @{@"resultNumber":@"responseObject[@\"lists\"] is null",
                                   @"responseObject":responseObject?:@""
                                   };
            error = [NSError errorWithDomain:_TTVideoErrorDomainTestListData code:_TTVideoErorCodeTestListDataResultEmpty userInfo:info];
            self.testListDataError = error;
            !result ?: result(nil,error);
            return;
        }
        NSArray *listDatas = [TTVideoListModel mj_objectArrayWithKeyValuesArray:resultDataList];
        self.testListData = listDatas.copy;
        !result ?: result(self.testListData, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        Log(@"test error tesk = %@, error = %@",task,error);
        //
        self.testListDataError = error;
        !result ?: result(nil,error);
    }];
}

- (void)startFetchTestListData {
    [self _startFetchTestListData:nil];
}

- (void)getTestListData:(FetchTestDataResult)result {
    if (self.testListDataError || self.testListData) {
        !result ?: result(self.testListData, self.testListDataError);
    } else {
        [self _startFetchTestListData:result];
    }
}



@end
