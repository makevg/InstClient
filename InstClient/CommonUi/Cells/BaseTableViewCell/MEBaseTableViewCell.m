//
//  MEBaseTableViewCell.m
//  InstClient
//
//  Created by Maximychev Evgeny on 19.03.16.
//  Copyright © 2016 Maximychev Evgeny. All rights reserved.
//

#import "MEBaseTableViewCell.h"

@implementation MEBaseTableViewCell

- (void)awakeFromNib {
    [self configureCell];
}

#pragma mark - Public

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

+ (CGFloat)cellHeight {
    return 44.f;
}

- (void)setModel:(id)model {
    // Abstract method.
}

- (void)configureCell {
    // Abstract method.
}

@end
