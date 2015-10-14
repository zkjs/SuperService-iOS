//
//  ZKJSTCPSessionManager.h
//  BeaconMall
//
//  Created by Hanton on 5/11/15.
//  Copyright (c) 2015 zkjinshi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MessageIMType) {
  //登录
  MessageIMClientLogin = 1,
  MessageIMClientLogin_RSP = 2,
  
  //登出
  MessageIMClientLogout = 3,
  MessageIMClientLogout_RSP = 4,
  
  //心跳
  MessageIMHeartbeat = 5,
  
  //转移至新服务器
  MessageIMTransferServer = 200,
  
  //user重复连接时,踢走前,给旧连接发条消息
  MessageIMServerRepeatLogin = 6,
};

//自定义用户协议
typedef NS_ENUM(NSInteger, MessageCustomType) {
  MessageCustomUserDefine = 7,
  MessageCustomUserDefine_RSP = 8
};

@protocol TCPSessionManagerDelegate;

@interface ZKJSTCPSessionManager : NSObject

@property (nonatomic, weak) id<TCPSessionManagerDelegate> delegate;

// 单例
+ (instancetype)sharedInstance;

// 初始化Socket
- (void)initNetworkCommunication;

// 释放Socket
- (void)deinitNetworkCommunication;

// 商家登录的接口
- (void)shopLogin:(NSString *)shopID;

// 发包的接口
- (void)sendPacketFromDictionary:(NSDictionary *)dictionary;

@end

@protocol TCPSessionManagerDelegate <NSObject>

@required

// 已建立连接的接口
- (void)didOpenTCPSocket;

// 收包的接口
- (void)didReceivePacket:(NSDictionary *)dictionary;

@end
