//
//  VodSettingsDefine.h
//  VCVodSettings
//
//  Created by 黄清 on 2021/5/18.
//

#ifndef VodSettingsDefine_h
#define VodSettingsDefine_h


/// version string
#ifndef __VERSION_STRING__
#define __VERSION_STRING__
#define VERSION_STRING "0.0.6-alpha5"
#endif
///

/// Log
#ifndef __VOD_SETTINGS_LOG__
#define __VOD_SETTINGS_LOG__
#ifdef DEBUG
#define Log(fmt, ...) \
do{\
NSString *log = [NSString stringWithFormat:(@"%s [Line %d] " fmt),__PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__];\
printf("VodSettings %s \n",log.UTF8String);}while(false);
#else
#define Log(...)
#endif
#endif


#endif /* VodSettingsDefine_h */
