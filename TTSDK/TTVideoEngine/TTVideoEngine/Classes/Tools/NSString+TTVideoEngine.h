//
//  NSString+TTVideoEngine.h
//  TTVideoEngine
//
//  Created by 黄清 on 2018/11/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSString (TTVideoEngine)


- (NSString *)ttvideoengine_transformEncode;
    
- (NSString *)ttvideoengine_transformDecode;

- (CGSize)ttvideoengine_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

- (NSNumber*)ttvideoengine_stringToNSNumber;

- (NSString *)ttvideoengine_base64DecodedString;

@end

NS_ASSUME_NONNULL_END
