//
//  IABRInitParams.h
//  abrmodule
//
//  Created by guikunzhi on 2020/3/29.
//  Copyright © 2020 gkz. All rights reserved.
//

#ifndef IVCABRInitParams_h
#define IVCABRInitParams_h

#import <Foundation/Foundation.h>

@protocol IVCABRInitParams <NSObject>

- (int64_t)getStartTime;
- (float)getProbeInterval;
- (int)getTrackType;

@end

#endif /* IABRInitParams_h */
