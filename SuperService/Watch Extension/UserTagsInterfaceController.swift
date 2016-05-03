//
//  UserTagsInterfaceController.swift
//  SuperService
//
//  Created by Qin Yejun on 5/3/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import WatchKit
import Foundation


class UserTagsInterfaceController: WKInterfaceController {

  @IBOutlet var table: WKInterfaceTable!
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
      
      // Configure interface objects here.
    self.setTitle("客人信息")
    if let tags = context?["tags"] as? NSArray {
      table.setNumberOfRows(tags.count, withRowType: "UserTagsRow")
      
      for (index,tag) in tags.enumerate() {
        let tagname = tag["tagname"] as? String ?? ""
        let count = tag["count"] as? Int ?? 0
        let controller = table.rowControllerAtIndex(index) as! UserTagsRowController
        controller.tagName.setText(tagname)
        controller.tagCount = count > 100 ? 100 : count
      }
    }
  }

  override func willActivate() {
      // This method is called when watch view controller is about to be visible to user
      super.willActivate()
  }

  override func didDeactivate() {
      // This method is called when watch view controller is no longer visible
      super.didDeactivate()
  }

}
