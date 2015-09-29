//
//  NumberPadDoneButtonView.swift
//  SuperService
//
//  Created by Hanton on 9/29/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class NumberPadButton: UIButton {
  
}

class NumberPadDoneButtonView: UIView {
  
  var doneButton = UIButton()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    clipsToBounds = false
    
    doneButton.titleLabel?.font = UIFont.systemFontOfSize(16.0)
    doneButton.setTitle("Done", forState: UIControlState.Normal)
//    doneButton.addTarget(self, action: "", forControlEvents: <#T##UIControlEvents#>)
    
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  /*
  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func drawRect(rect: CGRect) {
  // Drawing code
  }
  */
  
}
