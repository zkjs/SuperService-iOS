//
//  LeisureTVC.swift
//  SVIP
//
//  Created by AlexBang on 15/12/30.
//  Copyright © 2015年 zkjinshi. All rights reserved.
//

import UIKit

class LeisureTVC: UITableViewController {
  @IBOutlet weak var arriveLabel: UILabel!

  @IBOutlet weak var invoinceTextField: UITextField!
  @IBOutlet weak var telphotoTextFiled: UITextField!
  @IBOutlet weak var contacterTextField: UITextField!
  @IBOutlet weak var remarkTextView: UITextView!
  
  
  var orderno: String!
  var order = OrderModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.translucent = false
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.translucent = true
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    view.endEditing(true)
  }

  

}
