//
//  MEBaseCollectionViewCell.h
//  InstClient
//
//  Created by Maximychev Evgeny on 21.03.16.
//  Copyright © 2016 Maximychev Evgeny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEStyle.h"

@interface MEBaseCollectionViewCell : UICollectionViewCell

+ (NSString *)cellIdentifier;

- (void)setModel:(id)model;
- (void)configureCell;

@end
