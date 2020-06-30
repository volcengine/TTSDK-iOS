//
//  TTVideoEnginePlayUrlsSource.h
//  TTVideoEngine
//
//  Created by 黄清 on 2019/1/11.
//

#import "TTVideoEnginePlayBaseSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoEnginePlayUrlsSource : TTVideoEnginePlayBaseSource

@property (nonatomic, strong) NSArray<NSString *> *urls;

@end

NS_ASSUME_NONNULL_END
