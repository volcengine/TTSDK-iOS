//
//  ABRResult.h
//  abrmodule
//
//  Created by guikunzhi on 2020/3/29.
//  Copyright © 2020 gkz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCABRResultElement.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCABRResult : NSObject

- (void)addElement:(VCABRResultElement *)element;

- (int)getSize;

- (VCABRResultElement *)elementAtIndex:(int)index;

@end

NS_ASSUME_NONNULL_END
