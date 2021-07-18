//
//  BDWebImageRequestBlocks.h
//  BDWebImage
//
//  Created by 陈奕 on 2020/10/30.
//

#import <Foundation/Foundation.h>
#import "BDWebImageRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDWebImageRequestBlocks : NSObject

@property (nonatomic, copy)BDImageRequestProgressBlock progressBlock;
@property (nonatomic, copy)BDImageRequestCompletedBlock completedBlock;
@property (nonatomic, copy)BDImageRequestDecryptBlock decryptBlock;

@end

NS_ASSUME_NONNULL_END
