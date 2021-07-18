//
// TTVideoEngineOwnPlayerVanGuard.h
// TTVideoEngine
//
// Created by baishuai on 2020/11/29
//

#import <Foundation/Foundation.h>
#import "TTVideoEngineDualCore.h"

@interface TTPlayerVanGuardFactory : NSObject<TTVideoEngineDualCore>

- (NSObject<TTAVPlayerProtocol> *)playerWithItem:(NSObject<TTAVPlayerItemProtocol>*)item options:(NSDictionary *)header;

- (NSObject<TTAVPlayerItemProtocol> *)playerItemWithURL:(NSURL *)url;

- (UIView<TTPlayerViewProtocol> *)viewWithFrame:(CGRect)frame;

- (NSString *) getVersion;

@end
