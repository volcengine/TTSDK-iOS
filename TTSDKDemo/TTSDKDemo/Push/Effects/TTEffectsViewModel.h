//
//  TTEffectsViewModel.h
//  TTSDKDemo
//
//  Created by 陈昭杰 on 2020/1/30.
//  Copyright © 2020 ByteDance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTEffectsModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^TTEffectsViewModelComposerNodesChangedBlock)(NSArray<NSString *> *currentComposerNodes);

typedef void(^TTEffectsViewModelComposerNodeIntensityChangedBlock)(NSString *path, NSString *key, CGFloat intensity);

typedef void(^TTEffectsViewModelStickerChangedBlock)(NSString *path);

typedef void(^TTEffectsViewModelFilterChangedBlock)(NSString *path);

typedef enum : NSUInteger {
    TTEffectsViewModelTypeUnknown,
    TTEffectsViewModelTypeEffect,
    TTEffectsViewModelTypeSticker,
} TTEffectsViewModelType;

typedef enum : NSUInteger {
    TTEffectsItemTypeUnknown,
    TTEffectsItemTypeAdjustable,
} TTEffectsItemType;

@interface TTEffectsViewModel : NSObject

@property (nonatomic, strong, readonly) NSArray<NSString *> *currentComposerNodes;

@property (nonatomic, strong, readonly) NSArray<NSString *> *currentCategories;

@property (nonatomic, assign) TTEffectsViewModelType type;

@property (nonatomic, copy) TTEffectsViewModelComposerNodesChangedBlock composerNodesChangedBlock;

@property (nonatomic, copy) TTEffectsViewModelComposerNodeIntensityChangedBlock composerNodeIntensityChangedBlock;

@property (nonatomic, copy) TTEffectsViewModelStickerChangedBlock stickerChangedBlock;

@property (nonatomic, copy) TTEffectsViewModelFilterChangedBlock filterChangedBlock;

- (instancetype)initWithModel:(TTEffectsModel *)model;

- (void)removeComposerNodesOfCategoryWithIndex:(NSInteger)index;

- (NSArray<NSString *> *)itemsOfCategoryWithIndex:(NSInteger)index;

- (CGFloat)intensityOfItemWithIndex:(NSIndexPath *)index;

- (void)updaetIntensityOfItemWithValue:(CGFloat)value index:(NSIndexPath *)index;

- (TTEffectsItemType)typeOfItemWithIndex:(NSIndexPath *)index;

@end

NS_ASSUME_NONNULL_END
