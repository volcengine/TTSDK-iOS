//
//  UIImageView+TTVideo.m
//  TTVideoPlayerDemo
//
//  Created by 黄清 on 2018/10/8.


#import "UIImageView+TTVideo.h"

@implementation UIImageView (TTVideo)

- (void)tt_setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder{
    if (!url || url.length == 0) {
        return;
    }
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
}

@end
