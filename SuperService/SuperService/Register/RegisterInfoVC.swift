//
//  RegisterInfo.swift
//  SuperService
//
//  Created by Hanton on 9/30/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class RegisterInfoVC: UIViewController {
  
  @IBOutlet weak var nameTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
  }
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
  // MARK: - Button Action
  
  
  @IBAction func selectAvatarImage(sender: AnyObject) {
    let mediaPicker = WPMediaPickerViewController()
    mediaPicker.delegate = self
    mediaPicker.filter = WPMediaType.Image
    mediaPicker.allowMultipleSelection = false
    presentViewController(mediaPicker, animated: true, completion: nil)
  }
  
  @IBAction func goBack(sender: AnyObject) {
    navigationController?.popViewControllerAnimated(true)
  }
  
}

extension RegisterInfoVC: UITextFieldDelegate {
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    nameTextField.resignFirstResponder()
    return true
  }
  
}

extension RegisterInfoVC: WPMediaPickerViewControllerDelegate {
  
  func mediaPickerController(picker: WPMediaPickerViewController!, didFinishPickingAssets assets: [AnyObject]!) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func mediaPickerControllerDidCancel(picker: WPMediaPickerViewController!) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
}
