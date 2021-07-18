//
//  VCABRDeviceInfo.h
//  Pods
//
//  Created by wangchen.sh on 2020/5/25.
//

#import <Foundation/Foundation.h>
#import "IVCABRDeviceInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCABRDeviceInfo : NSObject<IVCABRDeviceInfo>

@property (nonatomic, assign, getter=getScreenWidth) int screenWidth;
@property (nonatomic, assign, getter=getScreenHeight) int screenHeight;
@property (nonatomic, assign, getter=getScreenFps) int screenFps;
@property (nonatomic, assign, getter=getHWDecodeMaxLength) int hwdecodeMaxLength;
@property (nonatomic, assign, getter=getHDRInfo) int hdrInfo;

@end

NS_ASSUME_NONNULL_END

