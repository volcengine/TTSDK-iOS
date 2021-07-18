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

NS_ASSUME_NONNULL_BEGIN

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
static const NSInteger VALUE_QUALITY_TYPE = 18;

static const NSInteger VALUE_USER_ID = 21;
static const NSInteger VALUE_VIDEO_ID = 22;
static const NSInteger VALUE_VIDEO_DURATION = 23;
static const NSInteger VALUE_STATUS = 24;
static const NSInteger VALUE_VIDEO_LIST = 25;
static const NSInteger VALUE_DYNAMIC_VIDEO_List = 26;
static const NSInteger VALUE_DYNAMIC_AUDIO_List = 27;
static const NSInteger VALUE_MEDIA_TYPE = 28;
static const NSInteger VALUE_URL_EXPIRE = 29;
static const NSInteger VALUE_VIDEO_REF_STRING= 30;
static const NSInteger VALUE_CHECK_INFO = 31;
static const NSInteger VALUE_VIDEO_QUALITY_DESC = 32;
static const NSInteger VALUE_VIDEO_MODEL_VERSION = 33;
static const NSInteger VALUE_BARRAGE_MASK_URL = 34;
static const NSInteger VALUE_VIDEO_DECODING_MODE = 35;

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
static const NSInteger VALUE_BARRAGE_MASK_OFFSET = 112;

static const NSInteger VALUE_LOGO_TYPE = 200;
static const NSInteger VALUE_QUALITY = 201;

static const NSInteger VALUE_CODEC_HAS_H264 = 203;
static const NSInteger VALUE_CODEC_HAS_h265 = 204;
static const NSInteger VALUE_FORMAT_HAS_DASH = 205;
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
static const NSInteger VALUE_DYNAMIC_TYPE     = 223;
static const NSInteger VALUE_HAS_VIDEO        = 224;
static const NSInteger VALUE_THUMB_IMG_URLS   = 225;
static const NSInteger VALUE_VOLUME_LOUDNESS  = 226;
static const NSInteger VALUE_VOLUME_PEAK      = 227;
static const NSInteger VALUE_FULLSCREEN_STRATEGY = 228;
static const NSInteger VALUE_CODEC_HAS_BYTEVC2 = 229;

FOUNDATION_EXPORT NSString *kTTVideoEngineCodecH264;
FOUNDATION_EXPORT NSString *kTTVideoEngineCodech265;
FOUNDATION_EXPORT NSString *kTTVideoEngineCodecByteVC2;

@class TTVideoEngineMediaFitterInfo;
@interface TTVideoEngineURLInfo : NSObject<NSSecureCoding>

@property (nonatomic, assign) TTVideoEngineResolutionType videoDefinitionType;
@property (nonatomic, nullable, copy) NSString  *vType;
@property (nonatomic, nullable, copy) NSString  *mediaType;
@property (nonatomic, nullable, copy) NSString  *audioQuality;
@property (nonatomic, nullable, copy) NSString *codecType;
@property (nonatomic, nullable, copy) NSString *fileHash;
@property (nonatomic, nullable, copy) NSString *mainURLStr;
@property (nonatomic, nullable, copy) NSString  *backupURL1;
@property (nonatomic, nullable, copy) NSString  *backupURL2;
@property (nonatomic, nullable, copy) NSString  *backupURL3;
@property (nonatomic, nullable, copy) NSString  *barrageMaskUrl;
@property (nonatomic, nullable, strong) NSNumber  *vHeight;
@property (nonatomic, nullable, strong) NSNumber  *vWidth;
@property (nonatomic, nullable, strong) NSNumber  *size;
@property (nonatomic, assign) NSInteger bitrate;
@property (nonatomic, nullable, strong) NSNumber  *preloadSize;
@property (nonatomic, nullable, strong) NSNumber  *playLoadMaxStep;
@property (nonatomic, nullable, strong) NSNumber  *playLoadMinStep;
@property (nonatomic, assign) BOOL      encrypt;
@property (nonatomic, nullable, copy) NSString *spade_a;
@property (nonatomic, nullable, copy) NSString *definition;
@property (nonatomic, nullable, copy) NSString *checkInfo;
@property (nonatomic, assign) CGFloat loudness;
@property (nonatomic, assign) CGFloat peak;
/// Text value in [audioQuality,definition];
@property (nonatomic, nullable, copy) NSString *definitionString;
/// Add by huangqing.
@property (nonatomic, nullable, copy) NSString *fileId;
@property (nonatomic, nullable, copy) NSString *p2pVerifyUrl;
//add by jyy
@property (nonatomic, nullable, copy) NSString *qualityDesc;
@property (nonatomic, assign) NSInteger videoModelVersion;
@property (nonatomic, nullable, strong) NSNumber  *fps;
@property (nonatomic, nullable, copy) NSString *kid;
@property (nonatomic, nullable, copy) NSString *bashInitRange;
@property (nonatomic, nullable, copy) NSString *bashIndexRange;
@property (nonatomic, nullable, copy) NSString *message;
@property (nonatomic, nullable ,copy) NSString *barrageMaskOffset;
@property (nonatomic, nullable, strong) NSMutableDictionary *packetOffset;
@property (nonatomic, nullable, strong) TTVideoEngineMediaFitterInfo *fitterInfo;

