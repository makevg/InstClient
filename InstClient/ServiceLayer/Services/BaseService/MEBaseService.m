//
//  MEBaseService.m
//  InstClient
//
//  Created by Максимычев Е.О. on 25.03.16.
//  Copyright © 2016 Maximychev Evgeny. All rights reserved.
//

#import "MEBaseService.h"

@implementation MEBaseService

#pragma mark - Private

- (void)makeRequestAsync:(NSString *)method
                     url:(NSString *)urlString
                  params:(NSDictionary *)reqestParams
              completion:(void (^)(NSDictionary *responseObject))completion
                 failure:(void (^)(NSError *error))failure {
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    NSError *serializationError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:reqestParams options:0 error:&serializationError];
    if (serializationError) {
        NSLog(@"error is %@", [serializationError localizedDescription]);
    }
    
    request.HTTPMethod = method;
    request.HTTPBody = postData;
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:reqestParams
                                                   options:kNilOptions error:&error];
    
    if (!serializationError) {
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        if ([httpResponse statusCode] != 200) {
                                                            id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                            NSDictionary *errorDict = responseObject[@"meta"];
                                                            error = [NSError errorWithDomain:errorDict[@"error_type"]
                                                                                        code:[errorDict[@"code"] integerValue]
                                                                                    userInfo:@{NSLocalizedDescriptionKey : errorDict[@"error_message"]}];
                                                            NSLog(@"%@", responseObject);
                                                            if (failure) failure(error);
                                                            return;
                                                        }
                                                        if (data) {
                                                            NSError *jsonError;
                                                            id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                                                            if (jsonError) {
                                                                NSLog(@"Error: %@", [jsonError localizedDescription]);
                                                                return;
                                                            }
                                                            if (error) {
                                                                if (failure) failure(error);
                                                            } else if (completion) completion(responseObject);
                                                            
                                                        }
                                                    }];
        [dataTask resume];
    }
    
}

#pragma mark - Public

- (void)makePOSTRequestAsync:(NSString *)urlAddr
                      params:(NSDictionary *)reqestParams
                  completion:(void (^)(NSDictionary *responseObject))completion
                     failure:(void (^)(NSError *error))failure {
    [self makeRequestAsync:@"POST" url:urlAddr params:reqestParams completion:completion failure:failure];
}

- (void)makeGETRequestAsync:(NSString *)urlAddr
                     params:(NSDictionary *)reqestParams
                 completion:(void (^)(NSDictionary *responseObject))completion
                    failure:(void (^)(NSError *error))failure {
    [self makeRequestAsync:@"GET" url:urlAddr params:reqestParams completion:completion failure:failure];
}

@end
