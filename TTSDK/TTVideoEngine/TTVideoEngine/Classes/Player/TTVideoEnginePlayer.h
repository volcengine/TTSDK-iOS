//
//  TTVideoPlayer.h
//  testAVPlayer
//
//  Created by Chen Hong on 15/11/2.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "TTVideoEnginePlayerProtocol.h"

/*
 ## 基本用法
 
 self.playerController = [[TTAVMoviePlayerController alloc] initWithOwnPlayer:NO];
 
 self.playerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
 
 self.playerController.view.frame = self.view.bounds;
 
 self.playerController.view.backgroundColor = [UIColor blackColor];
 
 [self.view addSubview:self.playerController.view];
 
 [self.playerController setContentURLString:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"];
 
 [self.playerController prepareToPlay];
 
 [self.playerController play];
 
 ## 更多

 请参考TTAVMoviePlayerController的子类SSMoviePlayerController，
 
 */

@interface TTVideoEnginePlayer : NSObject<TTVideoEnginePlayer>

- (id)initWithOwnPlayer:(BOOL)isOwn;
- (void)setContentURLString:(NSString *)aUrl;
- (void)setValueString:(NSString *)valueString forKey:(NSInteger)key;
- (void)setCacheFile:(NSString *)cacheFile forMode:(int)mode;

- (NSString* )getIpAddress;

@end


