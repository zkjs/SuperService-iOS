//
//  ContactListSelectViewController.m
//  ChatDemo-UI2.0
//
//  Created by EaseMob on 15/10/13.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import "ContactListSelectViewController.h"

#import "ChatViewController.h"
//#import "UserProfileManager.h"
#import "SuperService-Swift.h"

@interface ContactListSelectViewController () <EMUserListViewControllerDelegate,EMUserListViewControllerDataSource>

@end

@implementation ContactListSelectViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.delegate = self;
  self.dataSource = self;
  
  self.title = NSLocalizedString(@"title.chooseContact", @"select the contact");
}

#pragma mark - EMUserListViewControllerDelegate
- (void)userListViewController:(EaseUsersListViewController *)userListViewController
            didSelectUserModel:(id<IUserModel>)userModel
{
  BOOL flag = YES;
  if (self.messageModel) {
    NSMutableDictionary *ext = [self.messageModel.message.ext mutableCopy];
    ext[@"fromName"] = [AccountManager sharedInstance].userName;
    ext[@"toName"] = userModel.nickname;
    
    if (self.messageModel.bodyType == eMessageBodyType_Text) {
      [EaseSDKHelper sendTextMessage:self.messageModel.text to:userModel.buddy.username messageType:eMessageTypeChat requireEncryption:NO messageExt:[ext copy]];
    } else if (self.messageModel.bodyType == eMessageBodyType_Image) {
      flag = NO;
      [self showHudInView:self.view hint:NSLocalizedString(@"transponding", @"transpondFailing...")];
      [[EaseMob sharedInstance].chatManager asyncFetchMessage:self.messageModel.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
        BOOL isSucceed = NO;
        if (!error) {
          NSString *localPath = aMessage == nil ? self.messageModel.fileLocalPath : [[aMessage.messageBodies firstObject] localPath];
          if (localPath && localPath.length > 0) {
            UIImage *image = [UIImage imageWithContentsOfFile:localPath];
            if (image) {
              [EaseSDKHelper sendImageMessageWithImage:image to:userModel.buddy.username messageType:eMessageTypeChat requireEncryption:NO messageExt:[ext copy] quality:1.0f progress:nil];
              isSucceed = YES;
            } else {
              NSLog(@"Read %@ failed!", localPath);
            }
          }
        }
        if (isSucceed) {
          NSMutableArray *array = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
          ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:userModel.buddy.username conversationType:eConversationTypeChat];
          chatController.title = userModel.nickname;
          chatController.hidesBottomBarWhenPushed = YES;
          if ([array count] >= 3) {
            [array removeLastObject];
            [array removeLastObject];
          }
          [array addObject:chatController];
          [self.navigationController setViewControllers:array animated:YES];
        } else {
          [self showHudInView:self.view hint:NSLocalizedString(@"transpondFail", @"transpond Fail")];
        }
      } onQueue:nil];
    }
  }
  if (flag) {
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:userModel.buddy.username conversationType:eConversationTypeChat];
    chatController.title = userModel.nickname;
    chatController.hidesBottomBarWhenPushed = YES;
    if ([array count] >= 3) {
      [array removeLastObject];
      [array removeLastObject];
    }
    [array addObject:chatController];
    [self.navigationController setViewControllers:array animated:YES];
  }
}

#pragma mark - EMUserListViewControllerDataSource
- (id<IUserModel>)userListViewController:(EaseUsersListViewController *)userListViewController
                           modelForBuddy:(EMBuddy *)buddy
{
  id<IUserModel> model = nil;
  model = [[EaseUserModel alloc] initWithBuddy:buddy];
  //    UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.buddy.username];
  //    if (profileEntity) {
  //        model.nickname= profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
  //        model.avatarURLPath = profileEntity.imageUrl;
  //    }
  model.nickname = model.buddy.username;
  return model;
}

- (id<IUserModel>)userListViewController:(EaseUsersListViewController *)userListViewController
                   userModelForIndexPath:(NSIndexPath *)indexPath
{
  id<IUserModel> model = nil;
  model = [self.dataArray objectAtIndex:indexPath.row];
  //    UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.buddy.username];
  //    if (profileEntity) {
  //        model.nickname= profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
  //        model.avatarURLPath = profileEntity.imageUrl;
  //    }
  model.nickname = model.buddy.username;
  return model;
}

#pragma mark - action
- (void)backAction
{
  [self.navigationController popViewControllerAnimated:YES];
}

@end
