//
//  SettingUpTVC.swift
//  SuperService
//
//  Created by AlexBang on 15/11/6.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class SettingUpTVC: UITableViewController,UINavigationControllerDelegate {
  
  @IBOutlet weak var codeLabel: UILabel!
  @IBOutlet weak var telphoneLabel: UILabel!
  @IBOutlet weak var businessInformationLabel: UILabel!
  @IBOutlet weak var mechanismLabel: UILabel!
  @IBOutlet weak var organizationLabel: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "设置"
   
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return super.tableView(tableView, numberOfRowsInSection: section)
  }
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 84
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    return cell
  }
  
  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let myView = NSBundle.mainBundle().loadNibNamed("HeaderView", owner: self, options: nil).first as? HeaderView
    if myView != nil {
      myView?.userImageView.sd_setImageWithURL(NSURL(string: AccountInfoManager.sharedInstance.avatarURL), placeholderImage: UIImage(named: "logo_white"))
      myView?.selectedImageViewButton.addTarget(self, action: "selectedIamge:", forControlEvents: UIControlEvents.TouchUpInside)
      myView?.usernameLabel.text = AccountInfoManager.sharedInstance.userName
      let tap = UITapGestureRecognizer(target: self, action: "gotoNameVC:")
      myView?.addGestureRecognizer(tap)
      self.tableView.addSubview(myView!)
    }
    return myView
  }
  
  func gotoNameVC(tap:UITapGestureRecognizer) {
    let vc = NameVC()
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    if indexPath == NSIndexPath(forRow: 0, inSection: 0) {
      let vc = InformVC()
      self.navigationController?.pushViewController(vc, animated: true)
    } else {
      self.verifyPassword()
    }

  }
  
  func verifyPassword() {
    let alertController = UIAlertController(title: "验证原密码", message: "为保障您的数据安全，修改密码请填写原密码。", preferredStyle: UIAlertControllerStyle.Alert)
    let checkAction = UIAlertAction(title: "确定", style: .Default) { (_) in
      let passwordTextField = alertController.textFields![0] as UITextField
      guard let phone = passwordTextField.text else { return }
      self.showHUDInView(self.view, withLoading: "")
        HttpService.sharedInstance.userVerifyPassword(phone, completionHandler: { (json, error) -> Void in
          if let error = error ,let errorInfo = error.userInfo["resDesc"] as? String {
              //提示框密码错误
              let alertController = UIAlertController(title: "\(errorInfo)", message: "", preferredStyle: UIAlertControllerStyle.Alert)
              let checkAction = UIAlertAction(title: "确定", style: .Default) { (_) in
                self.verifyPassword()
              }
              alertController.addAction(checkAction)
              self.presentViewController(alertController, animated: true, completion: nil)
          } else {
            //跳转修改密码页面
            let vc = PassWordVC()
            vc.oldPassword = phone
            self.navigationController?.pushViewController(vc, animated: true)
          }
          self.hideHUD()
        })
   }
    checkAction.enabled = false
    let cancelAction = UIAlertAction(title: "取消", style: .Cancel) { (_) in
      self.view.endEditing(true)
    }
    alertController.addTextFieldWithConfigurationHandler { (textField) in
      textField.placeholder = "请输入旧密码"
      textField.secureTextEntry = true
      textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
      NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
        checkAction.enabled = (textField.text != "")
      }
    }
    alertController.addAction(checkAction)
    alertController.addAction(cancelAction)
    presentViewController(alertController, animated: true, completion: nil)
  }

  
  func selectedIamge(sender:UIButton) {
    showPhotoPicker()
  }
  
  func showPhotoPicker() {
    
    let alertController = UIAlertController(title: "请选择图片", message: "", preferredStyle: .ActionSheet)
    let takePhotoAction = UIAlertAction(title: "拍照", style:.Default, handler: { (action: UIAlertAction) -> Void in
      let picker = UIImagePickerController()
      picker.sourceType = UIImagePickerControllerSourceType.Camera
      picker.delegate = self
      picker.allowsEditing = true
      self.presentViewController(picker, animated: true, completion: nil)
    })
    alertController.addAction(takePhotoAction)
    let choosePhotoAction = UIAlertAction(title: "从相册中选择", style:.Default, handler: { (action: UIAlertAction) -> Void in
      let picker = UIImagePickerController()
      picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
      picker.delegate = self
      picker.allowsEditing = true
      self.presentViewController(picker, animated: true, completion: nil)
    })
    alertController.addAction(choosePhotoAction)
    let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
    alertController.addAction(cancelAction)
    presentViewController(alertController, animated: true, completion: nil)
  }
  
}

extension SettingUpTVC: UIImagePickerControllerDelegate {
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
    picker.dismissViewControllerAnimated(true, completion: nil)
    
    showHudInView(view, hint: "正在上传头像...")
    var imageData = UIImageJPEGRepresentation(image, 1.0)!
    var i = 0
    while imageData.length / 1024 > 80 {
      let persent = CGFloat(100 - i++) / 100.0
      imageData = UIImageJPEGRepresentation(image, persent)!
    }
    
    
    let name = AccountInfoManager.sharedInstance.userName
    HttpService.sharedInstance.updateUserInfo(false, realname: name, eamil:nil,sex: nil, image: image, completionHandler: {[unowned self] (json, error) -> Void in
      if let _ = error {
        self.hideHUD()
        self.showHint("上传头像失败")
      } else {
        self.hideHUD()
        self.showHint("上传头像成功")
        self.tableView.reloadData()
        self.dismissViewControllerAnimated(true, completion: nil)
        HttpService.sharedInstance.getUserInfo({ (json, error) -> Void in
          
        })
        
      }
      })
    
  }

  
}

extension SettingUpTVC:UITextFieldDelegate {
  func textFieldDidBeginEditing(textField: UITextField) {
    textField.secureTextEntry = true
  }
}
