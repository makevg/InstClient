//
//  UIImageView+AsyncLoad.m
//  InstClient
//
//  Created by Maximychev Evgeny on 19.03.16.
//  Copyright © 2016 Maximychev Evgeny. All rights reserved.
//

#import "UIImageView+AsyncLoad.h"
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (AsyncLoad)

- (void)loadAsyncFromUrl:(NSString *)photoUrl {
    [self loadAsyncFromUrl:photoUrl placeHolder:@"Placeholder"];
}

- (void)loadAsyncFromUrl:(NSString *)photoUrl placeHolder:(NSString *)placeholder {
    [self sd_setImageWithURL:[NSURL URLWithString:photoUrl]
            placeholderImage:[UIImage imageNamed:placeholder]
                     options:(SDWebImageOptions) (SDWebImageLowPriority | SDWebImageRetryFailed)
                    progress:nil
                   completed:^(UIImage *image_, NSError *error, SDImageCacheType cacheType_, NSURL *url) {
                       if (!image_)
                           return;
                   }];
}

@end
