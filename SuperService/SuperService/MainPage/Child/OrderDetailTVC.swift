//
//  OrderDetailTVC.swift
//  SuperService
//
//  Created by admin on 15/10/27.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit
private let kNameSection = 2
private let kReceiptSection = 4
private let kReceiptRow = 1
private let kRoomSection = 5
private let kRoomRow = 1
private let kServiceSection = 6
private let kServiceRow = 1
class OrderDetailTVC: UITableViewController,UITextFieldDelegate {
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var roomTypeLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  
  @IBOutlet weak var roomCountInfoLabel: UILabel!
  @IBOutlet weak var roomCountLabel: UILabel!
  @IBOutlet weak var dateInfoLabel: UILabel!
  @IBOutlet weak var startDateLabel: UILabel!
  @IBOutlet weak var endDateLabel: UILabel!
  @IBOutlet var nameInfos: [UILabel]!
  @IBOutlet weak var secondnameTextField: UITextField!
  @IBOutlet weak var secondnameLabel: UILabel!
  @IBOutlet var nameTextFields: [UITextField]!
  
  @IBOutlet weak var thirdnameLabel: UILabel!
  
  @IBOutlet weak var thirdnameTextField: UITextField!
  @IBOutlet weak var PaymentInfoLabel: UILabel!
  @IBOutlet weak var paymentLabel: UILabel!
  @IBOutlet weak var paymentButton: UIButton!
  @IBOutlet weak var invoiceInfoLabel: UILabel!
  @IBOutlet weak var receiptLabel: UILabel!
  @IBOutlet weak var invoiceFooterLabel: UILabel!
  @IBOutlet weak var remarkInfoLabel: UILabel!
  @IBOutlet weak var remarkInfoPromptLabel: UILabel!
  @IBOutlet weak var remarkTextView: UITextView!
  @IBOutlet weak var roomTagInfoLabel: UILabel!
  @IBOutlet weak var roomTagView: JCTagListView!
  @IBOutlet weak var roomTagFooterLabel: UILabel!
  @IBOutlet weak var serviceInfoLabel: UILabel!
  @IBOutlet weak var serviceTagView: JCTagListView!
  @IBOutlet weak var serviceFooterLabel: UILabel!
  
  @IBOutlet weak var okButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  var roomCount = 1
  var DetailOrder:OrderModel!
    override func viewDidLoad() {
        super.viewDidLoad()
      title = "订单处理"
      roomCountLabel.text = DetailOrder.rooms
      startDateLabel.text = DetailOrder.arrival_date
      endDateLabel.text = DetailOrder.departure_date
      roomTypeLabel.text = DetailOrder.room_type
      // status=订单状态 默认0 未确认可取消订单 1取消订单 2已确认订单 3已经完成的订单 4已经入住的订单 5删除订单

      if DetailOrder.status == 1 {
        statusLabel.text = "已确定"
      }else {
        statusLabel.text = "待确认"
      }
      

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      var count = super.tableView(tableView, numberOfRowsInSection: section)
      if section == kNameSection {
        count = roomCount
      }
      return count
    }
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.section == kNameSection {
      if indexPath.row > roomCount {
        return 0.0
      }
    }
    return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
  }

  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
      
      if indexPath.section == kRoomSection && indexPath.row == kRoomRow {
        cell.contentView.addSubview(roomTagView)
      } else if indexPath.section == kServiceSection && indexPath.row == kServiceRow {
        cell.contentView.addSubview(serviceTagView)
      }
      
      return cell

    }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let indexPath = NSIndexPath(forItem: 1, inSection: 3)
    if indexPath == indexPath {
      print("111")
    }
    
  }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
