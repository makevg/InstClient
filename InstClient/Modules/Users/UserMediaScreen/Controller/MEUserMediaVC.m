//
//  MEUserMediaVC.m
//  InstClient
//
//  Created by Maximychev Evgeny on 21.03.16.
//  Copyright © 2016 Maximychev Evgeny. All rights reserved.
//

#import "MEUserMediaVC.h"
#import "MEUserMediaView.h"
#import "MEUserMediaCell.h"
#import "MEInstService.h"
#import "MEUser.h"
#import "MEMedia.h"
#import "URBMediaFocusViewController.h"

@interface MEUserMediaVC () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet MEUserMediaView *contentView;
@property (nonatomic) NSArray<MEMedia *> *mediaData;
@end

@implementation MEUserMediaVC {
    CGFloat screenWidth;
    URBMediaFocusViewController *mediaFocusController;
}

#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setTitle:self.user.userName];
}

#pragma mark - Configure

- (void)configureController {
    screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    mediaFocusController = [URBMediaFocusViewController new];
    [self setDataSourceAndDelegate];
    __weak typeof(self)weakSelf = self;
    [Inst_service getMediaByUserId:self.user.userId
                         onSuccess:^(NSArray *mediaArray) {
                             weakSelf.mediaData = mediaArray;
                             [weakSelf reloadCollectionView];
                         }
                         onFailure:^(NSError *error) {
                             [weakSelf showAlertWithTitle:@"Error"
                                                  message:error.localizedDescription];
                         }];
}

#pragma mark - Private

- (void)setDataSourceAndDelegate {
    self.contentView.collectionView.dataSource = self;
    self.contentView.collectionView.delegate = self;
}

- (void)reloadCollectionView {
    [self.contentView.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.mediaData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [MEUserMediaCell cellIdentifier];
    MEUserMediaCell *cell = [cv dequeueReusableCellWithReuseIdentifier:identifier
                                                          forIndexPath:indexPath];
    [cell setModel:self.mediaData[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSURL *mediaUrl = [NSURL URLWithString:self.mediaData[indexPath.row].standardResolution];
    [mediaFocusController showImageFromURL:mediaUrl fromView:self.contentView inViewController:self];
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellWidth = screenWidth / 3 - 0.5f;
    CGFloat cellHeight = cellWidth;
    return CGSizeMake(cellWidth, cellHeight);
}

@end
