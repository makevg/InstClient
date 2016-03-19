//
//  MEStyle.h
//  InstClient
//
//  Created by Maximychev Evgeny on 19.03.16.
//  Copyright © 2016 Maximychev Evgeny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MEStyle : NSObject

// Colors
+ (UIColor *)blueColor;
+ (UIColor *)whiteColor;
+ (UIColor *)grayColor;
+ (UIColor *)lightGrayColor;

// Fonts
+ (UIFont *)defaultFontOfSize:(CGFloat)size;
+ (UIFont *)regularFontOfSize:(CGFloat)size;

@end
