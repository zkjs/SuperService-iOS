//
//  GoodsModel.swift
//  SuperService
//
//  Created by Hanton on 10/29/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class GoodsModel: NSObject {

  var id: NSNumber?
  var room: String?
  var type: String?
  var imgurl: String?
  var meat: String?
  var price: NSNumber?
  var name: String? {
    get {
      let room = self.room ?? ""
      let type = self.type ?? ""
      let meat = self.meat ?? ""
      return room + type + meat
    }
  }
  override var description: String {
    var output = "id: \(id)\n"
    output += "room: \(room)\n"
    output += "type: \(type)\n"
    output += "imgurl: \(imgurl)\n"
    output += "meat: \(meat)\n"
    output += "price: \(price)\n"
    output += "name: \(name)\n"
    return output
  }
  
  init(dic: [String:AnyObject]) {
    id = dic["id"] as? NSNumber
    room = dic["room"] as? String
    type = dic["type"] as? String
    imgurl = dic["imgurl"] as? String
    meat = dic["meat"] as? String
    price = dic["price"] as? NSNumber
  }
  
}
