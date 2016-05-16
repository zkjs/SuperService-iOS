//
//  JSGtool.m
//  BeaconMall
//
//  Created by dai.fengyi on 4/28/15.
//  Copyright (c) 2015 zkjinshi. All rights reserved.
//

#import "ZKJSTool.h"
#import "MBProgressHUD.h"

@implementation ZKJSTool

#pragma mark - HUD
+ (MBProgressHUD *)Hud {
  UIApplication *application = [UIApplication sharedApplication];
  MBProgressHUD *hud = [MBProgressHUD HUDForView:application.keyWindow];
  if (hud){
    [hud removeFromSuperview];
  }else{
    hud = [[MBProgressHUD alloc] initWithWindow:application.keyWindow];
    hud.removeFromSuperViewOnHide = YES;
  }
  [application.keyWindow addSubview:hud];
  return hud;
}

#pragma mark - 显示提示信息

+ (void)showMsg:(NSString *)message {
  MBProgressHUD * hud = [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow];
  hud.removeFromSuperViewOnHide = YES;
  hud.labelText = message;
  hud.mode = MBProgressHUDModeText;
  hud.labelFont = [UIFont systemFontOfSize:17];
  [hud show:YES];
  [hud hide:YES afterDelay:2.0];
}

#pragma mark - 检测手机号码是否合法
+ (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    /**
     * 虚拟运营商 170
     */
    NSString * VO = @"^1(7[0-9])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestvo = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VO];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestvo evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - 检测邮箱格式
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}
#pragma mark - 检查密码格式
+ (BOOL)validatePassword:(NSString *)password {
  NSString * regex = @"^[A-Za-z0-9]{8,}$";
  NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
  return  [pred evaluateWithObject:password];
}

#pragma mark - JSON String to Dictionary
+ (NSDictionary *)convertJSONStringToDictionary:(NSString *)jsonString {
  NSError *jsonError;
  NSData *objectData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:objectData
                                                       options:NSJSONReadingMutableContainers
                                                         error:&jsonError];
  if (jsonError) {
    NSLog(@"%@", jsonError);
  }
  return dictionary;
}

+ (NSString *)convertJSONStringFromDictionary:(NSDictionary *)dictionary {
  NSError *error;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                     options:0 //NSJSONWritingPrettyPrinted
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