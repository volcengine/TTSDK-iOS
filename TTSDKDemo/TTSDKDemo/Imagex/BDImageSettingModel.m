//
//  BDImageSettingModel.m
//  BDWebImage_Example
//
//  Created by 陈奕 on 2020/4/8.
//  Copyright © 2020 Bytedance.com. All rights reserved.
//

#import "BDImageSettingModel.h"
#import "BDImageAdapter.h"

NSString *const kBDImageSettingAppID = @"kBDImageSettingAppID";

@implementation BDImageSettingModel

+ (NSArray<BDImageSettingModel *> *)defaultSettingModels {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:9];
    [array addObject:({
        BDImageSettingModel *model = [BDImageSettingModel new];
        model.name = @"动图边下边放";
        model.type = BDImageSettingSelectType;
        model.showSelect = ^BOOL{
            return [BDImageAdapter sharedAdapter].options & BDImageAnimatedImageProgressiveDownload;
        };
        model.selectItem = ^{
            [BDImageAdapter sharedAdapter].options ^= BDImageAnimatedImageProgressiveDownload;
        };
        model;
    })];
    [array addObject:({
        BDImageSettingModel *model = [BDImageSettingModel new];
        model.name = @"动图循环播放";
        model.type = BDImageSettingSelectType;
        model.showSelect = ^BOOL{
            return [BDImageAdapter sharedAdapter].isCyclePlayAnim;
        };
        model.selectItem = ^{
            [BDImageAdapter sharedAdapter].isCyclePlayAnim = ![BDImageAdapter sharedAdapter].isCyclePlayAnim;
        };
        model;
    })];
    [array addObject:({
        BDImageSettingModel *model = [BDImageSettingModel new];
        model.name = @"失败后自动重试";
        model.type = BDImageSettingSelectType;
        model.showSelect = ^BOOL{
            return [BDImageAdapter sharedAdapter].isRetry;
        };
        model.selectItem = ^{
            [BDImageAdapter sharedAdapter].isRetry = ![BDImageAdapter sharedAdapter].isRetry;
        };
        model;
    })];
    [array addObject:({
        BDImageSettingModel *model = [BDImageSettingModel new];
        model.name = @"预加载";
        model.type = BDImageSettingSelectType;
        model.showSelect = ^BOOL{
            return [BDImageAdapter sharedAdapter].isPrefetch;
        };
        model.selectItem = ^{
            [BDImageAdapter sharedAdapter].isPrefetch = ![BDImageAdapter sharedAdapter].isPrefetch;
        };
        model;
    })];
    [array addObject:({
        BDImageSettingModel *model = [BDImageSettingModel new];
        model.name = @"预解码";
        model.type = BDImageSettingSelectType;
        model.showSelect = ^BOOL{
            return [BDImageAdapter sharedAdapter].isDecodeForDisplay;
        };
        model.selectItem = ^{
            [BDImageAdapter sharedAdapter].isDecodeForDisplay = ![BDImageAdapter sharedAdapter].isDecodeForDisplay;
        };
        model;
    })];
    [array addObject:({
        BDImageSettingModel *model = [BDImageSettingModel new];
        model.name = @"开启图像超分";
        model.type = BDImageSettingSelectType;
        model.showSelect = ^BOOL{
            return [BDImageAdapter sharedAdapter].isSuperResolution;
        };
        model.selectItem = ^{
            [BDImageAdapter sharedAdapter].isSuperResolution = ![BDImageAdapter sharedAdapter].isSuperResolution;
        };
        model;
    })];
    [array addObject:({
        BDImageSettingModel *model = [BDImageSettingModel new];
        model.name = @"选择超分模型";
        model.info = @"3倍超分（VASR模型）";
        model.type = BDImageSettingInfoType;
        model;
    })];
    [array addObject:({
        BDImageSettingModel *model = [BDImageSettingModel new];
        model.name = @"超分文件来源";
        model.info = [BDImageAdapter sharedAdapter].srImagesUrl ?: @"url";
        model.type = BDImageSettingEditType;
        __weak BDImageSettingModel *weakModel = model;
        model.action = ^{
            [BDImageAdapter sharedAdapter].srImagesUrl = weakModel.info;
        };
        model;
    })];
    [array addObject:({
        BDImageSettingModel *model = [BDImageSettingModel new];
        model.name = @"缓存控制";
        model.type = BDImageSettingActionType;
        model;
    })];
    [array addObject:({
        BDImageSettingModel *model = [BDImageSettingModel new];
        model.name = @"清除缓存";
        [[BDImageAdapter sharedAdapter] updateCacheSize];
        model.info = @([BDImageAdapter sharedAdapter].cacheSize).stringValue;
        model.type = BDImageSettingActionType;
        model;
    })];
    return array;
}

+ (NSArray<BDImageSettingModel *> *)cacheSettingModels {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
    [array addObject:({
        BDImageSettingModel *model = [BDImageSettingModel new];
        model.name = @"忽略内存缓存";
        model.type = BDImageSettingSelectType;
        model.showSelect = ^BOOL{
            return [BDImageAdapter sharedAdapter].options & BDImageRequestIgnoreMemoryCache;
        };
        model.selectItem = ^{
            [BDImageAdapter sharedAdapter].options ^= BDImageRequestIgnoreMemoryCache;
        };
        model;
    })];
    [array addObject:({
        BDImageSettingModel *model = [BDImageSettingModel new];
        model.name = @"忽略磁盘缓存";
        model.type = BDImageSettingSelectType;
        model.showSelect = ^BOOL{
            return [BDImageAdapter sharedAdapter].options & BDImageRequestIgnoreDiskCache;
        };
        model.selectItem = ^{
            [BDImageAdapter sharedAdapter].options ^= BDImageRequestIgnoreDiskCache;
        };
        model;
    })];
    [array addObject:({
        BDImageSettingModel *model = [BDImageSettingModel new];
        model.name = @"下载后不存内存缓存";
        model.type = BDImageSettingSelectType;
        model.showSelect = ^BOOL{
            return [BDImageAdapter sharedAdapter].options & BDImageRequestNotCacheToDisk;
        };
        model.selectItem = ^{
            [BDImageAdapter sharedAdapter].options ^= BDImageRequestNotCacheToDisk;
        };
        model;
    })];
    return array;
}

@end
