//
//  JSHChatVC.m
//  HotelVIP
//
//  Created by Hanton on 6/3/15.
//  Copyright (c) 2015 ZKJS. All rights reserved.
//

#import "SuperService-Swift.h"
#import "JSHChatVC.h"
#import "XHDisplayMediaViewController.h"
#import "XHAudioPlayerHelper.h"
#import "ZKJSTCPSessionManager.h"
#import "UIImage+Resize.h"
#import "ZKJSTool.h"
#import "JTSImageViewController.h"
#import "ZKJSHTTPChatSessionManager.h"

@import AVFoundation;


@interface JSHChatVC () <XHMessageTableViewControllerDelegate, XHMessageTableViewCellDelegate, XHAudioPlayerHelperDelegate, AVAudioPlayerDelegate>
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) XHMessageTableViewCell *currentSelectedCell;
@property (nonatomic, strong) NSString *messageReceiver;
@property (nonatomic, strong) NSString *senderID;
@property (nonatomic, strong) NSString *senderName;
@property (nonatomic, strong) UIImage *senderAvatar;
@property (nonatomic) ChatType chatType;
@property (nonatomic, strong) NSString *shopID;
@end

@implementation JSHChatVC

#pragma mark - View Lifecycle

- (instancetype)initWithChatType:(ChatType)chatType {
  self = [super init];
  if (self) {
    self.chatType = chatType;
    self.shopID = [AccountManager sharedInstance].shopID;
  }
  return self;
}

- (void)viewDidLoad {
  self.allowsSendFace = NO;
  
  [super viewDidLoad];
  
  [[Persistence sharedInstance] resetConversationBadgeWithSessionID:self.sessionID];
  
  [self setupNotification];
  [self setupMessageTableView];
  [self setupMessageInputView];
//  [self setupSessionID];
  [self customizeChatType];
  [self loadDataSource];
}

- (void)dealloc {
  [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - XHMessageTableViewController Delegate

- (BOOL)shouldLoadMoreMessagesScrollToTop {
  return YES;
}

- (void)loadMoreMessagesScrollTotop {
  NSLog(@"Load More Messages");
  if (self.messages.count == 0) {
    return;
  } else {
    if (!self.loadingMoreMessage) {
      self.loadingMoreMessage = YES;
      XHMessage *message = self.messages[0];
      
      WEAKSELF
      NSNumber *timestamp = [NSNumber numberWithLongLong:[message.timestamp timeIntervalSince1970]];
      [[ZKJSHTTPChatSessionManager sharedInstance] getChatLogWithSessionID:self.sessionID fromTime:timestamp count:@7 success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray *chatMessages = [NSMutableArray array];
        for (NSDictionary *message in responseObject) {
          XHMessage *chatMessage = [self getXHMessageFromDictionary:message];
          [chatMessages addObject:chatMessage];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
          if (chatMessages.count != 0) {
            [weakSelf insertOldMessages:[[[chatMessages reverseObjectEnumerator] allObjects] copy] completion:^{
              weakSelf.loadingMoreMessage = NO;
            }];
          } else {
            weakSelf.loadingMoreMessage = NO;
          }
        });
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [ZKJSTool showMsg:error.localizedDescription];
      }];
    }
  }
}

- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
  [self sendTextMessage:text];
  XHMessage *message = [[XHMessage alloc] initWithText:text sender:sender timestamp:date];
  message.bubbleMessageType = XHBubbleMessageTypeSending;
  message.messageMediaType = XHBubbleMessageMediaTypeText;
  message.avatar = self.senderAvatar;

  [[Persistence sharedInstance] saveConversationWithSessionID:self.sessionID
                                                  otherSideID:self.receiverID
                                                otherSideName:self.receiverName
                                                     lastChat:text
                                                    timestamp:date];
  
  [self addMessage:message];
  [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
}

- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date {
  [ZKJSTool showLoading:@"正在发送..."];
  NSNumber *timestamp = [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]];
  NSString *format = @"jpg";
  // 压缩图片
  CGFloat compression = 0.9f;
  CGFloat maxCompression = 0.1f;
  int maxFileSize = 1*1024;//1024*1024;  //大约1K
  NSData *imageData = UIImageJPEGRepresentation(photo, compression);
  while ([imageData length] > maxFileSize && compression > maxCompression) {
    compression -= 0.1;
    imageData = UIImageJPEGRepresentation(photo, compression);
  }
  UIImage *thumbnail = [UIImage imageWithData:imageData];
  NSLog(@"Thumbnail Size: %fK", [imageData length]/1024.0);
  
  [[ZKJSHTTPChatSessionManager sharedInstance] uploadPictureWithFromID:self.senderID sessionID:self.sessionID shopID:self.shopID format:format image:photo success:^(NSURLSessionDataTask *task, id responseObject) {
    NSNumber *result = responseObject[@"result"];
    NSString *url = responseObject[@"url"];
    NSString *s_url = responseObject[@"s_url"];
    if ([result isEqual:@1]) {
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
      NSString *fileName = [dateFormatter stringFromDate:[NSDate date]];
      NSDictionary *dictionary = @{
                                   @"type": [NSNumber numberWithInteger:MessageServiceChatImgChat],
                                   @"timestamp": timestamp,
                                   @"fromid": self.senderID,
                                   @"fromname": self.senderName,
                                   @"clientid": self.senderID,
                                   @"clientname": self.senderName,
                                   @"shopid": self.shopID,
                                   @"sessionid": self.sessionID,
                                   @"url": url,
                                   @"scaleurl": s_url,
                                   @"format": format,
                                   @"ruletype": @"DefaultChatRuleType",
                                   @"filename": [NSString stringWithFormat:@"%@.%@", fileName, format]
                                   };
      [[ZKJSTCPSessionManager sharedInstance] sendPacketFromDictionary:dictionary];
      
      XHMessage *message = [[XHMessage alloc] initWithPhoto:thumbnail thumbnailUrl:s_url originPhotoUrl:url sender:sender timestamp:date];
      message.bubbleMessageType = XHBubbleMessageTypeSending;
      message.messageMediaType = XHBubbleMessageMediaTypePhoto;
      message.avatar = self.senderAvatar;
      
      [[Persistence sharedInstance] saveConversationWithSessionID:self.sessionID
                                                      otherSideID:self.receiverID
                                                    otherSideName:self.receiverName
                                                         lastChat:@"[图片]"
                                                        timestamp:date];
      
      [self addMessage:message];
      [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypePhoto];
      
      [ZKJSTool hideHUD];
    } else {
      [ZKJSTool hideHUD];
      [ZKJSTool showMsg:@"上传失败，请重新发送"];
    }
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    [ZKJSTool hideHUD];
    [ZKJSTool showMsg:error.localizedDescription];
  }];
}

- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date {
//  [self sendVoiceMessage:voicePath];
  NSData *audioData = [[NSData alloc] initWithContentsOfFile:voicePath];
  NSNumber *timestamp = [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]];
  NSString *format = @"aac";
  
  [[ZKJSHTTPChatSessionManager sharedInstance] uploadAudioWithFromID:self.senderID sessionID:self.sessionID shopID:self.shopID format:format body:audioData success:^(NSURLSessionDataTask *task, id responseObject) {
    NSNumber *result = responseObject[@"result"];
    NSString *url = responseObject[@"url"];
    if ([result  isEqual: @1]) {
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
      NSString *fileName = [dateFormatter stringFromDate:[NSDate date]];
      NSDictionary *dictionary = @{
                                   @"type": [NSNumber numberWithInteger:MessageServiceChatMediaChat],
                                   @"timestamp": timestamp,
                                   @"fromid": self.senderID,
                                   @"fromname": self.senderName,
                                   @"clientid": self.senderID,
                                   @"clientname": self.senderName,
                                   @"shopid": self.shopID,
                                   @"sessionid": self.sessionID,
                                   @"durnum": voiceDuration,
                                   @"format": format,
                                   @"ruletype": @"DefaultChatRuleType",
                                   @"filename": [NSString stringWithFormat:@"%@.%@", fileName, format],
                                   @"url": url
                                   };
      [[ZKJSTCPSessionManager sharedInstance] sendPacketFromDictionary:dictionary];
      
      XHMessage *message = [[XHMessage alloc] initWithVoicePath:voicePath voiceUrl:voicePath voiceDuration:voiceDuration sender:sender timestamp:date];
      message.bubbleMessageType = XHBubbleMessageTypeSending;
      message.messageMediaType = XHBubbleMessageMediaTypeVoice;
      message.avatar = self.senderAvatar;
      
      [[Persistence sharedInstance] saveConversationWithSessionID:self.sessionID
                                                      otherSideID:self.receiverID
                                                    otherSideName:self.receiverName
                                                         lastChat:@"[语音]"
                                                        timestamp:date];
      
      [self addMessage:message];
      [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVoice];
    } else {
      [ZKJSTool showMsg:@"上传失败，请重新发送"];
    }
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    [ZKJSTool showMsg:error.localizedDescription];
  }];
}

