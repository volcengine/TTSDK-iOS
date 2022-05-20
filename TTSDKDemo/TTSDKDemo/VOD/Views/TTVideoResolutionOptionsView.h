//
//  TTVideoResolutionOptionsView.h
//  TTVideoEngineDemo
//
//  Created by 黄清 on 2018/12/19.
//  Copyright © 2018 bytedance. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoResolutionOptionsView : BaseView

@property (nonatomic,   copy) IndexClick clickCall;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic,   copy) NSArray *titles;
@property (nonatomic, assign) BOOL verticalScreen;

- (void)showAtPoint:(CGPoint )point;

@end

@interface TTVideoResolutionOptionsItem : UICollectionViewCell

- (void)setTitle:(NSString *)title selected:(BOOL)selected;
@property (nonatomic, copy) IndexClick clickCall;

@end

NS_ASSUME_NONNULL_END
