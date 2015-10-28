//
//  ZKJSHTTPSessionManager.m
//  SuperService
//
//  Created by Hanton on 10/14/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

#import "ZKJSHTTPSessionManager.h"
#import "NSString+ZKJS.h"

@implementation ZKJSHTTPSessionManager

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
  self = [super initWithBaseURL:[[NSURL alloc] initWithString:@"http://120.25.241.196/"]];
  if (self) {
    self.requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    self.responseSerializer = [[AFJSONResponseSerializer alloc] init];
  }
  return self;
}

#pragma mark - 管理员登陆

- (void)adminLoginWithPhone:(NSString *)phone password:(NSString *)password success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"semp/semplogin" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[phone dataUsingEncoding:NSUTF8StringEncoding] name:@"phone"];
    [formData appendPartWithFormData:[[password MD5String] dataUsingEncoding:NSUTF8StringEncoding] name:@"password"];
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"%@", [responseObject description]);
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@", error.description);
    failure(task, error);
  }];
}

#pragma mark - 添加客户

- (void)addClientWithUserID:(NSString *)userID token:(NSString *)token shopID:(NSString *) shopID  phone:(NSString *)phone username:(NSString *)usernamer  position:(NSString *)position company:(NSString *)company other_desc:(NSString *)other_desc is_bill:(NSString *)is_bill success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"semp/adduser" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[userID dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[token dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    
    [formData appendPartWithFormData:[shopID dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
    [formData appendPartWithFormData:[phone dataUsingEncoding:NSUTF8StringEncoding] name:@"phone"];
    [formData appendPartWithFormData:[usernamer dataUsingEncoding:NSUTF8StringEncoding] name:@"username"];
    [formData appendPartWithFormData:[position dataUsingEncoding:NSUTF8StringEncoding ] name:@"position"];
    
    [formData appendPartWithFormData:[company dataUsingEncoding:NSUTF8StringEncoding] name:@"company"];
    [formData appendPartWithFormData:[other_desc dataUsingEncoding:NSUTF8StringEncoding] name:@"other_desc"];
    
    [formData appendPartWithFormData:[is_bill dataUsingEncoding:NSUTF8StringEncoding] name:@"is_bill"];
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"==%@", [responseObject description]);
    success(task, responseObject);
    
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"失败==%@", error.description);
    
    failure(task, error);
  }];
}

#pragma mark - 获取我的联系人列表

- (void)getClientListWithUserID:(NSString *)userID token:(NSString *)token shopID:(NSString *)shopID success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"semp/showuserlist" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[userID dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[token dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    
    [formData appendPartWithFormData:[shopID dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
    
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"我的客户==%@", [responseObject description]);
    success(task, responseObject);
    
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@", error.description);
    failure(task, error);
  }];
}

#pragma mark - 获取到店通知信息

- (void)clientArrivalInfoWithUserID:(NSString *)userID token:(NSString *)token clientID:(NSString *)clientID shopID:(NSString *)shopID success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"semp/notice" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[userID dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[token dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[clientID dataUsingEncoding:NSUTF8StringEncoding] name:@"uid"];
    [formData appendPartWithFormData:[shopID dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"%@", [responseObject description]);
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@", error.description);
    failure(task, error);
  }];
}

#pragma mark - 获取我的团队列表

- (void)getTeamListWithSalesID:(NSString *)salesID token:(NSString *)token shopID:(NSString *)shopID success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"semp/teamlist" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[salesID dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[token dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[shopID dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
    
  } success:^(NSURLSessionDataTask *  task, id responseObject) {
    NSLog(@"%@",[responseObject description]);
    success(task,responseObject);
  } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
    NSLog(@"%@",error.description);
    failure(task,error);
  }];
}

#pragma mark - 获取订单列表

- (void)getOrderListWithSalesID:(NSString *)salesID token:(NSString *)token shopID:(NSString *)shopID status:(NSString *)status userID:(NSString *)userIDs page:(NSString *)page pagetime:(NSString *)pagetime  pagedata:(NSString *)pagedata success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"semp/order" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[salesID dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[token dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[shopID dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
    [formData appendPartWithFormData:[status dataUsingEncoding:NSUTF8StringEncoding] name:@"status"];
    [formData appendPartWithFormData:[userIDs dataUsingEncoding:NSUTF8StringEncoding] name:@"userids"];
    [formData appendPartWithFormData:[page dataUsingEncoding:NSUTF8StringEncoding] name:@"page"];
    [formData appendPartWithFormData:[pagetime dataUsingEncoding:NSUTF8StringEncoding] name:@"pagetime"];
    [formData appendPartWithFormData:[pagedata dataUsingEncoding:NSUTF8StringEncoding] name:@"pagedata"];
  } success:^(NSURLSessionDataTask *  task, id responseObject) {
    NSLog(@"==%@",[responseObject description]);
    success(task,responseObject);
  } failure:^(NSURLSessionDataTask *  task, NSError * error) {
    NSLog(@"%@",error.description);
    failure(task,error);
  }];
}

@end
