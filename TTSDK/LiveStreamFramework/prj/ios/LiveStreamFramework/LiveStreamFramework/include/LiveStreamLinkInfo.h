//
//  LiveStreamLinkUser.h
//  Pods
//
//  Created by 赵凯 on 2019/5/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LSLinkUserFlags)
{
    LSLinkUserTags_FIT_MODE     = (0x01 << 0),
    LSLinkUserTags_MIRROR_Y     = (0x01 << 1),
    LSLinkUserTags_MIRROR_X     = (0x01 << 2),
};

typedef NS_ENUM(NSUInteger, LSLinkUserVideoMode)
{
    LSLinkUserVideoMode_FIT         = 1,//FIT 模式会做等比例scale，画面内容完整，如果比例不等则填充黑边
    LSLinkUserVideoMode_FILL        = 2,//FILL 模式会做最大等比例crop，画面内容可能不完整，但不会填充黑边
};


@interface LiveStreamLinkInfo : NSObject

/**
 用户id 唯一标识
 */
@property (nonatomic, copy)      NSString *uid;
@property (nonatomic, assign)    NSInteger fps;
@property (nonatomic, assign)    CGSize outputSize;

#pragma mark - Layout
// 取之范围为 0 - 1
// 布局如下
//     <--------[0, 1]----------->
//  ^  +------------+-----+------+
//  |  |                         |
//  |  |                         |
//  |  |       (x,y)             |
//  |  |         +--+---------+  |
//[0,1]|         |    width   |  |
//  |  |         |            |  |
//  |  |      height          |  |
//  |  |         |            |  |
//  |  |         +------------+  |
//  |  |                         |
//  v  +-------------------------+
//
@property (nonatomic, assign)    double     x;      //[0, 1.0]
@property (nonatomic, assign)    double     y;      //[0, 1.0]
@property (nonatomic, assign)    double     width;  //[0, 1.0]
@property (nonatomic, assign)    double     height; //[0, 1.0]

@property (nonatomic, assign)    NSInteger  zOrder;
@property (nonatomic, readonly)  int        flags;
@property (nonatomic, assign)    LSLinkUserVideoMode videoMode;
@property (nonatomic, getter=isMirrored) BOOL mirrored;  //基于Y轴镜像


/**
 取值范围 [0.0 ~ 2.0]
 */
@property (nonatomic, assign) CGFloat volume;

/*
 * The number of channels in each frame of data.
 */
@property (nonatomic, assign) int channelsPerFrame;
/*
 * The number of bytes in a packet of data.
 */
@property (nonatomic, assign) int bytesPerFrame;
/*
 * The number of bits of sample data for each channel in a frame of data.
 */
@property (nonatomic, assign) int bitsPerChannel;
/*
 * The number of sample frames per second of the data in the stream.
 */
@property (nonatomic, assign) int sampleRate;

@end

NS_ASSUME_NONNULL_END
