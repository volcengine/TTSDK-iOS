//
//  TTVideoEngineNetClient.h
//  TTVideoEngine
//
//  Created by guikunzhi on 2017/10/12.
//

#import <Foundation/Foundation.h>

@protocol TTVideoEngineNetClient <NSObject>

@required
- (void)configTaskWithURL:(NSURL *)url completion:(void (^)(id _Nullable jsonObject, NSError * _Nullable error))completionHandler;

- (void)configTaskWithURL:(NSURL *)url params:(NSDictionary *)params headers:(NSDictionary *)headers completion:(void (^)(id _Nullable jsonObject, NSError * _Nullable error))completionHandler;

- (void)cancel;

- (void)resume;

- (void)invalidAndCancel;

@optional
- (void)configTaskWithURL:(NSURL *)url params:(NSDictionary *)params completion:(void (^)(id _Nullable jsonObject, NSError * _Nullable error))completionHandler __attribute__((deprecated));

- (void)configPostTaskWithURL:(NSURL *)url params:(NSDictionary *)paramsdata headers:(NSDictionary *)headers completion:(void (^)(id _Nullable jsonObject, NSError * _Nullable error))completionHandler;

@end
