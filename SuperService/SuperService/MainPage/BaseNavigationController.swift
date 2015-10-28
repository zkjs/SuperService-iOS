//
//  BaseNavigationController.swift
//  SuperService
//
//  Created by admin on 15/10/22.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
  
  // MARK: - Private
  
  private func setupView() {
    navigationBar.barStyle = UIBarStyle.Black
    navigationBar.translucent = false
    navigationBar.barTintColor = UIColor(hexString: "03A9F4")
    navigationBar.tintColor = UIColor.whiteColor()
  }
  
}
