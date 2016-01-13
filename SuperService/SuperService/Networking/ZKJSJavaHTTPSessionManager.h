//
//  ZKJSJavaHTTPSessionManager.h
//  SuperService
//
//  Created by Hanton on 12/13/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

//#define kJavaBaseURL @"http://test.zkjinshi.com/japi/"
#define kJavaBaseURL @"http://p.zkjinshi.com/japi/"  // Java HTTP服务器预上线地址
//#define kJavaBaseURL @"http://mmm.zkjinshi.com/"  // Java HTTP服务器正式地址

@interface ZKJSJavaHTTPSessionManager : AFHTTPSessionManager

#pragma mark - 单例
+ (instancetype)sharedInstance;

#pragma mark - Public
- (NSString *)domain;

#pragma mark - 到店通知
- (void)getArrivalInfoWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 获取订单列表(服务员)
- (void)getOrderListWithPage:(NSString *)page success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 获取订单列表(商家)
- (void)bussinessGetOrderListWithPage:(NSString *)page success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

# pragma mark - 获取商家详情
- (void)getShopDetailWithShopID:(NSString *)shopID success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

# pragma mark - 订单新增
- (void)addOrderWithCategory:(NSString *)category data:(NSDictionary *)data Success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

# pragma mark - 获取订单详情
- (void)getOrderDetailWithOrderNo:(NSString *)orderno Success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 获取指定商家的商品列表
- (void)getShopGoodsListWithShopID:(NSString *)shopID success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - APP升级检查
- (void)checkVersionWithVersion:(NSNumber *)version success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 订单修改
- (void)updateOrderWithOrder:(NSDictionary *)order success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)confirmOrderWithOrderNo:(NSString *)orderno status:(int)status Success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
@end
