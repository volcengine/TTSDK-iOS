//
//  LiveStreamRawDataHelper.h
//  Pods
//
//  Created by 赵凯 on 2019/8/11.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LSRawDataSourceType) {
    LSRawDataSourceTypeOriginYUV = 0, //原始视频帧YUV裸数据
    LSRawDataSourceTypeOriginH264,//原始视频帧转录成264文件
    LSRawDataSourceTypeEffectedH264,//效果处理后视频帧转录成264文件
    LSRawDataSourceTypeEncoded, //Not supported
    LSRawDataSourceTypeUnknown,
};

typedef void (^LSRawDataRecordCompletionHandler)(NSError *error,LSRawDataSourceType type,NSURL *url);

@interface LiveStreamRawDataHelper : NSObject
@property (nonatomic,readonly) BOOL dumpIsFinished;
+ (instancetype)sharedInstance;

- (BOOL)processVideoPixelbuf:(CVPixelBufferRef) pixelbuf presentationTime:(CMTime) frameTime sourceType:(LSRawDataSourceType) type;

/**
 * 开启dump数据，dump的帧数duration*fps
 * @param duration     dump时长 单位秒
 * @param delay    延迟开始dump，延迟时间，单位秒
 * @param fps       视频帧率
 * @param completionHandler 处理完的通知回调,录制多个源，成功后会有多次回调
 */
- (void)startRecordingWithDuration:(NSTimeInterval)duration
                             delay:(NSTimeInterval)delay
                               fps:(NSUInteger)fps
             WithCompletionHandler:(LSRawDataRecordCompletionHandler)completionHandler;
- (void)setUserData:(NSDictionary *)user_data type:(LSRawDataSourceType)type;
- (void)resetRecording;
@end

NS_ASSUME_NONNULL_END
