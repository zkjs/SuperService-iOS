//
//  InquiryVC.swift
//  SuperService
//
//  Created by AlexBang on 15/11/2.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class InquiryVC: UIViewController{
  
  @IBOutlet weak var inquiryClientButton: UIButton! {
    didSet {
      inquiryClientButton.layer.masksToBounds = true
      inquiryClientButton.layer.cornerRadius = 20
    }
  }
  
  @IBOutlet weak var phonrtextField: UITextField!
  
  @IBAction func inquiryClient(sender: AnyObject) {
    if (phonrtextField.text != nil) {
      view.endEditing(true)
      ZKJSHTTPSessionManager.sharedInstance().inquiryClientWithPhoneNumber(phonrtextField.text, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
        let dic = responseObject as! [String: AnyObject]
        let client = ClientModel(dic: dic)
        let vc = AddClientVC()
        vc.client = client
        self.navigationController?.pushViewController(vc, animated: true)
        }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
          
      }
      
    }
    
  }
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("InquiryVC", owner:self, options:nil)
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
    
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
