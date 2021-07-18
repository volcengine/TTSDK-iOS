//
//  TTVideoEngineNetClient.h
//  TTVideoEngine
//
//  Created by guikunzhi on 2017/10/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTVideoEngineNetClient <NSObject>

@required
- (void)configTaskWithURL:(NSURL *)url completion:(void (^)(id _Nullable jsonObject, NSError * _Nullable error))completionHandler;

- (void)configTaskWithURL:(NSURL *)url params:(nullable NSDictionary *)params headers:(nullable NSDictionary *)headers completion:(void (^)(id _Nullable jsonObject, NSError * _Nullable error))completionHandler;

- (void)cancel;

- (void)resume;

- (void)invalidAndCancel;

@optional
- (void)configTaskWithURL:(NSURL *)url params:(nullable NSDictionary *)params completion:(void (^)(id _Nullable jsonObject, NSError * _Nullable error))completionHandler __attribute__((deprecated));

- (void)configPostTaskWithURL:(NSURL *)url params:(nullable NSDictionary *)paramsdata headers:(nullable NSDictionary *)headers completion:(void (^)(id _Nullable jsonObject, NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
