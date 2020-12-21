//
//  BDImageView.h
//  BDWebImage
//
//

#import <UIKit/UIKit.h>
#import "BDAnimatedImagePlayer.h"

@class BDImageView;
@protocol  BDPlayGIFStrategy
- (BDAnimatedImagePlayer *)createPlayer:(BDImageView *)imageView;
- (void)setImage:(UIImage *)image forImageView:(BDImageView *)imageView;
- (void)setImage:(UIImage *)image forImageView:(BDImageView *)imageView new:(BOOL)newImage;
@end
/**
 如果animateEnable == YES,并且当前image是动图，则生成BDAnimateImagePlayer自动播放当前动图，所有解码和缓存逻辑在异步线程，理论上不影响主线程性能
 具体介绍参见BDAnimateImagePlayer
 */
@interface BDImageView : UIImageView <BDAnimatedImagePlayerDelegate>
@property (nonatomic, assign, getter = isAnimateEnable)BOOL animateEnable;
@property (nonatomic, assign) BOOL infinityLoop;//强制无限循环，默认策略依据文件头信息
@property (nonatomic, assign) NSUInteger customLoop;//定制循环次数，默认为0，表示不定制。优先级大于infinityLoop。
@property (nonatomic, assign) BOOL frameCacheAutomatically;//参见BDAnimateImagePlayer
@property (nonatomic, assign) BOOL cacheAllFrame;//参见BDAnimateImagePlayer
@property (nonatomic, assign) NSUInteger currentAnimatedImageIndex;
@property (nonatomic, assign) BOOL autoPlayAnimatedImage;
@property (nonatomic, assign) BOOL hightAnimationControl;
@property (nonatomic, copy) void(^loopCompletionBlock)(void);
@property (nonatomic, copy) void(^firstFramePlayBlock)(NSString *url);

@property (nonatomic, strong, readonly) BDAnimatedImagePlayer *player;
@property (nonatomic, strong, readonly) BDImage *animateImage;
@property (nonatomic, assign) NSRunLoopMode animateRunLoopMode;
@property (nonatomic, assign) BDAnimatedImageAnimationType animationType;


- (void)pauseAnimation;//暂停并保持状态
- (void)startAnimation;//开始
- (void)stopAnimation;

@end
