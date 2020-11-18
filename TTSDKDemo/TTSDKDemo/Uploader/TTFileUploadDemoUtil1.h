////
////  TTFileUploadDemoUtil.h
////  TTSDKDemo
////
////  Created by bytedance on 2020/11/2.
////  Copyright © 2020 ByteDance. All rights reserved.
////
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "TTVideoUploadClientTop.h"
////#import "HttpResourceLoader.h"
////#import "TTNetResourceLoaderDelegate.h"
//#import "TTNetworkManager.h"
//#import "TTImageUploadClientTop.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTFileUploadDemoUtil : NSObject
////获取存储图片的地址
//+ (NSString*)photostDirectory;
////获取存储视频的地址
//+ (NSString*)videosDirectory;
//// 删除文件或文件夹
//+ (void)removeFolderFiles:(NSString*)filePath;
////获取文件夹内的所有文件路径
//+ (NSArray<NSString*>*)getfilesForfolder:(NSString*)floder;
////获取相册中是asset
//+ (void)loadAssets:(void(^)(id obj,NSUInteger idx))completion;
//
+ (void)configTaskWithURL:(NSString *)urlString params:(NSDictionary *)params headers:(NSDictionary *)headers completion:(void (^)(id _Nullable jsonObject, NSError * _Nullable error))completionHandler;
//
//+ (TTImageUploadClientTop*)imageUploadClientTop:(NSArray*)filePaths
//                                       delegate:(id)delegate
//                                  authParameter:(NSString*)parameter isImageX:(BOOL) isImageX;
//
//+ (TTVideoUploadClientTop*)videoUploadClientTop:(NSString*)filePath
//                                       delegate:(id)delegate
//                                  authParameter:(NSString*)parameter;
@end

NS_ASSUME_NONNULL_END