- (void)didSendEmotion:(NSString *)emotionPath fromSender:(NSString *)sender onDate:(NSDate *)date {
//  [self sendVoiceMessage:voicePath];
  XHMessage *message = [[XHMessage alloc] initWithEmotionPath:emotionPath sender:sender timestamp:date];
  message.bubbleMessageType = XHBubbleMessageTypeSending;
  message.messageMediaType = XHBubbleMessageMediaTypeEmotion;
  message.avatar = self.senderAvatar;
  
//  [Persistence.sharedInstance saveMessage:message shopID:self.shopID];
  
  [self addMessage:message];
  [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeEmotion];
}

#pragma mark - XHMessageTableViewCell delegate

- (void)multiMediaMessageDidSelectedOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
  UIViewController *disPlayViewController;
  switch (message.messageMediaType) {
    case XHBubbleMessageMediaTypeVideo:
    case XHBubbleMessageMediaTypePhoto: {
      DLog(@"message : %@", message.photo);
      DLog(@"message : %@", message.videoConverPhoto);
      
      JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
      imageInfo.imageURL = [NSURL URLWithString:message.originPhotoUrl];
      imageInfo.referenceRect = messageTableViewCell.frame;
      imageInfo.referenceView = messageTableViewCell.superview;
      JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                             initWithImageInfo:imageInfo
                                             mode:JTSImageViewControllerMode_Image
                                             backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
      [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOffscreen];
      break;
    }
      break;
    case XHBubbleMessageMediaTypeVoice: {
      DLog(@"message : %@", message.voicePath);
      
      message.isRead = YES;
      messageTableViewCell.messageBubbleView.voiceUnreadDotImageView.hidden = YES;
      
      [[XHAudioPlayerHelper shareInstance] setDelegate:(id<NSFileManagerDelegate>)self];
      if (self.currentSelectedCell) {
        [self.currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
      }
      if (self.currentSelectedCell == messageTableViewCell) {
        [messageTableViewCell.messageBubbleView.animationVoiceImageView stopAnimating];
        [[XHAudioPlayerHelper shareInstance] stopAudio];
        self.currentSelectedCell = nil;
      } else {
        self.currentSelectedCell = messageTableViewCell;
        [messageTableViewCell.messageBubbleView.animationVoiceImageView startAnimating];
        [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:message.voicePath toPlay:YES];
      }
      break;
    }
    case XHBubbleMessageMediaTypeEmotion:
      DLog(@"facePath : %@", message.emotionPath);
      break;
    case XHBubbleMessageMediaTypeLocalPosition: {
      DLog(@"facePath : %@", message.localPositionPhoto);
      break;
    }
//    case XHBubbleMessageMediaTypeCard: {
//      disPlayViewController = [UIViewController new];
//      disPlayViewController.view.backgroundColor = [UIColor whiteColor];
//      UILabel *label = [[UILabel alloc] initWithFrame:disPlayViewController.view.bounds];
//      label.textAlignment = NSTextAlignmentCenter;
//      label.textColor = [UIColor blackColor];
//      label.text = @"呵呵";
//      [disPlayViewController.view addSubview:label];
//      break;
//    }
    default:
      break;
  }
  if (disPlayViewController) {
    [self.navigationController pushViewController:disPlayViewController animated:YES];
  }
}

