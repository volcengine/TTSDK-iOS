//
//  TTVideoEngine+Tracker.h
//  TTVideoEngine
//
//  Created by 黄清 on 2018/12/10.
//

#import "TTVideoEngine.h"

NS_ASSUME_NONNULL_BEGIN

#ifndef __TTVIDEOENGINE_TRACKER__
#define __TTVIDEOENGINE_TRACKER__
#if  __has_include("BDTrackerSDK.h")
#define TTVIDEOENGINE_ENABLE_TRACKER 1
#else
#define TTVIDEOENGINE_ENABLE_TRACKER 0
#endif
#endif


typedef void(^TTVideoEngineDeviceInfo)(NSString *_Nullable deviceID, NSString *_Nullable installID, NSString *_Nullable ssID);

typedef NS_ENUM(NSInteger, TTVideoEngineServiceVendorType) {
    TTVideoEngineServiceVendorCN   = 0x010,//China
    TTVideoEngineServiceVendorSG,          //Singapore
    TTVideoEngineServiceVendorVA,
};

@interface TTVideoEngine()

/// Report log switch. Default: YES
@property (nonatomic, assign) BOOL reportLogEnable;

/// The unique identify of user. Maybe you need to distinguish the user's login status.
/// It will set in a single log.
@property (nonatomic, nonnull, copy) NSString *userUniqueId;

+ (void)tracker_start:(TTVideoEngineDeviceInfo)callBack DEPRECATED_MSG_ATTRIBUTE("please use RangersAppLog SDK");

@end

NS_ASSUME_NONNULL_END
