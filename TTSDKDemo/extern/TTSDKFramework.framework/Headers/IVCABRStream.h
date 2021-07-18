//
//  IABRStream.h
//  abrmodule
//
//  Created by guikunzhi on 2020/3/29.
//  Copyright © 2020 gkz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IVCABRStream <NSObject>

- (nullable NSString *)getStreamId;
- (nullable NSString *)getCodec;
- (int)getSegmentDuration;
- (int)getBandwidth;

@end

@protocol IVCABRVideoStream <NSObject, IVCABRStream>

- (int)getWidth;
- (int)getHeight;
- (float)getFrameRate;

@end

@protocol IVCABRAudioStream <NSObject, IVCABRStream>

- (int)getSampleRate;

@end

NS_ASSUME_NONNULL_END
