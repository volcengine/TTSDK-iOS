//
//  BDImageDecoderInternal.h
//  BDWebImage
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BDImageCodeType);

@protocol BDImageDecoderExt <NSObject>
+ (BOOL)canDecode:(NSData *)data;
@end

@interface BDImageDecoderInternal : NSObject
@property (nonatomic, assign) BDImageCodeType codeType;
@property (nonatomic, assign) BOOL decodeForDisplay;
@property (nonatomic, assign) BOOL shouldScaleDown;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGSize downsampleSize;
@property (nonatomic, assign) CGRect cropRect;
@property (nonatomic, assign) CGSize originSize;
@property (nonatomic, assign) BOOL hasDownsampled;
@property (nonatomic, assign) BOOL hasSmartCrop;
@property (nonatomic, assign, readonly) UIImageOrientation imageOrientation;
@property (nonatomic, strong, readonly) NSData *data;
@property (nonatomic, strong, readonly) NSString *filePath;
@property (nonatomic, assign, readonly) NSUInteger imageCount;
@property (nonatomic, assign, readonly) NSUInteger loopCount;
@property (nonatomic, assign) BOOL isDidScaleDown;//是否已经被缩小过
@property (nonatomic, assign) BOOL enableMultiThreadHeicDecoder;
- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithContentOfFile:(NSString *)file;
- (CGImageRef)copyImageAtIndex:(NSUInteger)index;
- (CFTimeInterval)frameDelayAtIndex:(NSUInteger)index;
+ (BOOL)supportProgressDecode:(NSData *)data;
- (void)changeDecoderWithData:(NSData *)data;
@end
