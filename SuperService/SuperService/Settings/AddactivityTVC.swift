//
//  AddactivityTVC.swift
//  SuperService
//
//  Created by AlexBang on 16/6/29.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit
class AddactivityTVC: UITableViewController,UITextViewDelegate {
  var avtivityModel = ActivitymanagerModel(dic:nil)
  var datePicker = UIDatePicker()
  var keyboardDoneButtonView = UIToolbar()
  var portable = 0
  var image = UIImage()
  @IBOutlet weak var personSwitch: UISwitch!
  @IBOutlet weak var linkAaddresstextField: UITextField!
  @IBOutlet weak var activityImageView: UIImageView!
  @IBOutlet weak var activitycontent: UITextView! 
  @IBOutlet weak var activityEnddateButton: UIButton!
  @IBOutlet weak var activityStartdateButton: UIButton!
  @IBOutlet weak var actvityname: UITextView!
  override func viewDidLoad() {
      super.viewDidLoad()
      title = "创建活动"
      let nextStepButton = UIBarButtonItem.init(title: "下一步", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddactivityTVC.nextStep))
      navigationItem.rightBarButtonItem = nextStepButton
      let item = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: #selector(AddactivityTVC.backtoVC))
      navigationItem.leftBarButtonItem = item
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  
  func backtoVC(sender:UIBarButtonItem) {
    let alertController = UIAlertController(title: "推出该界面，内容将不会被保存", message: "", preferredStyle: .Alert)
    let checkAction = UIAlertAction(title: "确定", style: .Default) { (_) in
      self.navigationController?.popViewControllerAnimated(true)
    }
    let cancleAction = UIAlertAction(title: "取消", style: .Cancel) { (_) in
      self.view.endEditing(true)
    }
    alertController.addAction(checkAction)
    alertController.addAction(cancleAction)
    self.presentViewController(alertController, animated: true, completion: nil)
  }

  @IBAction func personCountSwith(sender: AnyObject) {
    if personSwitch.on == true {
      portable = 1
    }
  }
  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
      cell.selectionStyle = UITableViewCellSelectionStyle.None
      return cell
  }
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 || section == 6 {
      return 1
    }
    return 5
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.section == 3 {
      showPhotoPicker()
    }
  }
  
  func showPhotoPicker() {
    let alertController = UIAlertController(title: "请选择图片", message: "", preferredStyle: DeviceType.IS_IPAD ?  .Alert : .ActionSheet)
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
  
  
  func nextStep(sender:UIBarButtonItem) {
    if actvityname.text.trim.isEmpty == true || activitycontent.text.trim.isEmpty == true || activityStartdateButton.titleLabel?.text == "请选择活动开始日期" || activityEnddateButton.titleLabel?.text == "请选择活动结束时间" || activityImageView.image == nil {
      self.showHint("请完善创建活动信息")
      return
    } 
    let storyboard = UIStoryboard(name: "ActivityManagementTVC", bundle: nil)
    let choseInvitationVC = storyboard.instantiateViewControllerWithIdentifier("ChoseInvitationTVC") as! ChoseInvitationTVC
    choseInvitationVC.actname = actvityname.text
    choseInvitationVC.actcontent = activitycontent.text
    choseInvitationVC.startdate = activityStartdateButton.titleLabel?.text
    choseInvitationVC.enddate = activityEnddateButton.titleLabel?.text
    choseInvitationVC.maxtake = 5
    choseInvitationVC.actimage = image
    choseInvitationVC.acturl = linkAaddresstextField.text
    choseInvitationVC.portable = portable

    self.navigationController?.pushViewController(choseInvitationVC, animated: true)
    
    
  }
    
  @IBAction func startDate(sender: AnyObject) {
    addDatepicker(1)
  }

  @IBAction func endDate(sender: AnyObject) {
    addDatepicker(2)
  }
  
  func addDatepicker(tag:Int) {
    
    let storyboard = UIStoryboard(name: "ActivityManagementTVC", bundle: nil)
    let datePickerVC = storyboard.instantiateViewControllerWithIdentifier("DatePickerViewController") as! DatePickerViewController
    self.presentViewController(datePickerVC, animated: true) { 
    }
    datePickerVC.modalPresentationStyle = .OverFullScreen
    datePickerVC.datepickerClourse = {dateString -> Void in
      if tag == 1 {
        self.activityStartdateButton.titleLabel?.text = dateString
      } else {
        self.activityEnddateButton.titleLabel?.text = dateString
      }
    }

  }
  
//  func doneClicked(sender:UIBarButtonItem) {
//    //更新提醒时间文本框
//    let formatter = NSDateFormatter()
//    //日期样式
//    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//    if sender.tag == 1 {
//      activityStartdateButton.titleLabel?.text = formatter.stringFromDate(datePicker.date)
//    } else {
//      activityEnddateButton.titleLabel?.text = formatter.stringFromDate(datePicker.date)
//    }
//    
//    self.tableView.scrollEnabled = true
//    datePicker.removeFromSuperview()
//    keyboardDoneButtonView.removeFromSuperview()
//  }
//  
//  func cancle(sender:UIBarButtonItem) {
//    self.tableView.scrollEnabled = true
//    datePicker.removeFromSuperview()
//    keyboardDoneButtonView.removeFromSuperview()
//  }
   
  //UITEXTVIEW DELEGATE
  
  func textViewShouldBeginEditing(textView: UITextView) -> Bool {
    return true
  }
  
  func textViewDidBeginEditing(textView: UITextView) {
    if actvityname.text == "请输入活动名称" {
      actvityname.text = ""
    } 
    if activitycontent.text == "请输入活动内容（100字以内）" {
      activitycontent.text = ""
    } 
    
  }
  
  func textViewDidEndEditing(textView: UITextView) {
    if activitycontent.text == "" {
      activitycontent.text = "请输入活动内容（100字以内）"
    } 
    if actvityname.text == "" {
      actvityname.text = "请输入活动名称"
    }
  }

}

extension AddactivityTVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
    picker.dismissViewControllerAnimated(true, completion: nil)
    
    var imageData = UIImageJPEGRepresentation(image, 1.0)!
    var i = 0
    while imageData.length / 1024 > 80 {
      i += 1
      let persent = CGFloat(100 - i) / 100.0
      self.activityImageView.image = image
      self.image = image
      imageData = UIImageJPEGRepresentation(image, persent)!
      
    }
  }
  
}

