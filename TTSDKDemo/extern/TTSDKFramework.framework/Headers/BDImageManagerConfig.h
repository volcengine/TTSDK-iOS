//
//  BDImageManagerConfig.h
//  BDWebImageToB
//
//  Created by 陈奕 on 2020/6/17.
//

#import <Foundation/Foundation.h>
#import "BDWebImage.h"
#import "BDWebImageStartUpConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDImageManagerConfig : NSObject

@property (nonatomic, copy) BDWebImageStartUpConfig *startUpConfig;

@property (atomic, assign) NSInteger monitorRate;

@property (atomic, assign) NSInteger errorMonitorRate;

@property (atomic, strong) NSArray<NSString *> *addedComponents;
@property (atomic, strong) NSDictionary<NSString *, NSString *> *verifyErr;

@property (nonatomic, strong) NSString *settingStr;
@property (nonatomic, strong) NSString *authCodesStr;

+ (BDImageManagerConfig *)sharedInstance;

- (void)startFetchConfig;

@end

NS_ASSUME_NONNULL_END
