//
//  BDWebImageCompat.h
//  BDWebImage
//
//

#import <Foundation/Foundation.h>
#import <objc/objc.h>

NSString *BDWebImageSDKVersion(void);

void BDWebImageMethodSwizzle(Class cls, SEL originalSelector, SEL swizzledSelector);

FOUNDATION_EXPORT CGFloat BDScaledFactorForKey(NSString *key);

/**
 * 此接口要特别慎重使用，因为此设置是全局的，一个App和它的多个组件，如果都使用了BD，那调用此接口会导致他们和之前的行为不一致！
 */
FOUNDATION_EXPORT __attribute__((deprecated)) void BDSetWebImageUsingScreenScale(BOOL use);

FOUNDATION_EXPORT NSDictionary *BDCGRect2Dict(CGRect rect);

FOUNDATION_EXPORT CGRect BDDict2CGRect(NSDictionary *rectDict);
