//
//  TTVideoPreloaderHelper.h
//  TTVideoEngineDemo
//
//  Created by 黄清 on 2019/7/1.
//  Copyright © 2019 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoPreloaderHelper : NSObject

+ (void)preloadItems:(NSArray<NSDictionary *> *)items;

+ (void)cancelPreloadItem:(NSDictionary *)item;

+ (void)cancelAllPreloadItems;

@end

NS_ASSUME_NONNULL_END