#pragma mark - XHAudioPlayerHelper Delegate

- (void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer {
  if (!self.currentSelectedCell) {
    return;
  }
  [self.currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
  self.currentSelectedCell = nil;
}

#pragma mark - RecorderPath Helper Method

- (NSString *)getRecorderPath {
  NSURL *recorderPath = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
  NSDate *now = [NSDate date];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
  NSString *fileName = [NSString stringWithFormat:@"%@.aac", [dateFormatter stringFromDate:now]];
  recorderPath = [recorderPath URLByAppendingPathComponent:fileName];
  return [recorderPath path];
}

- (NSString *)getPlayPath {
  NSURL *recorderPath = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
  NSDate *now = [NSDate date];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
  NSString *fileName = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:now]];
  recorderPath = [recorderPath URLByAppendingPathComponent:fileName];
  return [recorderPath path];
}

#pragma mark - Private Methods

- (void)popToRootVC:(UIBarButtonItem *)sender {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setupMessageTableView {
  self.messageTableView.backgroundColor = [UIColor colorWithHexString:@"#CBCCCA"];
  self.messageSender = @"我";
  self.messageReceiver = self.receiverName;
  self.shopID = [AccountManager sharedInstance].shopID;
  self.senderID = [AccountManager sharedInstance].userID;
  self.senderName = [AccountManager sharedInstance].userName;
  
  NSString *urlString = [NSString stringWithFormat:@"%@uploads/users/%@.jpg", kBaseURL, self.senderID];
  NSURL *url = [NSURL URLWithString:urlString];
  NSData *imageData = [NSData dataWithContentsOfURL:url];
  if (imageData) {
    self.senderAvatar = [[UIImage imageWithData:imageData] resizedImage:CGSizeMake(50, 50) interpolationQuality:kCGInterpolationDefault];
  } else {
    self.senderAvatar = [[UIImage imageNamed:@"img_hotel_zhanwei"] resizedImage:CGSizeMake(50, 50) interpolationQuality:kCGInterpolationDefault];
  }
}

- (void)setupMessageInputView {
  NSMutableArray *shareMenuItems = [NSMutableArray array];
  NSArray *plugIcons = @[@"sharemore_pic", @"sharemore_video"];
  NSArray *plugTitle = @[@"图片", @"拍照"];
  for (NSString *plugIcon in plugIcons) {
    XHShareMenuItem *shareMenuItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:plugIcon] title:[plugTitle objectAtIndex:[plugIcons indexOfObject:plugIcon]]];
    [shareMenuItems addObject:shareMenuItem];
  }
  self.shareMenuItems = shareMenuItems;
  [self.shareMenuView reloadData];
  
  self.messageInputView.inputTextView.placeHolder = @"";
  self.messageInputView.delegate = self;
  
  NSMutableArray *emotionManagers = [NSMutableArray array];
  for (NSInteger i = 0; i < 1; i ++) {
    XHEmotionManager *emotionManager = [[XHEmotionManager alloc] init];
    emotionManager.emotionName = @"";//[NSString stringWithFormat:@"表情%ld", (long)i];
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSInteger j = 0; j < 18; j ++) {
      XHEmotion *emotion = [[XHEmotion alloc] init];
      NSString *imageName = [NSString stringWithFormat:@"section%ld_emotion%ld", (long)i , (long)j % 16];
      emotion.emotionPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"emotion%ld.gif", (long)j] ofType:@""];
      emotion.emotionConverPhoto = [UIImage imageNamed:imageName];
      [emotions addObject:emotion];
    }
    emotionManager.emotions = emotions;
    
    [emotionManagers addObject:emotionManager];
  }
}

- (void)customizeChatType {
  self.title = self.receiverName;
}

