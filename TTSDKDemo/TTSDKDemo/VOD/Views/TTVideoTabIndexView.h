//
//  TTVideoTabIndexView.h
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/12/12.


#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTVideoTabIndexView : BaseView

@property (nonatomic,   copy) IndexClick clickCall;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL hiddenLineView;

- (void)updateTitles:(NSArray *)titles;

@end


@interface TTVideoTabIndexItem : UICollectionViewCell

- (void)setTitle:(NSString *)title selected:(BOOL)selected;
- (void)setTextLabelx:(CGFloat)labX;

@end

NS_ASSUME_NONNULL_END
