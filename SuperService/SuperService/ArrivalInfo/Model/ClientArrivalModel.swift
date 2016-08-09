//
//  ClientArrivalModel.swift
//  SuperService
//
//  Created by Qin Yejun on 8/8/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

struct ClientArrivalModel {
  let locid: String
  let total: Int
  let area: String
  let firstDate: String
  let firstFullDatetime: String
  let firstTime: String
  
  init(dic:JSON){
    locid = dic["locid"].string ?? ""
    total = dic["total"].int ?? 0
    area = dic["area"].string ?? ""
    firstDate = dic["firstDate"].string ?? ""
    firstFullDatetime = dic["firstFullDatetime"].string ?? ""
    firstTime = dic["firstTime"].string ?? ""
  }
}