- (void)loadDataSource {
  [ZKJSTool showLoading:@"正在加载聊天记录..."];

  [self loadServerMessages];
}

- (XHMessage *)getXHMessageFromDictionary:(NSDictionary *)message {
  XHMessage *chatMessage = [XHMessage new];
  chatMessage.sender = message[@"fromname"];
  chatMessage.senderName = message[@"fromname"];
  NSTimeInterval timestamp = [message[@"srvtime"] doubleValue];
  chatMessage.timestamp = [[NSDate alloc] initWithTimeIntervalSince1970:timestamp];
  NSLog(@"Message Timestamp: %@", chatMessage.timestamp);
  chatMessage.sended = YES;
  chatMessage.isRead = YES;
  switch ([message[@"type"] integerValue]) {
    case MessageServiceChatTextChat:
      if ([message[@"childtype"] integerValue] == 0) {
        // 普通文本
        chatMessage.text = message[@"textmsg"];
        chatMessage.textString = message[@"textmsg"];
        chatMessage.messageMediaType = XHBubbleMessageMediaTypeText;
      } else if ([message[@"childtype"] integerValue] == 1) {
        // 卡片消息
        chatMessage.cardTitle = @"客户订房信息";
        NSData *jsonData = [message[@"textmsg"] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSString *urlString = [kBaseURL stringByAppendingString:json[@"image"]];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
        chatMessage.cardImage = [UIImage imageWithData:imageData];
        NSArray *subStrings = [json[@"arrival_date"] componentsSeparatedByString:@"-"];
        NSString *date = [NSString stringWithFormat:@"%@/%@", subStrings[1], subStrings[2]];
        NSString *content = [NSString stringWithFormat:@"%@ | %@ | %@晚", json[@"room_type"], date, json[@"dayNum"]];
        chatMessage.cardContent = content;
        chatMessage.messageMediaType = XHBubbleMessageMediaTypeCard;
      }
      break;
    case MessageServiceChatImgChat:
      chatMessage.originPhotoUrl = message[@"url"];
      chatMessage.thumbnailUrl = message[@"scaleurl"];
      chatMessage.messageMediaType = XHBubbleMessageMediaTypePhoto;
      break;
    case MessageServiceChatMediaChat: {
      NSURL *audioURL = [NSURL URLWithString:message[@"url"]];
      NSData *audioData = [NSData dataWithContentsOfURL:audioURL];
      NSString *path = [self getRecorderPath];
      [audioData writeToFile:path atomically:YES];
      chatMessage.voicePath = path;
      chatMessage.voiceUrl = path;
      chatMessage.voiceDuration = message[@"durationnum"];
      chatMessage.messageMediaType = XHBubbleMessageMediaTypeVoice;
      break;
    }
    default:
      break;
  }
  
  if ([message[@"fromid"] isEqualToString:self.senderID]) {
    chatMessage.bubbleMessageType = XHBubbleMessageTypeSending;
    chatMessage.avatar = self.senderAvatar;
  } else {
    chatMessage.bubbleMessageType = XHBubbleMessageTypeReceiving;
    NSString *urlString = [NSString stringWithFormat:@"%@uploads/users/%@.jpg", kBaseURL, message[@"fromid"]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    if (imageData) {
      chatMessage.avatar = [[UIImage imageWithData:imageData] resizedImage:CGSizeMake(50, 50) interpolationQuality:kCGInterpolationDefault];
    } else {
      chatMessage.avatar = [[UIImage imageNamed:@"ic_home_nor"] resizedImage:CGSizeMake(50, 50) interpolationQuality:kCGInterpolationDefault];
    }
  }

  return chatMessage;
}

- (void)loadServerMessages {
  WEAKSELF
  NSNumber *timestamp = [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]];
  [[ZKJSHTTPChatSessionManager sharedInstance] getChatLogWithSessionID:self.sessionID fromTime:timestamp count:@7 success:^(NSURLSessionDataTask *task, id responseObject) {
    NSMutableArray *chatMessages = [NSMutableArray array];
    for (NSDictionary *message in responseObject) {
      XHMessage *chatMessage = [self getXHMessageFromDictionary:message];
      [chatMessages addObject:chatMessage];
    }
    
    self.messages = [[[chatMessages reverseObjectEnumerator] allObjects] copy];
//    self.messages = chatMessages;
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf.messageTableView reloadData];
      [weakSelf scrollToBottomAnimated:NO];
      [ZKJSTool hideHUD];
    });
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    [ZKJSTool showMsg:error.localizedDescription];
  }];
}

