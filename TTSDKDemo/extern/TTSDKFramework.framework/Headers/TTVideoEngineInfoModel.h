//
//  TTVideoInfoModel.h
//  Article
//
//  Created by Dai Dongpeng on 6/2/16.
//
//

#import "TTVideoEngineModelDef.h"
#import "TTVideoEngineThumbInfo.h"
#import "TTVideoEngineSource.h"

static const NSInteger VALUE_MAIN_URL            = 0;
static const NSInteger VALUE_VWIDTH              = 1;
static const NSInteger VALUE_VHEIGHT = 2;
static const NSInteger VALUE_BITRATE = 3;
static const NSInteger VALUE_ENCRYPT = 4;
static const NSInteger VALUE_PLAY_AUTH = 5;
static const NSInteger VALUE_FORMAT_TYPE = 6;
static const NSInteger VALUE_DEFINITION = 7;
static const NSInteger VALUE_CODEC_TYPE = 8;
static const NSInteger VALUE_PRELOAD_SIZE = 9;
static const NSInteger VALUE_PRELOAD_MIN_STEP = 10;
static const NSInteger VALUE_PRELOAD_MAX_STEP = 11;
static const NSInteger VALUE_SIZE = 12;
static const NSInteger VALUE_PRELOAD_INTERVAL = 13;
static const NSInteger VALUE_SOCKET_BUFFER = 14;
static const NSInteger VALUE_FILE_HASH = 15;
static const NSInteger VALUE_URLS               = 16;
static const NSInteger VALUE_BACKUP_URL_1 = 17;

static const NSInteger VALUE_USER_ID = 21;
static const NSInteger VALUE_VIDEO_ID = 22;
static const NSInteger VALUE_VIDEO_DURATION = 23;
static const NSInteger VALUE_STATUS = 24;
static const NSInteger VALUE_VIDEO_LIST = 25;
static const NSInteger VALUE_DYNAMIC_VIDEO_List = 26;
static const NSInteger VALUE_MEDIA_TYPE = 27;
static const NSInteger VALUE_URL_EXPIRE = 28;

static const NSInteger VALUE_BACKUP_URL_2 = 101;
static const NSInteger VALUE_BACKUP_URL_3 = 102;
static const NSInteger VALUE_GBR = 103;
static const NSInteger VALUE_STOREPATH = 104;
static const NSInteger VALUE_USE_VIDEO_PROXY = 105;

static const NSInteger VALUE_VIDEO_ENABLE_SSL = 106;
static const NSInteger VALUE_AUTO_DEFINITION = 107;
static const NSInteger VALUE_DYNAMIC_MAIN_URL = 108;
static const NSInteger VALUE_DYNAMIC_BACKUP_URL = 109;
static const NSInteger VALUE_VIDEO_NAME = 110;
static const NSInteger VALUE_VIDEO_VALIDATE = 111;

static const NSInteger VALUE_LOGO_TYPE = 200;
static const NSInteger VALUE_QUALITY = 201;

static const NSInteger VALUE_CODEC_HAS_H264 = 203;
static const NSInteger VALUE_CODEC_HAS_H265 = 204;
static const NSInteger VALUE_FORMAT_HAS_MP4 = 206;
static const NSInteger VALUE_FORMAT_HAS_MPD = 207;
static const NSInteger VALUE_FORMAT_HAS_HLS = 208;
static const NSInteger VALUE_TOTAL_COUNT    = 209;
static const NSInteger VALUE_POSTER_URL     = 210;
static const NSInteger VALUE_SEEKTS_OPENING = 211;
static const NSInteger VALUE_SEEKTS_ENDING  = 212;
static const NSInteger VALUE_THUMB_IMG_NUM    = 213;
static const NSInteger VALUE_THUMB_URI        = 214;
static const NSInteger VALUE_THUMB_IMG_URL    = 215;
static const NSInteger VALUE_THUMB_IMG_X_SIZE = 216;
static const NSInteger VALUE_THUMB_IMG_Y_SIZE = 217;
static const NSInteger VALUE_THUMB_IMG_X_LEN  = 218;
static const NSInteger VALUE_THUMB_IMG_Y_LEN  = 219;
static const NSInteger VALUE_THUMB_DURATION   = 220;
static const NSInteger VALUE_THUMB_INTERVAL   = 221;
static const NSInteger VALUE_THUMB_FEXT       = 222;


@interface TTVideoEngineURLInfo : NSObject

@property (nonatomic, assign) TTVideoEngineResolutionType videoDefinitionType;
@property (nonatomic, copy) NSString  *vType;
@property (nonatomic, copy) NSString  *mediaType;
@property (nonatomic, copy) NSString  *audioQuality;
@property (nonatomic, copy) NSString *codecType;
@property (nonatomic, copy) NSString *fileHash;
@property (nonatomic, copy) NSString *mainURLStr;
@property (nonatomic, copy) NSString  *backupURL1;
@property (nonatomic, copy) NSString  *backupURL2;
@property (nonatomic, copy) NSString  *backupURL3;
@property (nonatomic, strong) NSNumber  *vHeight;
@property (nonatomic, strong) NSNumber  *vWidth;
@property (nonatomic, strong) NSNumber  *size;
@property (nonatomic, assign) NSInteger bitrate;
@property (nonatomic, strong) NSNumber  *preloadSize;
@property (nonatomic, strong) NSNumber  *playLoadMaxStep;
@property (nonatomic, strong) NSNumber  *playLoadMinStep;
@property (nonatomic, assign) BOOL      encrypt;
@property (nonatomic, copy) NSString *spade_a;
@property (nonatomic, copy) NSString *definition;
/// Text value in [audioQuality,definition];
@property (nonatomic, copy) NSString *definitionString;
/// Add by huangqing.
@property (nonatomic, copy) NSString *fieldId;
@property (nonatomic, copy) NSString *p2pVerifyUrl;

