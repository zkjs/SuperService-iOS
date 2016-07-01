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
  @IBOutlet weak var activityImageView: UIImageView!
  @IBOutlet weak var activitycontent: UITextView! 
  @IBOutlet weak var activityEnddateButton: UIButton!
  @IBOutlet weak var activityStartdateButton: UIButton!
  @IBOutlet weak var actvityname: UITextView!
  @IBOutlet weak var activitypersonCountTextField: UITextField!
  var avtivityModel = ActivitymanagerModel(dic:nil)
  var datePicker = UIDatePicker()
  var keyboardDoneButtonView = UIToolbar()
  override func viewDidLoad() {
      super.viewDidLoad()
    title = "编辑活动"
    let item = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
    navigationItem.backBarButtonItem = item
    tableView.bounces = false


  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    setupUI()
  }
  
  func setupUI() {
    if let actcontent = avtivityModel.actcontent,let startdate = avtivityModel.startdate,let enddate = avtivityModel.enddate,let actname = avtivityModel.actname,let actimage = avtivityModel.actimage?.fullImageUrl,let acturl = avtivityModel.acturl {
      activitycontent.text = actcontent
      activityStartdateButton.setTitle(startdate, forState: .Normal)
      activityEnddateButton.setTitle(enddate, forState: .Normal)
      actvityname.text = actname
      activityImageView.sd_setImageWithURL(NSURL(string: "\(actimage)"), placeholderImage: nil)
      linkAaddresstextField.text = acturl
    }
    
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