- (nullable NSArray *)allURLForVideoID:(NSString *)videoID transformedURL:(BOOL)transformed;
- (TTVideoEngineResolutionType)getVideoDefinitionType;

- (void)setUpResolutionMap:(nullable NSDictionary *)map;

- (nullable NSNumber *)getValueNumber:(NSInteger)key;
- (nullable NSString *)getValueStr:(NSInteger)key;
- (NSInteger)getValueInt:(NSInteger)key;
- (BOOL)getValueBool:(NSInteger)key;
- (CGFloat)getValueFloat:(NSInteger)key;
@end

@interface TTVideoEngineURLInfoMap : NSObject<NSSecureCoding>

- (void)setUpResolutionMap:(nullable NSDictionary *)map;

@property (nonatomic, nullable, strong) TTVideoEngineURLInfo  *video1;
@property (nonatomic, nullable, strong) TTVideoEngineURLInfo  *video2;
@property (nonatomic, nullable, strong) TTVideoEngineURLInfo  *video3;
@property (nonatomic, nullable, strong) TTVideoEngineURLInfo  *video4;
@property (nonatomic, nullable, strong) TTVideoEngineURLInfo  *video5;
@property (nonatomic, nullable, strong) TTVideoEngineURLInfo  *video6;
@property (nonatomic, nullable, strong) TTVideoEngineURLInfo  *video7;
@property (nonatomic, nullable, strong) TTVideoEngineURLInfo  *video8;
@property (nonatomic, nullable, strong) NSMutableArray<TTVideoEngineURLInfo *> *videoInfoList;
@property (nonatomic, assign) NSInteger videoModelVersion;

@end

@interface TTVideoEngineAdaptiveInfo : NSObject<NSSecureCoding>

@property (nonatomic, nullable, copy) NSString *mainPlayURL;
@property (nonatomic, nullable, copy) NSString *backupPlayURL;
@property (nonatomic, nullable, copy) NSString *adaptiveType;

@end

@interface TTVideoEngineDynamicVideo : NSObject<NSSecureCoding>

- (void)setUpResolutionMap:(nullable NSDictionary *)map;

@property (nonatomic, nullable, copy) NSArray<TTVideoEngineURLInfo *> *dynamicVideoInfo;
@property (nonatomic, nullable, copy) NSArray<TTVideoEngineURLInfo *> *dynamicAudioInfoV3;
@property (nonatomic, nullable, copy) NSArray<TTVideoEngineURLInfo *> *dynamicVideoInfoV3;
@property (nonatomic, nullable, copy) NSString *mainURL;
@property (nonatomic, nullable, copy) NSString *backupURL;
@property (nonatomic, nullable, copy) NSString *dynamicType;
@property (nonatomic, assign) NSInteger videoModelVersion;

- (nullable TTVideoEngineURLInfo *)videoForResolutionType:(TTVideoEngineResolutionType)type mediaType:(nullable NSString *)mediaType otherCondition:(nullable NSDictionary *)params;

/// mediaType = @"video" && params = nil.
- (nullable TTVideoEngineURLInfo *)videoForResolutionType:(TTVideoEngineResolutionType)type;

@end

@interface TTVideoEngineLiveURLInfo : NSObject<NSSecureCoding>

@property (nonatomic, nullable, copy) NSString *mainPlayURL;
@property (nonatomic, nullable, copy) NSString *backupPlayURL;

@end

@interface TTVideoEngineLiveVideo : NSObject<NSSecureCoding>

@property (nonatomic, nullable, strong) NSMutableArray<TTVideoEngineLiveURLInfo *> *liveURLInfos;
@property (nonatomic, assign) NSInteger backupStatus;
@property (nonatomic, assign) NSInteger liveStatus;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) long long startTime;
@property (nonatomic, assign) long long endTime;

@end

@interface TTVideoEngineSeekTS : NSObject<NSSecureCoding>

@property (nonatomic, assign) CGFloat opening; //片头，单位: 秒
@property (nonatomic, assign) CGFloat ending; //片尾, 单位: 秒

- (instancetype)initWithDictionary:(NSDictionary *)jsonDict;

- (CGFloat)getValueFloat:(NSInteger)key;

@end

@interface TTVideoEngineMediaFitterInfo : NSObject<NSSecureCoding>

@property (nonatomic, strong) NSMutableArray<NSNumber *>* functionParams;
@property (nonatomic, assign) NSUInteger headerSize;
@property (nonatomic, assign) NSUInteger duration;
@property (nonatomic, assign) NSUInteger functionType;

