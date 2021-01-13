//
//  SourceViewController.h
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/13.


#import <Foundation/Foundation.h>

typedef NSString* SourceKey;
typedef NSString* SourceValue;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN SourceKey const SourceKeyURL;
FOUNDATION_EXTERN SourceKey const SourceKeyVid;
FOUNDATION_EXTERN SourceKey const SourceKeyAuth;
FOUNDATION_EXTERN SourceKey const SourceKeyTitle;
FOUNDATION_EXTERN SourceKey const SourceKeyPtoken;
FOUNDATION_EXTERN SourceKey const SourceKeyAuthWithHost;
FOUNDATION_EXTERN SourceKey const SourceKeyDash;
FOUNDATION_EXTERN SourceKey const SourceKeyHardWare;
FOUNDATION_EXTERN SourceKey const SourceKeyByteVC1;

@protocol SourceViewController <NSObject>

@required

/// Didmiss viewController
- (void)willDismiss;

/// Get history data
- (nullable NSArray *)historyInfos;

/// Delete history data
- (void)deleteHistoryInfos;

/// Update show info
- (void)setSources:(NSDictionary<SourceKey,SourceValue> *)sources;

@end

@class BaseViewController;
@protocol SourceViewControllerDelegate <NSObject>

@required
- (void)dismiss:(BaseViewController *)vc result:(NSDictionary<SourceKey,SourceValue> *)result;

@end

@protocol HistoryViewControllerDelegate <NSObject>

@required
- (void)select:(BaseViewController *)vc result:(NSDictionary<SourceKey,SourceValue> *)result;
- (void)deleteAllDatas:(BaseViewController *)vc;

@end

NS_ASSUME_NONNULL_END
