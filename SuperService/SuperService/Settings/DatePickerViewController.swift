//
//  DatePickerViewController.swift
//  SuperService
//
//  Created by AlexBang on 16/7/8.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit
typealias DatePickerClourse = (dateString:String) ->Void
class DatePickerViewController: UIViewController {

  @IBOutlet weak var datetoolBar: UIToolbar!
  @IBOutlet weak var datePicker: UIDatePicker!
  var datepickerClourse:DatePickerClourse?
    override func viewDidLoad() {
        super.viewDidLoad()
      //将日期选择器区域设置为中文，则选择器日期显示为中文
      datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
    }

  @IBAction func cancle(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func clickeddone(sender: AnyObject) {
    //更新提醒时间文本框
    let formatter = NSDateFormatter()
    //日期样式
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let str = formatter.stringFromDate(datePicker.date)
    if let clourse = self.datepickerClourse {
      clourse(dateString: str)
    }
    self.dismissViewControllerAnimated(true, completion: nil)
  }

    
}
