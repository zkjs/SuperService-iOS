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
  
  func nextStep(sender:UIBarButtonItem) {
//    if actvityname.text.trim.isEmpty == true || activitycontent.text.trim.isEmpty == true || activityStartdateButton.titleLabel?.text == "请选择活动开始日期" || activityEnddateButton.titleLabel?.text == "请选择活动结束时间" || activityImageView.image == nil {
//      self.showHint("请完善创建活动信息")
//      return
//    } 
    let storyboard = UIStoryboard(name: "ActivityManagementTVC", bundle: nil)
    let choseInvitationVC = storyboard.instantiateViewControllerWithIdentifier("ChoseInvitationTVC") as! ChoseInvitationTVC
    self.navigationController?.pushViewController(choseInvitationVC, animated: true)
    
    
  }
    
  @IBAction func startDate(sender: AnyObject) {
    addDatepicker(1)
  }

  @IBAction func endDate(sender: AnyObject) {
    addDatepicker(2)
  }
  
  func addDatepicker(tag:Int) {
    keyboardDoneButtonView = UIToolbar()
    keyboardDoneButtonView.sizeToFit()
    keyboardDoneButtonView.frame = CGRectMake(0.0, ScreenSize.SCREEN_HEIGHT-266.0, ScreenSize.SCREEN_WIDTH, 50)
    let calcleButton = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(cancle))
    let btngap = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.FlexibleSpace,target:nil,action:nil)
    let doneButton = UIBarButtonItem(title: "确认", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(doneClicked))
    doneButton.tag = tag
    var items = [UIBarButtonItem]()
    items.append(calcleButton)
    items.append(btngap)
    items.append(doneButton)
    keyboardDoneButtonView.items = items
    
    //创建日期选择器
    
    datePicker = UIDatePicker(frame: CGRectMake(0.0, ScreenSize.SCREEN_HEIGHT-216.0, ScreenSize.SCREEN_WIDTH, 216.0))
    datePicker.backgroundColor = UIColor.hx_colorWithHexRGBAString("#D1D1D1")
    //将日期选择器区域设置为中文，则选择器日期显示为中文
    datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
    self.tableView.scrollEnabled = false
    self.tableView.addSubview(datePicker)
    self.tableView.addSubview(keyboardDoneButtonView)
  }
  
  func doneClicked(sender:UIBarButtonItem) {
    //更新提醒时间文本框
    let formatter = NSDateFormatter()
    //日期样式
    formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
    if sender.tag == 1 {
      activityStartdateButton.titleLabel?.text = formatter.stringFromDate(datePicker.date)
    } else {
      activityEnddateButton.titleLabel?.text = formatter.stringFromDate(datePicker.date)
    }
    
    self.tableView.scrollEnabled = true
    datePicker.removeFromSuperview()
    keyboardDoneButtonView.removeFromSuperview()
  }
  
  func cancle(sender:UIBarButtonItem) {
    self.tableView.scrollEnabled = true
    datePicker.removeFromSuperview()
    keyboardDoneButtonView.removeFromSuperview()
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

}
