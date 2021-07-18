//
//  SSTTVideoEngineDebugVideoInfoView.h
//  Article
//
//  Created by guoyuhang on 2020/3/2.
//

#import <UIKit/UIKit.h>
#import "TTVideoEngineModelDef.h"
#import "TTVideoEnginePlayerDefine.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TTVideoEngineDebugVideoInfoViewDelegate;
@class TTVideoEngineDebugVideoInfoState;

@interface TTVideoEngineDebugVideoInfoView : UIView

@property (nonatomic) BOOL catchingLog;
@property (nonatomic, weak) id<TTVideoEngineDebugVideoInfoViewDelegate> delegate;
@property (nonatomic) BOOL isFullScreen;

//videoinfo
@property (nonatomic, copy) NSString *videoId;
@property (nonatomic, copy) NSString *sdkVersion;
@property (nonatomic, copy) NSString *pcVersion;
@property (nonatomic, copy) NSString *netClient;
@property (nonatomic, copy) NSString *authToken;
@property (nonatomic, copy) NSString *playUrl;
@property (nonatomic, copy) NSString *playerLog;
@property (nonatomic, copy) NSDictionary *jsonVideoInfo;
@property (nonatomic, copy) NSDictionary *mainError;
@property (nonatomic, copy) NSString *initialIp;
@property (nonatomic, copy) NSString *internalIp;
@property (nonatomic, copy) NSString *apiString;
@property (nonatomic, copy) NSString *auth;
@property (nonatomic, copy) NSString *sourceType;

//视频指标 codec
@property (nonatomic) long long vpls; 
@property (nonatomic) long long bytesTransferred;
@property (nonatomic) long long bytesPlayed;
@property (nonatomic) long long downloadSpeed;
@property (nonatomic) long long videoBufferLength;
@property (nonatomic) long long audioBufferLength;
@property (nonatomic, copy) NSString *codecType;
@property (nonatomic, copy) NSString *formatType;
@property (nonatomic) TTVideoEngineResolutionType resolutionType;
@property (nonatomic) TTVideoEnginePlaybackState playbackState;
@property (nonatomic) TTVideoEngineLoadState loadState;
@property (nonatomic) NSInteger videoWidth;
@property (nonatomic) NSInteger videoHeight;
@property (nonatomic) NSInteger seekCount;
@property (nonatomic) NSInteger loopCount;
@property (nonatomic) NSInteger bufferCount;
@property (nonatomic, copy) NSString *audioName;
@property (nonatomic, copy) NSString *videoName;
@property (nonatomic, assign) CGFloat outputFps;
@property (nonatomic, copy) NSString *containerFps;
@property (nonatomic, copy) NSString *playBytes;
@property (nonatomic, copy) NSString *videoSize;
@property (nonatomic, copy) NSString *errorInfo;


//首帧指标 duration
@property (nonatomic) long readHeaderDuration;
@property (nonatomic) long readFirstVideoPktDuration;
@property (nonatomic) long firstFrameDecodedDuration;
@property (nonatomic) long firstFrameRenderDuration;
@property (nonatomic) long playbackBufferEndDuration;
@property (nonatomic) long firstFrameDuration;
@property (nonatomic) NSInteger playedTime;
@property (nonatomic) NSTimeInterval currentPlaybackTime;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSTimeInterval durationWatched;
@property (nonatomic) NSTimeInterval playableDuration;
@property (nonatomic) long long pt;
@property (nonatomic) long long at;
@property (nonatomic) long long dnsT;
@property (nonatomic) long long tranCT;
@property (nonatomic) long long tranFT;
@property (nonatomic) long long reVideoframeT;
@property (nonatomic) long long reAudioframeT;
@property (nonatomic) long long deVideoframeT;
@property (nonatomic) long long deAudioframeT;
@property (nonatomic) long long videoOpenT;
@property (nonatomic) long long videoOpenedT;
@property (nonatomic) long long audioOpenT;
@property (nonatomic) long long audioOpenedT;
@property (nonatomic) long long prepareST;
@property (nonatomic) long long prepareET;
@property (nonatomic) long long vt;
@property (nonatomic) long long et;
@property (nonatomic) long long lt;
@property (nonatomic) long long bft;

//checkinfo
@property (nonatomic, copy) NSString *mute;
@property (nonatomic, copy) NSString *loop;
@property (nonatomic, copy) NSString *asyncInit;
@property (nonatomic, copy) NSString *volume;
@property (nonatomic, copy) NSString *dash;
@property (nonatomic, copy) NSString *checkHijack;
@property (nonatomic, copy) NSString *bash;
@property (nonatomic, copy) NSString *dashAbr;
@property (nonatomic, copy) NSString *hijackMainDns;
@property (nonatomic, copy) NSString *hijackBackDns;
@property (nonatomic, copy) NSString *hijackDns;
@property (nonatomic, copy) NSString *hardware;
@property (nonatomic, copy) NSString *h265;
@property (nonatomic, copy) NSString *speed;
@property (nonatomic, copy) NSString *smoothlySwitch;
@property (nonatomic, copy) NSString *reuseSocket;
@property (nonatomic, copy) NSString *bufferingTimeout;
@property (nonatomic, copy) NSString *cacheMaxSeconds;
@property (nonatomic, copy) NSString *boe;
@property (nonatomic, copy) NSString *dnsCache;
@property (nonatomic, copy) NSString *videomodelCache;
@property (nonatomic, copy) NSString *bitrate;
@property (nonatomic, copy) NSString *bufferingDirectly;
@property (nonatomic, copy) NSString *scaleMode;
@property (nonatomic) TTVideoEngineRenderEngine renderType;
@property (nonatomic, copy) NSString *imageScaleType;
@property (nonatomic, copy) NSString *enhancementType;
@property (nonatomic, copy) NSString *imageLayoutType;
@property (nonatomic, copy) NSString *rotateType;
@property (nonatomic, copy) NSString *mirrorType;
@property (nonatomic, copy) NSString *dynamicType;
@property (nonatomic, copy) NSString *deviceId;

+ (instancetype)videoDebugInfoViewWithParentView:(UIView *)parentView;

- (void)updateInfoValue;

@end

@protocol TTVideoEngineDebugVideoInfoViewDelegate <NSObject>

- (void)catchLogButtonClicked:(BOOL)catchLog;

- (void)copyInfoButtonClicked;

@end

NS_ASSUME_NONNULL_END
