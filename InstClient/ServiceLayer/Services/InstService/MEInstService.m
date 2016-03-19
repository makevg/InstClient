//
//  MEInstService.m
//  InstClient
//
//  Created by Maximychev Evgeny on 19.03.16.
//  Copyright © 2016 Maximychev Evgeny. All rights reserved.
//

#import "MEInstService.h"
#import "MEUser.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

NSString *const cAuthUrl = @"https://api.instagram.com/oauth/authorize/";
NSString *const cSearchUrl = @"https://api.instagram.com/v1/users/search";

@implementation MEInstService {
    NSString *cliendId;
    NSString *redirectUri;
    NSString *responseType;
    NSString *scope;
    AFHTTPSessionManager *requestOperationManager;
}

#pragma mark - Singleton

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance lazyLoad];
    });
    return sharedInstance;
}

#pragma mark - Private

- (void)lazyLoad {
    cliendId = @"c6eb493b3a834158bb1e24b26ba16b4f";
    redirectUri = @"http://makevg.livejournal.com/";
    responseType = @"token";
    scope = @"basic+public_content";
    [self prepareOperationManager];
}

- (void)prepareOperationManager {
    requestOperationManager = [AFHTTPSessionManager new];
    requestOperationManager.responseSerializer.acceptableContentTypes = [requestOperationManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
}

- (void)getInformationWithParams:(NSDictionary *)params
                          method:(NSString *)method
                       onSuccess:(void(^)(NSDictionary *responseObject))success
                       onFailure:(void (^)(NSError *error))failure {
    [requestOperationManager GET:method
                      parameters:params
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
                                  if (success) {
                                      success(responseObject);
                                  }
                              }
                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             NSLog(@"Error: %@", error);
                             if (failure) {
                                 failure(error);
                             }
                         }];
}

#pragma mark - Public

- (void)auth {
    NSDictionary *params = @{@"client_id" : cliendId,
                             @"redirect_uri" : redirectUri,
                             @"response_type" : responseType,
                             @"scope" : scope};
    [self getInformationWithParams:params
                            method:cAuthUrl
                         onSuccess:^(NSDictionary *responseObject) {
                             NSLog(@"%@", responseObject.description);
                         }
                         onFailure:^(NSError *error) {
                             NSLog(@"%@", error.description);
                         }];
}

- (NSURLRequest *)getAutorizationRequestForInstagram {
    NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=%@&scope=%@", cAuthUrl, cliendId, redirectUri, responseType, scope];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    return request;
}

- (NSString *)getTokenFromURL:(NSString *)urlString {
    NSString *tokenStr = @"access_token=";
    if ([urlString containsString:tokenStr]) {
        NSArray *array = [urlString componentsSeparatedByString:tokenStr];
        NSString *result = [array lastObject];
        self.accessToken = result;
        return result;
    }
    return nil;
}

- (void)getUsersBySearchString:(NSString *)searchStr
                     onSuccess:(void(^)(NSArray *users))success
                     onFailure:(void (^)(NSError *error))failure {
    NSDictionary *params = @{@"q" : @"maximychev",
                             @"access_token" : self.accessToken};
    [self getInformationWithParams:params
                            method:cSearchUrl
                         onSuccess:^(NSDictionary *responseObject) {
                             NSArray<MEUser *> *usersArray = [self usersFromResponseArray:responseObject[@"data"]];
                             if (success) {
                                 success(usersArray);
                             }
                         }
                         onFailure:^(NSError *error) {
                             if (failure) {
                                 failure(error);
                             }
                         }];
}

- (NSArray<MEUser *> *)usersFromResponseArray:(NSArray *)response {
    NSMutableArray<MEUser *> *users = [NSMutableArray<MEUser *> new];
    for (NSDictionary *userDict in response) {
        MEUser *user = [MEUser new];
        user.userId = userDict[@"id"];
        user.userName = userDict[@"username"];
        user.fullName = userDict[@"full_name"];
        user.bio = userDict[@"bio"];
        user.profilePicture = userDict[@"profile_picture"];
        user.website = userDict[@"website"];
        
        [users addObject:user];
    }
    return users;
}

@end