- (NSArray *)allURLForVideoID:(NSString *)videoID transformedURL:(BOOL)transformed;
- (TTVideoEngineResolutionType)getVideoDefinitionType;

- (void)setUpResolutionMap:(NSDictionary *)map;

- (NSNumber *)getValueNumber:(NSInteger)key;
- (NSString *)getValueStr:(NSInteger)key;
- (NSInteger)getValueInt:(NSInteger)key;
- (BOOL)getValueBool:(NSInteger)key;
@end

@interface TTVideoEngineURLInfoMap : NSObject

- (void)setUpResolutionMap:(NSDictionary *)map;

@property (nonatomic, strong) TTVideoEngineURLInfo *video1; //标清 360p
@property (nonatomic, strong) TTVideoEngineURLInfo  *video2; // 480p
@property (nonatomic, strong) TTVideoEngineURLInfo  *video3; // 720p
@property (nonatomic, strong) TTVideoEngineURLInfo  *video4; // 720p

- (TTVideoEngineURLInfo *)videoForResolutionType:(TTVideoEngineResolutionType)type;

@end

@interface TTVideoEngineDynamicVideo : NSObject

- (void)setUpResolutionMap:(NSDictionary *)map;

@property (nonatomic, strong) NSMutableArray<TTVideoEngineURLInfo *> *dynamicVideoInfo;
@property (nonatomic, copy) NSString *mainURL;
@property (nonatomic, copy) NSString *backupURL;

- (TTVideoEngineURLInfo *)videoForResolutionType:(TTVideoEngineResolutionType)type;

@end

@interface TTVideoEngineLiveURLInfo : NSObject

@property (nonatomic, copy) NSString *mainPlayURL;
@property (nonatomic, copy) NSString *backupPlayURL;

@end

@interface TTVideoEngineLiveVideo : NSObject

@property (nonatomic, strong) NSMutableArray<TTVideoEngineLiveURLInfo *> *liveURLInfos;
@property (nonatomic, assign) NSInteger backupStatus;
@property (nonatomic, assign) NSInteger liveStatus;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) long long startTime;
@property (nonatomic, assign) long long endTime;

@end

@interface TTVideoEngineSeekTS : NSObject

@property (nonatomic, assign) CGFloat opening; //片头，单位: 秒
@property (nonatomic, assign) CGFloat ending; //片尾, 单位: 秒

- (instancetype)initWithDictionary:(NSDictionary *)jsonDict;

- (CGFloat)getValueFloat:(NSInteger)key;

@end

@interface TTVideoEngineInfoModel : NSObject

@property (nonatomic, copy) NSString *videoID;
@property (nonatomic, copy) NSString  *userID;
@property (nonatomic, strong) TTVideoEngineSeekTS *seekTs;
@property (nonatomic, strong) TTVideoEngineURLInfoMap *videoURLInfoMap;
@property (nonatomic, strong) TTVideoEngineDynamicVideo *dynamicVideo;
@property (nonatomic, strong) TTVideoEngineLiveVideo *liveVideo;
@property (nonatomic, strong) NSMutableArray<TTVideoEngineThumbInfo *> *bigThumbs;
@property (nonatomic, strong) NSNumber  *videoDuration;
@property (nonatomic, strong) NSString  *mediaType;
@property (nonatomic, copy) NSString *autoDefinition;
@property (nonatomic, assign) NSInteger videoStatusCode;
@property (nonatomic, copy) NSString *validate;
@property (nonatomic, assign) BOOL enableSSL;
@property (nonatomic, assign, readonly) BOOL hasExpired;

- (instancetype)initWithDictionary:(NSDictionary *)jsonDict;

/// After data parsing, you need to call it right away.
- (void)setUpResolutionMap:(NSDictionary *)map;

- (NSArray *)allURLWithDefinition:(TTVideoEngineResolutionType)type transformedURL:(BOOL)transformed;
- (NSInteger)videoSizeForType:(TTVideoEngineResolutionType)type;
- (NSString *)definitionStrForType:(TTVideoEngineResolutionType)type;
- (NSInteger)preloadSizeForType:(TTVideoEngineResolutionType)type;
- (NSInteger)playLoadMaxStepForType:(TTVideoEngineResolutionType)type;
- (NSInteger)playLoadMinStepForType:(TTVideoEngineResolutionType)type;
- (TTVideoEngineURLInfo *)videoInfoForType:(TTVideoEngineResolutionType)type;


- (TTVideoEngineURLInfo *)videoInfoForType:(TTVideoEngineResolutionType *)type autoMode:(BOOL)mode;
- (NSArray<NSString *> *)allUrlsWithResolution:(TTVideoEngineResolutionType *)type autoMode:(BOOL)model;

- (TTVideoEngineURLInfo *)videoInfoForType:(TTVideoEngineResolutionType)type otherCondition:(NSMutableDictionary *)searchCondition;
- (NSArray *)codecTypes;
- (NSString *)videoType;
- (NSArray<NSNumber *> *)supportedResolutionTypes;

- (NSNumber *)getValueNumber:(NSInteger)key;
- (NSString *)getValueStr:(NSInteger)key;
- (NSInteger)getValueInt:(NSInteger)key;
- (BOOL)getValueBool:(NSInteger)key;
//- (TTVideoEngineURLInfo *)videoInfoForType:(TTVideoEngineResolutionType)type autoMode:(BOOL)mode;

@end

