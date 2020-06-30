//
//  NSArray+TTVideoEngine.h
//  Pods
//
//  Created by 钟少奋 on 2017/5/18.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (TTVideoEngine)

- (NSArray *)ttVideoEngine_map:(id(^)(id obj, NSUInteger idx))block;

/// safe objectAtIndex:
- (id)ttvideo_objectAtIndex:(NSInteger)index;

/// safe objectAtIndex:class:
- (id)ttvideo_objectAtIndex:(NSInteger)index class:(Class)aClass;

@end


@interface NSMutableArray (TTVideoEngine)

/// safe addObject:
- (void)ttvideo_addObject:(id)anObject;

/// safe insertObject:atIndex:
- (void)ttvideo_insertObject:(id)anObject atIndex:(NSInteger)index;

/// safe replaceObjectAtIndex:withObject:
- (void)ttvideo_replaceObjectAtIndex:(NSInteger)index withObject:(id)anObject;

/// safe removeObjectAtIndex:
- (void)ttvideo_removeObjectAtIndex:(NSUInteger)index;

/// safe removeObject:
- (void)ttvideo_removeObject:(id)anObject;

@end
