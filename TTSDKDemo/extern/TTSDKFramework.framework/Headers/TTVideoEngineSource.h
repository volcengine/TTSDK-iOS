//
//  TTVideoEngineSource.h
//  Pods
//
//  Created by guikunzhi on 2017/6/12.
//
//
#import "TTVideoEngineModelDef.h"


NS_ASSUME_NONNULL_BEGIN

@class TTVideoEngineURLInfo;

@protocol TTVideoEngineSource <NSObject>

- (nullable NSArray *)allURLWithDefinitionType:(TTVideoEngineResolutionType)type transformedURL:(BOOL)transformed;

- (nullable TTVideoEngineURLInfo *)videoInfoForType:(TTVideoEngineResolutionType)type;

- (nullable NSArray<NSNumber *> *)supportedResolutionTypes;
- (nullable NSArray<NSString *> *)supportedQualityInfos;

@end

NS_ASSUME_NONNULL_END
