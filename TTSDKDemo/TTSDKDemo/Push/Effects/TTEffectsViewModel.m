//
//  TTEffectsViewModel.m
//  TTSDKDemo
//
//  Created by 陈昭杰 on 2020/1/30.
//  Copyright © 2020 ByteDance. All rights reserved.
//

#import "TTEffectsViewModel.h"

static NSString * const kCategotyNameBeautyFace = @"美颜";
static NSString * const kCategotyNameBeautyReshape = @"美形";
static NSString * const kCategotyNameBeautyBody = @"美体";
static NSString * const kCategotyNameMakeup = @"美妆";
static NSString * const kCategotyNameFilter = @"滤镜";
static NSString * const kCategotyNameSticker = @"贴纸";

@interface TTEffectsViewModel ()

@property (nonatomic, strong) TTEffectsModel *model;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *currentNodes;

@property (nonatomic, strong) NSDictionary *nodeMap;

@property (nonatomic, strong) NSArray *menuViewModel;

@end

@implementation TTEffectsViewModel

- (instancetype)initWithModel:(TTEffectsModel *)model {
    if (self = [self init]) {
        _currentNodes = [NSMutableDictionary dictionary];
        _type = TTEffectsViewModelTypeUnknown;
        _model = model;
        [self updateNodeMap];
    }
    return self;
}

- (NSArray<NSString *> *)currentCategories {
    NSMutableArray *categories = [NSMutableArray array];
    for (NSInteger index = 0; index < self.menuViewModel.count; index++) {
        [categories addObject:[[[self.menuViewModel objectAtIndex:index] allKeys] firstObject]];
    }
    return categories.copy;
}

- (void)removeComposerNodesOfCategoryWithIndex:(NSInteger)index {
    if ([[self.currentCategories objectAtIndex:index] isEqualToString:kCategotyNameFilter]) {
        [self updateFilter:@""];
    } else if ([[self.currentCategories objectAtIndex:index] isEqualToString:kCategotyNameSticker]) {
        [self updateSticker:@""];
    } else {
        NSArray *itemsName = [[[self.menuViewModel objectAtIndex:index] allValues] firstObject];
        for (NSString *itemName in itemsName) {
            [self.currentNodes removeObjectForKey:[self.nodeMap objectForKey:itemName]];
        }
        [self updateWithNodes:self.currentNodes.allKeys];
    }
}

- (NSArray<NSString *> *)itemsOfCategoryWithIndex:(NSInteger)index {
    if (index < 0) {
        return @[];
    }
    NSMutableArray *items = [NSMutableArray array];
    [items addObjectsFromArray:[[[self.menuViewModel objectAtIndex:index] allValues] firstObject]];
    return items.copy;
}

- (CGFloat)intensityOfItemWithIndex:(NSIndexPath *)index {
    NSString *node = [self nodeWithIndex:index];
    NSNumber *intensity = [self.currentNodes objectForKey:node];
    return intensity ? intensity.floatValue : 0;
}

- (void)updaetIntensityOfItemWithValue:(CGFloat)value index:(NSIndexPath *)index {
    NSString *node = [self nodeWithIndex:index];
    if ([node hasPrefix:self.model.filterPath]) {
        [self updateFilter:node];
    } else if ([node hasPrefix:self.model.stickerPath]) {
        [self updateSticker:node];
    } else {
        NSString *key = [self keyOfNode:node];
        NSString *path = [self pathOfNode:node];
        [self.currentNodes setObject:@(value) forKey:node];
        [self updateWithNodes:self.currentNodes.allKeys];
        if (self.composerNodeIntensityChangedBlock) {
            self.composerNodeIntensityChangedBlock(path, key, value);
        }
    }
}

- (TTEffectsItemType)typeOfItemWithIndex:(NSIndexPath *)index {
    NSString *node = [self nodeWithIndex:index];
    BOOL isFilter = [node hasPrefix:self.model.filterPath];
    BOOL isSticker = [node hasPrefix:self.model.stickerPath];
    BOOL hasKey = ![node hasSuffix:@"/"];
    return hasKey && !isFilter && !isSticker ? TTEffectsItemTypeAdjustable : TTEffectsItemTypeUnknown;
}

// MARK: Private Methods

- (void)updateSticker:(NSString *)path {
    if (self.stickerChangedBlock) {
        self.stickerChangedBlock(path);
    }
}

- (void)updateFilter:(NSString *)path {
    if (self.filterChangedBlock) {
        self.filterChangedBlock(path);
    }
}

