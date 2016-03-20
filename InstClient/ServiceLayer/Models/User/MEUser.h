//
//  MEUser.h
//  InstClient
//
//  Created by Maximychev Evgeny on 19.03.16.
//  Copyright © 2016 Maximychev Evgeny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEUser : NSObject

@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *fullName;
@property (nonatomic) NSString *bio;
@property (nonatomic) NSString *profilePicture;
@property (nonatomic) NSString *website;

@end
