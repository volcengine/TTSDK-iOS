//
//  TTVideoEnginePlayItem.h
//  Pods
//
//  Created by guikunzhi on 2017/5/23.
//
//

#import <Foundation/Foundation.h>
#import "TTVideoEngineModelDef.h"

@interface TTVideoEnginePlayItem : NSObject

@property (nonatomic, copy) NSString *playURL;
@property (nonatomic, copy) NSString *vid;
@property (nonatomic, assign) TTVideoEngineResolutionType resolution;
@property (nonatomic, assign) long long expire;

- (BOOL)isExpired;

@end
