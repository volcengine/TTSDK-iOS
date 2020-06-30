//
//  NSDictionary+TTVideoEngine.h
//  Pods
//
//  Created by guikunzhi on 16/12/22.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (TTVideoEngine)

- (NSDictionary *)ttVideoEngineDictionaryValueForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue;

- (NSArray *)ttVideoEngineArrayValueForKey:(NSString *)key defaultValue:(NSArray *)defaultValue;

- (int)ttVideoEngineIntValueForKey:(NSString *)key defaultValue:(int)defaultValue;

@end


@interface NSMutableDictionary(TTVideoEngine)

/// safe setObject:forKey:
- (void)ttvideo_setObject:(id)anObject forKey:(id<NSCopying>)aKey;

/// safe objectForKey:
- (id)ttvideo_objectForKey:(id)aKey;

@end
