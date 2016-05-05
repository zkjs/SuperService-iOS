//
//  ZKJSConstant.swift
//  SuperService
//
//  Created by Qin Yejun on 5/5/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

struct ScreenSize {
  static let SCREEN_WIDTH = CGRectGetWidth(UIScreen.mainScreen().bounds)
  static let SCREEN_HEIGHT = CGRectGetHeight(UIScreen.mainScreen().bounds)
  static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
  static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType {
  static let IS_IPHONE_4_OR_LESS =  UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
  static let IS_IPHONE_5 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
  static let IS_IPHONE_6 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
  static let IS_IPHONE_6P = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
  static let IS_IPAD = UIDevice.currentDevice().userInterfaceIdiom == .Pad
}

// 用户姓名最大长度
let MAX_NAME_LENGTH = 20