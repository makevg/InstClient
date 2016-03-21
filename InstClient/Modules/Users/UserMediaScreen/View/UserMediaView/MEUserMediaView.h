//
//  MEUserMediaView.h
//  InstClient
//
//  Created by Maximychev Evgeny on 21.03.16.
//  Copyright © 2016 Maximychev Evgeny. All rights reserved.
//

#import "MEBaseView.h"

@interface MEUserMediaView : MEBaseView

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (void)startAnimating;
- (void)stopAnimating;

@end
