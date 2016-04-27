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
      self.tableView.addSubview(myView!)
    }
    return myView
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    if indexPath == NSIndexPath(forRow: 0, inSection: 0) {
      let vc = InformVC()
      self.navigationController?.pushViewController(vc, animated: true)
    }
//    if indexPath == NSIndexPath(forRow: 1, inSection: 0) {
//      let vc = CodeVC()
//      self.navigationController?.pushViewController(vc, animated: true)
//    }
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
