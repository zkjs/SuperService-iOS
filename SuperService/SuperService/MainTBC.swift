//
//  MainTBC.swift
//  SuperService
//
//  Created by Hanton on 10/14/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class MainTBC: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if AccountManager.sharedInstance().userID.isEmpty == false {
      ZKJSTCPSessionManager.sharedInstance().initNetworkCommunication()
    }
    
    setupView()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if AccountManager.sharedInstance().userID.isEmpty {
      showLogin()
    }
  }
  
  
  // MARK: - Private
  
  private func showLogin() {
    let loginVC = StaffLoginVC()
    let nv = UINavigationController(rootViewController: loginVC)
    nv.navigationBar.barTintColor = UIColor.ZKJS_themeColor()
    nv.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    nv.navigationBar.translucent = false
    presentViewController(nv, animated: true, completion: nil)
  }
  
  private func setupView() {
    tabBar.tintColor = UIColor.ZKJS_themeColor()
  }
  
}
