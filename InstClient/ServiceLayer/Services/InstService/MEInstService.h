//
//  MEInstService.h
//  InstClient
//
//  Created by Maximychev Evgeny on 19.03.16.
//  Copyright © 2016 Maximychev Evgeny. All rights reserved.
//

#import "MEBaseService.h"

#define Inst_service [MEInstService sharedInstance]

@interface MEInstService : MEBaseService

@property (nonatomic) NSString *accessToken;

+ (instancetype)sharedInstance;

- (NSURLRequest *)getAutorizationRequestForInstagram;

- (NSString *)getTokenFromURL:(NSString *)urlString;

- (void)getUsersBySearchString:(NSString *)searchStr
                     onSuccess:(void(^)(NSArray *users))success
                     onFailure:(void (^)(NSError *error))failure;

- (void)getMediaByUserId:(NSString *)userId
              maxMediaId:(NSString *)mediaId
               onSuccess:(void(^)(NSArray *mediaArray))success
               onFailure:(void (^)(NSError *error))failure;

- (NSString *)errorDescriptionByError:(NSError *)error;

@end
