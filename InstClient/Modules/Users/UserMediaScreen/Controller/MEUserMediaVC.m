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
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) NSMutableArray<MEMedia *> *mediaData;
@end

@implementation MEUserMediaVC {
    BOOL pageLoading;
    CGFloat screenWidth;
    URBMediaFocusViewController *mediaFocusController;
}

#pragma mark - Lazy init

- (NSMutableArray<MEMedia *> *)mediaData {
    if (!_mediaData) {
        _mediaData = [NSMutableArray<MEMedia *> new];
    }
    return _mediaData;
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
    [self configureRefreshControl];
    [self setDataSourceAndDelegate];
    [self getNextMediaDataByMinMediaId:nil];
}

#pragma mark - Private

- (void)setDataSourceAndDelegate {
    self.contentView.collectionView.dataSource = self;
    self.contentView.collectionView.delegate = self;
}

- (void)configureRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshMediaData:)
                  forControlEvents:UIControlEventValueChanged];
    [self.contentView.collectionView addSubview:self.refreshControl];
    self.contentView.collectionView.alwaysBounceVertical = YES;
}

- (void)refreshMediaData:(id)sender {
    [self.mediaData removeAllObjects];
    [self getNextMediaDataByMinMediaId:nil];
}

- (void)getNextMediaDataByMinMediaId:(NSString *)mediaId {
    __weak typeof(self)weakSelf = self;
    [Inst_service getMediaByUserId:self.user.userId
                        minMediaId:mediaId
                         onSuccess:^(NSArray *mediaArray) {
                             [weakSelf.mediaData addObjectsFromArray:mediaArray];
                             [weakSelf reloadCollectionView];
                             [weakSelf.contentView stopAnimating];
                             [weakSelf.refreshControl endRefreshing];
                             pageLoading = NO;
                         }
                         onFailure:^(NSError *error) {
                             [weakSelf.contentView stopAnimating];
                             [weakSelf.refreshControl endRefreshing];
                             [weakSelf showAlertWithTitle:@"Error"
                                                  message:error.localizedDescription];
                         }];
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

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == [self.mediaData count] - 1 && !pageLoading) {
        pageLoading = YES;
        NSString *mediaId = [self.mediaData lastObject].mediaId;
        [self getNextMediaDataByMinMediaId:mediaId];
    }
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellWidth = screenWidth / 3 - 1.f;
    CGFloat cellHeight = cellWidth;
    return CGSizeMake(cellWidth, cellHeight);
}

@end
