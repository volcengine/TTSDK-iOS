//
//  TTEffectsModel.h
//  TTSDKDemo
//
//  Created by 陈昭杰 on 2020/1/30.
//  Copyright © 2020 ByteDance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTEffectsModel : NSObject

@property (nonatomic, copy, readonly) NSString *beautyFacePath;

@property (nonatomic, copy, readonly) NSString *beautyFacialItemPath;

@property (nonatomic, copy, readonly) NSString *beautyReshapePath;

@property (nonatomic, copy, readonly) NSString *beautyBodyThinPath;

@property (nonatomic, copy, readonly) NSString *beautyBodyLongLegPath;

@property (nonatomic, copy, readonly) NSString *makeupLipPath;

@property (nonatomic, copy, readonly) NSString *makeupHairPath;

@property (nonatomic, copy, readonly) NSString *makeupEyeshadowPath;

@property (nonatomic, copy, readonly) NSString *filterPath;

@property (nonatomic, copy, readonly) NSString *stickerPath;

+ (instancetype)defaultModel;

@end

NS_ASSUME_NONNULL_END
