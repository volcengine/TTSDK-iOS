//
//  BDImageCacheConfig.h
//  BDWebImage
//
//

#import <Foundation/Foundation.h>

@protocol BDMemoryCache;
@protocol BDDiskCache;

// 缓存配置项，初始化方法会有默认值，注意修改完以后需要重新设置到缓存的config属性上方可生效
@interface BDImageCacheConfig : NSObject <NSCopying>

#pragma mark - Memory
// 内存缓存，会在写入新的内存对象时，检查是否过期并进行清理操作，因此这里配置指的是清理全部内存缓存的策略
@property (nonatomic, assign) BOOL clearMemoryOnMemoryWarning; // 是否内存低时清除所有内存缓存，默认YES
@property (nonatomic, assign) BOOL clearMemoryWhenEnteringBackground; // 是否进入后台时清除所有内存缓存，默认YES
@property (assign, nonatomic) BOOL shouldUseWeakMemoryCache; //是否使用 weak cache 优化内存缓存
@property (nonatomic, assign) NSUInteger memoryCountLimit; // 最大内存缓存对象数量限制，默认无限制
@property (nonatomic, assign) NSUInteger memorySizeLimit; // 最大内存缓存大小，字节数（Attention，单位 byte），默认256MB
@property (nonatomic, assign) NSUInteger memoryAgeLimit; // 最大内存过期时间，秒数，默认12小时

#pragma mark - Disk
// 磁盘缓存，一般只有手动调用方法才会检查超过大小限制或过期缓存，并进行清理操作，因此这里配置指的是清理超限或者过期缓存的策略
@property (nonatomic, assign) BOOL trimDiskWhenEnteringBackground; // 是否进入后台时清除超限或者过期磁盘缓存，默认YES
@property (nonatomic, assign) NSUInteger diskCountLimit; // 最大磁盘缓存对象数量限制，默认无限制
@property (nonatomic, assign) NSUInteger diskSizeLimit; // 最大磁盘缓存大小，字节数，默认256MB
@property (nonatomic, assign) NSUInteger diskAgeLimit; // 最大磁盘缓存过期时间，秒数，默认7天
@property (assign, nonatomic) BOOL shouldDisableiCloud; //磁盘缓存不支持从 iCloud 同步，默认YES
@end
