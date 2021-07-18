//
//  IVCNetworkSpeedRecord.h
//  test
//
//  Created by guikunzhi on 2020/3/29.
//  Copyright © 2020 gkz. All rights reserved.
//

#ifndef IVCNetworkSpeedRecord_h
#define IVCNetworkSpeedRecord_h

#import <Foundation/Foundation.h>

@protocol IVCNetworkSpeedRecord <NSObject>

- (nullable NSString *)getStreamId;
- (int)getTrackType;
- (int64_t)getBytes;
- (int64_t)getTime;
- (int64_t)getTimestamp;

@end

#endif /* IVCNetworkSpeedRecord_h */
