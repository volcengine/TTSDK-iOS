//
//  TTOwnAVPlayer.h
//  Pods
//
//  Created by guikunzhi on 16/12/6.
//
//

#import <Foundation/Foundation.h>
#import "TTVideoEnginePlayerDefine.h"
#import "TTVideoEnginePlayer.h"

@interface TTVideoEngineOwnPlayer : NSObject <TTVideoEnginePlayer>

- (void)setValueString:(NSString *)string forKey:(int)key;

- (void)setCacheFile:(NSString *)path mode:(int)mode;

- (int64_t)getInt64ValueForKey:(int)key;

- (int)getIntValueForKey:(int)key;

- (NSString* )getIpAddress;

@end
