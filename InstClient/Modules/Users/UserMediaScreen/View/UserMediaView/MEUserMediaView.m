//
//  MEUserMediaView.m
//  InstClient
//
//  Created by Maximychev Evgeny on 21.03.16.
//  Copyright © 2016 Maximychev Evgeny. All rights reserved.
//

#import "MEUserMediaView.h"

@interface MEUserMediaView ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation MEUserMediaView

#pragma mark - Setup

- (void)setup {
    self.collectionView.backgroundColor = [MEStyle whiteColor];
}

#pragma mark - Public

- (void)startAnimating {
    [self.activityIndicator startAnimating];
}

- (void)stopAnimating {
    if (self.activityIndicator.isAnimating) {
        [self.activityIndicator stopAnimating];
    }
}

@end
