//
//  VodSettingsConfigEnv.h
//  VCVodSettings
//
//  Created by 黄清 on 2021/5/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,VodSettingsRegion) {
    VodSettingsRegionCN = 1,
    VodSettingsRegionSG = 2,
    VodSettingsRegionUS = 3,
    VodSettingsRegionDefault = VodSettingsRegionCN,
};

@interface VodSettingsConfigEnv : NSObject

@property (nonatomic, copy) NSString *usEast;
@property (nonatomic, copy) NSString *sgSingapore;
@property (nonatomic, copy) NSString *cnNorth;

@property (nonatomic, assign) VodSettingsRegion region;

@property (nonatomic, copy) NSDictionary *appInfo;
@property (nonatomic, copy) NSDictionary *sdkInfo;

@property (nonatomic, copy, readonly) NSString *host;
@property (nonatomic, copy) NSString *path;

- (NSString *)getHost:(VodSettingsRegion)region;

@end

NS_ASSUME_NONNULL_END