- (NSString *)pathOfNode:(NSString *)node {
    if ([node hasSuffix:@"/"]) {
        return node;
    } else {
        return [node stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@", [self keyOfNode:node]] withString:@""];
    }
}

- (NSString *)keyOfNode:(NSString *)node {
    return [[node componentsSeparatedByString:@"/"] lastObject];
}

- (void)updateWithNodes:(NSArray *)nodes {
    NSMutableArray *paths = [NSMutableArray array];
    for (NSString *node in nodes) {
        NSString *path = [self pathOfNode:node];
        if ([paths containsObject:path]) {
            continue;
        }
        [paths addObject:path];
    }
    if (self.composerNodesChangedBlock) {
        self.composerNodesChangedBlock(paths);
    }
}

- (NSArray *)menuViewModel {
    if (self.type == TTEffectsViewModelTypeEffect) {
        return @[
            @{
                kCategotyNameBeautyFace: @[
                        @"锐化",
                        @"磨皮",
                        @"美白",
                        @"亮眼",
                        @"黑眼圈",
                        @"法令纹",
                        @"白牙",
                ],
            },
            @{
                kCategotyNameBeautyReshape: @[
                        @"瘦脸",
                        @"大眼",
                        @"痩鼻",
                ],
            },
            @{
                kCategotyNameBeautyBody: @[
                        @"瘦身",
                        @"长腿",
                ],
            },
            @{
                kCategotyNameMakeup: @[
                        @"口红",
                        @"染发",
                        @"眼影",
                ],
            },
            @{
                kCategotyNameFilter: @[
                        @"柔白",
                        @"奶油",
                        @"氧气",
                        @"桔梗",
                        @"洛丽塔",
                        @"蜜桃",
                        @"马卡龙",
                        @"泡沫",
                        @"樱花",
                ],
            },
        ];
    } else {
        return @[
            @{
                kCategotyNameSticker: @[
                        @"彩小猫",
                        @"三只懒猫",
                        @"扯脸猫",
                        @"颜值扫描",
                        @"皮卡丘",
                ]
            },
        ];
    }
}

- (void)updateNodeMap {
    self.nodeMap = @{
        @"锐化": [NSString stringWithFormat:@"%@/sharp", self.model.beautyFacePath],
        @"磨皮": [NSString stringWithFormat:@"%@/smooth", self.model.beautyFacePath],
        @"美白": [NSString stringWithFormat:@"%@/whiten", self.model.beautyFacePath],
        @"亮眼": [NSString stringWithFormat:@"%@/BEF_BEAUTY_BRIGHTEN_EYE", self.model.beautyFacialItemPath],
        @"黑眼圈": [NSString stringWithFormat:@"%@/BEF_BEAUTY_REMOVE_POUCH", self.model.beautyFacialItemPath],
        @"法令纹": [NSString stringWithFormat:@"%@/BEF_BEAUTY_SMILES_FOLDS", self.model.beautyFacialItemPath],
        @"白牙": [NSString stringWithFormat:@"%@/BEF_BEAUTY_WHITEN_TEETH", self.model.beautyFacialItemPath],
        @"瘦脸": [NSString stringWithFormat:@"%@/Internal_Deform_Overall", self.model.beautyReshapePath],
        @"大眼": [NSString stringWithFormat:@"%@/Internal_Deform_Eye", self.model.beautyReshapePath],
        @"痩鼻": [NSString stringWithFormat:@"%@/Internal_Deform_Nose", self.model.beautyReshapePath],
        @"瘦身": [NSString stringWithFormat:@"%@/", self.model.beautyBodyThinPath],
        @"长腿": [NSString stringWithFormat:@"%@/", self.model.beautyBodyLongLegPath],
        @"口红": [NSString stringWithFormat:@"%@/Internal_Makeup_Lips", self.model.makeupLipPath],
        @"染发": [NSString stringWithFormat:@"%@/", self.model.makeupHairPath],
        @"眼影": [NSString stringWithFormat:@"%@/Internal_Makeup_Eye", self.model.makeupEyeshadowPath],
        @"柔白": [NSString stringWithFormat:@"%@/Filter_01_38", self.model.filterPath],
        @"奶油": [NSString stringWithFormat:@"%@/Filter_02_14", self.model.filterPath],
        @"氧气": [NSString stringWithFormat:@"%@/Filter_03_20", self.model.filterPath],
        @"桔梗": [NSString stringWithFormat:@"%@/Filter_04_12", self.model.filterPath],
        @"洛丽塔": [NSString stringWithFormat:@"%@/Filter_05_10", self.model.filterPath],
        @"蜜桃": [NSString stringWithFormat:@"%@/Filter_06_03", self.model.filterPath],
        @"马卡龙": [NSString stringWithFormat:@"%@/Filter_07_06", self.model.filterPath],
        @"泡沫": [NSString stringWithFormat:@"%@/Filter_08_17", self.model.filterPath],
        @"樱花": [NSString stringWithFormat:@"%@/Filter_09_19", self.model.filterPath],
        @"彩小猫": [NSString stringWithFormat:@"%@/e31f163f969a35655b1953c4cdf49d77", self.model.stickerPath],
        @"三只懒猫": [NSString stringWithFormat:@"%@/623a287f5dd0bc5e914716778edf5834", self.model.stickerPath],
        @"扯脸猫": [NSString stringWithFormat:@"%@/47127c515e75a6198c17d9833403de06", self.model.stickerPath],
        @"颜值扫描": [NSString stringWithFormat:@"%@/1ada96a8bdfe03333a8192b32163e7b2", self.model.stickerPath],
        @"皮卡丘": [NSString stringWithFormat:@"%@/973855381b6e36fc862848be4eb2d209", self.model.stickerPath],
    };
}

- (NSString *)nodeWithIndex:(NSIndexPath *)indexPath {
    NSArray *items = [[[self.menuViewModel objectAtIndex:indexPath.section] allValues] firstObject];
    return [self.nodeMap objectForKey:[items objectAtIndex:indexPath.row]];
}

@end
