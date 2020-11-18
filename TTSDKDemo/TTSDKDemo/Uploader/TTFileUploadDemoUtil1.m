////
////  TTFileUploadDemoUtil.m
////  TTSDKDemo
////
////  Created by bytedance on 2020/11/2.
////  Copyright © 2020 ByteDance. All rights reserved.
////
//
#import "TTFileUploadDemoUtil.h"
//#import <AssetsLibrary/AssetsLibrary.h>
//#import <Photos/PHPhotoLibrary.h>
//#import <Photos/PHObject.h>
//#import <Photos/PHAsset.h>
//#import <Photos/PHLivePhoto.h>
//#import <Photos/PHCollection.h>
//#import <Photos/PHFetchOptions.h>
//#import <Photos/PHFetchResult.h>
@implementation TTFileUploadDemoUtil
//+ (NSString*)photostDirectory{
//    NSString *documentPath = [NSString stringWithFormat:@"%@/photosFile", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]];
//    
//    return [TTFileUploadDemoUtil createDirectory:documentPath];
//}
//+ (NSString*)videosDirectory{
//    NSString *documentPath = [NSString stringWithFormat:@"%@/videosFile", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]];
//    return [TTFileUploadDemoUtil createDirectory:documentPath];
//}
//+ (NSString*)createDirectory:(NSString*)filePath{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL isDir= NO;
//    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
//    if (!(existed&&isDir)){
//        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    return filePath;
//}
//+ (void)removeFolderFiles:(NSString*)filePath{
//    NSFileManager* manger = [NSFileManager defaultManager];
//    if ([manger fileExistsAtPath:filePath]) {
//        NSError* error;
//        [manger removeItemAtPath:filePath error:&error];
//        if (error) {
//            NSLog(@"removeFolderFiles error = %@",error);
//        }
//    }
//}
//+ (NSArray<NSString*>*)getfilesForfolder:(NSString*)floder{
//    NSFileManager * manger = [NSFileManager defaultManager];
//    BOOL isDiectory;
//
//    BOOL isExist = [manger fileExistsAtPath:floder isDirectory:&isDiectory];
//    if (!isExist||!isDiectory ){
//        NSLog(@"传入的必须是文件夹");
//    }
//    NSMutableArray<NSString*>* filePathArray = [NSMutableArray arrayWithCapacity:10];
//    NSArray *arrayPath = [manger subpathsAtPath:floder];
//    for (NSString* subFilePath in arrayPath) {
//        NSString* filePath = [floder stringByAppendingPathComponent:subFilePath];
//        BOOL isDiectory;
//        BOOL isExist = [manger fileExistsAtPath:filePath isDirectory:&isDiectory];
//        if (!isExist||isDiectory ) continue;
//        [filePathArray addObject:filePath];
//    }
//    return filePathArray;
//}
//+ (void)loadAssets:(void(^)(id obj,NSUInteger idx))completion{
//    if (NSClassFromString(@"PHAsset")) {
//        // Check library permissions
//        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
//        if (status == PHAuthorizationStatusNotDetermined) {
//            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
//                if (status == PHAuthorizationStatusAuthorized) {
//                    [TTFileUploadDemoUtil performLoadAssets:completion];
//                }
//            }];
//        } else if (status == PHAuthorizationStatusAuthorized) {
//            [TTFileUploadDemoUtil performLoadAssets:completion];
//        }
//
//    } else {
//        // Assets library
//        NSLog(@"version < iOS 8");
//    }
//}
//+ (void)performLoadAssets:(void(^)(id obj,NSUInteger idx))completion{
//
//    // Initialise
//    NSMutableArray* assets = [NSMutableArray new];
//
//    // Load
//    if (NSClassFromString(@"PHAsset")) {
//
//        // Photos library iOS >= 8
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            PHFetchOptions *options = [PHFetchOptions new];
//            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
//            PHFetchResult *fetchResults = [PHAsset fetchAssetsWithOptions:options];
//            [fetchResults enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                [assets addObject:obj];
//                completion(obj,idx);
//            }];
//        });
//
//    }
//
//}
+ (void)configTaskWithURL:(NSString *)urlString params:(NSDictionary *)params headers:(NSDictionary *)headers completion:(void (^)(id _Nullable jsonObject, NSError * _Nullable error))completionHandler
{
    NSString *originURL = urlString;
    NSMutableString *requestURL = [NSMutableString stringWithString:originURL];
    if (params != nil) {
        NSRange range = [originURL rangeOfString:@"?"];
        if (range.location == NSNotFound) {
            [requestURL appendString:@"?"];
        }
        else if (range.location != originURL.length - 1) {
            [requestURL appendString:@"&"];
        }
        NSUInteger keysNum = [params allKeys].count;
        for (int i = 0; i < keysNum; i++) {
            NSString *key = [[params allKeys] objectAtIndex:i];
            NSString *value = [params objectForKey:key];
            NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *encodedValue = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [requestURL appendString:[NSString stringWithFormat:@"%@=%@",encodedKey,encodedValue]];
            if (i != keysNum - 1) {
                [requestURL appendString:@"&"];
            }
        }
    }
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    //    [urlRequest setValue:@"TTVideoEngine(iOS)" forHTTPHeaderField:@"User-Agent"];
    for (NSString *key in [headers allKeys]) {
        [urlRequest setValue:[headers valueForKey:key] forHTTPHeaderField:key];
    }
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:[urlRequest copy]
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                if (error) {
                                                    completionHandler(nil,error);
                                                }
                                                else {
                                                    NSLog(@"**********************************%@",((NSHTTPURLResponse*)response).allHeaderFields);
                                                    NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
                                                    if ([response isKindOfClass:[NSHTTPURLResponse class]] && (statusCode == 200 || statusCode == 403)) {
                                                        NSError *jsonError = nil;
                                                        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:nil error:&jsonError];
                                                        if (jsonError) {
                                                            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:jsonError.userInfo];
                                                            if (data) {
                                                                const char *cStr = (const char *)[data bytes];
                                                                NSString *body = nil;
                                                                if (cStr != NULL) {
                                                                    body = [NSString stringWithUTF8String:cStr];
                                                                }
                                                                if (body) {
                                                                    [userInfo setValue:body forKey:@"body"];
                                                                } else {
                                                                    [userInfo setValue:@"" forKey:@"body"];
                                                                }
                                                            }
                                                            NSError *parseError = [NSError errorWithDomain:jsonError.domain code:jsonError.code userInfo:userInfo];
                                                            completionHandler(nil,jsonError);
                                                        }
                                                        else {
                                                            NSError *retError = nil;
                                                            if (statusCode != 200) {

                                                            }
                                                            completionHandler(jsonObject,retError);
                                                        }
                                                    }
                                                    else {
                                                        completionHandler(nil,[NSError errorWithDomain:@"not 200" code:-1000 userInfo:@{@"description": response.description ?:@""}]);
                                                    }
                                                }
                                            }];
    [task resume];

}
//+ (TTImageUploadClientTop*)imageUploadClientTop:(NSArray*)filePaths
//                                       delegate:(id)delegate
//                                  authParameter:(NSString*)parameter isImageX:(BOOL)isImageX{
//    TTImageUploadType type = isImageX ? TTImageUploadTypeImageX: TTImageUploadTypeImage;
//    TTImageUploadClientTop* clientTop = [[TTImageUploadClientTop alloc] initWithFilePaths:filePaths uploadType:type];
//    clientTop.delegate = delegate;
//
//    [clientTop setRequestParameter: @{/* TTFileUploadSpace:@"for-boe-test",*/
//                                      TTFileUploadFileTypeStr:@"image",
//                                      }];
//
//
//    [clientTop setAuthorizationParameter:parameter];
//    [clientTop setProcessActionType:TTFileUploadTopActionTypeGetMedia parameter:nil];
//
////    [clientTop setFileNames:filePaths];
//    NSDictionary* config = @{
//                             TTFileUploadFileRetryCount:@1,
//                             TTFileUploadSliceTimeout:@40,
//                             TTFileUploadSocketNum:@1,
//                             TTFileUploadDeviceID:@3424321,
//                             TTFileUploadTraceId:@"asdf"
//                             };
//    [clientTop setUploadConfig:config];
//    if(isImageX){
//        [clientTop setImageHostName:@"imagex.bytedanceapi.com"];
//    }
//
//    return clientTop;
//}
//+ (TTVideoUploadClientTop*)videoUploadClientTop:(NSString*)filePath
//                                       delegate:(id)delegate
//                                  authParameter:(NSString*)parameter{
////    NSString *path = [[NSBundle mainBundle] pathForResource:@"upload" ofType:@"txt"];
//    TTVideoUploadClientTop* clientTop  = [[TTVideoUploadClientTop alloc] initWithFilePath:filePath];
//    NSDictionary* requestParameter = @{/* TTFileUploadSpace:@"for-boe-test",*/
//                                       TTFileUploadFileTypeStr:@"video",
//                                       };
//    clientTop.delegate = delegate;
//    NSString* hostName = @"vod.bytedanceapi.com";
////    [clientTop setVideoHostName:hostName];
//    [clientTop setRequestParameter: requestParameter];
//    [clientTop setAuthorizationParameter:parameter];
//    [clientTop setProcessActionType:TTFileUploadTopActionTypeGetMedia|TTFileUploadTopActionTypeSnapshot parameter:nil];
//    return clientTop;
//}
//+ (NSDictionary*)actionProcess{
//    return @{TTFileUploadEncryptionConfig:[TTFileUploadDemoUtil configVideoUpload],
//             TTFileUploadEncryptionPolicyParams:[TTFileUploadDemoUtil policyParams]
//             };
//}
//+ (NSDictionary*)processParam{
//    NSDictionary *logo_param = @{@"format":@"",
//                                 @"q":@0,
//                                 @"tpl":@"xglogo",
//                                 @"q":@"100",
//                                 @"text":@"haha",
//                                 @"version":@"v2",
//                                 };
//    NSDictionary *ratio_param = @{ @"width": @600,
//                                   @"height": @800,
//                                   };
//    NSDictionary *params = @{
//                             @"logo_param":logo_param,
//                             @"ratio_param":ratio_param,
//                             @"custom":@"hi honey"
//                             };
//
//    return params;
//}
//+ (NSDictionary*)configVideoUpload{
//    NSDictionary *params = @{
//                             @"need_vframe":@"true",
//                             };
//    return params;
//}
//+ (NSDictionary*)policyParams{
//    NSDictionary *params = @{@"policy-set":@"thumb",
//                             @"thumbS-size":@"500",
//                             @"thumbS-limit":@"201",
//                             };
//    return params;
//}
//+ (NSDictionary*)customConfig{
//    NSDictionary *customConfig = @{
//                                   @"test":@"sucess",
//                                   @"test1":@"sucess",
//                                   };
//    return customConfig;
//}
//+ (NSDictionary*)configInfo{
//    return @{
//             TTFileUploadDeviceID:@(6673761387486037506),
//             TTFileUploadTraceId:@"afafadfafa",
//             //             TTFileUploadEnableBOE:@(YES)
//             };
//}
@end

