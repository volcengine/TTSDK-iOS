//
//  Header.h
//  Pods
//
//  Created by wyf on 2018/11/13.
//

#import <Foundation/Foundation.h>

@interface TimeCalibration : NSObject
@property (nonatomic, assign) long long serverTimeToCali;
@property (nonatomic, assign) long long localTimeToCali;
@property (nonatomic, assign) BOOL isCalibrated;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

- (long long)getServerTime;
- (NSString *)getServerTimeStr:(NSString *)pattern;
- (void)updateServerTime:(long long)STToCali localTime:(long long)LTToCali;
@end


@interface STSAuth : NSObject
@property (nonatomic, copy) NSString *authAK;
@property (nonatomic, copy) NSString *authSK;
@property (nonatomic, copy) NSString *authSessionToken;
@property (nonatomic, copy) NSString *authExpiredTime;
@property (nonatomic, assign) long long authExpiredTimeInLong;

@property (nonatomic, copy) NSString *curServerTime;
@property (nonatomic, assign) long long curServerTimeInLong;
@property (nonatomic, assign) long long curLocalTimeInLong;

- (instancetype)initWithSTS:(NSString *)ak sk:(NSString *)sk sessionToken:(NSString *)sessionToken expiredTime:(NSString *)expiredTime curTime:(NSString *)curTime;
- (long long)getServerTime;
- (NSString *)toString;
@end


@class AuthTimer;
@protocol AuthTimerProtocol <NSObject>

- (void)onAuthExpired:(AuthTimer *)authTimer projectTag:(NSString *)projectTag;

@end


@interface AuthTimer : NSObject

+ (instancetype)sharedInstance;
- (instancetype)init;
- (void)setTag:(NSString *)projectTag;
- (STSAuth *)getAuth:(NSString *)projectTag;
- (void)postUpdate:(NSString *)projectTag timeToUpdate:(long long)timeToUpdate;
- (void)notifyUpdate:(NSTimer *)inTimer;
- (void)setAuth:(STSAuth *)stsAuth projectTag:(NSString *)tag stopUpdate:(BOOL)stopUpdate;
- (void)setAuthTimerListener:(id <AuthTimerProtocol>)delegate;
- (void)cancel;
+ (long long)getMilliSeconds:(NSString *)timeStr Pattern:(NSString *)pattern;

@end






