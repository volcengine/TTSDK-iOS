//
//  VCVodSettingsNetProtocol.h
//  VCVodSettings
//
//  Created by 黄清 on 2021/5/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VodSettingsNetProtocol <NSObject>

- (void)start:(NSString *)urlString
      headers:(NSDictionary<NSString *, NSString *> *)headers
       result:(void(^)(NSError * _Nullable error, _Nullable id jsonObject)) result;

- (void)cancel;

@end

NS_ASSUME_NONNULL_END
