//
//  AdminLoginVC.swift
//  SuperService
//
//  Created by Hanton on 9/30/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class AdminLoginVC: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
  // MARK: - Button Action
  
  @IBAction func tapLoginButton(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
}
