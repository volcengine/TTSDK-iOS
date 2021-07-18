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

NS_ASSUME_NONNULL_BEGIN

@protocol TTVideoInfoFetcherDelegate <NSObject>

- (void)infoFetcherDidFinish:(NSInteger)status;

- (void)infoFetcherDidFinish:(nullable TTVideoEngineModel *)videoModel error:(nullable NSError *)error;

- (void)infoFetcherShouldRetry:(NSError *)error;

- (void)infoFetcherDidCancel;

- (void)infoFetcherFinishWithDNSError:(NSError *)error;

@end

@interface TTVideoEngineInfoFetcher : NSObject

@property (nonatomic, nullable, weak) id<TTVideoInfoFetcherDelegate> delegate;
@property (nonatomic, assign) NSInteger retryCount;
@property (nonatomic, assign, readonly) NSTimeInterval retryTimeInterval;
@property (nonatomic, nullable, copy) NSString *apiString;
@property (nonatomic, nullable, strong) NSDictionary *parameters;
@property (nonatomic, nullable, strong) id<TTVideoEngineNetClient> networkSession;
@property (nonatomic, nullable, strong, readonly) TTVideoEngineModel *videoModel;
@property (nonatomic, assign) BOOL cacheModelEnable;
@property (nonatomic, assign) NSInteger apiversion;
@property (nonatomic, nullable, copy) NSString *projectTag;
@property (nonatomic, assign) BOOL useEphemeralSession;

- (void)fetchInfoWithAPI:(NSString *)apiString
              parameters:(nullable NSDictionary *)params
                    auth:(nullable NSString *)auth;

- (void)fetchInfoWithAPI:(NSString *)apiString
              parameters:(nullable NSDictionary *)params
                    auth:(nullable NSString *)auth
                     vid:(nullable NSString* )vid;

- (void)fetchInfoWithAPI:(NSString *)apiString
              parameters:(nullable NSDictionary *)params
                    auth:(nullable NSString *)auth
                     vid:(nullable NSString *)vid
                     key:(nullable NSString *)key;

- (void)cancel;

@end

NS_ASSUME_NONNULL_END
