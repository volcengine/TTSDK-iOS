//
//  IVCABRDeviceInfo.h
//  Pods
//
//  Created by wangchen.sh on 2020/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IVCABRDeviceInfo <NSObject>

- (int)getScreenWidth;
- (int)getScreenHeight;
- (int)getScreenFps;
- (int)getHWDecodeMaxLength;
- (int)getHDRInfo;

@end

NS_ASSUME_NONNULL_END
