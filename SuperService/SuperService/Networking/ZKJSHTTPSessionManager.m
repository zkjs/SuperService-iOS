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

//#define kBaseURL @"http://api.zkjinshi.com/"  // HTTP外网服务器地址
#define kBaseURL @"http://tap.zkjinshi.com/" // HTTP服务器测试地址

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
  self = [super initWithBaseURL:[[NSURL alloc] initWithString:kBaseURL]];
  if (self) {
    self.requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    self.responseSerializer = [[AFJSONResponseSerializer alloc] init];
  }
  return self;
}


#pragma mark - Public

- (NSString *)domain {
  return kBaseURL;
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


#pragma mark - 管理员添加客户

- (void)addClientWithPhone:(NSString *)phone userid:(NSString *)userid username:(NSString *)username  position:(NSString *)position company:(NSString *)company other_desc:(NSString *)other_desc is_bill:(NSString *)is_bill success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"semp/adduser" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[[self shopID] dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
    [formData appendPartWithFormData:[phone dataUsingEncoding:NSUTF8StringEncoding] name:@"phone"];
    [formData appendPartWithFormData:[userid dataUsingEncoding:NSUTF8StringEncoding] name:@"userid"];
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

#pragma mark - 服务员添加客户

- (void)waiterAddClientWithPhone:(NSString *)phone tag:(NSString *)tag success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"semp/addtag" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[[self shopID] dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
    [formData appendPartWithFormData:[phone dataUsingEncoding:NSUTF8StringEncoding] name:@"phone"];
    [formData appendPartWithFormData:[tag dataUsingEncoding:NSUTF8StringEncoding] name:@"tag"];
    
    
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
    [formData appendPartWithFormData:[@"0,1,2,3,4,5" dataUsingEncoding:NSUTF8StringEncoding] name:@"status"];
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

- (void)addMemberWithUserData:(NSString *)userData success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"shop/importsemp" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[[self shopID] dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
    [formData appendPartWithFormData:[userData dataUsingEncoding:NSUTF8StringEncoding] name:@"userdata"];
    
  } success:^(NSURLSessionDataTask *  task, id responseObject) {
    NSLog(@"==%@",[responseObject description]);
    success(task,responseObject);
    
  } failure:^(NSURLSessionDataTask *  task, NSError * error) {
    NSLog(@"%@",error.description);
    failure(task,error);
  }];
}

#pragma mark - 批量删除员工

- (void)deleteMemberWithDeleteList:(NSString *)deleteList success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"shop/deletesemp" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[[self shopID] dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
    [formData appendPartWithFormData:[deleteList dataUsingEncoding:NSUTF8StringEncoding] name:@"deletelist"];
    
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"%@", [responseObject description]);
    success(task, responseObject);
    
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@", error.description);
    failure(task, error);
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

#pragma mark - 支付方式列表

- (void)getPaymentListWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"semp/paylist" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[[self shopID] dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
    
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"==%@", [responseObject description]);
    success(task, responseObject);
    
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@", error.description);
    failure(task, error);
  }];
}

#pragma mark - 商品列表

- (void)getGoodsListWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  NSString *url = [NSString stringWithFormat:@"semp/goods?shopid=%@", [self shopID]];
  [self GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
    NSLog(@"==%@", [responseObject description]);
    success(task, responseObject);
    
  } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    NSLog(@"%@", error.description);
    failure(task, error);
  }];
}

#pragma mark - 修改订单

