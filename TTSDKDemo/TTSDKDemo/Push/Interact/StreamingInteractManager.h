//
//  StreamingInteractManager.h
//  TTSDKDemo
//
//  Created by guojieyuan on 2021/11/9.
//  Copyright © 2021 ByteDance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class StreamConfigurationModel;

@interface StreamingInteractManager : NSObject

@property (nonatomic, readonly) UIView *previewContainer;

- (void)joinChannel;

- (BOOL)processVideoPixelbuf:(CVPixelBufferRef)pixelbuf presentationTime:(CMTime) frameTime;

- (void)dismiss;

+ (UIAlertController *)joinRoomRequestIsHost:(BOOL)isHost
                              configurations:(StreamConfigurationModel *)config
                               completeBlock:(void (NS_NOESCAPE^)(StreamingInteractManager *obj))block;

@end

@protocol StreamingInteractManagerDelegate <NSObject>

- (void)interactManagerUserShouldSetupRemoteViewFor:(StreamingInteractManager *)manager;

@end

NS_ASSUME_NONNULL_END
