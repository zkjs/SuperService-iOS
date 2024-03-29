//
//  EditActivityTVC.swift
//  SuperService
//
//  Created by AlexBang on 16/7/1.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class EditActivityTVC: UITableViewController {
  @IBOutlet weak var linkAaddresstextField: UITextField!
  @IBOutlet weak var personSwitch: UISwitch!
  @IBOutlet weak var activityImageView: UIImageView!
  @IBOutlet weak var activitycontent: UITextView! 
  @IBOutlet weak var activityEnddateButton: UIButton!
  @IBOutlet weak var activityStartdateButton: UIButton!
  @IBOutlet weak var actvityname: UITextView!
  @IBOutlet weak var activitypersonCountTextField: UITextField!
  var avtivityModel = ActivitymanagerModel(dic:nil)
  var datePicker = UIDatePicker()
  var keyboardDoneButtonView = UIToolbar()
  var portable = 0
  var image = UIImage()
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "编辑活动"
    let item = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
    navigationItem.backBarButtonItem = item
    tableView.bounces = false
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    setupUI()
  }
  
  func setupUI() {
    if let actcontent = avtivityModel.actcontent,let startdate = avtivityModel.startdate,let enddate = avtivityModel.enddate,let actname = avtivityModel.actname,let actimage = avtivityModel.actimage?.fullImageUrl,let acturl = avtivityModel.acturl,let personcount = avtivityModel.invitedpersoncnt {
      activitycontent.text = actcontent
      activityStartdateButton.setTitle(startdate, forState: .Normal)
      activityEnddateButton.setTitle(enddate, forState: .Normal)
      actvityname.text = actname
      activityImageView.sd_setImageWithURL(NSURL(string: "\(actimage)"), placeholderImage: nil)
      self.activityImageView.image = image
      linkAaddresstextField.text = acturl
      activitypersonCountTextField.text = String(personcount)
    }
    
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
    datePickerVC.datepickerClourse = {dateString -> Void in
      if tag == 1 {
        self.activityStartdateButton.titleLabel?.text = dateString
      } else {
        self.activityEnddateButton.titleLabel?.text = dateString
      }
    }

  }
  
   
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

  @IBAction func checkoutEdit(sender: AnyObject) {

    guard let actvityname = actvityname.text,let activitycontent = activitycontent.text,let startDate = activityStartdateButton.titleLabel?.text,let  enddate = activityEnddateButton.titleLabel?.text,let maxtake = Int(activitypersonCountTextField.text!),let acturl = linkAaddresstextField.text,let actid = avtivityModel.actid else {return}
    self.showHudInView(view, hint: "")
    HttpService.sharedInstance.createActivity(actid, actname: actvityname, actcontent: activitycontent, startdate: startDate, enddate: enddate, acturl: acturl, invitesi: "", portable: self.portable == 1, maxtake: maxtake, image: image) { (json, error) in
      if let error = error {
        self.showErrorHint(error)
      } else {
        if let data = json {
          self.navigationController?.popToRootViewControllerAnimated(true)
        }
      }
      self.hideHUD()
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

}

extension EditActivityTVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
    picker.dismissViewControllerAnimated(true, completion: nil)
    var imageData = UIImageJPEGRepresentation(image, 1.0)!
    var i = 0
    while imageData.length / 1024 > 80 {
      i += 1
      let persent = CGFloat(100 - i) / 100.0
      self.image = image
      imageData = UIImageJPEGRepresentation(image, persent)!
    }
  }
  
}
