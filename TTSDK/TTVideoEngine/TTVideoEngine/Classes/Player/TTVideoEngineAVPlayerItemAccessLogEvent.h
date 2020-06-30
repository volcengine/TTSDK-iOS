//
//  TTAVPlayerItemAccessLogEvent.h
//  Article
//
//  Created by panxiang on 16/10/26.
//
//

#import <Foundation/Foundation.h>

@interface TTVideoEngineAVPlayerItemAccessLogEvent : NSObject
@property (nonatomic) NSString *URI;
@property (nonatomic) NSString *serverAddress;
@property (nonatomic) NSTimeInterval durationWatched;
@end