- (void)sendTextMessage:(NSString *)text {
  NSNumber *timestamp = [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]];
  NSDictionary *dictionary = @{
                               @"type": [NSNumber numberWithInteger:MessageServiceChatTextChat],
                               @"timestamp": timestamp,
                               @"fromid": self.senderID,
                               @"fromname": self.senderName,
                               @"shopid": self.shopID,
                               @"sessionid": self.sessionID,
                               @"childtype": @0,
                               @"textmsg": text
                               };
  [[ZKJSTCPSessionManager sharedInstance] sendPacketFromDictionary:dictionary];
}

- (void)sendVoiceMessage:(NSString *)voicePath {
  NSData *audioData = [[NSData alloc] initWithContentsOfFile:voicePath];
  NSString *voiceDuration = [self getVoiceDuration:voicePath];
  NSNumber *timestamp = [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]];
  NSString *format = @"aac";
  
  [[ZKJSHTTPChatSessionManager sharedInstance] uploadAudioWithFromID:self.senderID sessionID:self.sessionID shopID:self.shopID format:format body:audioData success:^(NSURLSessionDataTask *task, id responseObject) {
    NSNumber *result = responseObject[@"result"];
    NSString *url = responseObject[@"url"];
    if ([result  isEqual: @1]) {
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
      NSString *fileName = [dateFormatter stringFromDate:[NSDate date]];
      NSDictionary *dictionary = @{
                                   @"type": [NSNumber numberWithInteger:MessageServiceChatMediaChat],
                                   @"timestamp": timestamp,
                                   @"fromid": self.senderID,
                                   @"fromname": self.senderName,
                                   @"clientid": self.senderID,
                                   @"clientname": self.senderName,
                                   @"shopid": self.shopID,
                                   @"sessionid": self.sessionID,
                                   @"durnum": voiceDuration,
                                   @"format": format,
                                   @"ruletype": @"DefaultChatRuleType",
                                   @"filename": [NSString stringWithFormat:@"%@.%@", fileName, format],
                                   @"url": url
                                   };
      [[ZKJSTCPSessionManager sharedInstance] sendPacketFromDictionary:dictionary];
    } else {
      [ZKJSTool showMsg:@"发送失败，请重新发送"];
    }
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
  }];
}

- (void)sendImageMessage:(UIImage *)image {
//  NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
//  NSString *body = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//  NSNumber *timestamp = [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]];
//  NSString *format = @"jpg";
//  
//  [[ZKJSHTTPChatSessionManager sharedInstance] uploadPictureWithFromID:self.senderID sessionID:self.sessionID shopID:self.shopID format:@"jpg" body:body success:^(NSURLSessionDataTask *task, id responseObject) {
//    NSNumber *result = responseObject[@"result"];
//    NSString *url = responseObject[@"url"];
//    NSString *s_url = responseObject[@"s_url"];
//    if ([result isEqual:@1]) {
//      NSDictionary *dictionary = @{
//                                   @"type": [NSNumber numberWithInteger:MessageServiceChatCustomerServiceImgChat],
//                                   @"timestamp": timestamp,
//                                   @"fromid": self.senderID,
//                                   @"fromname": self.senderName,
//                                   @"clientid": self.senderID,
//                                   @"clientname": self.senderName,
//                                   @"shopid": self.shopID,
//                                   @"sessionid": self.sessionID,
//                                   @"url": url,
//                                   @"scaleurl": s_url
//                                   };
//      [[ZKJSTCPSessionManager sharedInstance] sendPacketFromDictionary:dictionary];
//    } else {
//      NSDictionary *dictionary = @{
//                                   @"type": [NSNumber numberWithInteger:MessageServiceChatCustomerServiceImgChat],
//                                   @"timestamp": timestamp,
//                                   @"fromid": self.senderID,
//                                   @"fromname": self.senderName,
//                                   @"clientid": self.senderID,
//                                   @"clientname": self.senderName,
//                                   @"shopid": self.shopID,
//                                   @"sessionid": self.sessionID,
//                                   @"format": format,
//                                   @"body": body
//                                   };
//      [[ZKJSTCPSessionManager sharedInstance] sendPacketFromDictionary:dictionary];
//    }
//  } failure:^(NSURLSessionDataTask *task, NSError *error) {
//
//  }];
}

