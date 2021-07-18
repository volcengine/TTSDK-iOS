//  Created by 黄清 on 2020/5/15.
//

#import <Foundation/Foundation.h>
#import "IVCMediaLoadMedia.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCMediaLoadMedia : NSObject<IVCMediaLoadMedia>

+ (instancetype)media:(NSArray *)urls
                  key:(NSString *)fileKey
               rawKey:(NSString *)playSourceId;

@property (nonatomic, copy, nullable) NSDictionary<NSString *,id> *extraInfo;

@end

NS_ASSUME_NONNULL_END
