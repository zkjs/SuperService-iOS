//
//  SetUpVC.swift
//  SuperService
//
//  Created by admin on 15/10/24.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class SetUpVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  
  @IBOutlet weak var avatarButton: UIButton! {
    didSet {
      avatarButton.layer.masksToBounds = true
      avatarButton.layer.cornerRadius = avatarButton.frame.width / 2.0
    }
  }
  @IBOutlet weak var nameTextFiled: UITextField!
  @IBOutlet weak var segmentControl: UISegmentedControl!
  
  var imageData = NSData()
  var sex :String?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "完善"
    nameTextFiled.text = AccountManager.sharedInstance().userName
    sex = "1"
    
    let url = NSURL(string: kBaseURL)
    let userID = AccountManager.sharedInstance().userID
    if let url = url?.URLByAppendingPathComponent("uploads/users/\(userID).jpg") {
      if let data = NSData(contentsOfURL: url),
        let image = UIImage(data: data) {
          avatarButton.setImage(UIImage(data: data), forState: .Normal)
          imageData = UIImageJPEGRepresentation(image, 0.8)!
      }
    }
  }
  
  
  // MARK: - Button Actions
  
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
    showPhotoPicker()
  }
  
  @IBAction func gobackButton(sender: UIButton) {
    navigationController?.popViewControllerAnimated(true)
    navigationController?.navigationBarHidden = false
  }
  
  @IBAction func goforwardButton(sender: UIButton) {
    ZKJSTool.showLoading("正在上传资料...")
    ZKJSHTTPSessionManager.sharedInstance().uploadDataWithUserName(nameTextFiled.text, sex: sex, imageFile: imageData, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      if let dict = responseObject as? NSDictionary {
        if let set = dict["set"] as? Bool {
          if set {
            ZKJSTool.hideHUD()
            AccountManager.sharedInstance().saveUserName(self.nameTextFiled.text!)
            let InformV = InformVC()
            InformV.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(InformV, animated: true)
          }
        }
      }
      }, failure: { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        ZKJSTool.hideHUD()
        ZKJSTool.showMsg("上传失败,请重新上传")
    })
  }
  
  
  // MARK: - Gesture
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
  }
  
  
  // MARK: - Private
  
  func showPhotoPicker() {
    let mediaPicker = WPMediaPickerViewController()
    mediaPicker.delegate = self
    mediaPicker.filter = WPMediaType.Image
    mediaPicker.allowMultipleSelection = false
    presentViewController(mediaPicker, animated: true, completion: nil)
  }
  
}

extension SetUpVC: WPMediaPickerViewControllerDelegate {
  
  func mediaPickerController(picker: WPMediaPickerViewController!, didFinishPickingAssets assets: [AnyObject]!) {
    let set = assets.first as! ALAsset
    let image = UIImage(CGImage:set.thumbnail().takeUnretainedValue())
    avatarButton.setImage(image, forState: .Normal)
    imageData = UIImageJPEGRepresentation(image, 0.8)!
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func mediaPickerControllerDidCancel(picker: WPMediaPickerViewController!) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
}
