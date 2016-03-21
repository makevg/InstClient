//
//  MEInstService.m
//  InstClient
//
//  Created by Maximychev Evgeny on 19.03.16.
//  Copyright © 2016 Maximychev Evgeny. All rights reserved.
//

#import "MEInstService.h"
#import "MEUser.h"
#import "MEMedia.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

NSString *const cAuthUrl = @"https://api.instagram.com/oauth/authorize/";
NSString *const cSearchUrl = @"https://api.instagram.com/v1/users/search";

NSString *const cClientID = @"f43ec3d18a3a47e597f78e909c77c1e3";
NSString *const credirectUri = @"http://makevg.livejournal.com/";
NSString *const cresponseType = @"token";
NSString *const cScopes = @"basic+public_content";

@interface MEInstService ()
@property (nonatomic) AFHTTPSessionManager *requestOperationManager;
@end

@implementation MEInstService {
    NSString *cliendId;
    NSString *redirectUri;
    NSString *responseType;
    NSString *scope;
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

#pragma mark - Lazy init

- (AFHTTPSessionManager *)requestOperationManager {
    if (!_requestOperationManager) {
        _requestOperationManager = [self prepareOperationManager];
    }
    return _requestOperationManager;
}

#pragma mark - Private

- (void)lazyLoad {
    cliendId = cClientID;
    redirectUri = credirectUri;
    responseType = cresponseType;
    scope = cScopes;
    [self prepareOperationManager];
}

- (AFHTTPSessionManager *)prepareOperationManager {
    AFHTTPSessionManager *requestOperationManager = [AFHTTPSessionManager new];
    requestOperationManager.responseSerializer.acceptableContentTypes
    = [requestOperationManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    return requestOperationManager;
}

- (void)getInformationWithParams:(NSDictionary *)params
                          method:(NSString *)method
                       onSuccess:(void(^)(NSDictionary *responseObject))success
                       onFailure:(void (^)(NSError *error))failure {
    __weak typeof(self)weakSelf = self;
    [self showActivityIndicator:YES];
    [self.requestOperationManager GET:method
                           parameters:params
                             progress:nil
                              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
                                  if (success) {
                                      success(responseObject);
                                      [weakSelf showActivityIndicator:NO];
                                  }
                              }
                              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                  if (failure) {
                                      failure(error);
                                      [weakSelf showActivityIndicator:NO];
                                  }
                              }];
}

- (void)showActivityIndicator:(BOOL)show {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = show;
}

#pragma mark - Public

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
    
    __block NSMutableArray<MEUser *> *usersArray = [NSMutableArray<MEUser *> new];
    
    if ([searchStr length] < 1) {
        if (success) {
            success(usersArray);
            return;
        }
    }
    
    NSDictionary *params = @{@"q" : searchStr,
                             @"access_token" : self.accessToken};
    [self getInformationWithParams:params
                            method:cSearchUrl
                         onSuccess:^(NSDictionary *responseObject) {
                             usersArray = [[self usersFromResponseArray:responseObject[@"data"]] mutableCopy];
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

- (void)getMediaByUserId:(NSString *)userId
              maxMediaId:(NSString *)mediaId
               onSuccess:(void(^)(NSArray *mediaArray))success
               onFailure:(void (^)(NSError *error))failure {
    
    NSString *mediaUrl = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent/", userId];
    NSString *maxMediaId = mediaId ? mediaId : @"";
    
    [self getInformationWithParams:@{@"access_token" : self.accessToken,
                                     @"count" : @9,
                                     @"max_id" : maxMediaId}
                            method:mediaUrl
                         onSuccess:^(NSDictionary *responseObject) {
                             NSArray<MEMedia *> *mediaArray =
                             [self mediaFromResponseArray:responseObject[@"data"]];
                             
                             if (success) {
                                 success(mediaArray);
                             }
                         }
                         onFailure:^(NSError *error) {
                             if (failure) {
                                 failure(error);
                             }
                         }];
}

- (NSArray<MEMedia *> *)mediaFromResponseArray:(NSArray *)response {
    NSMutableArray<MEMedia *> *mediaArray = [NSMutableArray<MEMedia *> new];
    for (NSDictionary *mediaDict in response) {
        MEMedia *media = [MEMedia new];
        media.mediaId = mediaDict[@"id"];
        NSDictionary *imagesDict = mediaDict[@"images"];
        media.lowResolution = imagesDict[@"low_resolution"][@"url"];
        media.standardResolution = imagesDict[@"standard_resolution"][@"url"];
        
        [mediaArray addObject:media];
    }
    return mediaArray;
}

@end
