//
//  BDAnimatedImagePlayer.h
//  BDWebImage
//
//

#import <Foundation/Foundation.h>
#import "BDImage.h"

typedef enum : NSUInteger {
    BDAnimatedImageAnimationTypeOrder,
    BDAnimatedImageAnimationTypeReciprocating,
} BDAnimatedImageAnimationType;

@class BDAnimatedImagePlayer;
@protocol BDAnimatedImagePlayerDelegate <NSObject>
- (void)imagePlayer:(BDAnimatedImagePlayer *)Player didUpdateImage:(UIImage *)image index:(NSUInteger)index;

@optional
- (void)imagePlayerStartPlay:(BDAnimatedImagePlayer *)player;
/**
 播放完最后一帧后回调
 */
- (void)imagePlayerDidReachEnd:(BDAnimatedImagePlayer *)player;
- (void)imagePlayerDidStopPlay:(BDAnimatedImagePlayer *)player;
@end

/**
 player不会预先批量取帧缓存，仅保证提前取下一帧的缓存，如果循环次数大于一且当前条件能保证缓存全部帧，则不释放已播放帧，否则每播放一帧释放当前帧并异步预加载下一帧
 为什么：
 1.动图基本都是顺序播放的，播放器永远关心的都是下一帧，如果不能保证所有帧都缓存下来，则永远不能命中缓存，缓存越多越浪费性能
 2.异步加载下一帧仅保证主线程的性能和时间戳的准确性，动图一般帧率不高，基本能边解码边播放，如果手机性能不能保证边解码边播放预加载只会让性能更差，不如降低帧率，不影响主线程性能。
 */
@interface BDAnimatedImagePlayer : NSObject
@property (nonatomic, weak)id<BDAnimatedImagePlayerDelegate> delegate;
@property (nonatomic, strong, readonly)BDImage *image;

@property (nonatomic, assign) BOOL frameCacheAutomatically;//是否自动处理内存缓存，默认为YES，仅在cacheAllFrame == NO时生效

@property (nonatomic, assign) BOOL cacheAllFrame;//强制缓存所有帧，默认为NO,

@property (nonatomic, assign) NSUInteger loopCount;//循环次数，超过循环次数停留在最后一帧
@property (nonatomic, readonly) BOOL isPlaying;

@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, strong) BDAnimateImageFrame *currentFrame;
@property (nonatomic, assign) NSRunLoopMode animateRunLoopMode; // Default: NSRunLoopCommonModes
@property (nonatomic, assign) BDAnimatedImageAnimationType animationType;



- (id)initWithImage:(BDImage *)image;
+ (id)playerWithImage:(BDImage *)image;

- (void)updateProgressImage:(BDImage *)image;

- (void)startPlay;
- (void)pause;//暂停并保持状态
- (void)stopPlay;//停止并重置状态和缓存
@end
