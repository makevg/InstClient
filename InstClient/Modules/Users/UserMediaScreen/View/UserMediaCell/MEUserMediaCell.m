//
//  MEUserMediaCell.m
//  InstClient
//
//  Created by Maximychev Evgeny on 21.03.16.
//  Copyright © 2016 Maximychev Evgeny. All rights reserved.
//

#import "MEUserMediaCell.h"
#import "MEMedia.h"
#import "UIImageView+AsyncLoad.h"

@interface MEUserMediaCell ()
@property (weak, nonatomic) IBOutlet UIImageView *mediaImageView;
@end

@implementation MEUserMediaCell

#pragma mark - Public

- (void)configureCell {
    
}

- (void)setModel:(id)model {
    if ([model isKindOfClass:[MEMedia class]]) {
        [self configureCellWithMedia:model];
    }
}

#pragma mark - Private

- (void)configureCellWithMedia:(MEMedia *)media {
    [self.mediaImageView loadAsyncFromUrl:media.lowResolution];
}

@end
