//
//  ZKJSHTTPSessionManager.m
//  SuperService
//
//  Created by Hanton on 10/14/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

#import "ZKJSHTTPSessionManager.h"
#import "NSString+ZKJS.h"
#import "SuperService-Swift.h"

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

- (void)addClientWithPhone:(NSString *)phone username:(NSString *)username  position:(NSString *)position company:(NSString *)company other_desc:(NSString *)other_desc is_bill:(NSString *)is_bill success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"semp/adduser" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[[self shopID] dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
    [formData appendPartWithFormData:[phone dataUsingEncoding:NSUTF8StringEncoding] name:@"phone"];
    [formData appendPartWithFormData:[username dataUsingEncoding:NSUTF8StringEncoding] name:@"username"];
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


#pragma mark - 获取我的客户

- (void)getClientListWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"semp/showuserlist" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[[self shopID] dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
    
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"我的客户==%@", [responseObject description]);
    success(task, responseObject);
    
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@", error.description);
    failure(task, error);
  }];
}


#pragma mark - 获取到店通知信息

- (void)clientArrivalInfoWithClientID:(NSString *)clientID success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"semp/notice" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[[self shopID] dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
    [formData appendPartWithFormData:[clientID dataUsingEncoding:NSUTF8StringEncoding] name:@"uid"];
    
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"%@", [responseObject description]);
    success(task, responseObject);
    
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@", error.description);
    failure(task, error);
  }];
}


#pragma mark - 获取我的团队列表

- (void)getTeamListWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"semp/teamlist" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[[self shopID] dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
    
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"%@",[responseObject description]);
    success(task,responseObject);

  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@",error.description);
    failure(task,error);
  }];
}


#pragma mark - 获取订单列表

- (void)getOrderListWithPage:(NSString *)page success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"semp/order" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[[self shopID] dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
    [formData appendPartWithFormData:[@"1" dataUsingEncoding:NSUTF8StringEncoding] name:@"status"];
    [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"userids"];
    [formData appendPartWithFormData:[page dataUsingEncoding:NSUTF8StringEncoding] name:@"page"];
    [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"pagetime"];
    [formData appendPartWithFormData:[@"7" dataUsingEncoding:NSUTF8StringEncoding] name:@"pagedata"];
    
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"==%@",[responseObject description]);
    success(task,responseObject);
    
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@",error.description);
    failure(task,error);
  }];
}

#pragma mark - 获取订单详情

- (void)getOrderWithReservationNO:(NSString *)reservationNO success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"semp/show" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[reservationNO dataUsingEncoding:NSUTF8StringEncoding] name:@"reservation_no"];
    
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"==%@",[responseObject description]);
    success(task,responseObject);
    
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@",error.description);
    failure(task,error);
  }];
}

#pragma mark - 新建成员

- (void)addMemberWithPhone:(NSString *)phone name:(NSString *)name roleid:(NSString *)roleid email:(NSString *)email dept:(NSString *)dept desc:(NSString *)desc success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"shop/add" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
   [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"userid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[[self shopID] dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
    [formData appendPartWithFormData:[phone dataUsingEncoding:NSUTF8StringEncoding] name:@"phone"];
    [formData appendPartWithFormData:[name dataUsingEncoding:NSUTF8StringEncoding] name:@"name"];
    [formData appendPartWithFormData:[roleid dataUsingEncoding:NSUTF8StringEncoding] name:@"roleid"];
    [formData appendPartWithFormData:[email dataUsingEncoding:NSUTF8StringEncoding] name:@"email"];
    [formData appendPartWithFormData:[dept dataUsingEncoding:NSUTF8StringEncoding] name:@"dept"];
    [formData appendPartWithFormData:[desc dataUsingEncoding:NSUTF8StringEncoding] name:@"desc"];
    
  } success:^(NSURLSessionDataTask *  task, id responseObject) {
    NSLog(@"==%@",[responseObject description]);
    success(task,responseObject);
    
  } failure:^(NSURLSessionDataTask *  task, NSError * error) {
    NSLog(@"%@",error.description);
    failure(task,error);
  }];
}

#pragma mark - 获取部门列表

- (void)getMemberListWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"shop/deptlist" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[[self shopID] dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
    
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"部门列表==%@", [responseObject description]);
    success(task, responseObject);
    
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@", error.description);
    failure(task, error);
  }];
}

#pragma mark - 新增部门

- (void)addDepartmentWithDepartment:(NSString *)department success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"shop/adddept" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[[self shopID] dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
    [formData appendPartWithFormData:[department dataUsingEncoding:NSUTF8StringEncoding] name:@"dept"];
    
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"==%@", [responseObject description]);
    success(task, responseObject);
    
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@", error.description);
    failure(task, error);
  }];
}
@end
