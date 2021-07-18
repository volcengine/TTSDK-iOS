//
//  TTVideoEnginePlayItem.h
//  Pods
//
//  Created by guikunzhi on 2017/5/23.
//
//

#import <Foundation/Foundation.h>
#import "TTVideoEngineModelDef.h"


NS_ASSUME_NONNULL_BEGIN

@interface TTVideoEnginePlayItem : NSObject<NSCoding>

@property (nonatomic, nullable, copy) NSString *playURL;
@property (nonatomic, nullable, copy) NSString *vid;
@property (nonatomic, assign) TTVideoEngineResolutionType resolution;
@property (nonatomic, assign) long long expire;

- (BOOL)isExpired;

@end

NS_ASSUME_NONNULL_END
