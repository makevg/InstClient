//
//  UIImageView+AsyncLoad.h
//  InstClient
//
//  Created by Maximychev Evgeny on 19.03.16.
//  Copyright © 2016 Maximychev Evgeny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (AsyncLoad)

- (void)loadAsyncFromUrl:(NSString *)photoUrl;

- (void)loadAsyncFromUrl:(NSString *)photoUrl
             placeHolder:(NSString *)placeholder;

@end
