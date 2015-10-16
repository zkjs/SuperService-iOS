//
//  ZKJSHTTPSessionManager.h
//  SuperService
//
//  Created by Hanton on 10/14/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

#import "AFNetworking.h"

@interface ZKJSHTTPSessionManager : AFHTTPSessionManager

// 单例
+ (instancetype)sharedInstance;

// 管理员登陆
- (void)adminLoginWithPhone:(NSString *)phone password:(NSString *)password success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
