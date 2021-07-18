//
// DualCoreProtocol.h
// TTVideoEngine
//
// Created by baishuai on 2020/11/29
//

#import <Foundation/Foundation.h>
#import <TTPlayerSDK/TTAVPlayerProtocol.h>
#import <TTPlayerSDK/TTAVPlayerItemProtocol.h>
#import <TTPlayerSDK/TTPlayerViewProtocol.h>

@protocol TTVideoEngineDualCore <NSObject>

@required
- (NSObject<TTAVPlayerProtocol> *)playerWithItem:(NSObject<TTAVPlayerItemProtocol>*)item options:(NSDictionary *)header;

- (NSObject<TTAVPlayerItemProtocol> *)playerItemWithURL:(NSURL *)url;

- (UIView<TTPlayerViewProtocol> *)viewWithFrame:(CGRect)frame;

- (NSString *) getVersion;

@end
