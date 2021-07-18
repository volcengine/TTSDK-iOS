//
//  VCVodSettingsFetcher.h
//  VCVodSettings
//
//  Created by 黄清 on 2021/5/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


FOUNDATION_EXTERN NSString *const VodSettingsFetcherErrorDomain;

typedef NS_ENUM(NSInteger, VodSettingsErrorCode) {
    VodSettingsErrorCodeOverRetryTimes = -999,
    VodSettingsErrorCodeInvalidHost = -998,
    VodSettingsErrorCodeInvalidJson = -997,
    VodSettingsErrorCodeInvalidNetImp = -996,
};

@class VodSettingsFetcher;
@protocol VodSettingsFetcherListener <NSObject>

@optional
- (void)vodSettingsFetcher:(VodSettingsFetcher *)fetcher
            resultWithData:(nullable NSDictionary *)data
                   orError:(nullable NSError *)error;

@end

@class VodSettingsConfigEnv;
@protocol VodSettingsNetProtocol;
@interface VodSettingsFetcher : NSObject

@property (nonatomic, assign) BOOL debug;
@property (nonatomic, assign) NSInteger maxRetryTimes;
@property (nonatomic, assign) NSInteger fetchInterval;
@property (nonatomic, strong) id<VodSettingsNetProtocol> netImp;
@property (nonatomic, assign) int64_t version;
@property (nonatomic,   weak) id<VodSettingsFetcherListener> delegate;
@property (nonatomic, strong, readonly) VodSettingsConfigEnv *env;

- (void)fetchIfNeed:(NSString *)module;
- (void)fetch:(NSString *)module
    configKey:(nullable NSString *)key
        force:(BOOL)isForce;


@end

@interface NSTimer(VodSettigs)

+ (NSTimer *)vodSettings_scheduledNoRetainTimerWithTimeInterval:(NSTimeInterval)ti
                                                         target:(id)aTarget
                                                       selector:(SEL)aSelector
                                                       userInfo:(id)userInfo
                                                        repeats:(BOOL)yesOrNo;

@end

NS_ASSUME_NONNULL_END
