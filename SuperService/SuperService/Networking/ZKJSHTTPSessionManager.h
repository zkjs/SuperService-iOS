//
//  ZKJSHTTPSessionManager.h
//  SuperService
//
//  Created by Hanton on 10/14/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

#import "AFNetworking.h"

@protocol HTTPSessionManagerDelegate;

@class OrderModel;

//#define kBaseURL @"http://api.zkjinshi.com/"  // HTTP外网服务器地址
#define kBaseURL @"http://tap.zkjinshi.com/" // HTTP服务器测试地址

@interface ZKJSHTTPSessionManager : AFHTTPSessionManager

@property (nonatomic, weak) id<HTTPSessionManagerDelegate> delegate;

#pragma mark - 单例
+ (instancetype)sharedInstance;

#pragma mark - Public
- (NSString *)domain;

#pragma mark - 管理员登陆
- (void)adminLoginWithPhone:(NSString *)phone password:(NSString *)password success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 添加客户
- (void)addClientWithPhone:(NSString *)phone userid:(NSString *)userid username:(NSString *)username  position:(NSString *)position company:(NSString *)company other_desc:(NSString *)other_desc is_bill:(NSString *)is_bill success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 获取到店通知信息
- (void)clientArrivalInfoWithClientID:(NSString *)clientID success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 获取我的客户列表
- (void)getClientListWithPage:(NSString *)page success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 获取我的团队列表
- (void)getTeamListWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 获取订单列表
- (void)getOrderListWithPage:(NSString *)page success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 获取订单详情
- (void)getOrderWithReservationNO:(NSString *)reservationNO success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 新建成员
- (void)addMemberWithUserData:(NSString *)userData success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 批量删除员工
- (void)deleteMemberWithDeleteList:(NSString *)deleteList success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 获取部门列表
- (void)getMemberListWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 新增部门
- (void)addDepartmentWithDepartment:(NSString *)department success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 支付列表
- (void)getPaymentListWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 商品列表
- (void)getGoodsListWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 更新订单
- (void)updateOrderWithOrder:(OrderModel *)order success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 员工登录
- (void)loginWithphoneNumber:(NSString *)phoneNumber success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 上传服务员资料
- (void)uploadDataWithUserName:(NSString *)userName sex:(NSString *)sex imageFile:(NSData *)imageFile success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 服务员添加客户
- (void)waiterAddClientWithPhone:(NSString *)phone tag:(NSString *)tag success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 获取区域列表
- (void)WaiterGetWholeAreaOfTheBusinessListWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 服务员获取自己的通知区域
- (void)WaiterGetAreaOfTheBusinessListWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 服务员管理修改通知区域
- (void)TheClerkModifiestheAreaOfJurisdictionWithLocID:(NSString *)locID success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 新增订单
- (void)addOrderWithOrder:(OrderModel *)order success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 查询客户
- (void)inquiryClientWithPhoneNumber:(NSString *)phoneNumber success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 服务员随机获取一个邀请码
- (void)theWaiterRandomAccessToanInvitationCodeSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 服务员查看我的邀请码
- (void)theWaiterCheckMyInvitationWithPage:(NSString *)page pageData:(NSString *)pageData success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 服务员查看我的单个邀请码记录
- (void)whoUsedMyCodeWithCode:(NSString *)code success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 查询用户(服务员)简单信息
- (void)getUserInfoWithChatterID:(NSString *)chatterID success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 查询用户(服务员)简单信息
- (void)getMemberInfoWithMemebers:(NSString *)members success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 获取区域到店客户
- (void)getArriveUsersWithLocid:(NSString *)locid success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 邀请码列表带是否被使用
- (void)getInvitationCodeWithPage:(NSString *)page success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)getInvitationLinkWithCode:(NSString *)code success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 服务员获取所有受邀者
- (void)getAllCodeUserWithPage:(NSString *)page success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end

@protocol HTTPSessionManagerDelegate <NSObject>

// error = 400, token失效
- (void)didReceiveInvalidToken;

@end