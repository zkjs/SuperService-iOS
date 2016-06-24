//
//  ServicetagFirstModel.swift
//  SuperService
//
//  Created by AlexBang on 16/6/23.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit
struct ServicetagSecondmodel {
  var secondSrvTagName:String?
  var secondSrvTagId:String?
  var secondSrvTagDesc:String?
  
  init(json:JSON) {
    secondSrvTagId = json["secondSrvTagId"].string ?? ""
    secondSrvTagName = json["secondSrvTagName"].string ?? ""
    secondSrvTagDesc = json["secondSrvTagDesc"].string ?? ""
  }
  
}
struct ServicetagFirstModel {
  var firstSrvTagName:String?
  var firstSrvTagId:String?
  var secondSrvTag:[ServicetagSecondmodel]?
  
  init(dic:JSON) {
    firstSrvTagName = dic["firstSrvTagName"].string ?? ""
    firstSrvTagId = dic["firstSrvTagId"].string ?? ""
    if let  secondsrvTag = dic["secondSrvTag"].array {
      var ordersArray = [ServicetagSecondmodel]()
      for o in secondsrvTag {
        let order = ServicetagSecondmodel(json: o)
        ordersArray.append(order)
      }
      secondSrvTag = ordersArray
    } else {
      secondSrvTag = nil
    }
    }
  }

