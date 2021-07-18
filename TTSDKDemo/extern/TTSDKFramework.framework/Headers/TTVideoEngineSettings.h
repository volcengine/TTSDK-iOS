//
//  TTVideoEngineSettings.h
//  TTVideoEngine
//
//  Created by 黄清 on 2021/5/26.
//

#import <Foundation/Foundation.h>

#if __has_include(<VCVodSettings/VodSettingsManager.h>)
#import <VCVodSettings/VodSettingsManager.h>
#else
#import "VodSettingsManager.h"
#endif

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TTVideoEngineServiceVendorType) {
    TTVideoEngineServiceVendorCN   = 0x010,
    TTVideoEngineServiceVendorSG,
    TTVideoEngineServiceVendorVA,
};


@protocol TTVideoEngineNetClient;
@interface TTVideoEngineSettings : NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)settings;

/// Whether to enable.
@property (nonatomic, assign) BOOL enable;
- (TTVideoEngineSettings *(^)(BOOL debug))setDebug;

/// Need to use ttnet.
@property (nonatomic, strong) id<TTVideoEngineNetClient> netClient;
- (TTVideoEngineSettings *(^)(id<TTVideoEngineNetClient> netClinet))setNetClient;

/// host info.
@property (nonatomic, copy) NSString *usEast;
- (TTVideoEngineSettings *(^)(NSString *hostString))setUSEast;
@property (nonatomic, copy) NSString *sgSingapore;
- (TTVideoEngineSettings *(^)(NSString *hostString))setSGSingapore;
@property (nonatomic, copy) NSString *cnNorth;
- (TTVideoEngineSettings *(^)(NSString *hostString))setCNNorth;

@end




/// Engine use.
@interface TTVideoEngineSettings ()

@property (nonatomic, assign) BOOL debug;
- (TTVideoEngineSettings *(^)(BOOL enable))setEnable;

- (TTVideoEngineSettings *(^)(void))config;

- (TTVideoEngineSettings *(^)(void))load;

+ (VodSettingsManager *)manager;

@end

NS_ASSUME_NONNULL_END
