//
//  MEUserHeader.m
//  InstClient
//
//  Created by Maximychev Evgeny on 21.03.16.
//  Copyright © 2016 Maximychev Evgeny. All rights reserved.
//

#import "MEUserHeader.h"
#import "MEUser.h"
#import "UIImageView+AsyncLoad.h"

@interface MEUserHeader ()
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorHeightConstraint;
@end

@implementation MEUserHeader

#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        [self addSubview:self.mainView];
        [self configureView];
    }
    return self;
}

#pragma mark - Private

- (void)configureView {
    [self prepareConstraints];
    [self configureSubviews];
}

- (void)prepareConstraints {
    [self.mainView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view":self.mainView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view":self.mainView}]];
}

- (void)configureSubviews {
    self.mainView.backgroundColor = [MEStyle whiteColor];
    self.photoImageView.layer.cornerRadius = self.photoImageView.frame.size.width/2;
    self.photoImageView.clipsToBounds = YES;
    self.userNameLabel.font = [MEStyle defaultFontOfSize:13.f];
    self.fullNameLabel.font = [MEStyle defaultFontOfSize:12.f];
    self.fullNameLabel.textColor = [MEStyle grayColor];
    self.separatorView.backgroundColor = [MEStyle lightGrayColor];
    self.separatorHeightConstraint.constant = 0.5f;
}

- (void)configureViewWithUser:(MEUser *)user {
    [self.photoImageView loadAsyncFromUrl:user.profilePicture];
    self.userNameLabel.text = user.userName;
    self.fullNameLabel.text = user.fullName;
}

#pragma mark - Public

- (void)setModel:(id)model {
    if ([model isKindOfClass:[MEUser class]]) {
        [self configureViewWithUser:model];
    }
}

@end
