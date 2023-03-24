//
//  TTFileUploadDemoUtil.h
//  TTSDKDemo
//
//  Created by bytedance on 2020/10/29.
//  Copyright © 2020 ByteDance. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<TTSDK/TTFileUploader.h>)

@interface TTFileUploadDemoUtil : NSObject

+ (void)configTaskWithURL:(NSString *)urlString params:(NSDictionary *)params headers:(NSDictionary *)headers completion:(void (^)(id _Nullable jsonObject, NSError * _Nullable error))completionHandler;

+ (TTImageUploadClientTop*)imageUploadClientTop:(NSArray*)filePaths
     delegate:(id)delegate
authParameter:(NSString*)parameter processAction:(int) processAction;

+ (TTVideoUploadClientTop*)videoUploadClientTop:(NSString*)filePath
     delegate:(id)delegate
authParameter:(NSString*)parameter;

+ (TTMateUploadClientTop*)mateUploadClientTop:(NSString*)filePath
                                       delegate:(id)delegate
                                  authParameter:(NSDictionary*)parameter
                                       fileType:(NSString*)fileType
                                       category:(NSString*)category;

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
@end


#endif
