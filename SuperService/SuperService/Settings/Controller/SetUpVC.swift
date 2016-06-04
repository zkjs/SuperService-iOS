//
//  SetUpVC.swift
//  SuperService
//
//  Created by admin on 15/10/24.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit
import AssetsLibrary

class SetUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var avatarButton: UIButton! {
    didSet {
      avatarButton.layer.masksToBounds = true
      avatarButton.layer.cornerRadius = avatarButton.frame.width / 2.0
    }
  }
  @IBOutlet weak var nameTextFiled: UITextField!
  @IBOutlet weak var segmentControl: UISegmentedControl!
  
  lazy var imageData: NSData? = nil
  var sex :String?
  var image = UIImage()
  
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("SetUpVC", owner:self, options:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "完善"
    nameTextFiled.text = AccountInfoManager.sharedInstance.userName
    sex = "1"
    
    if let image = AccountInfoManager.sharedInstance.avatarImage {
      avatarButton.setImage(image, forState: .Normal)
      imageData = UIImageJPEGRepresentation(image, 0.8)!
    }
    
    let nextStepButton = UIBarButtonItem(image: UIImage(named: "ic_qianjin"), style: UIBarButtonItemStyle.Plain ,
      target: self, action: #selector(SetUpVC.nextStep))
    navigationItem.rightBarButtonItem = nextStepButton
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
  
  func nextStep() {
    showHUDInView(view, withLoading: "正在上传资料...")
    if nameTextFiled.text!.isEmpty {
      showHint("用户名不能为空")
      return
    }
    
    if nameTextFiled.text!.characters.count > 6 {
      showHint("用户名最多6位")
      return
    }
    
    if self.imageData == nil {
      showHint("头像不能为空")
      return
    }
    
    HttpService.sharedInstance.updateUserInfo(true, realname: nameTextFiled.text, eamil: nil, sex: sex, image: image) { (json, error) -> Void in
      self.hideHUD()
      if let error = error {
        if let msg = error.userInfo["resDesc"] as? String {
          ZKJSTool.showMsg(msg)
        } else {
          ZKJSTool.showMsg("上传图片失败，请再次尝试")
        }
      } else {
        AccountManager.sharedInstance().saveUserName(self.nameTextFiled.text!)
        HttpService.sharedInstance.getUserInfo({ (json, error) -> Void in
          
        })
        if let window = UIApplication.sharedApplication().delegate?.window {
          window!.rootViewController = MainTBC()
        }
        
        
      }
    }
    
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
    if let set = assets.first as? ALAsset {
      self.image = UIImage(CGImage:set.thumbnail().takeUnretainedValue())
      avatarButton.setImage(image, forState: .Normal)
      imageData = UIImageJPEGRepresentation(image, 0.8)!
    }
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func mediaPickerControllerDidCancel(picker: WPMediaPickerViewController!) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
}
