//
//  TTVideoEngine+SubTitle.h
//  TTVideoEngine
//
//  Created by haocheng on 2020/11/4.
//

#import "TTVideoEngine.h"

NS_ASSUME_NONNULL_BEGIN

//sub model json field name
extern NSString *const kTTVideoEngineSubModelURLKey;
extern NSString *const kTTVideoEngineSubModelLangIdKey;
extern NSString *const kTTVideoEngineSubModelFormatKey;
extern NSString *const kTTVideoEngineSubModelIndexKey;
extern NSString *const kTTVideoEngineSubModelLanguageKey;
extern NSString *const kTTVideoEngineSubModelExpireTimeKey;
extern NSString *const kTTVideoEngineSubModelListKey;
extern NSString *const kTTVideoEngineSubModelSubIndexKey;
extern NSString *const kTTVideoEngineSubModelSourceKey;
extern NSString *const kTTVideoEngineSubModelVersionKey;

@protocol TTVideoEngineSubDecInfoProtocol <NSObject>

- (NSString *_Nullable)jsonString;
- (NSInteger)subtitleCount;

@end

@protocol TTVideoEngineSubProtocol <NSObject>

//required
/* json field name: "language_id" */
@property (nonatomic, assign, readonly) NSInteger languageId;
/* json field name: "url" */
@property (nonatomic, copy, readonly) NSString *urlString;
/* json field name: "format" */
@property (nonatomic, copy, readonly) NSString *format;

- (NSDictionary *_Nullable)toDictionary;

@end

@interface TTVideoEngineSubModel : NSObject <TTVideoEngineSubProtocol>

//optional
@property (nonatomic, assign, readonly) NSInteger index;
@property (nonatomic, copy, readonly) NSString *language;
@property (nonatomic, assign, readonly) NSInteger expireTime;

- (instancetype)initWithDictionary:(NSDictionary * _Nonnull)dict;
- (NSDictionary *_Nullable)toDictionary;

@end

@interface TTVideoEngineSubDecInfoModel : NSObject <TTVideoEngineSubDecInfoProtocol>

- (instancetype)initWithDictionary:(NSDictionary *_Nonnull)dict;
- (instancetype)initWithSubModels:(NSArray<id<TTVideoEngineSubProtocol>> *_Nonnull)models;

- (NSString *_Nullable)jsonString;
- (NSInteger)subtitleCount;

@end


@interface TTVideoEngineSubInfo: NSObject

@property (nonatomic, assign) NSInteger pts;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger duration;

@end

@protocol TTVideoEngineSubtitleDelegate <NSObject>

@optional

- (void)videoEngine:(TTVideoEngine *)videoEngine onSubtitleInfoCallBack:(NSString *)content pts:(NSUInteger)pts;

- (void)videoEngine:(TTVideoEngine *)videoEngine onSubtitleInfoCallBack:(TTVideoEngineSubInfo *)subInfo;

- (void)videoEngine:(TTVideoEngine *)videoEngine onSubtitleInfoRequested:(id _Nullable)info error:(NSError * _Nullable)error;

- (void)videoEngine:(TTVideoEngine *)videoEngine onSubSwitchCompleted:(BOOL)success currentLangId:(NSInteger)currentLangId;

- (void)videoEngine:(TTVideoEngine *)videoEngine onSubLoadFinished:(BOOL)success;

@end

@interface TTVideoEngine()
/* host name of subtitle request */
@property (nonatomic, copy) NSString *subtitleHostName;
/* subtitle delegate */
@property (nonatomic, weak, nullable) id<TTVideoEngineSubtitleDelegate> subtitleDelegate;
/* subtitle model */
@property (nonatomic, weak) id<TTVideoEngineSubDecInfoProtocol> subDecInfoModel;

@end

@interface TTVideoEngine(SubTitle)

/* subtitle requested info*/
- (NSDictionary * _Nullable)requestedSubtitleInfo;

/* support languages */
- (NSArray * _Nullable)subtitleLangs;

/* support language IDs */
- (NSArray * _Nullable)subtitleIDs;

/** pre_request method */
+ (void)requestSubtitleInfoWith:(NSString * _Nonnull)hostName
                            vid:(NSString * _Nonnull)vid
                         fileId:(NSString * _Nonnull)fileId
                       language:(NSString * _Nullable)language
                         client:(id<TTVideoEngineNetClient> _Nullable)client
                     completion:(nullable void (^)(id _Nullable jsonObject, NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
