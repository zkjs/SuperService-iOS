//
//  SetUpVC.swift
//  SuperService
//
//  Created by admin on 15/10/24.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class SetUpVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  
  @IBOutlet weak var uoloadButton: UIButton!  {
    didSet {
      uoloadButton.layer.masksToBounds = true
      uoloadButton.layer.cornerRadius = 20
    }
  }

  @IBOutlet weak var newNameYextFiled: UITextField!
  @IBOutlet weak var username: UILabel!
  @IBOutlet weak var userImage: UIImageView!
  var imageData = NSData()
  var sex :String?
  @IBOutlet weak var segmentControl: UISegmentedControl!
  @IBAction func uploadImageButton(sender: UIButton) {
    ZKJSHTTPSessionManager.sharedInstance().uploadDataWithUserName(AccountManager.sharedInstance().userName, sex: sex, imageFile: imageData, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      if let dict = responseObject as? NSDictionary {
        if let set = dict["set"] as? Bool {
          if set {
            
          }
        }
      }
      
      }, failure: { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    })

  }

  @IBAction func segmentSelectIndex(sender: AnyObject) {
    switch segmentControl.selectedSegmentIndex {
    case 0:
      sex = "1";
    case 1:
      sex = "0";
    default:
      break;
    }
  }
  
 
  @IBAction func checkoutImage(sender: AnyObject) {
    let mediaPicker = WPMediaPickerViewController()
    mediaPicker.delegate = self
    mediaPicker.filter = WPMediaType.Image
    mediaPicker.allowMultipleSelection = false
    presentViewController(mediaPicker, animated: true, completion: nil)
  }
  @IBAction func gobackButton(sender: UIButton) {
    navigationController?.popViewControllerAnimated(true)
    navigationController?.navigationBarHidden = false
  }
  
  @IBAction func goforwardButton(sender: UIButton) {
    let InformV = InformVC()
    self.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(InformV, animated: true)
  }
  
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      title = "完善"
      username.text = AccountManager.sharedInstance().userName
      sex = "1"
      
    let image =  UIImage(named: "img_hotel_zhanwei")
     imageData = UIImagePNGRepresentation(image!)!
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  func mediaPickerControllerDidCancel(picker: WPMediaPickerViewController!) {
    dismissViewControllerAnimated(true, completion: nil)
  }


}

extension SetUpVC: WPMediaPickerViewControllerDelegate {
  
  func mediaPickerController(picker: WPMediaPickerViewController!, didFinishPickingAssets assets: [AnyObject]!) {
    print(assets.first)
    let set = assets.first as! ALAsset
    print(set)
    let image = UIImage(CGImage:set.thumbnail().takeUnretainedValue())
    userImage.image = image
    imageData = UIImageJPEGRepresentation(image, 1.0)!
    dismissViewControllerAnimated(true, completion: nil)
}
}
