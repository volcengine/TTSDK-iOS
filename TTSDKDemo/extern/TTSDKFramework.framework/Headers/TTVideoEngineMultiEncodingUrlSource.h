//
//  TTVideoEngineMultiEncodingDirectUrlSource.h
//  TTVideoEngine
//
//  Created by bytedance on 4.6.21.
//

#import <Foundation/Foundation.h>
#import "TTVideoEnginePlayerDefine.h"

NS_ASSUME_NONNULL_BEGIN

@class TTVideoEngineDirectUrlAsset;

/// TTVideoEngineMultiEncodingUrlSource is a class which can aggregate multi encoding url sources,
/// in cases of  those video/audio programs support more than one encode type.
/// for example, if there is a video program, not only support h264 encode but also support h265 encode, each encode source link to a single url,
/// then construct the two urls in an instance of TTVideoEngineMultiEncodingUrlSource is convenient.
@interface TTVideoEngineMultiEncodingUrlSource : NSObject

/// Add direct url source.
/// @param url Direct url string.
/// @param encodeType The source's encode type.
/// @param cacheKey Local file cache key.
/// @param auth Decrypt key for encrypted video.
- (void)addUrl:(NSString *)url
      forCodec:(TTVideoEngineEncodeType)encodeType
  withCacheKey:(NSString *)cacheKey
   andPlayAuth:(NSString * _Nullable)auth;

- (TTVideoEngineDirectUrlAsset *)assetForCodec:(TTVideoEngineEncodeType)encodeType;

/// If there is a url asset link to h265
- (BOOL)hash265Asset;

@end

NS_ASSUME_NONNULL_END
