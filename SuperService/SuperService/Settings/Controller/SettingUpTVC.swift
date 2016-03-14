//
//  SettingUpTVC.swift
//  SuperService
//
//  Created by AlexBang on 15/11/6.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class SettingUpTVC: UITableViewController {
  
  @IBOutlet weak var codeLabel: UILabel!
  @IBOutlet weak var telphoneLabel: UILabel!
  @IBOutlet weak var businessInformationLabel: UILabel!
  @IBOutlet weak var mechanismLabel: UILabel!
  @IBOutlet weak var organizationLabel: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "设置"
   
    telphoneLabel.text = AccountInfoManager.sharedInstance.phone
    organizationLabel.text = AccountInfoManager.sharedInstance.fullname
    
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
    
    if indexPath == NSIndexPath(forRow: 2, inSection: 0) {
      let vc = InformVC()
      self.navigationController?.pushViewController(vc, animated: true)
    }
    if indexPath == NSIndexPath(forRow: 3, inSection: 0) {
      let vc = CodeVC()
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  func selectedIamge(sender:UIButton) {
//    let vc = SetUpVC()
//    navigationController?.pushViewController(vc, animated: true)
    showPhotoPicker()
  }
  
  func showPhotoPicker() {
    let mediaPicker = WPMediaPickerViewController()
    mediaPicker.delegate = self
    mediaPicker.filter = WPMediaType.Image
    mediaPicker.allowMultipleSelection = false
    presentViewController(mediaPicker, animated: true, completion: nil)
  }
  
}

extension SettingUpTVC: WPMediaPickerViewControllerDelegate {
  
  func mediaPickerController(picker: WPMediaPickerViewController!, didFinishPickingAssets assets: [AnyObject]!) {
    if let set = assets.first as? ALAsset {
      let image = UIImage(CGImage:set.thumbnail().takeUnretainedValue())
      let name = AccountInfoManager.sharedInstance.userName
      HttpService.updateUserInfo(true, realname: name, eamil:nil,sex: nil, image: image, completionHandler: {[unowned self] (json, error) -> Void in
        if let _ = error {
          self.hideHUD()
          self.showHint("上传头像失败")
        } else {
          self.hideHUD()
          self.showHint("上传头像成功")
          self.tableView.reloadData()
          self.dismissViewControllerAnimated(true, completion: nil)
          
        }
      })
      
    }
    
  }
  
  func mediaPickerControllerDidCancel(picker: WPMediaPickerViewController!) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
}
