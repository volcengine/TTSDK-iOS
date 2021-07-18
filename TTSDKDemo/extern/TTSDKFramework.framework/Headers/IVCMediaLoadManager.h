//
//  IVCMediaLoadManager.h
//  TTVideoEngine
//
//  Created by 黄清 on 2020/5/25.
//

#import <Foundation/Foundation.h>
#import "IVCMediaLoadMedia.h"
#import "IVCMediaLoadStrategy.h"
#import "IVCMediaLoadStateSupplier.h"
#import "IVCMediaLoadMDL.h"

typedef NS_ENUM(NSInteger,VCPreloadProbeType) {
    VCPreloadProbeInterval          = 0,
    VCPreloadProbePlayTaskProgress  = 1,
};

typedef NS_ENUM(NSInteger,VCMediaLoadOption) {
    VCMediaLoadOptionLogLevel       = 0,
};

typedef NS_ENUM(NSInteger,VCMediaLoadLogLevel) {
    VCMediaLoadLogVerbose       = 0,
    VCMediaLoadLogDebug         = 1,
    VCMediaLoadLogInfo          = 2,
    VCMediaLoadLogWarn          = 3,
    VCMediaLoadLogError         = 4,
    VCMediaLoadLogFatal         = 5,
};

NS_ASSUME_NONNULL_BEGIN

@class VCMediaLoadTask;

@protocol IVCMediaLoadManager <NSObject>

- (instancetype)initWithMDL:(id<IVCMediaLoadMDL>)mdl;

/// Configer
@property (nonatomic, assign) VCPreloadProbeType probeType;
@property (nonatomic, assign) NSInteger intervalMS; // millisecond
@property (nonatomic, assign) float playTaskProgress;

/// preload source.
- (void)addOrderMedia:(NSArray<id<IVCMediaLoadMedia>> *)mediaArray;
- (void)addMedia:(id<IVCMediaLoadMedia>)media;
- (void)removeMedia:(NSArray<id<IVCMediaLoadMedia>> *)mediaArray;
- (void)removeAllMedia;
- (nullable NSArray<id<IVCMediaLoadMedia>> *)orderMediaArray;

@property (nonatomic, strong, nullable) id<IVCMediaLoadStrategy> loadStrategy;


- (void)start;
- (void)stop;


- (void)playerStall;

/// Play task.
- (void)addPlayTask:(VCMediaLoadTask *)playTask;
- (void)stopPlayTask:(VCMediaLoadTask *)playTask;


@property (nonatomic, strong, nullable) id<IVCMediaLoadStateSupplier> stateSupplier;


- (void)loadProgress:(NSString *)progressInfo taskType:(NSInteger)taskType;
- (void)loadFail:(NSString *)taskKey error:(NSError *)error;


- (void)setIntOption:(NSInteger)option value:(NSInteger)value;

@end

NS_ASSUME_NONNULL_END
