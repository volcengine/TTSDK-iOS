//
//  VodSettingsFetcherUtils.h
//  VCVodSettings
//
//  Created by 黄清 on 2021/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VodSettingsFetcherUtils : NSObject

+ (NSString*)devicePlatform;

+ (float)osVersionNumber;

+ (NSString *)platform;

+ (BOOL)validString:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
