//
//  TTEffectsModel.m
//  TTSDKDemo
//
//  Created by 陈昭杰 on 2020/1/30.
//  Copyright © 2020 ByteDance. All rights reserved.
//

#import "TTEffectsModel.h"

@interface TTEffectsModel ()

@property (nonatomic, copy) NSString *composeMakeupBundlePath;

@property (nonatomic, copy) NSString *filterResourceBundlePath;

@property (nonatomic, copy) NSString *beautyFacePath;

@property (nonatomic, copy) NSString *beautyFacialItemPath;

@property (nonatomic, copy) NSString *beautyReshapePath;

@property (nonatomic, copy) NSString *beautyBodyPath;

@property (nonatomic, copy) NSString *makeupPath;

@property (nonatomic, copy) NSString *filterPath;

@end

@implementation TTEffectsModel

static TTEffectsModel *_defaultModel = nil;

+ (instancetype)defaultModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultModel = [[TTEffectsModel alloc] init];
    });
    return _defaultModel;
}

- (NSString *)beautyFacePath {
    if (!_beautyFacePath) {
        _beautyFacePath = [self.composeMakeupBundlePath stringByAppendingString:@"/beauty_IOS"];
    }
    return _beautyFacePath;
}

- (NSString *)beautyFacialItemPath {
    if (!_beautyFacialItemPath) {
        _beautyFacialItemPath = [self.composeMakeupBundlePath stringByAppendingString:@"/beauty_4Items"];
    }
    return _beautyFacialItemPath;
}

- (NSString *)beautyReshapePath {
    if (!_beautyReshapePath) {
        _beautyReshapePath = [self.composeMakeupBundlePath stringByAppendingString:@"/reshape"];
    }
    return _beautyReshapePath;
}

- (NSString *)beautyBodyPath {
    if (!_beautyBodyPath) {
        _beautyBodyPath = [self.composeMakeupBundlePath stringByAppendingString:@"/body"];
    }
    return _beautyBodyPath;
}

- (NSString *)beautyBodyThinPath {
    return [self.beautyBodyPath stringByAppendingString:@"/thin"];
}

- (NSString *)beautyBodyLongLegPath {
    return [self.beautyBodyPath stringByAppendingString:@"/longleg"];
}

- (NSString *)makeupPath {
    if (!_makeupPath) {
        _makeupPath = self.composeMakeupBundlePath;
    }
    return _makeupPath;
}

- (NSString *)makeupLipPath {
    return [self.makeupPath stringByAppendingString:@"/lip/fuguhong"];
}

- (NSString *)makeupHairPath {
    return [self.makeupPath stringByAppendingString:@"/hair/anlan"];
}

- (NSString *)makeupEyeshadowPath {
    return [self.makeupPath stringByAppendingString:@"/eyeshadow/wanxiahong"];
}

- (NSString *)filterPath {
    if (!_filterPath) {
        _filterPath = [self.filterResourceBundlePath stringByAppendingString:@"/Filter"];
    }
    return _filterPath;
}

- (NSString *)stickerPath {
    return [[[NSBundle mainBundle] pathForResource:@"StickerResource" ofType:@"bundle"] stringByAppendingString:@"/stickers"];
}

- (NSString *)composeMakeupBundlePath {
    if (!_composeMakeupBundlePath) {
        _composeMakeupBundlePath = [[[NSBundle mainBundle] pathForResource:@"ComposeMakeup" ofType:@"bundle"] stringByAppendingString:@"/ComposeMakeup"];
    }
    return _composeMakeupBundlePath;
}

- (NSString *)filterResourceBundlePath {
    if (!_filterResourceBundlePath) {
        _filterResourceBundlePath = [[NSBundle mainBundle] pathForResource:@"FilterResource" ofType:@"bundle"];
    }
    return _filterResourceBundlePath;
}

@end

