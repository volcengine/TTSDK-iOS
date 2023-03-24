//
//  TTFileUploadDemoUtil.m
//  TTSDKDemo
//
//  Created by bytedance on 2020/10/29.
//  Copyright © 2020 ByteDance. All rights reserved.
//

#if __has_include(<TTSDK/TTFileUploader.h>)

#import "TTFileUploadDemoUtil.h"

@implementation TTFileUploadDemoUtil

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

+ (TTVideoUploadClientTop*)videoUploadClientTop:(NSString*)filePath
                                       delegate:(id)delegate
                                  authParameter:(NSDictionary*)parameter{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"upload" ofType:@"txt"];
    TTVideoUploadClientTop* clientTop  = [[TTVideoUploadClientTop alloc] initWithFilePath:filePath];
    NSDictionary* requestParameter = @{/* TTFileUploadSpace:@"for-boe-test",*/
                                       TTFileUploadFileTypeStr:@"video",
                                       TTFileUploadSpace:@"store",

                                       };
    clientTop.delegate = delegate;
    NSString* hostName = @"vod.volcengineapi.com";
    [clientTop setVideoHostName:hostName];
    [clientTop setRequestParameter: requestParameter];
    [clientTop setAuthorizationParameter:parameter];
    [clientTop setSeverParameter:@"key1=value1&key2=value2"];
    [clientTop setProcessActionType:TTVideoUploadActionTypeEncrypt parameter:nil];
    return clientTop;
}

+ (TTMateUploadClientTop*)mateUploadClientTop:(NSString*)filePath
                                       delegate:(id)delegate
                                  authParameter:(NSDictionary*)parameter
                                     fileType:(NSString*)fileType
                                     category:(NSString*)category{
    TTMateUploadClientTop* clientTop  = [[TTMateUploadClientTop alloc] initWithFilePath:filePath];
    if (fileType != nil) {
        NSDictionary* requestParameter = @{
                                           TTFileUploadFileTypeStr:fileType,
                                           //TTFileUploadSpace:@"boe-store",
                                           TTFileUploadSpace:@"store",
                                           };
        [clientTop setRequestParameter: requestParameter];
        NSLog(@"filePath %@ fileType %@ category %@",filePath,fileType,category);
    }
    
    clientTop.delegate = delegate;
    /**boe*/
    //NSString* hostName = @"volcengineapi-boe.byted.org";
    /**online*/
    NSString* hostName = @"vod.volcengineapi.com";
    [clientTop setMateHostName:hostName];
    [clientTop setAuthorizationParameter:parameter];
    [clientTop setSeverParameter:@"key1=value1&key2=value2"];
    [clientTop setRecordType:2];
    [clientTop setCategory:category];
    [clientTop setTitle:@"testMateUpload"];
    [clientTop setTags:@"testMateTag,testMateTagOne"];
    [clientTop setDescription:@"testMateDescription"];
    [clientTop setFormat:@"JPG"];
    return clientTop;
}

+ (TTImageUploadClientTop*)imageUploadClientTop:(NSArray*)filePaths
                                       delegate:(id)delegate
                                  authParameter:(NSString*)parameter
                                       processAction:(int)processAction{
    TTImageUploadClientTop* clientTop = [[TTImageUploadClientTop alloc] initWithFilePaths:filePaths];
    clientTop.delegate = delegate;

    NSString* hostName;
    hostName = @"imagex.volcengineapi.com";
    [clientTop setImageHostName:hostName];
    [clientTop setSeverParameter:@"key1=value1&key2=value2"];
    
    //[clientTop setRequestParameter: @{/* TTFileUploadSpace:@"for-boe-test",*/
//                                      TTFileUploadFileTypeStr:@"image",
//                                      }];
    
    
    //[clientTop setAuthorizationParameter:parameter];
    // NSDictionary *params = @{@"TTFileUploadEncryptionConfig":@{@"copies":@"both"}};
    // [clientTop setProcessActionType:processAction parameter:params];
    
    NSString* imagePathKey1 = @"redttstest";
    NSString* imagePathKey2 = @"yellowttstest";
    NSString* imagePathKey3 = @"bluettstest";
    NSArray* imagePathKeys = @[imagePathKey1,imagePathKey2,imagePathKey3];
    
    NSDictionary* config = @{
                             TTFileUploadFileRetryCount:@1,
                             TTFileUploadSliceTimeout:@40,
                             TTFileUploadSocketNum:@1,
                             TTFileUploadDeviceID:@3424321,
                             TTFileUploadTraceId:@"asdf",
                             TTFileUploadImagePathKey:imagePathKeys
                             };
    [clientTop setUploadConfig:config];
    [clientTop setImageHostName:@"imagex.volcengineapi.com"];
    
    return clientTop;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{

NSError *parseError = nil;

NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

}

@end

#endif
