//
//  BaseListModel.h
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/12.


#import <Foundation/Foundation.h>
#import "BaseListModelProtocol.h"
#import <MJExtension/MJExtension.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseListModel : NSObject<BaseListModelProtocol, MJCoding>

@end

NS_ASSUME_NONNULL_END
