//
//  JSHChatVC.h
//  HotelVIP
//
//  Created by Hanton on 6/3/15.
//  Copyright (c) 2015 ZKJS. All rights reserved.
//

#import "XHMessageTableViewController.h"


typedef NS_ENUM(NSInteger, ChatType) {
  ChatClient,
  ChatSingle,
  ChatGroup
};

@interface JSHChatVC : XHMessageTableViewController

@property (nonatomic, strong) NSString *receiverName;
@property (nonatomic, strong) NSString *receiverID;

- (instancetype)initWithChatType:(ChatType)chatType;

@end
