//
//  TTVideoPreloaderHelper.m
//  TTVideoEngineDemo
//
//  Created by 黄清 on 2019/7/1.
//  Copyright © 2019 bytedance. All rights reserved.
//

#import "TTVideoPreloaderHelper.h"
#import "SourceViewController.h"

@implementation TTVideoPreloaderHelper

+ (void)preloadItems:(NSArray<NSDictionary *> *)items {
    if (!items || items.count == 0) {
        return;
    }
    
    for (NSDictionary *item in items) {
        NSString *url = item[SourceKeyURL];
        NSString *vid = item[SourceKeyVid];
        
        static NSInteger s_preload_size = 500 * 1024;
        if (tt_valid_string(url)) {
            [TTVideoEngine ls_addTask:url.md5String vid:vid preSize:s_preload_size url:url];
        } else if(tt_valid_string(vid)) {
            TTVideoEnginePreloaderVidItem *vidItem = [TTVideoEnginePreloaderVidItem preloaderVidItem:vid
                                                                                            token:item[SourceKeyAuth]
                                                                                        reslution:TTVideoEngineResolutionTypeFullHD
                                                                                      preloadSize:s_preload_size
                                                                                        isByteVC1:NO];
            NSString *key = [NSString stringWithFormat:@"vid%@_resolution%@_h265%@_dash%@",vid,@(TTVideoEngineResolutionTypeFullHD),@(NO),@(NO)];
            [TTVideoEngine ls_addTask:key vidItem:vidItem];
            // [TTVideoEngine ls_addTaskWithVidItem:vidItem]；/// 建议使用该接口，但是没有自定义 key ,无法取消单个还未进行的 task,但是一般情况下会触发取消之前的所有预加载任务。
        }
    }
}

+ (void)cancelPreloadItem:(NSDictionary *)item {
    if (!item || item.count == 0) {
        return;
    }
    
    NSString *url = item[SourceKeyURL];
    NSString *vid = item[SourceKeyVid];
    
    if (tt_valid_string(url)) {
        [TTVideoEngine ls_cancelTaskByKey:url.md5String];
    } else if(tt_valid_string(vid)) {
        /// 这里的 key 和前面添加预加载生成的 key 需要是一致的。
        NSString *key = [NSString stringWithFormat:@"vid%@_resolution%@_h265%@_dash%@",vid,@(TTVideoEngineResolutionTypeFullHD),@(NO),@(NO)];
        [TTVideoEngine ls_cancelTaskByKey:key];
    }
}

+ (void)cancelAllPreloadItems {
    [TTVideoEngine ls_cancelAllTasks];
}

@end
