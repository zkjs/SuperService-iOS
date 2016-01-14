//
//  EaseUserModel.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/24.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "EaseUserModel.h"

#import "EMBuddy.h"

@implementation EaseUserModel

- (instancetype)initWithBuddy:(EMBuddy *)buddy
{
    self = [super init];
    if (self) {
        _buddy = buddy;
      if ([_buddy.username isKindOfClass:[NSNumber class]]) {
        NSNumber *usernameNumber = (NSNumber *)_buddy.username;
        _nickname = [usernameNumber stringValue];
      } else {
        _nickname = _buddy.username;
      }
        _avatarImage = [UIImage imageNamed:@"user"];
    }
    
    return self;
}

@end
