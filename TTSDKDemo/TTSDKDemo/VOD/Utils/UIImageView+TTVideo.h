//
//  UIImageView+TTVideo.h
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/10/8.


#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (TTVideo)

- (void)tt_setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder;

@end

NS_ASSUME_NONNULL_END
