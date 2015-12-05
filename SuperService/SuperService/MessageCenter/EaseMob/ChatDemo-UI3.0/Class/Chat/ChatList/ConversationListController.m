//
//  ConversationListController.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/25.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "ConversationListController.h"
#import "ChatViewController.h"
#import "ZKJSHTTPSessionManager.h"
#import "SuperService-Swift.h"
#import "EaseUI.h"
#import "ContactSelectionViewController.h"

@interface ConversationListController ()<EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource,UISearchDisplayDelegate, UISearchBarDelegate, EMChooseViewDelegate>

@property (nonatomic, strong) UIView *networkStateView;

@end

@implementation ConversationListController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"消息";
  
  [self setupRightBarButton];
  
  [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO];
  
  self.showRefreshHeader = YES;
  self.delegate = self;
  self.dataSource = self;
  
  [self tableViewDidTriggerHeaderRefresh];
  
  self.tableView.frame = self.view.bounds;
  
  [self networkStateView];
  
  [self removeEmptyConversationsFromDB];
}

#pragma mark - Private

- (void)setupRightBarButton {
  UIBarButtonItem *createGroupButton = [[UIBarButtonItem alloc] initWithTitle:@"建群" style:UIBarButtonItemStylePlain target:self action:@selector(createGroup)];
  self.navigationItem.rightBarButtonItem = createGroupButton;
}

- (void)createGroup
{
  ContactSelectionViewController *selectionController = [[ContactSelectionViewController alloc] init];
  selectionController.hidesBottomBarWhenPushed = YES;
  selectionController.delegate = self;
  [self.navigationController pushViewController:selectionController animated:YES];
}

#pragma mark - EMChooseViewDelegate

- (BOOL)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources
{
  NSInteger maxUsersCount = 200;
  if ([selectedSources count] > (maxUsersCount - 1)) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"group.maxUserCount", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
    
    return NO;
  }
  
  [self showHudInView:self.view hint:NSLocalizedString(@"group.create.ongoing", @"create a group...")];
  
  NSMutableArray *source = [NSMutableArray array];
  NSMutableArray *nameArray = [NSMutableArray array];
  for (EaseUserModel *model in selectedSources) {
    [source addObject:model.buddy.username];
    [nameArray addObject:model.nickname];
  }
  
  NSString *groupName = [[nameArray copy] componentsJoinedByString:@"、"];
  NSString *shopID = [AccountManager sharedInstance].shopID;
  
  EMGroupStyleSetting *setting = [[EMGroupStyleSetting alloc] init];
  setting.groupMaxUsersCount = maxUsersCount;
  setting.groupStyle = eGroupStyle_PrivateMemberCanInvite;
  
  __weak ConversationListController *weakSelf = self;
  NSString *username = [AccountManager sharedInstance].userName;
  NSString *messageStr = [NSString stringWithFormat:NSLocalizedString(@"group.somebodyInvite", @"%@ invite you to join groups \'%@\'"), username, groupName];
  [[EaseMob sharedInstance].chatManager asyncCreateGroupWithSubject:groupName description:shopID invitees:source initialWelcomeMessage:messageStr styleSetting:setting completion:^(EMGroup *group, EMError *error) {
    [weakSelf hideHud];
    NSLog(@"%@", error);
    if (group && !error) {
      [weakSelf showHint:NSLocalizedString(@"group.create.success", @"create group success")];
      
      ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:group.groupId
                                                                                  conversationType:eConversationTypeGroupChat];
      chatController.title = group.groupSubject;
      chatController.hidesBottomBarWhenPushed = YES;
      chatController.firstMessage = [NSString stringWithFormat:@"邀请%@加入群聊", group.groupSubject];
      [self.navigationController pushViewController:chatController animated:YES];
    }
    else{
      [weakSelf showHint:NSLocalizedString(@"group.create.fail", @"Failed to create a group, please operate again")];
    }
  } onQueue:nil];
  
  return YES;
}

- (void)removeEmptyConversationsFromDB
{
  NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
  NSMutableArray *needRemoveConversations;
  for (EMConversation *conversation in conversations) {
    if (!conversation.latestMessage || (conversation.conversationType == eConversationTypeChatRoom)) {
      if (!needRemoveConversations) {
        needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
      }
      
      [needRemoveConversations addObject:conversation.chatter];
    }
  }
  
  if (needRemoveConversations && needRemoveConversations.count > 0) {
    [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                         deleteMessages:YES
                                                            append2Chat:NO];
  }
}

#pragma mark - getter

- (UIView *)networkStateView
{
  if (_networkStateView == nil) {
    _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
    imageView.image = [UIImage imageNamed:@"messageSendFail"];
    [_networkStateView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
    [_networkStateView addSubview:label];
  }
  
  return _networkStateView;
}

#pragma mark - EaseConversationListViewControllerDelegate

- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel
{
  if (conversationModel) {
    EMConversation *conversation = conversationModel.conversation;
    if (conversation) {
      EMMessage *latestMessage = conversation.latestMessage;
      NSString *userName = [AccountManager sharedInstance].userName;
      NSMutableDictionary *ext = [NSMutableDictionary dictionary];
      NSString *title;
      if ([userName isEqualToString:latestMessage.ext[@"fromName"]]) {
        // 最后一条消息的发送者为自己
        ext = [conversation.latestMessage.ext mutableCopy];
        title = ext[@"toName"];
      } else {
        // 最后一条消息的发送者为对方
        ext[@"fromName"] = latestMessage.ext[@"toName"];
        ext[@"toName"] = latestMessage.ext[@"fromName"];
        if (latestMessage.ext[@"shopId"] &&
            latestMessage.ext[@"shopName"]) {
          ext[@"shopId"] = latestMessage.ext[@"shopId"];
          ext[@"shopName"] = latestMessage.ext[@"shopName"];
        }
        title = ext[@"fromName"];
      }
      ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:conversation.chatter conversationType:conversation.conversationType];
      chatController.title = title;
      chatController.hidesBottomBarWhenPushed = YES;
      chatController.conversation.ext = [ext copy];
      [self.navigationController pushViewController:chatController animated:YES];
    }
  }
}

