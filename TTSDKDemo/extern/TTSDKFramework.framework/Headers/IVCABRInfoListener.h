
//
//  IVCABRInfoListener.h
//  test
//
//  Created by guikunzhi on 2020/3/29.
//  Copyright © 2020 gkz. All rights reserved.
//

#ifndef IVCABRInfoListener_h
#define IVCABRInfoListener_h

#import <Foundation/Foundation.h>

static int ON_GET_PREDICT_RESULT = 1;

@protocol IVCABRInfoListener <NSObject>

- (void)onInfo:(int)code withDetail:(int)detailCode;

@end

#endif /* IVCABRInfoListener_h */
