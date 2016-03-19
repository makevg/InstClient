//
//  MEStyle.m
//  InstClient
//
//  Created by Maximychev Evgeny on 19.03.16.
//  Copyright © 2016 Maximychev Evgeny. All rights reserved.
//

#import "MEStyle.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.f]

NSString *const cRegularFontName = @"Freight";
NSString *const cDefaultFontName = @"HelveticaNeue";

@implementation MEStyle

// Colors

+ (UIColor *)blueColor {
    return RGB(11, 85, 138);
}

+ (UIColor *)whiteColor {
    return [UIColor whiteColor];
}

+ (UIColor *)grayColor {
    return RGB(103, 105, 109);
}

+ (UIColor *)lightGrayColor {
    return RGB(220, 220, 220);
}

// Fonts

+ (UIFont *)defaultFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:cDefaultFontName size:size];
}

+ (UIFont *)regularFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:cRegularFontName size:size];
}

@end
