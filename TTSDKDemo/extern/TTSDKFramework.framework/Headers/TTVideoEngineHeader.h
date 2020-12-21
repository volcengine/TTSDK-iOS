//
//  TTVideoEngineHeader.h
//  TTVideoEngine
//
//  Created by 黄清 on 2019/1/9.
//

#ifndef TTVideoEngineHeader_h
#define TTVideoEngineHeader_h

#if __has_include(<TTVideoEngine/TTVideoEngine.h>)
#import <TTVideoEngine/TTVideoEngine.h>
#import <TTVideoEngine/TTVideoEngine+Options.h>
#import <TTVideoEngine/TTVideoEngine+Preload.h>
#import <TTVideoEngine/TTVideoEngine+Tracker.h>
#import <TTVideoEngine/TTVideoEngineModel.h>
#import <TTVideoEngine/TTVideoEngineInfoModel.h>
#import <TTVideoEngine/TTVideoEngineModelDef.h>
#import <TTVideoEngine/TTVideoEngineUtil.h>
#import <TTVideoEngine/TTVideoEngineEventManager.h>
#import <TTVideoEngine/TTVideoEnginePlayerDefine.h>
#import <TTVideoEngine/TTVideoCacheManager.h>
#import <TTVideoEngine/TTVideoEngineExtraInfo.h>
#import <TTVideoEngine/TTVideoEngineExtraInfoProtocol.h>
#import <TTVideoEngine/TTVideoEnginePlayItem.h>
#import <TTVideoEngine/TTVideoEngineNetClient.h>
#import <TTVideoEngine/TTAVPreloaderItem.h>
#import <TTVideoEngine/TTVideoEngineKeys.h>
#else
#import "TTVideoEngine.h"
#import "TTVideoEngine+Options.h"
#import "TTVideoEngine+Preload.h"
#import "TTVideoEngineModel.h"
#import "TTVideoEngineInfoModel.h"
#import "TTVideoEngineModelDef.h"
#import "TTVideoEngineUtil.h"
#import "TTVideoEngineEventManager.h"
#import "TTVideoEnginePlayerDefine.h"
#import "TTVideoCacheManager.h"
#import "TTVideoEngineExtraInfo.h"
#import "TTVideoEngineExtraInfoProtocol.h"
#import "TTVideoEnginePlayItem.h"
#import "TTVideoEngineNetClient.h"
#import "TTAVPreloaderItem.h"
#import "TTVideoEngine+Tracker.h"
#import "TTVideoEngineKeys.h"
#endif

#endif /* TTVideoEngineHeader_h */
