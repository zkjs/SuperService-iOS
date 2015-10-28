//
//  SetUpVC.swift
//  SuperService
//
//  Created by admin on 15/10/24.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class SetUpVC: UIViewController {

  @IBAction func uploadImageButton(sender: UIButton) {
  }

  @IBOutlet weak var newNameYextFiled: UITextField!
  @IBOutlet weak var username: UILabel!
  @IBOutlet weak var userImage: UIImageView!
  
  
 
  @IBAction func gobackButton(sender: UIButton) {
    navigationController?.popViewControllerAnimated(true)
    navigationController?.navigationBarHidden = false
  }
  
  @IBAction func goforwardButton(sender: UIButton) {
    let InformV = InformVC()
    self.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(InformV, animated: true)
  }
    override func viewDidLoad() {
        super.viewDidLoad()
      navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
