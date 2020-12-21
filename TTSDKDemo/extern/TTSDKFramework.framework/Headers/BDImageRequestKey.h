//
//  BDImageRequestKey.h
//  BDWebImage
//
//  Created by 陈奕 on 2020/5/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDImageRequestKey : NSObject<NSCopying>

@property (nonatomic, copy, readonly)NSString *targetkey;   // image key，what is it composed of sourceKey、transfromName、cropRect、downsampleSize

@property (nonatomic, copy)NSString *sourceKey;             // data key，url or requestKey from urlfilter

@property (nonatomic, assign)CGSize downsampleSize;         // image downsample with size

@property (nonatomic, assign)CGRect cropRect;               // Image cropped area

@property (nonatomic, copy)NSString *transfromName;         // Image needs to be transfromed

@property (nonatomic, assign)BOOL smartCrop;                // Image need smart cropping

@property (nonatomic, assign)BOOL builded;                  // After builded = YES, the targetkey will be regenerated, the default targetkey == sourceKey

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithURL:(NSString *)url;
- (instancetype)initWithURL:(NSString *)url downsampleSize:(CGSize)downsampleSize cropRect:(CGRect)cropRect transfromName:(NSString *)transfromName smartCrop:(BOOL)smartCrop;

// Contains the URL, that is, BDImageRequestKey.sourceKey is equal to the URL
- (BOOL)containsUrl:(NSString *)url;

// targetkey is spliced with type and value to generate a new key
- (NSString *)extendKeyWithType:(NSString *)type value:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
