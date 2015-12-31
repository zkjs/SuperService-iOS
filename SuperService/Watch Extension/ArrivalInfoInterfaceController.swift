//
//  ArrivalInfoInterfaceController.swift
//  SuperService
//
//  Created by Hanton on 12/30/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import WatchKit
import Foundation


class ArrivalInfoInterfaceController: WKInterfaceController {
  
  @IBOutlet var arrivalInfoTable: WKInterfaceTable!
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    
    arrivalInfoTable.setNumberOfRows(9, withRowType: "ArrivalInfoRow")
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
  override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
    presentControllerWithName("default", context: nil)
  }
  
}
