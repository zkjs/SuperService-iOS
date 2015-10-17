//
//  ZKJSTCPSessionManager.m
//  BeaconMall
//
//  Created by Hanton on 5/11/15.
//  Copyright (c) 2015 zkjinshi. All rights reserved.
//

#import "ZKJSTCPSessionManager.h"
#import "SRWebSocket.h"

#define kHeartBeatInterval 60

@interface ZKJSTCPSessionManager () <SRWebSocketDelegate> {
  SRWebSocket *_webSocket;
}

@end

@implementation ZKJSTCPSessionManager

+ (instancetype)sharedInstance {
  static dispatch_once_t once;
  static id sharedInstance;
  dispatch_once(&once, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (id)init {
  self = [super init];
  if (self) {
    
  }
  return self;
}

- (void)dealloc {
  _webSocket.delegate = nil;
  [_webSocket close];
  _webSocket = nil;
}


#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
  NSLog(@"Websocket Connected");
    
  if (self.delegate && [self.delegate respondsToSelector:@selector(didOpenTCPSocket)]) {
    [self.delegate didOpenTCPSocket];
  }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
  NSLog(@"Websocket Failed With Error %@", error);
  _webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
  NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
  NSLog(@"Feedback: %@", dictionary);
  if ([dictionary[@"type"] integerValue] == MessageIMClientLogin_RSP) {
    NSLog(@"startHeartbeat");
    [self startHeartbeat];
  }
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(didReceivePacket:)]) {
    [self.delegate didReceivePacket:dictionary];
  }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
  NSLog(@"WebSocket closed");
  _webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
  NSLog(@"Websocket received pong");
}


#pragma mark Public Method

- (void)initNetworkCommunication {
  _webSocket.delegate = nil;
  [_webSocket close];
  _webSocket = nil;
  
  NSString *websocketURL = @"wss://im.zkjinshi.com:6666/zkjs";
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:websocketURL]
                                                         cachePolicy: NSURLRequestUseProtocolCachePolicy
                                                     timeoutInterval:5.0];
  
  // pin down certificate
  NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"der"];
  NSData *certData = [[NSData alloc] initWithContentsOfFile:cerPath];
  CFDataRef certDataRef = (__bridge CFDataRef)certData;
  SecCertificateRef certRef = SecCertificateCreateWithData(NULL, certDataRef);
  id certificate = (__bridge id)certRef;
  [request setSR_SSLPinnedCertificates:@[certificate]];
  
  _webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
  _webSocket.delegate = self;
  
  [_webSocket open];
}

- (void)deinitNetworkCommunication {
  _webSocket.delegate = nil;
  [_webSocket close];
  _webSocket = nil;
}

- (void)loginWithUserID:(NSString *)userID userName:(NSString *)userName deviceToken:(NSString *)deviceToken shopID:(NSString *)shopID beaconLocationIDs:(NSString *)beaconLocationIDs {
  NSNumber *timestamp = [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]];
#if DEBUG
  NSString *appid = @"SUPERSERVICE_DEBUG";
#else
  NSString *appid = @"SUPERSERVICE";
#endif
  NSDictionary *dictionary = @{
                               @"type": [NSNumber numberWithInteger:MessageIMClientLogin],
                               @"timestamp": timestamp,
                               @"platform": @"I",  // A: android,I:ios,W:web
                               @"roleid": @1,  //0: APP用户 1:商家
                               @"appid": appid,
                               @"id": userID,
                               @"name": userName,
                               @"devtoken": deviceToken,
                               @"shopid": shopID,
                               @"loc": beaconLocationIDs,
                               @"workstatus": @0  //0:上班 1:下班
                               };
  
  [self sendPacketFromDictionary:dictionary];
}

- (void)sendPacketFromDictionary:(NSDictionary *)dictionary {
  NSString *jsonString = [self jsonFromDictionary:dictionary];
  NSData *packet = [[NSData alloc] initWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
  [_webSocket send:packet];
  NSLog(@"%@", jsonString);
}


#pragma mark Private Method

- (void)startHeartbeat {
  [NSTimer scheduledTimerWithTimeInterval:kHeartBeatInterval
                                   target:self
                                 selector:@selector(heartBeat)
                                 userInfo:nil
                                  repeats:YES];
}

// 心跳包
- (void)heartBeat {
  NSDictionary *dictionary = @{
                               @"type": [NSNumber numberWithInteger:MessageIMHeartbeat]
                               };
  [self sendPacketFromDictionary:dictionary];
}

- (NSNumber *)timestamp {
  return [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]];
}

- (NSString *)jsonFromDictionary:(NSDictionary *)dictionary {
  NSError *error;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:&error];
  NSString *jsonString = @"";
  if (jsonData) {
    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  } else {
    NSLog(@"Got an error: %@", error);
  }
  
  return jsonString;
}

@end
