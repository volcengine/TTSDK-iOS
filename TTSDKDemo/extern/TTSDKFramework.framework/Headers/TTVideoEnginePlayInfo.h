//
//  TTVideoEnginePlayInfo.h
//  Pods
//
//  Created by guikunzhi on 2017/6/12.
//
//

#import <Foundation/Foundation.h>
#import "TTVideoEngineInfoModel.h"
#import "TTVideoEngineSource.h"


NS_ASSUME_NONNULL_BEGIN

@interface TTVideoEnginePlayInfo : NSObject<TTVideoEngineSource,NSSecureCoding>

@property (nonatomic, nullable, strong) TTVideoEngineInfoModel *videoInfo;

- (instancetype)initWithDictionary:(NSDictionary *)jsonDict;

@end

NS_ASSUME_NONNULL_END
