//
//  ZKJSJavaHTTPSessionManager.h
//  SuperService
//
//  Created by Hanton on 12/13/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

#define kJavaBaseURL @"http://mmm.zkjinshi.com/" // Java HTTP服务器测试地址
//#define kJavaBaseURL @"app.zkjinshi.com/japi" // Java服务器正式地址

@interface ZKJSJavaHTTPSessionManager : AFHTTPSessionManager

#pragma mark - 单例
+ (instancetype)sharedInstance;

#pragma mark - Public
- (NSString *)domain;

#pragma mark - 到店通知
- (void)getArrivalInfoWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 获取订单列表
- (void)getOrderListWithPage:(NSString *)page success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