- (void)updateOrderWithOrder:(OrderModel *)order success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"order/update" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    
    [formData appendPartWithFormData:[order.reservation_no dataUsingEncoding:NSUTF8StringEncoding] name:@"reservation_no"];
    [formData appendPartWithFormData:[order.status.stringValue dataUsingEncoding:NSUTF8StringEncoding] name:@"status"];
    
    [formData appendPartWithFormData:[order.arrival_date dataUsingEncoding:NSUTF8StringEncoding] name:@"arrival_date"];
    [formData appendPartWithFormData:[order.departure_date dataUsingEncoding:NSUTF8StringEncoding] name:@"departure_date"];
    [formData appendPartWithFormData:[order.room_typeid.stringValue dataUsingEncoding:NSUTF8StringEncoding] name:@"room_typeid"];
    [formData appendPartWithFormData:[order.room_type dataUsingEncoding:NSUTF8StringEncoding] name:@"room_type"];
    [formData appendPartWithFormData:[order.room_rate.stringValue dataUsingEncoding:NSUTF8StringEncoding] name:@"room_rate"];
    [formData appendPartWithFormData:[order.rooms.stringValue dataUsingEncoding:NSUTF8StringEncoding] name:@"rooms"];
    [formData appendPartWithFormData:[order.pay_id.stringValue dataUsingEncoding:NSUTF8StringEncoding] name:@"payment"];
    
    if (order.invoice) {
      [formData appendPartWithFormData:[order.invoice dataUsingEncoding:NSUTF8StringEncoding] name:@"invoice"];
    }
    if (order.users) {
      [formData appendPartWithFormData:[order.users dataUsingEncoding:NSUTF8StringEncoding] name:@"users"];
    }
    if (order.room_tags) {
      [formData appendPartWithFormData:[order.room_tags dataUsingEncoding:NSUTF8StringEncoding] name:@"room_tags"];
    }
    if (order.privilege) {
      [formData appendPartWithFormData:[order.privilege dataUsingEncoding:NSUTF8StringEncoding] name:@"privilege"];
    }
    if (order.remark) {
      [formData appendPartWithFormData:[order.remark dataUsingEncoding:NSUTF8StringEncoding] name:@"remark"];
    }
    
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"==%@", [responseObject description]);
    success(task, responseObject);
    
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@", error.description);
    failure(task, error);
  }];
}

#pragma mark - 员工登录

- (void)loginWithphoneNumber:(NSString *)phoneNumber success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"semp/login" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
    
    [formData appendPartWithFormData:[phoneNumber dataUsingEncoding:NSUTF8StringEncoding] name:@"phone"];
    
  } success:^(NSURLSessionDataTask *  task, id   responseObject) {
    NSLog(@"==%@", [responseObject description]);
    success(task, responseObject);
    
  } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
    NSLog(@"%@", error.description);
    failure(task, error);
    
  }];
}

#pragma mark - 上传服务员资料

- (void)uploadDataWithUserName:(NSString *)userName sex:(NSString *)sex imageFile:(NSData *)imageFile success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  NSDictionary *dict = @{
                         @"salesid": [self userID],
                         @"token": [self token],
                         @"name": [self userName],
                         @"sex": sex
                         };
  [self POST:@"semp/sempupdate" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileData:imageFile name:@"file" fileName:@"imageName.jpg" mimeType:@"image/jpeg"];
    
  } success:^(NSURLSessionDataTask *  task, id   responseObject) {
    NSLog(@"==%@", [responseObject description]);
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
    NSLog(@"%@", error.description);
    failure(task, error);
  }];
}

#pragma mark - 获取区域列表

-  (void)WaiterGetWholeAreaOfTheBusinessListWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"semp/shoplocation" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[[self shopID] dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
  } success:^(NSURLSessionDataTask *  task, id   responseObject) {
    //NSLog(@"11%@", [responseObject description]);
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
    //NSLog(@"%@", error.description);
    failure(task, error);
  }];
}

#pragma mark - 服务员获取自己的通知区域

- (void)WaiterGetAreaOfTheBusinessListWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"semp/semplocation" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[[self shopID] dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
  } success:^(NSURLSessionDataTask *  task, id   responseObject) {
    NSLog(@"11%@", [responseObject description]);
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
    NSLog(@"%@", error.description);
    failure(task, error);
  }];
}
#pragma mark - 服务员管理修改通知区域
- (void)TheClerkModifiestheAreaOfJurisdictionWithLocID:(NSString *)locID success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"semp/semplocationupdate" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[[self shopID] dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
    [formData appendPartWithFormData:[locID dataUsingEncoding:NSUTF8StringEncoding] name:@"locid"];
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"==%@", [responseObject description]);
    success(task, responseObject);
    
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@", error.description);
    failure(task, error);
  }];

}
#pragma mark - 新增订单

