// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.

#ifndef BEMacro_h
#define BEMacro_h

#define SCREEN_WIDTH ([UIApplication sharedApplication].keyWindow.bounds.size.width)
#define SCREEN_HEIGHT ([UIApplication sharedApplication].keyWindow.bounds.size.height)
#define SCREEN_SCALE [[UIScreen mainScreen] scale]

#define VIDEO_INPUT_WIDTH 720
#define VIDEO_INPUT_HEIGHT 1280

#define FACE_MAKEUP_TYPE_COUNT 7
#define APP_IS_DEBUG    true

#define BEBLOCK_INVOKE(block, ...) (block ? block(__VA_ARGS__) : 0)

#ifndef btd_keywordify
#if DEBUG
#define btd_keywordify autoreleasepool {}
#else
#define btd_keywordify try {} @catch (...) {}
#endif
#endif

#ifndef weakify
#if __has_feature(objc_arc)
#define weakify(object) btd_keywordify __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) btd_keywordify __block __typeof__(object) block##_##object = object;
#endif
#endif

#ifndef strongify
#if __has_feature(objc_arc)
#define strongify(object) btd_keywordify __typeof__(object) object = weak##_##object;
#else
#define strongify(object) btd_keywordify __typeof__(object) object = block##_##object;
#endif
#endif

#ifndef BE_isEmptyString
#define BE_isEmptyString(param)        ( !(param) ? YES : ([(param) isKindOfClass:[NSString class]] ? (param).length == 0 : NO) )
#endif

#define BEColorWithARGBHex(hex) [UIColor colorWithRed:((hex&0xFF0000)>>16)/255.0 green:((hex&0x00FF00)>>8)/255.0 blue:((hex&0x0000FF))/255.0 alpha:((hex&0xFF000000)>>24)/255.0]
#define BEColorWithRGBAHex(hex,alpha) [UIColor colorWithRed:((hex&0xFF0000)>>16)/255.0 green:((hex&0x00FF00)>>8)/255.0 blue:((hex&0x0000FF))/255.0 alpha:alpha]
#define BEColorWithRGBHex(hex) [UIColor colorWithRed:((hex&0xFF0000)>>16)/255.0 green:((hex&0x00FF00)>>8)/255.0 blue:((hex&0x0000FF))/255.0 alpha:1]


#endif /* BEMacro_h */
