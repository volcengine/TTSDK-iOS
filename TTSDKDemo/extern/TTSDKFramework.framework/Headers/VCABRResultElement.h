//
//  ABRResultElement.h
//  abrmodule
//
//  Created by guikunzhi on 2020/3/29.
//  Copyright © 2020 gkz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCABRResultElement : NSObject

@property (nonatomic, assign) int64_t bitrate;
@property (nonatomic, assign) int seconds;
@property (nonatomic, assign) int mediaType;
@property (nonatomic, assign) int cacheTime;

@end

NS_ASSUME_NONNULL_END
