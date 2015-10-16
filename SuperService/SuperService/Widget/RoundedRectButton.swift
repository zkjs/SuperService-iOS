//
//  RoundedRectButton.swift
//  SuperService
//
//  Created by Hanton on 9/29/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class RoundedRectButton: UIButton {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUp()
  }
  
  private func setUp() {
    layer.cornerRadius = 5.0
  }
  
}
