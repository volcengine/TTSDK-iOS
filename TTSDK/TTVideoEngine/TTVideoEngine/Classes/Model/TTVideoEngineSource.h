//
//  TTVideoEngineSource.h
//  Pods
//
//  Created by guikunzhi on 2017/6/12.
//
//
#import "TTVideoEngineModelDef.h"

@class TTVideoEngineURLInfo;
@protocol TTVideoEngineSource <NSObject>

- (NSArray *)allURLWithDefinitionType:(TTVideoEngineResolutionType)type transformedURL:(BOOL)transformed;

- (TTVideoEngineURLInfo *)videoInfoForType:(TTVideoEngineResolutionType)type;

- (NSArray<NSNumber *> *)supportedResolutionTypes;

@end
