//
//  TTVideoEngineThumbInfo.h
//  Pods
//
//  Created by guikunzhi on 2018/5/2.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface TTVideoEngineThumbInfo : NSObject

@property (nonatomic, assign) NSInteger imageNum;
@property (nonatomic, copy) NSString *uri;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, assign) NSInteger imageXSize;
@property (nonatomic, assign) NSInteger imageYSize;
@property (nonatomic, assign) NSInteger imageXLen;
@property (nonatomic, assign) NSInteger imageYLen;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat interval;
@property (nonatomic, copy) NSString *fext;

- (instancetype)initWithDictionary:(NSDictionary *)jsonDict;

- (NSInteger)getValueInt:(NSInteger)key;

- (CGFloat)getValueFloat:(NSInteger)key;

- (NSString *)getValueStr:(NSInteger)key;
@end
