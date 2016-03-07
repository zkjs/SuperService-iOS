//
//  YunbaSubscribeService.swift
//  SuperService
//
//  Created by Qin Yejun on 3/1/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

struct YunbaSubscribeService {
  static let sharedInstance = YunbaSubscribeService()
  private init(){}
  
  func subscribeAllChannels() {
    let tokenPayload = TokenPayload.sharedInstance
    guard let roles = tokenPayload.roles, let shopID = tokenPayload.shopid where roles.count > 0 && shopID != "" else {
      return
    }
    
    for roleID in roles {
      let topic = "\(shopID)_\(roleID)"
      print("subscribe:\(topic)")
      YunBaService.subscribe(topic, resultBlock: { (succ, err) -> Void in
        if succ {
          print("Yunba subscribe success:\(topic)")
        } else {
          print("Yunba subscribe fail.\(err)")
        }
      })
    }
  }
  
  func setAlias(alias:String) {
    print("set alias:\(alias)")
    YunBaService.setAlias(alias) { (succ, err) -> Void in
      if succ {
        print("Yunba setAlias success:\(alias)")
      } else {
        print("Yunba setAlias fail.\(err)")
      }
    }
  }
}