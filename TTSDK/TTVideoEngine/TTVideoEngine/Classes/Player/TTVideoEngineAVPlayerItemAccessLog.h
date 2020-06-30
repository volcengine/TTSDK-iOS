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

@interface TTVideoEngineAVPlayerItemAccessLog : NSObject
@property (nonatomic, readonly) NSArray<TTVideoEngineAVPlayerItemAccessLogEvent *> *events;
@property (nonatomic) AVPlayerItemAccessLog *accessLog;
- (void)addEvent:(TTVideoEngineAVPlayerItemAccessLogEvent *)event;
- (void)clearEvent;
@end
