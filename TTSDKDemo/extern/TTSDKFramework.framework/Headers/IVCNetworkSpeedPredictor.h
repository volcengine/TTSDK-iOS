//
//  IVCNetSpeedPredictor.h
//  Networkmodule
//
//  Created by guikunzhi on 2020/3/30.
//  Copyright © 2020 gkz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IVCNetworkSpeedRecord.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, NetworkPredictAlgoType) {
    NetworkPredictAlgoTypeHECNET = 0,
    NetworkPredictAlgoTypeHANET = 1,
    NetworkPredictAlgoTypeANET = 2,
    NetworkPredictAlgoTypeLSTMNET = 3,
};

@protocol IVCNetworkSpeedPredictor <NSObject>

- (float)getPredictSpeed;
- (float)getDownloadSpeed;
- (void)update:(NSObject<IVCNetworkSpeedRecord> *)speedRecord;

@end

NS_ASSUME_NONNULL_END
