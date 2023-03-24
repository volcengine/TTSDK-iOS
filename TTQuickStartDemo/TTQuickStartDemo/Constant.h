//
//  Constant.h
//  TTQuickStartDemo
//
//  Created by ByteDance on 2022/10/21.
//

#ifndef Constant_h
#define Constant_h

/// TTSDK 的 AppID
#define TTSDK_APP_ID @""
/// TTSDK 的 License 名称，根据代码业务调整
#define TTSDK_LICENSE_NAME @"ttsdk.lic"

/// 连麦相关参数请到 https://console.volcengine.com/rtc/listRTC 控制台生成
/// 连麦 Appid
#define RTC_APPID @""
/// 连麦房间 ID
#define RTC_ROOM_ID @""

/// 主播用户ID
#define RTC_ANCHOR_USER_ID @""
/// 主播token
#define RTC_ANCHOR_USER_TOKEN @""

/// 观众用户ID
#define RTC_AUDIENCE_USER_ID @""
/// 观众 Token
#define RTC_AUDIENCE_USER_TOKEN @""

/// 另外一个主播房间 ID
#define RTC_OTHER_ANCHOR_ROOM_ID @""
/// 用  RTC_OTHER_ANCHOR_ROOM_ID + RTC_ANCHOR_USER_ID  来生成token
#define RTC_ANCHOR_OTHER_ROOM_TOKEN @""

/// 直播推拉流地址请到 https://console.volcengine.com/live/main/locationGenerate 控制台生成
/// 推流地址
#define LIVE_PUSH_URL @""
/// 拉流地址
#define LIVE_PULL_URL @""


#endif /* Constant_h */
