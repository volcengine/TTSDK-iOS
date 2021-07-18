//
//  IABRBufferInfo.h
//  abrmodule
//
//  Created by guikunzhi on 2020/3/29.
//  Copyright © 2020 gkz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IVCABRBufferInfo <NSObject>

- (nullable NSString *)getStreamId;
- (float)getPlayerAvailDuration;
- (long long)getFileAvailSize;

@end

NS_ASSUME_NONNULL_END
