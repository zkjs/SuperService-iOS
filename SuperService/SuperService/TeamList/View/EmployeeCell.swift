//
//  EmployeeCell.swift
//  SuperService
//
//  Created by AlexBang on 15/11/24.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class EmployeeCell: UITableViewCell {
  var tel : String!
  @IBOutlet weak var sendMessageButton: UIButton!
  @IBOutlet weak var callButton: UIButton!
  @IBOutlet weak var phoneLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  class func reuseIdentifier() -> String {
    return "EmployeeCell"
  }
  
  class func nibName() -> String {
    return "EmployeeCell"
  }
  
  class func height() -> CGFloat {
    return 48
  }
  func setData(employee:TeamModel) {
    phoneLabel.text = employee.phone!
    tel = employee.phone!
  }
  func setdata(client:AddClientModel) {
    phoneLabel.text = client.phone!
    tel = client.phone!
  }

  @IBAction func call(sender: AnyObject) {
    UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(tel)")!)
  }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