- (instancetype)initWithDictionary:(NSDictionary *)jsonDict;
- (NSUInteger)calculateSizeBySecond:(double)seconds;

@end

@interface TTVideoEngineInfoModel : NSObject<NSSecureCoding>

@property (nonatomic, nullable, copy) NSString *videoID;
@property (nonatomic, nullable, copy) NSString  *userID;
@property (nonatomic, nullable, strong) TTVideoEngineSeekTS *seekTs;
@property (nonatomic, nullable, strong) TTVideoEngineURLInfoMap *videoURLInfoMap;
@property (nonatomic, nullable, strong) TTVideoEngineDynamicVideo *dynamicVideo;
@property (nonatomic, nullable, strong) TTVideoEngineLiveVideo *liveVideo;
@property (nonatomic, nullable, strong) TTVideoEngineAdaptiveInfo *adaptiveInfo;
@property (nonatomic, nullable, strong) NSMutableArray<TTVideoEngineThumbInfo *> *bigThumbs;
@property (nonatomic, nullable, strong) NSNumber  *videoDuration;
@property (nonatomic, nullable, strong) NSString  *mediaType;
@property (nonatomic, nullable, copy) NSString *autoDefinition;
@property (nonatomic, assign) NSInteger videoStatusCode;
@property (nonatomic, nullable, copy) NSString *validate;
@property (nonatomic, assign) BOOL enableSSL;
@property (nonatomic, assign, readonly) BOOL hasExpired;
@property (nonatomic, nullable, strong) NSString  *refString;
@property (nonatomic, nullable, strong) NSDictionary *params;
@property (nonatomic, nullable, copy) NSString *fallbackAPI;
@property (nonatomic, nullable, copy) NSString *keyseed;
@property (nonatomic, assign) NSInteger videoModelVersion;
@property (nonatomic, strong) NSNumber  *urlExpire;
@property (nonatomic, nullable, copy) NSString *barrageMaskUrl;
@property (nonatomic, nullable, copy) NSString *decodingMode;
@property (nonatomic, nullable, copy) NSString *bashString;
@property (nonatomic, assign) NSInteger popularityLevel;
@property (nonatomic, assign) BOOL enableAdaptive;
@property (nonatomic, nullable, strong) NSMutableArray *subtitleLangs;
@property (nonatomic, nullable, strong) NSMutableArray *subtitleIDs;

- (instancetype)initVideoInfoWithPb:(NSData *)data;

- (instancetype)initWithDictionary:(NSDictionary *)jsonDict;

- (instancetype)initWithDictionary:(NSDictionary *)jsonDict encrypted:(BOOL)encrypted;

/// After data parsing, you need to call it right away.
- (void)setUpResolutionMap:(nullable NSDictionary *)map;
- (nullable NSArray *)allURLWithDefinition:(TTVideoEngineResolutionType)type transformedURL:(BOOL)transformed;
- (NSInteger)videoSizeForType:(TTVideoEngineResolutionType)type;
- (nullable NSString *)definitionStrForType:(TTVideoEngineResolutionType)type;
- (NSInteger)preloadSizeForType:(TTVideoEngineResolutionType)type;
- (NSInteger)playLoadMaxStepForType:(TTVideoEngineResolutionType)type;
- (NSInteger)playLoadMinStepForType:(TTVideoEngineResolutionType)type;
- (nullable TTVideoEngineURLInfo *)videoInfoForType:(TTVideoEngineResolutionType)type;


- (nullable TTVideoEngineURLInfo *)videoInfoForType:(TTVideoEngineResolutionType *)type autoMode:(BOOL)mode;
- (nullable TTVideoEngineURLInfo *)videoInfoForType:(TTVideoEngineResolutionType *)type mediaType:(nullable NSString *)mediaType autoMode:(BOOL)mode;
- (nullable NSArray<NSString *> *)allUrlsWithResolution:(TTVideoEngineResolutionType *)type autoMode:(BOOL)model;

- (nullable TTVideoEngineURLInfo *)videoInfoForType:(TTVideoEngineResolutionType)type mediaType:(nullable NSString *)mediaType otherCondition:(nullable NSMutableDictionary *)searchCondition;
- (nullable NSArray *)codecTypes;
- (nullable NSString *)videoType;
- (NSArray<NSNumber *> *)supportedResolutionTypes;
- (NSArray<NSString *> *)supportedQualityInfos;

- (nullable NSNumber *)getValueNumber:(NSInteger)key;
- (nullable NSString *)getValueStr:(NSInteger)key;
- (NSInteger)getValueInt:(NSInteger)key;
- (BOOL)getValueBool:(NSInteger)key;
- (CGFloat)getValueFloat:(NSInteger)key;
- (nullable NSArray<TTVideoEngineURLInfo *> *)getValueArray:(NSInteger)key;

- (nullable NSString *)getSpade_aForType:(TTVideoEngineResolutionType)type;
- (TTVideoEngineResolutionType)autoResolution;

@end



NS_ASSUME_NONNULL_END
