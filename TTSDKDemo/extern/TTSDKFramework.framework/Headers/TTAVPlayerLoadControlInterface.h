//
//  TTAVPlayerLoadControlInterface.h
//  TTAVPlayer
//
//  Created by wangchen.sh on 2020/8/6.
//

#import <Foundation/Foundation.h>

#ifndef TTM_DUAL_CORE_TTPLAYER_LOAD_CONTROL_PROTOCOL_H
#define TTM_DUAL_CORE_TTPLAYER_LOAD_CONTROL_PROTOCOL_H

NS_ASSUME_NONNULL_BEGIN

@protocol TTAVPlayerLoadControlInterface <NSObject>

- (BOOL) shouldStartPlayback:(int64_t)bufferedDurationMs withplaybackSpeed:(float)playbackSpeed withreBuffering:(BOOL)rebuffering;
- (NSInteger) onTrackSelected:(NSInteger)trackType;

@optional
- (NSInteger) onCodecStackSelected:(NSInteger)trackType;
- (NSInteger) onFilterStackSelected:(NSInteger)trackType;

@end

NS_ASSUME_NONNULL_END

#endif // TTM_DUAL_CORE_TTPLAYER_LOAD_CONTROL_PROTOCOL_H
