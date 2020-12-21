//
//  TTVideoEngineEventManager.h
//  Pods
//
//  Created by guikunzhi on 16/12/23.
//
//

#import <Foundation/Foundation.h>

@class TTVideoEngineEventManager;
@protocol TTVideoEngineEventManagerProtocol <NSObject>

@optional

/**
 called when video event log comes

 @param eventManager event manager
 */
- (void)eventManagerDidUpdate:(TTVideoEngineEventManager *)eventManager;

@end

@interface TTVideoEngineEventManager : NSObject

@property (nonatomic, weak) id<TTVideoEngineEventManagerProtocol> delegate;

+ (instancetype)sharedManager;

- (void)addEvent:(NSDictionary *)event;


/**
 You can get all log events when the delegate method called.

 @return log events array
 */
- (NSArray<NSDictionary *> *)popAllEvents;


/**
 You can get the latest events

 @return the latest events array
 */
- (NSArray<NSDictionary *> *)feedbackEvents;

@end

@interface TTVideoEngineEventManager (Private)
- (void)private_addLogData:(NSDictionary *)event;
@end


