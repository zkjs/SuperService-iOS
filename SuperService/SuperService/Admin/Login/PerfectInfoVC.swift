//
//  PerfectInfoVC.swift
//  SuperService
//
//  Created by AlexBang on 15/10/30.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class PerfectInfoVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

  @IBOutlet weak var segmentControl: UISegmentedControl!
  @IBAction func indexChanged(sender: UISegmentedControl) {
    switch segmentControl.selectedSegmentIndex {
    case 0:
      sex = "1";
    case 1:
      sex = "0";
    default:
      break;
    }
  }
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var imageButton: UIButton!
  @IBOutlet weak var ompanyUnitTextField: UITextField!
  @IBOutlet weak var usernametextField: UITextField!
  @IBOutlet weak var nickNameTextField: UITextField!
  var sex :String?
  var imageData = NSData()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      title = "完善资料"
      setupUI()
      let  next_Button = UIBarButtonItem(image: UIImage(named: "ic_qianjin"), style: UIBarButtonItemStyle.Plain ,
        target: self, action: "nextSettingButton:")
      
      self.navigationItem.rightBarButtonItem = next_Button

        // Do any additional setup after loading the view.
    }
  
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
  }
  
  func setupUI() {
    usernameLabel.text = AccountManager.sharedInstance().userName
  }
  
  func nextSettingButton(sender:UIButton) {
    if  imageData != "" && sex != nil{
      
      ZKJSHTTPSessionManager.sharedInstance().uploadDataWithUserName(AccountManager.sharedInstance().userName, sex: sex, imageFile: imageData, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
        if let dict = responseObject as? NSDictionary {
          if let set = dict["set"] as? Bool {
            if set {
              let InformV = InformVC()
              self.hidesBottomBarWhenPushed = true
             self.navigationController?.pushViewController(InformV, animated: true)
            }
          }
        }
        
        }, failure: { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
          
      })
      
    }else {
      ZKJSTool.showMsg("请填写完整信息")
    }
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  @IBAction func SettingImageButton(sender: AnyObject) {
    let mediaPicker = WPMediaPickerViewController()
    mediaPicker.delegate = self
    mediaPicker.filter = WPMediaType.Image
    mediaPicker.allowMultipleSelection = false
    presentViewController(mediaPicker, animated: true, completion: nil)
    
    
  }


}

extension PerfectInfoVC: WPMediaPickerViewControllerDelegate {
  
  func mediaPickerController(picker: WPMediaPickerViewController!, didFinishPickingAssets assets: [AnyObject]!) {
    print(assets.first)
   let set = assets.first as! ALAsset
    print(set)
    let image = UIImage(CGImage:set.thumbnail().takeUnretainedValue())
    
    self.imageButton.setBackgroundImage(image, forState: .Normal)
    imageData = UIImageJPEGRepresentation(image, 1.0)!
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func mediaPickerControllerDidCancel(picker: WPMediaPickerViewController!) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
}
