//
//  IVCABRModule.h
//  test
//
//  Created by guikunzhi on 2020/3/29.
//  Copyright © 2020 gkz. All rights reserved.
//

#ifndef IVCABRModule_h
#define IVCABRModule_h

#import <Foundation/Foundation.h>
#import "IVCABRInitParams.h"
#import "IVCABRPlayStateSupplier.h"
#import "IVCABRStream.h"
#import "IVCABRInfoListener.h"
#import "IVCABRDeviceInfo.h"
#import "VCABRConfig.h"
#import "VCABRResult.h"

typedef NS_ENUM(NSInteger, ABRPredictAlgoType) {
    ABRPredictAlgoTypeBABB = 0,
    ABRPredictAlgoTypeBB = 1,
    ABRPredictAlgoTypeMPC = 2,
    ABRPredictAlgoTypeBW = 3,
    ABRPredictAlgoTypeCS = 4,
    ABRPredictAlgoTypeRL = 5,
    ABRPredictAlgoTypeBOLA = 6,
    ABRPredictAlgoTypeFESTIVE = 7,
    ABRPredictAlgoTypeMPC2 = 8,
};

@protocol IVCABRModule <NSObject>

- (void)configWithParams:( nullable id<IVCABRInitParams>)params supplier:(nullable id<IVCABRPlayStateSupplier>)playStateSupplier;
- (void)setMediaInfo:(nullable NSDictionary<NSString *, id<IVCABRVideoStream>> *)videoStreamDict withAudio:(nullable NSDictionary<NSString *, id<IVCABRAudioStream>> *)audioStreamDict;
- (void)setDeviceInfo:(nullable id<IVCABRDeviceInfo>)deviceInfo;
- (void)setInfoListener:(nullable id<IVCABRInfoListener>)infoListener;
- (nullable VCABRResult *)getStartupBitrate;
- (nullable VCABRResult *)getNextSegmentBitrate;
- (void)start;
- (void)stop;
- (void)setIntValue:(int)value forKey:(int)key;

@end

#endif /* IVCABRModule_h */