#pragma mark - EaseConversationListViewControllerDataSource

- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation
{
  EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
  if (model.conversation.conversationType == eConversationTypeChat) {
    EMMessage *latestMessage = conversation.latestMessage;
    NSString *userName = [AccountManager sharedInstance].userName;
    if ([userName isEqualToString:latestMessage.ext[@"fromName"]]) {
      // 最后一条消息的发送者为自己
      model.title = latestMessage.ext[@"toName"];
    } else {
      // 最后一条消息的发送者为对方
      model.title = latestMessage.ext[@"fromName"];
    }
    NSString *url = [NSString stringWithFormat:@"uploads/users/%@.jpg", conversation.chatter];
    model.avatarURLPath = [kBaseURL stringByAppendingString:url];
  } else if (model.conversation.conversationType == eConversationTypeGroupChat) {
    NSString *imageName = @"groupPublicHeader";
    if (![conversation.ext objectForKey:@"groupSubject"] || ![conversation.ext objectForKey:@"isPublic"]) {
      NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
      for (EMGroup *group in groupArray) {
        if ([group.groupId isEqualToString:conversation.chatter]) {
          model.title = group.groupSubject;
          imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
          model.avatarImage = [UIImage imageNamed:imageName];
          
          NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
          [ext setObject:group.groupSubject forKey:@"groupSubject"];
          [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
          conversation.ext = ext;
          break;
        }
      }
    } else {
      NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
      for (EMGroup *group in groupArray) {
        if ([group.groupId isEqualToString:conversation.chatter]) {
          imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
          
          NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
          [ext setObject:group.groupSubject forKey:@"groupSubject"];
          [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
          NSString *groupSubject = [ext objectForKey:@"groupSubject"];
          NSString *conversationSubject = [conversation.ext objectForKey:@"groupSubject"];
          if (groupSubject && conversationSubject && ![groupSubject isEqualToString:conversationSubject]) {
            conversation.ext = ext;
          }
          break;
        }
      }
      model.title = [conversation.ext objectForKey:@"groupSubject"];
      imageName = [[conversation.ext objectForKey:@"isPublic"] boolValue] ? @"groupPublicHeader" : @"groupPrivateHeader";
      model.avatarImage = [UIImage imageNamed:imageName];
    }
  }
  NSLog(@"%@", model.title);
  return model;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
      latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
  NSString *latestMessageTitle = @"";
  EMMessage *lastMessage = [conversationModel.conversation latestMessage];
  if (lastMessage) {
    id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
    switch (messageBody.messageBodyType) {
      case eMessageBodyType_Image:{
        latestMessageTitle = NSLocalizedString(@"message.image1", @"[image]");
      } break;
      case eMessageBodyType_Text:{
        if ([[messageBody.message.ext objectForKey:@"extType"] integerValue] == eTextTxtCard) {
          // 订单卡片。
          latestMessageTitle = NSLocalizedString(@"message.card1", @"[card]");
        } else {
          NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                      convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
          latestMessageTitle = didReceiveText;
        }
      } break;
      case eMessageBodyType_Voice:{
        latestMessageTitle = NSLocalizedString(@"message.voice1", @"[voice]");
      } break;
      case eMessageBodyType_Location: {
        latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
      } break;
      case eMessageBodyType_Video: {
        latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
      } break;
      case eMessageBodyType_File: {
        latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
      } break;
      default: {
      } break;
    }
  }
  
  return latestMessageTitle;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
  NSString *latestMessageTime = @"";
  EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
  if (lastMessage) {
    latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
  }
  
  return latestMessageTime;
}

#pragma mark - public

-(void)refreshDataSource
{
  [self tableViewDidTriggerHeaderRefresh];
  [self hideHUD];
}

- (void)isConnect:(BOOL)isConnect{
  if (!isConnect) {
    self.tableView.tableHeaderView = _networkStateView;
  }
  else{
    self.tableView.tableHeaderView = nil;
  }
  
}

- (void)networkChanged:(EMConnectionState)connectionState
{
  if (connectionState == eEMConnectionDisconnected) {
    self.tableView.tableHeaderView = _networkStateView;
  }
  else{
    self.tableView.tableHeaderView = nil;
  }
}

- (void)willReceiveOfflineMessages{
  NSLog(NSLocalizedString(@"message.beginReceiveOffine", @"Begin to receive offline messages"));
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
  [self refreshDataSource];
}

- (void)didFinishedReceiveOfflineMessages{
  NSLog(NSLocalizedString(@"message.endReceiveOffine", @"End to receive offline messages"));
}

@end