- (void)dismissSelf {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)newSessionID {
  return [NSString stringWithFormat:@"%@_%@_%@", self.senderID, self.shopID, @"DefaultChatRuleType"];
}

#pragma mark - Notifications

- (void)setupNotification {
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  [center addObserver:self selector:@selector(showTextMessage:) name:@"MessageServiceChatCustomerServiceTextChatNotification" object:nil];
  [center addObserver:self selector:@selector(showImageMessage:) name:@"MessageServiceChatCustomerServiceImgChatNotification" object:nil];
  [center addObserver:self selector:@selector(showVoiceMessage:) name:@"MessageServiceChatCustomerServiceMediaChatNotification" object:nil];
  [center addObserver:self selector:@selector(handleMessageResponse:) name:@"MessageServiceChatCustomerServiceRSPNotification" object:nil];
}

- (void)sendReadAcknowledge:(NSDictionary *)userInfo {
  NSNumber *timestamp = [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]];
  NSDictionary *dictionary = @{
                               @"type": [NSNumber numberWithInteger:MessageServiceChatMsgReadAck],
                               @"timestamp": timestamp,
                               @"shopid": userInfo[@"shopid"],
                               @"seqid": userInfo[@"seqid"],
                               @"fromid": self.senderID,
                               @"toid": userInfo[@"fromid"]
                               };
  [[ZKJSTCPSessionManager sharedInstance] sendPacketFromDictionary:dictionary];
}

- (void)showTextMessage:(NSNotification *)notification {
  NSString *sender = notification.userInfo[@"fromname"];
  NSString *text = notification.userInfo[@"textmsg"];
  
  XHMessage *message;
  message = [[XHMessage alloc] initWithText:text sender:sender timestamp:[NSDate date]];
  message.bubbleMessageType = XHBubbleMessageTypeReceiving;
  message.messageMediaType = XHBubbleMessageMediaTypeText;
  message.avatar = [[UIImage imageNamed:@"ic_home_nor"] resizedImage:CGSizeMake(50, 50) interpolationQuality:kCGInterpolationDefault];
  
  [[Persistence sharedInstance] saveConversationWithSessionID:self.sessionID
                                                  otherSideID:self.receiverID
                                                otherSideName:self.receiverName
                                                     lastChat:text
                                                    timestamp:[NSDate date]];
  
  [self addMessage:message];
  [self.messageTableView reloadData];
  [self scrollToBottomAnimated:NO];
  
  if ([notification.userInfo[@"isreadack"] isEqual: @1]) {
    // 发送回执
    [self sendReadAcknowledge:notification.userInfo];
  }
}

