//
//  BEResourceHelper.h
//  BytedEffects
//
//  Created by QunZhang on 2019/10/22.
//  Copyright © 2019 ailab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BEResourceHelperDelegate <NSObject>

@optional
- (NSString *)licenseDirPath;
- (NSString *)composerNodeDirPath;
- (NSString *)filterDirPath;
- (NSString *)stickerDirPath;
- (NSString *)composerDirPath;
- (NSString *)modelDirPath;
- (NSString *)licenseName;

@end

@interface BEResourceHelper : NSObject

@property (nonatomic, weak) id<BEResourceHelperDelegate> delegate;

- (NSString *)licensePath;
- (NSString *)composerNodePath:(NSString *)nodeName;
- (NSString *)filterPath:(NSString *)filterName;
- (NSString *)stickerPath:(NSString *)stickerName;
- (NSString *)modelPath:(NSString *)modelName;
- (NSString *)composerPath;
- (NSString *)modelDirPath;

@end
