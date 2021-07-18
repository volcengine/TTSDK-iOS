//
//  TTVideoEnginePreloader.h
//  TTVideoEngine
//
//  Created by 黄清 on 2020/4/20.
//

#import <Foundation/Foundation.h>
#import "TTVideoEngine+Preload.h"


NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const TTVideoEnginePreloadSuggestBytesSize;
FOUNDATION_EXPORT NSString * const TTVideoEnginePreloadSuggestCount;

FOUNDATION_EXPORT NSString * const  TTVideoEnginePreloadCancelConfigBuffer;
FOUNDATION_EXPORT NSString * const  TTVideoEnginePreloadCancelCurrentBuffer;

FOUNDATION_EXPORT NSString * const TTVideoEnginePreloadCancelReason;
FOUNDATION_EXPORT NSString * const TTVideoEnginePreloadNewPlayCancel;
FOUNDATION_EXPORT NSString * const TTVideoEnginePreloadLowBufferCancel;
FOUNDATION_EXPORT NSString * const TTVideoEnginePreloadStalledCancel;

@interface TTVideoEnginePreloader : NSObject

+ (void)engine:(TTVideoEngine *)engine playInfo:(NSDictionary<NSString *,id> *)info;

+ (BOOL)shouldPreload:(nullable TTVideoEngine *)engine;

+ (void)engine:(nullable TTVideoEngine *)engine prelaod:(NSDictionary<NSString *,id> *)suggestSetting;
+ (void)engine:(nullable TTVideoEngine *)engine cancelAllPrelaod:(NSDictionary<NSString *,id> *)info;

/// register a subClass of TTVideoEnginePreloader.
+ (BOOL)registerClass:(Class)preloaderClass;

///unregister class.
+ (void)unregisterClass:(Class)preloaderClass;

@end

NS_ASSUME_NONNULL_END
