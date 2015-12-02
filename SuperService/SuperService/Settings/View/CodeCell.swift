//
//  CodeCell.swift
//  SuperService
//
//  Created by AlexBang on 15/12/1.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class CodeCell: UITableViewCell ,HTCopyableLabelDelegate{

  @IBOutlet weak var codeLabel: HTCopyableLabel! {
    didSet {
      codeLabel.userInteractionEnabled = true
      codeLabel.copyableLabelDelegate = self
    }
  }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  class func reuseIdentifier() -> String {
    return "CodeCell"
  }
  
  class func nibName() -> String {
    return "CodeCell"
  }
  
  class func height() -> CGFloat {
    return 60
  }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  func setData(string:String) {
    codeLabel.text = string
  }
  
  func copyMenuTargetRectInCopyableLabelCoordinates(copyableLabel: HTCopyableLabel!) -> CGRect {
    return copyableLabel.frame
  }
  
  func stringToCopyForCopyableLabel(copyableLabel: HTCopyableLabel!) -> String! {
    return copyableLabel.text
  }
    
}
