//
//  ABRVideoStream.h
//  abrmodule
//
//  Created by guikunzhi on 2020/3/29.
//  Copyright © 2020 gkz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IVCABRStream.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCABRVideoStream : NSObject<IVCABRVideoStream>

@property (nonatomic, copy, nullable, getter=getStreamId) NSString *streamId;
@property (nonatomic, copy, nullable, getter=getCodec) NSString *codec;
@property (nonatomic, assign, getter=getSegmentDuration) int segmentDuration;
@property (nonatomic, assign, getter=getWidth) int width;
@property (nonatomic, assign, getter=getHeight) int height;
@property (nonatomic, assign, getter=getFrameRate) int frameRate;
@property (nonatomic, assign, getter=getBandwidth) int bandwidth;

@end

NS_ASSUME_NONNULL_END
