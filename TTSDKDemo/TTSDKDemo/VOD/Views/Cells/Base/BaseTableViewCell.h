//
//  BaseTableViewCell.h
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/10/8.


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewCell : UITableViewCell

@property(nonatomic, nullable, strong, readonly) id dataModel;

- (void)setupUI;
- (void)assignValue:(id)model;
- (void)refreshView:(id)model;
- (void)tryFresh;
- (void)willDisplay;
- (void)endDisplay;

@end

NS_ASSUME_NONNULL_END
