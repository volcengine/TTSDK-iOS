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

@interface TTVideoEngineVideoInfo : NSObject

@property (nonatomic, strong) NSString *vid;
@property (nonatomic, assign) TTVideoEngineResolutionType resolution;
@property (nonatomic, assign) long long expire;
@property (nonatomic, strong) TTVideoEnginePlayInfo *playInfo;

- (BOOL)isExpired;

- (BOOL)hasPlayURL;

- (NSString *)codecType;

@end
