//
//  MEUserCell.m
//  InstClient
//
//  Created by Maximychev Evgeny on 19.03.16.
//  Copyright © 2016 Maximychev Evgeny. All rights reserved.
//

#import "MEUserCell.h"
#import "MEUser.h"
#import "UIImageView+AsyncLoad.h"

@interface MEUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@end

@implementation MEUserCell

#pragma mark - Public

- (void)configureCell {
    self.photoImageView.layer.cornerRadius = self.photoImageView.frame.size.width/2;
    self.photoImageView.clipsToBounds = YES;
    self.userNameLabel.font = [MEStyle defaultFontOfSize:12.f];
    self.fullNameLabel.font = [MEStyle defaultFontOfSize:12.f];
    self.fullNameLabel.textColor = [MEStyle grayColor];
}

- (void)setModel:(id)model {
    if ([model isKindOfClass:[MEUser class]]) {
        [self configureCellWithUser:model];
    }
}

#pragma mark - Private

- (void)configureCellWithUser:(MEUser *)user {
    [self.photoImageView loadAsyncFromUrl:user.profilePicture];
    self.userNameLabel.text = user.userName;
    self.fullNameLabel.text = user.fullName;
}

@end
