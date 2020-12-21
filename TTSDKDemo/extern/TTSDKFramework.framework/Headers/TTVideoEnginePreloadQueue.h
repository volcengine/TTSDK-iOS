//
//  TTVideoEnginePreloadQueue.h
//  TTVideoEngine
//
//  Created by 黄清 on 2018/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTVideoEnginePreloadQueueItem <NSObject>

- (NSString *)itemKey;

@end

// TTVideoEnginePreloadQueue
//                                                enqueue
//                                                  |
//  <----------<-----------<-------------<----------<
//  <----------<-----------<-------------<----------^
//  |                                               |
// front                                           back
//
@interface TTVideoEnginePreloadQueue : NSObject

@property(atomic, assign) NSInteger maxCount;

@property(nonatomic, assign, readonly) NSInteger count;

- (nullable id<TTVideoEnginePreloadQueueItem>)frontItem;

- (nullable id<TTVideoEnginePreloadQueueItem>)popFrontItem;

- (nullable id<TTVideoEnginePreloadQueueItem>)backItem;

- (nullable id<TTVideoEnginePreloadQueueItem>)popBackItem;

/// Return the first item.
- (nullable id<TTVideoEnginePreloadQueueItem>)itemForKey:(NSString *)key;

/// Return & pop the first item.
- (nullable id<TTVideoEnginePreloadQueueItem>)popItemForKey:(NSString *)key;

- (BOOL)enqueueItem:(id<TTVideoEnginePreloadQueueItem>)item;

- (BOOL)containItem:(id<TTVideoEnginePreloadQueueItem>)item;

- (BOOL)containItemForKey:(NSString *)key;

- (void)popAllItems;

- (NSArray *)itemsForKey:(NSString *)key;

- (void)popItem:(id<TTVideoEnginePreloadQueueItem>)item;

@end

NS_ASSUME_NONNULL_END
