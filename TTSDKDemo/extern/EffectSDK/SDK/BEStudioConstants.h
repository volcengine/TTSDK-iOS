// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.

#import <Foundation/Foundation.h>

static NSString *const BEEffectNotificationUserInfoKey = @"data";

FOUNDATION_EXTERN NSString *const BEEffectFilterDidChangeNotification;
FOUNDATION_EXTERN NSString *const BEEffectFilterIntensityDidChangeNotification;
FOUNDATION_EXTERN NSString *const BEEffectCameraDidAuthorizationNotification;
FOUNDATION_EXTERN NSString *const BEEffectCameraDidAuthorizationNotification;

FOUNDATION_EXTERN NSString *const BEEffectQRCodeDidChangeNotification;
FOUNDATION_EXTERN NSString *const BEEffectNetworkStickerReadyNotification;
FOUNDATION_EXTERN NSString *const BEEffectNetworkNotReachedNotification;

FOUNDATION_EXTERN NSString *const BEEffectDidReturnToMainUINotification;
FOUNDATION_EXTERN NSString *const BEEffectNormalButtonNotification;

FOUNDATION_EXTERN NSString *const BEEffectButtonItemSelectNotification;
FOUNDATION_EXTERN NSString *const BEEffectUpdateComposerNodesNotification;
FOUNDATION_EXTERN NSString *const BEEffectUpdateComposerNodeIntensityNotification;

FOUNDATION_EXTERN NSString *const BEEffectExporsureValueChangedNotification;

FOUNDATION_EXPORT NSString *const BEFUserDefaultExclusive;
FOUNDATION_EXPORT NSString *const BESdkErrorNotification;
