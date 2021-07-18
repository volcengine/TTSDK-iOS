//
//  IVCABRSpeedRecord.h
//  test
//
//  Created by guikunzhi on 2020/3/29.
//  Copyright © 2020 gkz. All rights reserved.
//

#ifndef IVCABRModuleSpeedRecord_h
#define IVCABRModuleSpeedRecord_h

#import <Foundation/Foundation.h>

@protocol IVCABRModuleSpeedRecord <NSObject>

- (nullable NSString *)getStreamId;
- (int)getTrackType;
- (int64_t)getBytes;
- (int64_t)getTime;
- (int64_t)getTimestamp;

@end

#endif /* IVCABRSpeedRecord_h */
