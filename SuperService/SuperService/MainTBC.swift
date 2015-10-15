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
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if AccountManager.sharedInstance().userID.isEmpty {
      showAdminLogin()
    }
  }
  
  
  // MARK: - Private
  
  private func showAdminLogin() {
    let storyboard = UIStoryboard(name: "AdminLogin", bundle: nil)
    let vc = storyboard.instantiateViewControllerWithIdentifier("AdminLoginVC") as! AdminLoginVC
    let nv = UINavigationController(rootViewController: vc)
    nv.navigationBar.barTintColor = UIColor(hexString: "29B6F6")
    nv.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    nv.navigationBar.translucent = false
    presentViewController(nv, animated: true, completion: nil)
  }
  
}
