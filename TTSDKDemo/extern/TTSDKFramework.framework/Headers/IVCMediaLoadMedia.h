//  Created by 黄清 on 2020/5/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IVCMediaLoadMedia <NSObject, NSCopying>

@property (nonatomic,   copy, nullable) NSArray<NSString *> *urls;
@property (nonatomic, assign, getter=getFileSize) NSInteger fileSize;
@property (nonatomic, assign) NSInteger duration; // unknow = -1;
@property (nonatomic,   copy, nullable) NSString *fileKey;

/// video-Id or fileKey
@property (nonatomic,   copy, nullable) NSString *playSourceId;

/// target size
@property (nonatomic, assign, getter=getOffset) NSInteger offset; /// Default: 0
@property (nonatomic, assign, getter=getDowloadSize) NSInteger downloadSize;

/// - (BOOL)isEqual:(id)object; need implement.
/// - (id)copyWithZone:(nullable NSZone *)zone; need implement.

@end

NS_ASSUME_NONNULL_END
