//
//  InvoiceModel.swift
//  SuperService
//
//  Created by AlexBang on 16/1/11.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class InvoiceModel: NSObject {
  var id: String!
  var title: String!
  var isDefault = false
  
  override init() {
    super.init()
  }
  
  init(dict: [String: AnyObject]) {
    super.init()
    
    id = dict["id"] as? String ?? ""
    title = dict["invoice_title"] as? String ?? ""
    if let is_default = dict["is_default"] as? String {
      if is_default == "1" {
        isDefault = true
      }
    }
  }

}
