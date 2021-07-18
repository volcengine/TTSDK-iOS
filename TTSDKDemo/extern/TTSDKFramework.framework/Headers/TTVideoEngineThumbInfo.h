//
//  TTVideoEngineThumbInfo.h
//  Pods
//
//  Created by guikunzhi on 2018/5/2.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


NS_ASSUME_NONNULL_BEGIN

@interface TTVideoEngineThumbInfo : NSObject<NSSecureCoding>

@property (nonatomic, assign) NSInteger imageNum;
@property (nonatomic, nullable, copy) NSString *uri;
@property (nonatomic, nullable, copy) NSString *imageURL;
@property (nonatomic, assign) NSInteger imageXSize;
@property (nonatomic, assign) NSInteger imageYSize;
@property (nonatomic, assign) NSInteger imageXLen;
@property (nonatomic, assign) NSInteger imageYLen;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat interval;
@property (nonatomic, nullable, copy) NSString *fext;
@property (nonatomic, nullable, copy) NSArray<NSString *> *imageURLs;

- (instancetype)initWithDictionary:(NSDictionary *)jsonDict;

- (NSInteger)getValueInt:(NSInteger)key;

- (CGFloat)getValueFloat:(NSInteger)key;

- (nullable NSString *)getValueStr:(NSInteger)key;

- (nullable NSMutableArray<NSString *> *)getValueArray:(NSInteger)key;

@end

NS_ASSUME_NONNULL_END
