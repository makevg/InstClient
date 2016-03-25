//
//  MEBaseService.h
//  InstClient
//
//  Created by Максимычев Е.О. on 25.03.16.
//  Copyright © 2016 Maximychev Evgeny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEBaseService : NSObject

- (void)makePOSTRequestAsync:(NSString *)urlAddr
                      params:(NSDictionary *)reqestParams
                  completion:(void (^)(NSDictionary *responseObject))completion
                     failure:(void (^)(NSError *error))failure;

- (void)makeGETRequestAsync:(NSString *)urlAddr
                     params:(NSDictionary *)reqestParams
                 completion:(void (^)(NSDictionary *responseObject))completion
                    failure:(void (^)(NSError *error))failure;

@end
