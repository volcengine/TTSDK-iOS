//
//  TTAVPlayerItemAccessLog.h
//  Article
//
//  Created by panxiang on 16/10/26.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "TTVideoEngineAVPlayerItemAccessLogEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoEngineAVPlayerItemAccessLog : NSObject
@property (nonatomic, nullable,readonly) NSArray<TTVideoEngineAVPlayerItemAccessLogEvent *> *events;
@property (nonatomic, nullable) AVPlayerItemAccessLog *accessLog;
- (void)addEvent:(TTVideoEngineAVPlayerItemAccessLogEvent *)event;
- (void)clearEvent;
@end

NS_ASSUME_NONNULL_END
