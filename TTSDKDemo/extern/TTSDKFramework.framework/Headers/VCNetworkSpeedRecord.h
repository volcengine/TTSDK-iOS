//
//  VCABRSpeedRecord.h
//  abrmodule
//
//  Created by guikunzhi on 2020/3/29.
//  Copyright © 2020 gkz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IVCNetworkSpeedRecord.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCNetworkSpeedRecord : NSObject<IVCNetworkSpeedRecord>

@property (nonatomic, copy, nullable, getter=getStreamId) NSString *streamId;
@property (nonatomic, assign, getter=getTrackType) int trackType;
@property (nonatomic, assign, getter=getBytes) int64_t bytes;
@property (nonatomic, assign, getter=getTime) int64_t time;
@property (nonatomic, assign, getter=getTimestamp) int64_t timestamp;

@end

NS_ASSUME_NONNULL_END
