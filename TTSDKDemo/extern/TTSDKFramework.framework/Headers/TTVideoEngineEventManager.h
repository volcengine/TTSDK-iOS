//
//  TTVideoEngineEventManager.h
//  Pods
//
//  Created by guikunzhi on 16/12/23.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TTVideoEngineEventManager;
@protocol TTVideoEngineEventManagerProtocol <NSObject>

@optional

/**
 called when video event log comes

 @param eventManager event manager
 */
- (void)eventManagerDidUpdate:(TTVideoEngineEventManager *)eventManager;

@optional
/**
  called when video event log comes, use eventV3
    @param eventManager
    @param eventName
    @param params
 */
- (void)eventManagerDidUpdateV2:(TTVideoEngineEventManager *)eventManager eventName:(NSString*)eventName params:(NSDictionary*)params;

@end

static const NSInteger TTEVENT_LOG_VERSION_OLD = 1;
static const NSInteger TTEVENT_LOG_VERSION_NEW = 2;

@interface TTVideoEngineEventManager : NSObject

@property (nonatomic, nullable, weak) id<TTVideoEngineEventManagerProtocol> delegate;

@property (nonatomic, nullable, weak) id<TTVideoEngineEventManagerProtocol> innerDelegate;

+ (instancetype)sharedManager;

- (void)setLogVersion:(NSInteger)version;

- (NSInteger)logVersion;

- (void)addEvent:(NSDictionary *)event;

- (void)addEventV2:(NSDictionary *)event eventName:(NSString*)eventName;


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

NS_ASSUME_NONNULL_END
