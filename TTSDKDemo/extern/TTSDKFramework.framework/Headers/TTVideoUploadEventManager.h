//
//  TTVideoUploadEventManager.h
//  TTFileUpload
//
//  Created by guikunzhi on 2017/5/19.
//  Copyright © 2017年 gkz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTVideoUploadEventManager;
@protocol TTVideoUploadEventManagerProtocol <NSObject>

@optional

- (void)eventManagerDidUpdate:(TTVideoUploadEventManager *)eventManager;

@end

@interface TTVideoUploadEventManager : NSObject

@property (nonatomic, weak) id<TTVideoUploadEventManagerProtocol> delegate;

+ (instancetype)sharedManager;

- (void)addEvent:(NSDictionary *)event;

- (NSArray<NSDictionary *> *)popAllEvents;

@end
