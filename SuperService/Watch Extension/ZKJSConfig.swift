//
//  ZKJSConfig.swift
//  SuperService
//
//  Created by Qin Yejun on 4/13/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

struct ZKJSConfig {
  static let sharedInstance = ZKJSConfig()
  
  #if DEBUG
  
  //// 测试环境
  
  // 新API服务器
  let BaseURL = "http://p.zkjinshi.com/test"
  // 图片服务器
  let BaseImageURL = "http://d2.zkjinshi.com/"
  // 环信
  let EaseMobAppKey = "zkjs#svip"
  // 云巴
  let YunBaAppKey = "566563014407a3cd028aa72f"
  
  #elseif PRE_RELEASE
  
  //// 预上线
  
  // 新API服务器
  let BaseURL = "http://rap.zkjinshi.com/"
  // 图片服务器
  let BaseImageURL = "http://svip02.oss-cn-shenzhen.aliyuncs.com/"
  // 环信
  let EaseMobAppKey = "zkjs#sid"
  // 云巴
  let YunBaAppKey = "566563014407a3cd028aa72f"
  
  #else
  
  //// 生产环境
  
  // 新API服务器
  let BaseURL = "http://p.zkjinshi.com"
  // 图片服务器
  let BaseImageURL = "http://cdn.zkjinshi.com/"
  // 环信
  let EaseMobAppKey = "zkjs#prosvip"
  // 云巴
  let YunBaAppKey = "566563014407a3cd028aa72f"
  
  #endif
  
  
}