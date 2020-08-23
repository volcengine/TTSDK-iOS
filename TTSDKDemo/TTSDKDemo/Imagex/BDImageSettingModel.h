//
//  BDImageSettingModel.h
//  BDWebImage_Example
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, BDImageSettingType)
{
    BDImageSettingSelectType = 0,
    BDImageSettingActionType = 1,
    BDImageSettingInfoType = 2,
    BDImageSettingEditType = 3,
};

@interface BDImageSettingModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BDImageSettingType type;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) void (^action)(void);
@property (nonatomic, copy) void (^selectItem)(void);
@property (nonatomic, copy) BOOL (^showSelect)(void);

+ (NSArray<BDImageSettingModel *> *)defaultSettingModels;
+ (NSArray<BDImageSettingModel *> *)cacheSettingModels;

@end

NS_ASSUME_NONNULL_END
