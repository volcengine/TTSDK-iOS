//
//  BDImageDecoderHeic.h
//  BDWebImage
//
//

#import "BDImageDecoderInternal.h"

@interface BDImageDecoderHeic : BDImageDecoderInternal <BDImageDecoderExt>
+ (BOOL)canDecode:(NSData *)data;
@end
