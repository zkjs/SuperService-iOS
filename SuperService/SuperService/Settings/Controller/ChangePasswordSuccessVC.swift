//
//  ChangePasswordSuccessVC.swift
//  SuperService
//
//  Created by AlexBang on 16/5/11.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class ChangePasswordSuccessVC: UIViewController {
  private var blurView: UIVisualEffectView!
  override func viewDidLoad() {
      super.viewDidLoad()
    let blur = UIBlurEffect(style: .Dark)
    blurView = UIVisualEffectView(effect: blur)
    blurView.frame = self.view.bounds
    blurView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    blurView.translatesAutoresizingMaskIntoConstraints = true
    blurView.alpha = 0.7
    self.view.insertSubview(blurView, atIndex: 0)

      // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("ChangePasswordSuccessVC", owner:self, options:nil)
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
