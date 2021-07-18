//
//  Header.h
//  Pods
//
//  Created by wyf on 2018/11/13.
//

#import <Foundation/Foundation.h>

@interface TTVideoEngineTimeCalibration : NSObject
@property (nonatomic, assign) long long serverTimeToCali;
@property (nonatomic, assign) long long localTimeToCali;
@property (nonatomic, assign) BOOL isCalibrated;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

- (long long)getServerTime;
- (NSString *)getServerTimeStr:(NSString *)pattern;
- (void)updateServerTime:(long long)STToCali localTime:(long long)LTToCali;
@end


@interface TTVideoEngineSTSAuth : NSObject
@property (nonatomic, copy, nullable) NSString *authAK;
@property (nonatomic, copy, nullable) NSString *authSK;
@property (nonatomic, copy, nullable) NSString *authSessionToken;
@property (nonatomic, copy, nullable) NSString *authExpiredTime;
@property (nonatomic, assign) long long authExpiredTimeInLong;

@property (nonatomic, copy, nullable) NSString *curServerTime;
@property (nonatomic, assign) long long curServerTimeInLong;
@property (nonatomic, assign) long long curLocalTimeInLong;

- (instancetype)initWithSTS:(NSString *)ak sk:(NSString *)sk sessionToken:(NSString *)sessionToken expiredTime:(NSString *)expiredTime curTime:(NSString *)curTime;
- (long long)getServerTime;
- (NSString *)toString;
@end


@class TTVideoEngineAuthTimer;
@protocol TTVideoEngineAuthTimerProtocol <NSObject>

- (void)onAuthExpired:(TTVideoEngineAuthTimer *)authTimer projectTag:(NSString *)projectTag;

@end


@interface TTVideoEngineAuthTimer : NSObject

+ (instancetype)sharedInstance;
- (instancetype)init;
- (void)setTag:(NSString *)projectTag;
- (TTVideoEngineSTSAuth *)getAuth:(NSString *)projectTag;
- (void)postUpdate:(NSString *)projectTag timeToUpdate:(long long)timeToUpdate;
- (void)notifyUpdate:(NSTimer *)inTimer;
- (void)setAuth:(TTVideoEngineSTSAuth *)stsAuth projectTag:(NSString *)tag stopUpdate:(BOOL)stopUpdate;
- (void)setAuthTimerListener:(id <TTVideoEngineAuthTimerProtocol>)delegate;
- (void)cancel;
+ (long long)getSeconds:(NSString *)timeStr Pattern:(NSString *)pattern;

@end






