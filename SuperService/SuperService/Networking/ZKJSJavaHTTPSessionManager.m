//
//  ZKJSJavaHTTPSessionManager.m
//  SuperService
//
//  Created by Hanton on 12/13/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

#import "ZKJSJavaHTTPSessionManager.h"

#import "NSString+ZKJS.h"
#import "SuperService-Swift.h"
#import "EaseMob.h"

@implementation ZKJSJavaHTTPSessionManager

#pragma mark - Initialization

+ (instancetype)sharedInstance {
  static dispatch_once_t once;
  static id sharedInstance;
  dispatch_once(&once, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (id)init {
  self = [super initWithBaseURL:[[NSURL alloc] initWithString:kJavaBaseURL]];
  if (self) {
    self.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    self.responseSerializer = [[AFJSONResponseSerializer alloc] init];
  }
  return self;
}


#pragma mark - Public

- (NSString *)domain {
  return kJavaBaseURL;
}


#pragma mark - Private

- (NSString *)userID {
  return [AccountManager sharedInstance].userID;
}

- (NSString *)token {
  return [AccountManager sharedInstance].token;
}

- (NSString *)shopID {
  return [AccountManager sharedInstance].shopID;
}

- (NSString *)userName {
  return [AccountManager sharedInstance].userName;
}

- (NSString *)shopName {
  return [AccountManager sharedInstance].shopName;
}

- (NSString *)locid {
  return [AccountManager sharedInstance].beaconLocationIDs;
}

#pragma mark - 到店通知
- (void)getArrivalInfoWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  NSDictionary * dict = @{@"shopid": [self shopID],
                          @"locid": [self locid]};
  [self POST:@"arrive/users" parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
    success(task, responseObject);
//    NSLog(@"%@", [responseObject description]);
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    failure(task, error);
  }];
}

#pragma mark - 获取订单列表
- (void)getOrderListWithPage:(NSString *)page success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  NSString *url = [NSString stringWithFormat:@"order/list/%@/%@/%@/7", [self shopID], [self userID], page];
  [self GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
    success(task, responseObject);
//    NSLog(@"%@", [responseObject description]);
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    failure(task, error);
  }];
}

# pragma mark - 获取商家详情
- (void)getShopDetailWithShopID:(NSString *)shopID success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  NSString * url = [NSString stringWithFormat:@"shop/get/%@", shopID];
  [self GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
    success(task, responseObject);
//    NSLog(@"%@", [responseObject description]);
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    failure(task, error);
  }];
}

# pragma mark - 订单新增
- (void)addOrderWithCategory:(NSString *)category data:(NSDictionary *)data Success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  NSString * str = [ZKJSTool convertJSONStringFromDictionary:data];
  NSData *plainTextData = [str dataUsingEncoding:NSUTF8StringEncoding];
  NSString *base64String = [plainTextData base64EncodedStringWithOptions:0];
  NSDictionary * dic = @{@"category":category,@"data":base64String};
  [self POST:@"order/add" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
    success(task, responseObject);
//    NSLog(@"%@", [responseObject description]);
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    failure(task, error);
    NSLog(@"%@", [error description]);
  }];
}

# pragma mark - 获取订单详情
- (void)getOrderDetailWithOrderNo:(NSString *)orderno Success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  NSString * url = [NSString stringWithFormat:@"order/get/%@", orderno];
  [self GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
    success(task, responseObject);
//    NSLog(@"%@", [responseObject description]);
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    failure(task, error);
  }];
}

#pragma mark - 获取指定商家的商品列表
- (void)getShopGoodsListWithShopID:(NSString *)shopID success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  NSString *urlString = [NSString stringWithFormat:@"goods/get/%@", shopID];
  [self GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    //    NSLog(@"%@", [responseObject description]);
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@", error.description);
    failure(task, error);
  }];
}

#pragma mark - APP升级检查
- (void)checkVersionWithVersion:(NSNumber *)version success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  NSDictionary * dict = @{@"verno":version,
                          @"devicetype": @"ios",
                          @"appid": [NSNumber numberWithInt:2]};  //  应用编号(1:超级身份 2 超级服务)
  [self POST:@"app/upgrade" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
    //    NSLog(@"%@", [responseObject description]);
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@", error.description);
    failure(task, error);
  }];
}

#pragma mark - 订单修改
- (void)updateOrderWithOrder:(NSDictionary *)order success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  NSString * str = [ZKJSTool convertJSONStringFromDictionary:order];
  NSLog(@"%@", str);
  NSData *plainTextData = [str dataUsingEncoding:NSUTF8StringEncoding];
  NSString *base64String = [plainTextData base64EncodedStringWithOptions:0];
  NSDictionary * dic = @{@"data": base64String};
  [self POST:@"order/update" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"%@", [responseObject description]);
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@", error.description);
    failure(task, error);
  }];
}

@end
