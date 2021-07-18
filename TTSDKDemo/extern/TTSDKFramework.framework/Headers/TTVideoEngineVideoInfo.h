//
//  TTVideoEngineVideoInfo.h
//  Pods
//
//  Created by guikunzhi on 2017/6/8.
//
//

#import <Foundation/Foundation.h>
#import "TTVideoEngineModelDef.h"
#import "TTVideoEnginePlayInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoEngineVideoInfo : NSObject<NSSecureCoding>

@property (nonatomic, nullable, strong) NSString *vid;
@property (nonatomic, assign) TTVideoEngineResolutionType resolution;
@property (nonatomic, assign) long long expire;
@property (nonatomic, nullable, strong) TTVideoEnginePlayInfo *playInfo;

- (BOOL)isExpired;

- (BOOL)hasPlayURL;

- (NSString *)codecType;

@end

NS_ASSUME_NONNULL_END