- (void)addOrderWithOrder:(OrderModel *)order success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"order/add" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[[self shopID] dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
    [formData appendPartWithFormData:[order.userid dataUsingEncoding:NSUTF8StringEncoding] name:@"userid"];
    [formData appendPartWithFormData:[order.guest dataUsingEncoding:NSUTF8StringEncoding] name:@"guest"];
    [formData appendPartWithFormData:[order.guesttel dataUsingEncoding:NSUTF8StringEncoding] name:@"guesttel"];
    [formData appendPartWithFormData:[[self shopName] dataUsingEncoding:NSUTF8StringEncoding] name:@"fullname"];
    [formData appendPartWithFormData:[order.room_typeid.stringValue dataUsingEncoding:NSUTF8StringEncoding] name:@"roomid"];
    [formData appendPartWithFormData:[order.room_type dataUsingEncoding:NSUTF8StringEncoding] name:@"room_type"];
    [formData appendPartWithFormData:[order.imgurl dataUsingEncoding:NSUTF8StringEncoding] name:@"imgurl"];
    [formData appendPartWithFormData:[order.rooms.stringValue dataUsingEncoding:NSUTF8StringEncoding] name:@"rooms"];
    [formData appendPartWithFormData:[order.arrival_date dataUsingEncoding:NSUTF8StringEncoding] name:@"arrival_date"];
    [formData appendPartWithFormData:[order.departure_date dataUsingEncoding:NSUTF8StringEncoding] name:@"departure_date"];
    [formData appendPartWithFormData:[order.room_rate.stringValue dataUsingEncoding:NSUTF8StringEncoding] name:@"room_rate"];
    [formData appendPartWithFormData:[order.status.stringValue dataUsingEncoding:NSUTF8StringEncoding] name:@"status"];
    [formData appendPartWithFormData:[order.pay_id.stringValue dataUsingEncoding:NSUTF8StringEncoding] name:@"payment"];
    
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"==%@", [responseObject description]);
    success(task, responseObject);
    
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@", error.description);
    failure(task, error);
  }];
}

#pragma mark - 查询客户

- (void)inquiryClientWithPhoneNumber:(NSString *)phoneNumber success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"semp/sempsuforphone" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[phoneNumber dataUsingEncoding:NSUTF8StringEncoding] name:@"phone"];
    [formData appendPartWithFormData:[[self shopID] dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
    [formData appendPartWithFormData:[@"9" dataUsingEncoding:NSUTF8StringEncoding] name:@"set"];
  } success:^(NSURLSessionDataTask *  task, id responseObject) {
    NSLog(@"==%@",[responseObject description]);
    success(task,responseObject);
    
  } failure:^(NSURLSessionDataTask *  task, NSError * error) {
    NSLog(@"%@",error.description);
    failure(task,error);
  }];
}

#pragma mark - 服务员随机获取一个邀请码

- (void)theWaiterRandomAccessToanInvitationCodeSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"invitation/random" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[[self shopID] dataUsingEncoding:NSUTF8StringEncoding] name:@"shopid"];
  } success:^(NSURLSessionDataTask *  task, id responseObject) {
    NSLog(@"==%@",[responseObject description]);
    success(task,responseObject);
    
  } failure:^(NSURLSessionDataTask *  task, NSError * error) {
    NSLog(@"%@",error.description);
    failure(task,error);
  }];
}

#pragma mark - 服务员查看我的全部邀请码

- (void)theWaiterCheckMyInvitationWithPage:(NSString *)page pageData:(NSString *)pageData success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"invitation/sempcode" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[page dataUsingEncoding:NSUTF8StringEncoding] name:@"page"];
    [formData appendPartWithFormData:[pageData dataUsingEncoding:NSUTF8StringEncoding] name:@"pagedata"];
  } success:^(NSURLSessionDataTask *  task, id responseObject) {
    NSLog(@"==%@",[responseObject description]);
    success(task,responseObject);
    
  } failure:^(NSURLSessionDataTask *  task, NSError * error) {
    NSLog(@"%@",error.description);
    failure(task,error);
  }];
}

#pragma mark - 服务员查看我的单个邀请码记录

- (void)whoUsedMyCodeWithCode:(NSString *)code success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self POST:@"invitation/codeuserone" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[[self userID] dataUsingEncoding:NSUTF8StringEncoding] name:@"salesid"];
    [formData appendPartWithFormData:[[self token] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    [formData appendPartWithFormData:[code dataUsingEncoding:NSUTF8StringEncoding] name:@"code"];
    
  } success:^(NSURLSessionDataTask *  task, id responseObject) {
    NSLog(@"==%@",[responseObject description]);
    success(task,responseObject);
    
  } failure:^(NSURLSessionDataTask *  task, NSError * error) {
    NSLog(@"%@",error.description);
    failure(task,error);
  }];

}

@end
