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
    self.requestSerializer = [[AFHTTPRequestSerializer alloc] init];
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

#pragma mark - 到店通知
- (void)getArrivalInfoWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  NSString *url = [NSString stringWithFormat:@"arrive/users/%@/%@/%@", [self shopID], [self userID], [self token]];
  [self GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    failure(task, error);
  }];
}

#pragma mark - 获取订单列表

- (void)getOrderListWithPage:(NSString *)page success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  NSString *url = [NSString stringWithFormat:@"list/%@/%@/7", [self userID], page];
  [self GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    failure(task, error);
  }];
}

@end
