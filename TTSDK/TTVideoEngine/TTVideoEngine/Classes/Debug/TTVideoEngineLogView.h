//
//  TTVideoEngineLogView.h
//  TTVideoEngine
//
//  Created by 黄清 on 2019/1/28.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TTVideoEngineViewLogType) {
    TTVideoEngineViewLogTypeInfo        = 0,
    TTVideoEngineViewLogTypeError       = 1,
    TTVideoEngineViewLogTypeSucceed     = 2,
};

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoEngineLogView : UIView

/// Add a log
- (void)addLogInfo:(NSString *)log type:(TTVideoEngineViewLogType)logType;

/// Clear logs
- (void)clearLogs;

@end

NS_ASSUME_NONNULL_END
