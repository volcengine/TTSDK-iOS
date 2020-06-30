//
//  TTVideoEngineCache.h
//  Pods
//
//  Created by 钟少奋 on 2017/3/30.
//
//

#import <Foundation/Foundation.h>

@interface TTVideoEngineCache : NSObject

+ (instancetype)shareIPCache;

- (void)setIP:(NSString *)ip forHost:(NSString *)host;

- (NSArray<NSString *> *)IPsForHost:(NSString *)host;

- (void)synchronize;

@end