- (void)showVoiceMessage:(NSNotification *)notification {
  NSString *body = nil;
  NSString *voicePath = nil;
  NSString *voiceURL = nil;
  NSString *voiceDuration = nil;
  
  NSString *sender = notification.userInfo[@"fromname"];
  if ([notification.userInfo[@"body"] length] == 0) {
    // 直接传语音文件URL
    voiceURL = notification.userInfo[@"url"];
    voiceDuration = notification.userInfo[@"durnum"];
  } else {
    // 直接传语音文件
    body = notification.userInfo[@"body"];
    NSData *voiceData = [[NSData alloc] initWithBase64EncodedString:body options:NSDataBase64DecodingIgnoreUnknownCharacters];
    voicePath = [self getPlayPath];
    [voiceData writeToFile:voicePath atomically:NO];
    voiceDuration = [self getVoiceDuration:voicePath];
  }
  
  XHMessage *message;
  NSDate *timestamp = [NSDate date];
  message = [[XHMessage alloc] initWithVoicePath:voicePath voiceUrl:voiceURL voiceDuration:voiceDuration sender:sender timestamp:timestamp isRead:NO];
  message.bubbleMessageType = XHBubbleMessageTypeReceiving;
  message.messageMediaType = XHBubbleMessageMediaTypeVoice;
  message.avatar = [[UIImage imageNamed:@"ic_home_nor"] resizedImage:CGSizeMake(50, 50) interpolationQuality:kCGInterpolationDefault];
  
  [[Persistence sharedInstance] saveConversationWithSessionID:self.sessionID
                                                  otherSideID:self.receiverID
                                                otherSideName:self.receiverName
                                                     lastChat:@"[语音]"
                                                    timestamp:timestamp];
  
  [self addMessage:message];
  [self.messageTableView reloadData];
  [self scrollToBottomAnimated:NO];
  
  if ([notification.userInfo[@"isreadack"] isEqual: @1]) {
    // 发送回执
    [self sendReadAcknowledge:notification.userInfo];
  }
}

- (void)showImageMessage:(NSNotification *)notification {
  UIImage *image = nil;
  NSString *thumbnailURL = nil;
  NSString *originPhotoURL = nil;
  
  NSString *sender = notification.userInfo[@"fromname"];
  thumbnailURL = notification.userInfo[@"scaleurl"];
  originPhotoURL = notification.userInfo[@"url"];
  
  XHMessage *message;
  NSDate *timestamp = [NSDate date];
  message = [[XHMessage alloc] initWithPhoto:image thumbnailUrl:thumbnailURL originPhotoUrl:originPhotoURL sender:sender timestamp:timestamp];
  message.bubbleMessageType = XHBubbleMessageTypeReceiving;
  message.messageMediaType = XHBubbleMessageMediaTypePhoto;
  message.avatar = [[UIImage imageNamed:@"ic_home_nor"] resizedImage:CGSizeMake(50, 50) interpolationQuality:kCGInterpolationDefault];
  
  [[Persistence sharedInstance] saveConversationWithSessionID:self.sessionID
                                                  otherSideID:self.receiverID
                                                otherSideName:self.receiverName
                                                     lastChat:@"[图片]"
                                                    timestamp:timestamp];
  
  [self addMessage:message];
  [self.messageTableView reloadData];
  [self scrollToBottomAnimated:NO];
  
  if ([notification.userInfo[@"isreadack"] isEqual: @1]) {
    // 发送回执
    [self sendReadAcknowledge:notification.userInfo];
  }
}

- (void)handleMessageResponse:(NSNotification *)notification {
  NSNumber *result = notification.userInfo[@"result"];
  // 0:发送成功 1:发送失败(协议包不正确,不保存消息) 2:会话中仅客人在线(针对客人) 3:客人当前不在线(针对客服)
  // 4:商家所有客服都不在线 5:会话不存在(可能未创建或已解散) 6:发送者不在会话中
  if ([result integerValue] == 1) {
    [ZKJSTool showMsg:@"消息发送失败"];
  } else if ([result integerValue] == 3) {
    // 当前会话成员中只有客户自己在线
//    [self requestWaiterWithRuleType:@"DefaultChatRuleType" andDescription:@""];
    [ZKJSTool showMsg:@"客人不在线"];
  }
}

- (NSString *)getVoiceDuration:(NSString *)recordPath {
  NSError *error = nil;
  NSString *recordDuration = nil;
  AVAudioPlayer *play = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:recordPath] error:&error];
  if (error) {
    DLog(@"recordPath：%@ error：%@", recordPath, error);
    recordDuration = @"";
  } else {
    DLog(@"时长:%f", play.duration);
    recordDuration = [NSString stringWithFormat:@"%.1f", play.duration];
  }
  return recordDuration;
}

@end
