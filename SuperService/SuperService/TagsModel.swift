//
//  TagsModel.swift
//  SuperService
//
//  Created by AlexBang on 16/4/28.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

struct Tag {
  var tagid: Int
  var tagname: String
  var tagcode: String
  var count: Int
  var isopt: Int

  
  init(dic:JSON) {
    self.tagid = dic["tagid"].int ?? 0
    self.count = dic["count"].int ?? 0
    self.isopt = dic["isopt"].int ?? 0
    self.tagname = dic["tagname"].string ?? ""
    self.tagcode = dic["tagscode"].string ?? ""
  }
}

struct TagsModel {
  
  var tags: [Tag] = []
  var canoptcnt: Int = 0

  
  init(dic:JSON){
    canoptcnt = dic["canoptcnt"].int ?? 0
    
    if let tagsArr = dic["tags"].array where tagsArr.count > 0 {
      tags = tagsArr.map{ Tag(dic: $0) }
    }
  }
}
