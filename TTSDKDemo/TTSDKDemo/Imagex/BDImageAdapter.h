//
//  BDImageAdapter.h
//  BDWebImage_Example
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^fetchCallback)(BOOL success);

@interface BDImageAdapter : NSObject

@property (nonatomic, assign) BDImageRequestOptions options;
@property (atomic, strong) NSString *record;
@property (nonatomic, assign) BOOL isPrefetch;
@property (nonatomic, assign) BOOL isCyclePlayAnim;
@property (nonatomic, assign) BOOL isRetry;
@property (nonatomic, assign) BOOL isDecodeForDisplay;
@property (atomic, strong) NSDictionary<NSString *, NSArray *> * urls;

+ (instancetype)sharedAdapter;

- (void)updateCacheSize;

- (NSUInteger)cacheSize;

- (void)fetchTestURLs:(NSString *)url Block:(fetchCallback)callback;

@end

NS_ASSUME_NONNULL_END
