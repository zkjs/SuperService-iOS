//
//  StaffLoginVC.swift
//  SuperService
//
//  Created by AlexBang on 15/10/29.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class StaffLoginVC: UIViewController {

  @IBOutlet weak var identifyingCodeTextField: UITextField!
  @IBOutlet weak var userphoneTextField: UITextField!
  @IBOutlet weak var userImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func staffCheckoutLoginButton(sender: AnyObject) {
  }

  @IBAction func bussinessManButton(sender: AnyObject) {
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
