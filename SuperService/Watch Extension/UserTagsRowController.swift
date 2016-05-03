//
//  UserTagsRowController.swift
//  SuperService
//
//  Created by Qin Yejun on 5/3/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import WatchKit

class UserTagsRowController: NSObject {
  
  @IBOutlet var tagName: WKInterfaceLabel!
  @IBOutlet var progressImage: WKInterfaceImage!
  
  var tagCount:Int = 0 {
    didSet {
      progressImage.setImageNamed("progress_circle_percent_\(tagCount)")
    }
  }
}
