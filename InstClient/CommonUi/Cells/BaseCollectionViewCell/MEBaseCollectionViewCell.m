//
//  MEBaseCollectionViewCell.m
//  InstClient
//
//  Created by Maximychev Evgeny on 21.03.16.
//  Copyright © 2016 Maximychev Evgeny. All rights reserved.
//

#import "MEBaseCollectionViewCell.h"

@implementation MEBaseCollectionViewCell

- (void)awakeFromNib {
    [self configureCell];
}

#pragma mark - Public

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

- (void)setModel:(id)model {
    // Abstract method.
}

- (void)configureCell {
    // Abstract method.
}

@end
