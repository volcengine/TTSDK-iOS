//
//  LiveStreamMediaSource.h
//  LiveStreamFramework
//
//  Created by KeeeeC on 2019/5/29.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import "LiveStreamLinkInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSStreamMediaSource: NSObject
- (instancetype)initWithLinkInfo:(LiveStreamLinkInfo *)linkInfo;
- (LiveStreamLinkInfo *)linkInfo;
@end;

@class AudioSource;
@interface LSStreamAudioSource : LSStreamMediaSource
- (AudioSource *)getNativeSource;
@end

@interface LSStreamVideoSource : LSStreamMediaSource
@end

NS_ASSUME_NONNULL_END
