//  Created by 黄清 on 2020/5/15.
//

#import "TTVideoEngine.h"
#if __has_include(<VCPreloadStrategy/IVCMediaLoadManager.h>)
#import <VCPreloadStrategy/IVCMediaLoadManager.h>
#else
#import "IVCMediaLoadManager.h"
#endif
#import "TTVideoEnginePreloadMedia.h"
#import "TTVideoEngineLoadProgress.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoEngine (MediaLoad)

/// Configer
@property (nonatomic, class, assign) VCPreloadProbeType probeType;
@property (nonatomic, class, assign) NSInteger probeIntervalMS; // millisecond
@property (nonatomic, class, assign) float playTaskProgress;

/// preload source.
+ (void)addOrderMedia:(NSArray<id<IVCMediaLoadMedia>> *)mediaArray;
+ (void)addMedia:(id<IVCMediaLoadMedia>)media;
+ (void)removeMedia:(NSArray<id<IVCMediaLoadMedia>> *)mediaArray;
+ (void)removeAllMedia;
+ (nullable NSArray<id<IVCMediaLoadMedia>> *)orderMediaArray;

@property (nonatomic, class, strong, null_unspecified) id<IVCMediaLoadStrategy> loadStrategy;

@end


@protocol TTVideoEnginePreloadSourceProvider <NSObject>

- (void)onNeedMedias:(NSArray<TTVideoEnginePreloadMedia *> *)originMediaArray
        playingCache:(nullable TTVideoEngineLoadProgress *)loadCache;

@end

@interface TTVideoEngine (MediaLoad_Imp)

+ (void)addPreloadUrlMedia:(TTVideoEnginePreloadURLMedia *)urlMedia;
+ (void)addPreloadModelMedia:(TTVideoEnginePreloadModelMedia *)modelMedia;
+ (void)removePreloadMedia:(TTVideoEnginePreloadMedia *)media;
+ (void)removeAllPreloadMedia;

@property (nonatomic, class, weak, null_resettable) id<TTVideoEnginePreloadSourceProvider> preloadSourceProvider;

+ (TTVideoEnginePreloadMedia *)_getMediaInfoWithMediaLoadMedia:(id<IVCMediaLoadMedia>)mlMedia;
+ (TTVideoEngineLoadProgress *)_ml_getLoadProgress:(NSString *)playSouerceId;

@end

NS_ASSUME_NONNULL_END
