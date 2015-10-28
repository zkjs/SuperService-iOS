//
//  ZKJSHTTPSessionManager.h
//  SuperService
//
//  Created by Hanton on 10/14/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

#import "AFNetworking.h"

//static NSString *kBaseURL = @"http://172.21.7.54/";  // HTTP内网服务器地址
static NSString *kBaseURL = @"http://120.25.241.196/";  // HTTP外网服务器地址

@interface ZKJSHTTPSessionManager : AFHTTPSessionManager

// 单例
+ (instancetype)sharedInstance;

// 管理员登陆
- (void)adminLoginWithPhone:(NSString *)phone password:(NSString *)password success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

//添加客户
- (void)addClientWithPhone:(NSString *)phone username:(NSString *)username  position:(NSString *)position company:(NSString *)company other_desc:(NSString *)other_desc is_bill:(NSString *)is_bill success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

// 获取到店通知信息
- (void)clientArrivalInfoWithClientID:(NSString *)clientID success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

//获取我的客户列表
- (void)getClientListWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

//获取我的团队列表
- (void)getTeamListWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

// 获取订单列表
- (void)getOrderListWithPage:(NSString *)page success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
