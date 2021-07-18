//
//  TTAVPlayerItemAccessLogEvent.h
//  Article
//
//  Created by panxiang on 16/10/26.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoEngineAVPlayerItemAccessLogEvent : NSObject
@property (nonatomic, nullable, copy) NSString *URI;
@property (nonatomic, nullable, copy) NSString *serverAddress;
@property (nonatomic) NSTimeInterval durationWatched;
@end

NS_ASSUME_NONNULL_END
