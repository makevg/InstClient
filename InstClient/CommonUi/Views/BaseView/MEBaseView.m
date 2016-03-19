//
//  MEBaseView.m
//  InstClient
//
//  Created by Maximychev Evgeny on 19.03.16.
//  Copyright © 2016 Maximychev Evgeny. All rights reserved.
//

#import "MEBaseView.h"

@implementation MEBaseView

#pragma mark - Init

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

#pragma mark - Public

- (void)setup {
    // Abstract method.
}

- (void)setModel:(id)model {
    // Abstract method.
}

@end
