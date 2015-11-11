//
//  UIViewController+HUD.swift
//  SuperService
//
//  Created by Hanton on 11/11/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import Foundation

extension UIViewController {

  private struct AssociatedKeys {
    static var ZKJS_HUD = "ZKJS_HUD"
  }
  
  var HUD: MBProgressHUD? {
    get {
      return objc_getAssociatedObject(self, &AssociatedKeys.ZKJS_HUD) as? MBProgressHUD
    }
    
    set {
      if let newValue = newValue {
        objc_setAssociatedObject(
          self,
          &AssociatedKeys.ZKJS_HUD,
          newValue as MBProgressHUD?,
          .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
      }
    }
  }
  
  func showHUDInView(view: UIView, withLoading hint: String) {
    let HUD = MBProgressHUD(view: view)
    HUD.labelText = hint
    view.addSubview(HUD)
    HUD.show(true)
    self.HUD = HUD
  }
  
  func showHint(hint: String) {
    if let view = UIApplication.sharedApplication().delegate?.window {
      let HUD = MBProgressHUD.showHUDAddedTo(view, animated: true)
      HUD.userInteractionEnabled = false
      HUD.mode = .Text
      HUD.labelText = hint
      HUD.margin = 10.0
      HUD.removeFromSuperViewOnHide = true
      HUD.hide(true, afterDelay: 1)
    }
  }
  
  func hideHUD() {
    HUD?.hide(true)
  }
  
}
