//
//  BDWebImageStartUpConfig.h
//  BDWebImageToB
//
//  Created by 陈奕 on 2020/10/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    BDImageServiceVendorCN,
    BDImageServiceVendorVA,
    BDImageServiceVendorSG
} BDImageServiceVendor;

@interface BDWebImageStartUpConfig : NSObject

@property (nonatomic, assign) BOOL isInBoe;
@property (nonatomic, copy) NSString *appID;
@property (nonatomic, assign) BDImageServiceVendor serviceVendor;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSArray<NSString *> *authCodes;

@end

NS_ASSUME_NONNULL_END
