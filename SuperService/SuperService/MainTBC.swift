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
    let vc1 = ArrivalTVC()
    vc1.tabBarItem.image = UIImage(named: "ic_home")
    vc1.tabBarItem.title = "到店通知"
    let nv1 = BaseNavigationController()
    nv1.viewControllers = [vc1]
    
    let vc2 = OrderTVC()
    vc2.tabBarItem.title = "订单"
    vc2.tabBarItem.image = UIImage(named: "ic_dingdan")
    let nv2 = BaseNavigationController()
    nv2.viewControllers = [vc2]
    
    let vc3 = MessageTVC()
    vc3.tabBarItem.title = "消息"
    vc3.tabBarItem.image = UIImage(named: "ic_duihua_b")
    let nv3 = BaseNavigationController()
    nv3.viewControllers = [vc3]
    
    let vc4 = ContactVC()
    vc4.tabBarItem.title = "联系人"
    vc4.tabBarItem.image = UIImage(named: "ic_tuandui_b")
    let nv4 = BaseNavigationController()
    nv4.viewControllers = [vc4]
    
    let vc5 = SettingsVC()
    vc5.tabBarItem.title = "我的"
    vc5.tabBarItem.image = UIImage(named: "ic_shezhi")
    let nv5 = BaseNavigationController()
    nv5.viewControllers = [vc5]
    
    viewControllers = [nv1, nv2, nv3, nv4, nv5]
    
    tabBar.tintColor = UIColor.ZKJS_themeColor()
  }
  
}
