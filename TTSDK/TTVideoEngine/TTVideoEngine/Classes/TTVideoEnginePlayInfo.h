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

@interface TTVideoEnginePlayInfo : NSObject<TTVideoEngineSource>

@property (nonatomic, strong) TTVideoEngineInfoModel *videoInfo;

- (instancetype)initWithDictionary:(NSDictionary *)jsonDict;

@end
