//
//  TTVideoEngineInfoFetcher.h
//  Pods
//
//  Created by guikunzhi on 16/12/2.
//
//

#import <Foundation/Foundation.h>
#import "TTVideoEngineNetClient.h"
#import "TTVideoEngineUtil.h"
#import "TTVideoEngineInfoModel.h"
#import "TTVideoEngineModel.h"

@protocol TTVideoInfoFetcherDelegate <NSObject>

- (void)infoFetcherDidFinish:(NSInteger)status;

- (void)infoFetcherDidFinish:(TTVideoEngineModel *)videoModel error:(NSError *)error;

- (void)infoFetcherShouldRetry:(NSError *)error;

- (void)infoFetcherDidCancel;

- (void)infoFetcherFinishWithDNSError:(NSError *)error;

@end

@interface TTVideoEngineInfoFetcher : NSObject

@property (nonatomic, weak) id<TTVideoInfoFetcherDelegate> delegate;
@property (nonatomic, assign) NSInteger retryCount;
@property (nonatomic, assign, readonly) NSTimeInterval retryTimeInterval;
@property (nonatomic, copy) NSString *apiString;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, strong) id<TTVideoEngineNetClient> networkSession;
@property (nonatomic, strong, readonly) TTVideoEngineModel *videoModel;
@property (nonatomic, assign) BOOL cacheModelEnable;
@property (nonatomic, assign) NSInteger apiversion;

- (void)fetchInfoWithAPI:(NSString *)apiString parameters:(NSDictionary *)params auth:(NSString *)auth;

/// vid for cache model
- (void)fetchInfoWithAPI:(NSString *)apiString
              parameters:(NSDictionary *)params
                    auth:(NSString *)auth
                     vid:(NSString* )vid;

- (void)cancel;

@end
