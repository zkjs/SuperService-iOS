//
//  GuideVC.swift
//  SuperService
//
//  Created by Hanton on 12/7/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class GuideVC: AnimatedPagingScrollViewController {
  
  private let background = UIImageView(image: UIImage(named: "guide_bg"))
  
  private let comment0 = UIImageView(image: UIImage(named: "rounded_rectangle_0"))
  private let people0 = UIImageView(image: UIImage(named: "p_0"))
  private let people1 = UIImageView(image: UIImage(named: "p_4"))
  private let people2 = UIImageView(image: UIImage(named: "p_6"))
  private let people3 = UIImageView(image: UIImage(named: "p_2"))
  private let people4 = UIImageView(image: UIImage(named: "p_5"))
  private let people5 = UIImageView(image: UIImage(named: "p_1"))
  private let people6 = UIImageView(image: UIImage(named: "p_4"))
  private let label1 = UIImageView(image: UIImage(named: "l_1"))
  
  private let comment1 = UIImageView(image: UIImage(named: "rounded_rectangle_1"))
  private let comment2 = UIImageView(image: UIImage(named: "rounded_rectangle_2"))
  private let comment3 = UIImageView(image: UIImage(named: "rounded_rectangle_3"))
  private let comment4 = UIImageView(image: UIImage(named: "rounded_rectangle_4"))
  private let comment5 = UIImageView(image: UIImage(named: "rounded_rectangle_5"))
  private let comment6 = UIImageView(image: UIImage(named: "rounded_rectangle_6"))
  private let label2 = UIImageView(image: UIImage(named: "l_2"))
  
  private let layer1 = UIImageView(image: UIImage(named: "layer_1"))
  private let layer2 = UIImageView(image: UIImage(named: "layer_2"))
  private let layer3 = UIImageView(image: UIImage(named: "layer_3"))
  private let layer4 = UIImageView(image: UIImage(named: "layer_4"))
  private let layer5 = UIImageView(image: UIImage(named: "layer_5"))
  private let layer6 = UIImageView(image: UIImage(named: "layer_6"))
  private let paper = UIImageView(image: UIImage(named: "paper"))
  private let label3 = UIImageView(image: UIImage(named: "l_3"))
  
  private let layer7 = UIImageView(image: UIImage(named: "layer_7"))
  private let layer8 = UIImageView(image: UIImage(named: "layer_8"))
  private let layer9 = UIImageView(image: UIImage(named: "layer_9"))
  private let layer10 = UIImageView(image: UIImage(named: "layer_10"))
  private let layer11 = UIImageView(image: UIImage(named: "layer_11"))
  private let layer12 = UIImageView(image: UIImage(named: "layer_12"))
  private let phone = UIImageView(image: UIImage(named: "phone"))
  private let label4 = UIImageView(image: UIImage(named: "l_4"))
  private var button = UIImageView(image: UIImage(named: "sign_in"))
  
  private let pageControl = UIPageControl()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
    
    configureViews()
    configureAnimations()
    startPage1Animation()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
  }
  
  override func numberOfPages() -> Int {
    return 4
  }

  private func configureViews() {
    scrollView.backgroundColor = UIColor(hexString: "#F5F5F5")
    
    contentView.addSubview(background)
    
    contentView.addSubview(comment0)
    contentView.addSubview(people2)
    contentView.addSubview(people5)
    contentView.addSubview(people1)
    contentView.addSubview(people3)
    contentView.addSubview(people4)
    contentView.addSubview(people6)
    contentView.addSubview(people0)
    contentView.addSubview(label1)
    
    contentView.addSubview(comment1)
    contentView.addSubview(comment2)
    contentView.addSubview(comment3)
    contentView.addSubview(comment4)
    contentView.addSubview(comment5)
    contentView.addSubview(comment6)
    contentView.addSubview(label2)
    
    contentView.addSubview(paper)
    contentView.addSubview(layer1)
    contentView.addSubview(layer2)
    contentView.addSubview(layer3)
    contentView.addSubview(layer4)
    contentView.addSubview(layer5)
    contentView.addSubview(layer6)
    contentView.addSubview(label3)
    
    contentView.addSubview(phone)
    contentView.addSubview(layer7)
    contentView.addSubview(layer8)
    contentView.addSubview(layer9)
    contentView.addSubview(layer10)
    contentView.addSubview(layer11)
    contentView.addSubview(layer12)
    contentView.addSubview(label4)
    contentView.addSubview(button)
    
    configurePageControl()
  }
  
  // MARK: - UIScrollViewDelegate
  
  override func scrollViewDidScroll(scrollView: UIScrollView) {
    super.scrollViewDidScroll(scrollView)
    
    let pageWidth = self.scrollView.frame.size.width
    let page = floor((self.scrollView.contentOffset.x - pageWidth / 2 ) / pageWidth) + 1
    pageControl.currentPage = Int(page)
  }
  
  private func configurePageControl() {
    pageControl.frame = CGRectMake(0, 0, 100, 10)
    pageControl.center = CGPointMake(view.center.x, view.center.y + 260)
    pageControl.numberOfPages = 4
    pageControl.currentPage = 0
    pageControl.currentPageIndicatorTintColor = UIColor.ZKJS_themeColor()
    pageControl.pageIndicatorTintColor = UIColor.ZKJS_themeColor().colorWithAlphaComponent(0.1)
    view.addSubview(pageControl)
  }
  
  private func configureAnimations() {
    configureBackground()
    configurePage1()
    configurePage2()
    configurePage3()
    configurePage4()
    animateCurrentFrame()
  }
  
  private func configurePage1() {
    configureComment0()
    configurePeople0()
    configurePeople1()
    configurePeople2()
    configurePeople3()
    configurePeople4()
    configurePeople5()
    configurePeople6()
    configureLabel1()
  }
  
  private func configurePage2() {
    configureComment1()
    configureComment2()
    configureComment3()
    configureComment4()
    configureComment5()
    configureComment6()
    configureLabel2()
  }
  
  private func configurePage3() {
    configureLayer1()
    configureLayer2()
    configureLayer3()
    configureLayer4()
    configureLayer5()
    configureLayer6()
    configurePaper()
    configureLabel3()
  }
  
  private func configurePage4() {
    configureLayer7()
    configureLayer8()
    configureLayer9()
    configureLayer10()
    configureLayer11()
    configureLayer12()
    configurePhone()
    configureLabel4()
    configureButton()
  }
  
  private func configureBackground() {
    background.frame = CGRectMake(0.0, 0.0, view.frame.size.width * 4, view.frame.size.height)
  }
  
  private func startPage1Animation() {
    comment0.alpha = 0.0
    label1.alpha = 0.0
    UIView.animateWithDuration(2.0) { () -> Void in
      self.comment0.alpha = 1.0
      self.label1.alpha = 1.0
    }
    
    people1.transform = CGAffineTransformMakeTranslation(-100.0, 0.0)
    people2.transform = CGAffineTransformMakeTranslation(-100.0, 0.0)
    people3.transform = CGAffineTransformMakeTranslation(-100.0, 0.0)
    people4.transform = CGAffineTransformMakeTranslation(100.0, 0.0)
    people5.transform = CGAffineTransformMakeTranslation(100.0, 0.0)
    people6.transform = CGAffineTransformMakeTranslation(100.0, 0.0)
    UIView.animateWithDuration(0.6) { () -> Void in
      self.people1.transform = CGAffineTransformIdentity
      self.people2.transform = CGAffineTransformIdentity
      self.people3.transform = CGAffineTransformIdentity
      self.people4.transform = CGAffineTransformIdentity
      self.people5.transform = CGAffineTransformIdentity
      self.people6.transform = CGAffineTransformIdentity
    }
  }
  
  // MARK: - Page 1
  
  private func configurePeople0() {
    let people0AlphaAnimation = AlphaAnimation(view: people0)
    people0AlphaAnimation[1] = 1.0
    people0AlphaAnimation[2] = 0.0
    animator.addAnimation(people0AlphaAnimation)
    
    scrollView.addConstraint(NSLayoutConstraint(item: people0, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: 0))
    
    keepView(people0, onPages: [0, 1, 2])
  }
  
  private func configurePeople1() {
    let people1ScaleAnimation = ScaleAnimation(view: people1)
    people1ScaleAnimation[0] = 1.0
    people1ScaleAnimation[1] = 0.0
    animator.addAnimation(people1ScaleAnimation)
    
    let people1AlphaAnimation = AlphaAnimation(view: people1)
    people1AlphaAnimation[0] = 1.0
    people1AlphaAnimation[1] = 0.0
    animator.addAnimation(people1AlphaAnimation)
    
    let people1VerticalContraint = NSLayoutConstraint(item: people1, attribute: .Bottom, relatedBy: .Equal, toItem: people0, attribute: .Bottom, multiplier: 1.0, constant: 0)
    scrollView.addConstraint(people1VerticalContraint)
    
    keepView(people1, onPages: [-0.36, 0.70], atTimes: [0, 1])
    
    let people1VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: people1VerticalContraint)
    people1VerticalAnimation[0] = 0
    people1VerticalAnimation[1] = -80
    animator.addAnimation(people1VerticalAnimation)
  }
  
  private func configurePeople2() {
    let people2ScaleAnimation = ScaleAnimation(view: people2)
    people2ScaleAnimation[0] = 1.0
    people2ScaleAnimation[1] = 0.0
    animator.addAnimation(people2ScaleAnimation)
    
    let people2AlphaAnimation = AlphaAnimation(view: people2)
    people2AlphaAnimation[0] = 1.0
    people2AlphaAnimation[1] = 0.0
    animator.addAnimation(people2AlphaAnimation)
    
    let people2VerticalContraint = NSLayoutConstraint(item: people2, attribute: .Bottom, relatedBy: .Equal, toItem: people0, attribute: .Bottom, multiplier: 1.0, constant: 0)
    scrollView.addConstraint(people2VerticalContraint)
    
    keepView(people2, onPages: [-0.25, 0.75], atTimes: [0, 1])
    
    let people2VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: people2VerticalContraint)
    people2VerticalAnimation[0] = 0
    people2VerticalAnimation[1] = -150
    animator.addAnimation(people2VerticalAnimation)
  }
  
  private func configurePeople3() {
    let people3ScaleAnimation = ScaleAnimation(view: people3)
    people3ScaleAnimation[0] = 1.0
    people3ScaleAnimation[1] = 0.0
    animator.addAnimation(people3ScaleAnimation)
    
    let people3AlphaAnimation = AlphaAnimation(view: people3)
    people3AlphaAnimation[0] = 1.0
    people3AlphaAnimation[1] = 0.0
    animator.addAnimation(people3AlphaAnimation)
    
    let people3VerticalContraint = NSLayoutConstraint(item: people3, attribute: .Bottom, relatedBy: .Equal, toItem: people0, attribute: .Bottom, multiplier: 1.0, constant: 0)
    scrollView.addConstraint(people3VerticalContraint)
    
    keepView(people3, onPages: [-0.1, 0.9], atTimes: [0, 1])
    
    let people3VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: people3VerticalContraint)
    people3VerticalAnimation[0] = 0
    people3VerticalAnimation[1] = -250
    animator.addAnimation(people3VerticalAnimation)
  }
  
  private func configurePeople4() {
    let people4ScaleAnimation = ScaleAnimation(view: people4)
    people4ScaleAnimation[0] = 1.0
    people4ScaleAnimation[1] = 0.0
    animator.addAnimation(people4ScaleAnimation)
    
    let people4AlphaAnimation = AlphaAnimation(view: people4)
    people4AlphaAnimation[0] = 1.0
    people4AlphaAnimation[1] = 0.0
    animator.addAnimation(people4AlphaAnimation)
    
    let people4VerticalContraint = NSLayoutConstraint(item: people4, attribute: .Bottom, relatedBy: .Equal, toItem: people0, attribute: .Bottom, multiplier: 1.0, constant: 0)
    scrollView.addConstraint(people4VerticalContraint)
    
    keepView(people4, onPages: [0.14, 1.2], atTimes: [0, 1])
    
    let people4VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: people4VerticalContraint)
    people4VerticalAnimation[0] = 0
    people4VerticalAnimation[1] = -180
    animator.addAnimation(people4VerticalAnimation)
  }
  
  private func configurePeople5() {
    let people5ScaleAnimation = ScaleAnimation(view: people5)
    people5ScaleAnimation[0] = 1.0
    people5ScaleAnimation[1] = 0.0
    animator.addAnimation(people5ScaleAnimation)
    
    let people5AlphaAnimation = AlphaAnimation(view: people5)
    people5AlphaAnimation[0] = 1.0
    people5AlphaAnimation[1] = 0.0
    animator.addAnimation(people5AlphaAnimation)
    
    let people5VerticalContraint = NSLayoutConstraint(item: people5, attribute: .Bottom, relatedBy: .Equal, toItem: people0, attribute: .Bottom, multiplier: 1.0, constant: 0)
    scrollView.addConstraint(people5VerticalContraint)
    
    keepView(people5, onPages: [0.33, 1.25], atTimes: [0, 1])
    
    let people5VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: people5VerticalContraint)
    people5VerticalAnimation[0] = 0
    people5VerticalAnimation[1] = -90
    animator.addAnimation(people5VerticalAnimation)
  }
  
  private func configurePeople6() {
    let people6ScaleAnimation = ScaleAnimation(view: people6)
    people6ScaleAnimation[0] = 1.0
    people6ScaleAnimation[1] = 0.0
    animator.addAnimation(people6ScaleAnimation)
    
    let people6AlphaAnimation = AlphaAnimation(view: people6)
    people6AlphaAnimation[0] = 1.0
    people6AlphaAnimation[1] = 0.0
    animator.addAnimation(people6AlphaAnimation)
    
    let people6VerticalContraint = NSLayoutConstraint(item: people6, attribute: .Bottom, relatedBy: .Equal, toItem: people0, attribute: .Bottom, multiplier: 1.0, constant: 0)
    scrollView.addConstraint(people6VerticalContraint)
    
    keepView(people6, onPages: [0.45, 1.35], atTimes: [0, 1])
    
    let people6VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: people6VerticalContraint)
    people6VerticalAnimation[0] = 0
    people6VerticalAnimation[1] = -60
    animator.addAnimation(people6VerticalAnimation)
  }
  
  private func configureLabel1() {
    let label1AlphaAnimation = AlphaAnimation(view: label1)
    label1AlphaAnimation[0] = 1.0
    label1AlphaAnimation[0.2] = 0.3
    label1AlphaAnimation[1] = 0.0
    animator.addAnimation(label1AlphaAnimation)
    
    scrollView.addConstraint(NSLayoutConstraint(item: label1, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: 160))
    
    keepView(label1, onPage: 0)
  }
  
  // MARK: - Page 2
  
  private func configureComment1() {
    let comment1ScaleAnimation = ScaleAnimation(view: comment1)
    comment1ScaleAnimation[1] = 1.0
    comment1ScaleAnimation[2] = 0.0
    animator.addAnimation(comment1ScaleAnimation)
    
    let comment1AlphaAnimation = AlphaAnimation(view: comment1)
    comment1AlphaAnimation[0.6] = 0.0
    comment1AlphaAnimation[1] = 1.0
    comment1AlphaAnimation[1.6] = 0.0
    animator.addAnimation(comment1AlphaAnimation)
    
    let comment1HorizontalConstraint = NSLayoutConstraint(item: comment1, attribute: .CenterX, relatedBy: .Equal, toItem: people0, attribute: .CenterX, multiplier: 1.0, constant: -30)
    scrollView.addConstraint(comment1HorizontalConstraint)
    
    let comment1VerticalConstraint = NSLayoutConstraint(item: comment1, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: -195)
    scrollView.addConstraint(comment1VerticalConstraint)
    
    keepView(comment1, onPages: [0, 1, 2])
    
    let comment1HorizontalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: comment1HorizontalConstraint)
    comment1HorizontalAnimation[1] = -30
    comment1HorizontalAnimation[1.3] = -70
    animator.addAnimation(comment1HorizontalAnimation)
    
    let comment1VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: comment1VerticalConstraint)
    comment1VerticalAnimation[1] = -195
    comment1VerticalAnimation[1.3] = -150
    animator.addAnimation(comment1VerticalAnimation)
  }
  
  private func configureComment2() {
    let comment2ScaleAnimation = ScaleAnimation(view: comment2)
    comment2ScaleAnimation[1] = 1.0
    comment2ScaleAnimation[2] = 0.0
    animator.addAnimation(comment2ScaleAnimation)
    
    let comment2AlphaAnimation = AlphaAnimation(view: comment2)
    comment2AlphaAnimation[0.6] = 0.0
    comment2AlphaAnimation[1] = 1.0
    comment2AlphaAnimation[1.6] = 0.0
    animator.addAnimation(comment2AlphaAnimation)
    
    let comment2HorizontalConstraint = NSLayoutConstraint(item: comment2, attribute: .CenterX, relatedBy: .Equal, toItem: people0, attribute: .CenterX, multiplier: 1.0, constant: 80)
    scrollView.addConstraint(comment2HorizontalConstraint)
    
    let comment2VerticalConstraint = NSLayoutConstraint(item: comment2, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: -140)
    scrollView.addConstraint(comment2VerticalConstraint)
    
    keepView(comment2, onPages: [0, 1, 2])
    
    let comment2HorizontalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: comment2HorizontalConstraint)
    comment2HorizontalAnimation[1] = 80
    comment2HorizontalAnimation[1.3] = -55
    animator.addAnimation(comment2HorizontalAnimation)
    
    let comment2VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: comment2VerticalConstraint)
    comment2VerticalAnimation[1] = -140
    comment2VerticalAnimation[1.3] = -120
    animator.addAnimation(comment2VerticalAnimation)
  }
  
  private func configureComment3() {
    let comment3ScaleAnimation = ScaleAnimation(view: comment3)
    comment3ScaleAnimation[1] = 1.0
    comment3ScaleAnimation[2] = 0.0
    animator.addAnimation(comment3ScaleAnimation)
    
    let comment3AlphaAnimation = AlphaAnimation(view: comment3)
    comment3AlphaAnimation[0.6] = 0.0
    comment3AlphaAnimation[1] = 1.0
    comment3AlphaAnimation[1.6] = 0.0
    animator.addAnimation(comment3AlphaAnimation)
    
    let comment3HorizontalConstraint = NSLayoutConstraint(item: comment3, attribute: .CenterX, relatedBy: .Equal, toItem: people0, attribute: .CenterX, multiplier: 1.0, constant: -85)
    scrollView.addConstraint(comment3HorizontalConstraint)
    
    let comment3VerticalConstraint = NSLayoutConstraint(item: comment3, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: -135)
    scrollView.addConstraint(comment3VerticalConstraint)
    
    keepView(comment3, onPages: [0, 1, 2])
    
    let comment3HorizontalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: comment3HorizontalConstraint)
    comment3HorizontalAnimation[1] = -85
    comment3HorizontalAnimation[1.3] = -40
    animator.addAnimation(comment3HorizontalAnimation)
    
    let comment3VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: comment3VerticalConstraint)
    comment3VerticalAnimation[1] = -135
    comment3VerticalAnimation[1.3] = -90
    animator.addAnimation(comment3VerticalAnimation)
  }
  
  private func configureComment4() {
    let comment4ScaleAnimation = ScaleAnimation(view: comment4)
    comment4ScaleAnimation[1] = 1.0
    comment4ScaleAnimation[2] = 0.0
    animator.addAnimation(comment4ScaleAnimation)
    
    let comment4AlphaAnimation = AlphaAnimation(view: comment4)
    comment4AlphaAnimation[0.6] = 0.0
    comment4AlphaAnimation[1] = 1.0
    comment4AlphaAnimation[1.6] = 0.0
    animator.addAnimation(comment4AlphaAnimation)
    
    let comment4HorizontalConstraint = NSLayoutConstraint(item: comment4, attribute: .CenterX, relatedBy: .Equal, toItem: people0, attribute: .CenterX, multiplier: 1.0, constant: -90)
    scrollView.addConstraint(comment4HorizontalConstraint)
    
    let comment4VerticalConstraint = NSLayoutConstraint(item: comment4, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: -60)
    scrollView.addConstraint(comment4VerticalConstraint)
    
    keepView(comment4, onPages: [0, 1, 2])
    
    let comment4HorizontalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: comment4HorizontalConstraint)
    comment4HorizontalAnimation[1] = -90
    comment4HorizontalAnimation[1.3] = -35
    animator.addAnimation(comment4HorizontalAnimation)
    
    let comment4VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: comment4VerticalConstraint)
    comment4VerticalAnimation[1] = -60
    comment4VerticalAnimation[1.3] = -60
    animator.addAnimation(comment4VerticalAnimation)
  }
  
  private func configureComment5() {
    let comment5ScaleAnimation = ScaleAnimation(view: comment5)
    comment5ScaleAnimation[1] = 1.0
    comment5ScaleAnimation[2] = 0.0
    animator.addAnimation(comment5ScaleAnimation)
    
    let comment5AlphaAnimation = AlphaAnimation(view: comment5)
    comment5AlphaAnimation[0.6] = 0.0
    comment5AlphaAnimation[1] = 1.0
    comment5AlphaAnimation[1.6] = 0.0
    animator.addAnimation(comment5AlphaAnimation)
    
    let comment5HorizontalConstraint = NSLayoutConstraint(item: comment5, attribute: .CenterX, relatedBy: .Equal, toItem: people0, attribute: .CenterX, multiplier: 1.0, constant: 90)
    scrollView.addConstraint(comment5HorizontalConstraint)
    
    let comment5VerticalConstraint = NSLayoutConstraint(item: comment5, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: -80)
    scrollView.addConstraint(comment5VerticalConstraint)
    
    keepView(comment5, onPages: [0, 1, 2])
    
    let comment5HorizontalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: comment5HorizontalConstraint)
    comment5HorizontalAnimation[1] = 90
    comment5HorizontalAnimation[1.3] = -25
    animator.addAnimation(comment5HorizontalAnimation)
    
    let comment5VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: comment5VerticalConstraint)
    comment5VerticalAnimation[1] = -80
    comment5VerticalAnimation[1.3] = -30
    animator.addAnimation(comment5VerticalAnimation)
  }
  
  private func configureComment6() {
    let comment6ScaleAnimation = ScaleAnimation(view: comment6)
    comment6ScaleAnimation[1] = 1.0
    comment6ScaleAnimation[2] = 0.0
    animator.addAnimation(comment6ScaleAnimation)
    
    let comment6AlphaAnimation = AlphaAnimation(view: comment6)
    comment6AlphaAnimation[0.6] = 0.0
    comment6AlphaAnimation[1] = 1.0
    comment6AlphaAnimation[1.6] = 0.0
    animator.addAnimation(comment6AlphaAnimation)
    
    let comment6HorizontalConstraint = NSLayoutConstraint(item: comment6, attribute: .CenterX, relatedBy: .Equal, toItem: people0, attribute: .CenterX, multiplier: 1.0, constant: 100)
    scrollView.addConstraint(comment6HorizontalConstraint)
    
    let comment6VerticalConstraint = NSLayoutConstraint(item: comment6, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: -20)
    scrollView.addConstraint(comment6VerticalConstraint)
    
    keepView(comment6, onPages: [0, 1, 2])
    
    let comment6HorizontalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: comment6HorizontalConstraint)
    comment6HorizontalAnimation[1] = 100
    comment6HorizontalAnimation[1.3] = -70
    animator.addAnimation(comment6HorizontalAnimation)
    
    let comment6VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: comment6VerticalConstraint)
    comment6VerticalAnimation[1] = -20
    comment6VerticalAnimation[1.3] = 0
    animator.addAnimation(comment6VerticalAnimation)
  }
  
  private func configureComment0() {
    let comment0AlphaAnimation = AlphaAnimation(view: comment0)
    comment0AlphaAnimation[0] = 1.0
    comment0AlphaAnimation[0.4] = 0.0
    animator.addAnimation(comment0AlphaAnimation)
    
    scrollView.addConstraint(NSLayoutConstraint(item: comment0, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: -160))
    
    keepView(comment0, onPages: [0, 1])
  }
  
  private func configureLabel2() {
    let label2AlphaAnimation = AlphaAnimation(view: label2)
    label2AlphaAnimation[0] = 0.0
    label2AlphaAnimation[1] = 1.0
    label2AlphaAnimation[1.2] = 0.3
    label2AlphaAnimation[2] = 0.0
    animator.addAnimation(label2AlphaAnimation)
    
    scrollView.addConstraint(NSLayoutConstraint(item: label2, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: 160))
    
    keepView(label2, onPage: 1)
  }
  
  // MARK: - Page 3
  
  private func configureLayer1() {
    let layer1AlphaAnimation = AlphaAnimation(view: layer1)
    layer1AlphaAnimation[1.5] = 0.0
    layer1AlphaAnimation[2] = 1.0
    layer1AlphaAnimation[3] = 0.0
    animator.addAnimation(layer1AlphaAnimation)

    let layer1VerticalConstraint = NSLayoutConstraint(item: layer1, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: -150)
    scrollView.addConstraint(layer1VerticalConstraint)
    
    keepView(layer1, onPages: [1, 2, 3])
    
    let layer1VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: layer1VerticalConstraint)
    layer1VerticalAnimation[2] = -150
    layer1VerticalAnimation[2.6] = -130
    animator.addAnimation(layer1VerticalAnimation)
  }
  
  private func configureLayer2() {
    let layer2AlphaAnimation = AlphaAnimation(view: layer2)
    layer2AlphaAnimation[1.5] = 0.0
    layer2AlphaAnimation[2] = 1.0
    layer2AlphaAnimation[3] = 0.0
    animator.addAnimation(layer2AlphaAnimation)
    
    let layer2VerticalConstraint = NSLayoutConstraint(item: layer2, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: -120)
    scrollView.addConstraint(layer2VerticalConstraint)
    
    keepView(layer2, onPages: [1.05, 2, 3], atTimes: [1, 2, 3])
    
    let layer2VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: layer2VerticalConstraint)
    layer2VerticalAnimation[2] = -120
    layer2VerticalAnimation[2.47] = -95
    animator.addAnimation(layer2VerticalAnimation)
  }
  
  private func configureLayer3() {
    let layer3AlphaAnimation = AlphaAnimation(view: layer3)
    layer3AlphaAnimation[1.5] = 0.0
    layer3AlphaAnimation[2] = 1.0
    layer3AlphaAnimation[3] = 0.0
    animator.addAnimation(layer3AlphaAnimation)
    
    let layer3VerticalConstraint = NSLayoutConstraint(item: layer3, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: -90)
    scrollView.addConstraint(layer3VerticalConstraint)
    
    keepView(layer3, onPages: [1.1, 2, 3], atTimes: [1, 2, 3])
    
    let layer3VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: layer3VerticalConstraint)
    layer3VerticalAnimation[2] = -90
    layer3VerticalAnimation[2.55] = -60
    animator.addAnimation(layer3VerticalAnimation)
  }
  
  private func configureLayer4() {
    let layer4AlphaAnimation = AlphaAnimation(view: layer4)
    layer4AlphaAnimation[1.5] = 0.0
    layer4AlphaAnimation[2] = 1.0
    layer4AlphaAnimation[3] = 0.0
    animator.addAnimation(layer4AlphaAnimation)
    
    let layer4VerticalConstraint = NSLayoutConstraint(item: layer4, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: -60)
    scrollView.addConstraint(layer4VerticalConstraint)
    
    keepView(layer4, onPages: [1.15, 2, 3], atTimes: [1, 2, 3])
    
    let layer4VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: layer4VerticalConstraint)
    layer4VerticalAnimation[2] = -60
    layer4VerticalAnimation[2.6] = -25
    animator.addAnimation(layer4VerticalAnimation)
  }
  
  private func configureLayer5() {
    let layer5AlphaAnimation = AlphaAnimation(view: layer5)
    layer5AlphaAnimation[1.5] = 0.0
    layer5AlphaAnimation[2] = 1.0
    layer5AlphaAnimation[3] = 0.0
    animator.addAnimation(layer5AlphaAnimation)
    
    let layer5VerticalConstraint = NSLayoutConstraint(item: layer5, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: -30)
    scrollView.addConstraint(layer5VerticalConstraint)
    
    keepView(layer5, onPages: [1.2, 2, 3], atTimes: [1, 2, 3])
    
    let layer5VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: layer5VerticalConstraint)
    layer5VerticalAnimation[2] = -30
    layer5VerticalAnimation[2.49] = 10
    animator.addAnimation(layer5VerticalAnimation)
  }
  
  private func configureLayer6() {
    let layer6AlphaAnimation = AlphaAnimation(view: layer6)
    layer6AlphaAnimation[1.5] = 0.0
    layer6AlphaAnimation[2] = 1.0
    layer6AlphaAnimation[3] = 0.0
    animator.addAnimation(layer6AlphaAnimation)
    
    let layer6VerticalConstraint = NSLayoutConstraint(item: layer6, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: 0)
    scrollView.addConstraint(layer6VerticalConstraint)
    
    keepView(layer6, onPages: [1, 2, 3])
    
    let layer6VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: layer6VerticalConstraint)
    layer6VerticalAnimation[2] = 0
    layer6VerticalAnimation[2.50] = 45
    animator.addAnimation(layer6VerticalAnimation)
  }
  
  private func configurePaper() {
    let paperAlphaAnimation = AlphaAnimation(view: paper)
    paperAlphaAnimation[2] = 1.0
    paperAlphaAnimation[3] = 0.0
    animator.addAnimation(paperAlphaAnimation)
    
    scrollView.addConstraint(NSLayoutConstraint(item: paper, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: -50))
    
    keepView(paper, onPages: [2])
  }
  
  private func configureLabel3() {
    let label3AlphaAnimation = AlphaAnimation(view: label3)
    label3AlphaAnimation[1] = 0.0
    label3AlphaAnimation[2] = 1.0
    label3AlphaAnimation[2.2] = 0.3
    label3AlphaAnimation[3] = 0.0
    animator.addAnimation(label3AlphaAnimation)
    
    scrollView.addConstraint(NSLayoutConstraint(item: label3, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: 160))
    
    keepView(label3, onPage: 2)
  }
  
  // MARK: - Page 4
  
  private func configureLayer7() {
    let layer7AlphaAnimation = AlphaAnimation(view: layer7)
    layer7AlphaAnimation[2] = 0.0
    layer7AlphaAnimation[3] = 1.0
    animator.addAnimation(layer7AlphaAnimation)
    
    let layer7VerticalConstraint = NSLayoutConstraint(item: layer7, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: -130)
    scrollView.addConstraint(layer7VerticalConstraint)
    
    keepView(layer7, onPages: [2, 3])
    
    let layer7VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: layer7VerticalConstraint)
    layer7VerticalAnimation[2] = -150
    layer7VerticalAnimation[2.6] = -130
    animator.addAnimation(layer7VerticalAnimation)
  }
  
  private func configureLayer8() {
    let layer8AlphaAnimation = AlphaAnimation(view: layer8)
    layer8AlphaAnimation[2] = 0.0
    layer8AlphaAnimation[3] = 1.0
    animator.addAnimation(layer8AlphaAnimation)
    
    let layer8VerticalConstraint = NSLayoutConstraint(item: layer8, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: -95)
    scrollView.addConstraint(layer8VerticalConstraint)
    
    keepView(layer8, onPages: [2, 3])
    
    let layer8VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: layer8VerticalConstraint)
    layer8VerticalAnimation[2] = -120
    layer8VerticalAnimation[2.47] = -95
    animator.addAnimation(layer8VerticalAnimation)
  }
  
  private func configureLayer9() {
    let layer9AlphaAnimation = AlphaAnimation(view: layer9)
    layer9AlphaAnimation[2] = 0.0
    layer9AlphaAnimation[3] = 1.0
    animator.addAnimation(layer9AlphaAnimation)
    
    let layer9VerticalConstraint = NSLayoutConstraint(item: layer9, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: -60)
    scrollView.addConstraint(layer9VerticalConstraint)
    
    keepView(layer9, onPages: [2, 3])
    
    let layer9VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: layer9VerticalConstraint)
    layer9VerticalAnimation[2] = -90
    layer9VerticalAnimation[2.55] = -60
    animator.addAnimation(layer9VerticalAnimation)
  }
  
  private func configureLayer10() {
    let layer10AlphaAnimation = AlphaAnimation(view: layer10)
    layer10AlphaAnimation[2] = 0.0
    layer10AlphaAnimation[3] = 1.0
    animator.addAnimation(layer10AlphaAnimation)
    
    let layer10VerticalConstraint = NSLayoutConstraint(item: layer10, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: -25)
    scrollView.addConstraint(layer10VerticalConstraint)
    
    keepView(layer10, onPages: [2, 3])
    
    let layer10VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: layer10VerticalConstraint)
    layer10VerticalAnimation[2] = -60
    layer10VerticalAnimation[2.6] = -25
    animator.addAnimation(layer10VerticalAnimation)
  }
  
  private func configureLayer11() {
    let layer11AlphaAnimation = AlphaAnimation(view: layer11)
    layer11AlphaAnimation[2] = 0.0
    layer11AlphaAnimation[3] = 1.0
    animator.addAnimation(layer11AlphaAnimation)
    
    let layer11VerticalConstraint = NSLayoutConstraint(item: layer11, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: 10)
    scrollView.addConstraint(layer11VerticalConstraint)
    
    keepView(layer11, onPages: [2, 3])
    
    let layer11VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: layer11VerticalConstraint)
    layer11VerticalAnimation[2] = -30
    layer11VerticalAnimation[2.49] = 10
    animator.addAnimation(layer11VerticalAnimation)
  }
  
  private func configureLayer12() {
    let layer12AlphaAnimation = AlphaAnimation(view: layer12)
    layer12AlphaAnimation[2] = 0.0
    layer12AlphaAnimation[3] = 1.0
    animator.addAnimation(layer12AlphaAnimation)
    
    let layer12VerticalConstraint = NSLayoutConstraint(item: layer12, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: 45)
    scrollView.addConstraint(layer12VerticalConstraint)
    
    keepView(layer12, onPages: [2, 3])
    
    let layer12VerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: layer12VerticalConstraint)
    layer12VerticalAnimation[2] = 0
    layer12VerticalAnimation[2.5] = 45
    animator.addAnimation(layer12VerticalAnimation)
  }
  
  private func configurePhone() {
    let phoneAlphaAnimation = AlphaAnimation(view: phone)
    phoneAlphaAnimation[2] = 0.0
    phoneAlphaAnimation[3] = 1.0
    animator.addAnimation(phoneAlphaAnimation)
    
    scrollView.addConstraint(NSLayoutConstraint(item: phone, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: -65))
    
    keepView(phone, onPages: [3])
  }
  
  private func configureLabel4() {
    let label4AlphaAnimation = AlphaAnimation(view: label4)
    label4AlphaAnimation[2] = 0.0
    label4AlphaAnimation[3] = 1.0
    animator.addAnimation(label4AlphaAnimation)
    
    scrollView.addConstraint(NSLayoutConstraint(item: label4, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: 160))
    
    keepView(label4, onPage: 3)
  }
  
  private func configureButton() {
    let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("buttonTapped:"))
    button.userInteractionEnabled = true
    button.addGestureRecognizer(tapGestureRecognizer)
    
    let buttonAlphaAnimation = AlphaAnimation(view: button)
    buttonAlphaAnimation[2] = 0.0
    buttonAlphaAnimation[3] = 1.0
    animator.addAnimation(buttonAlphaAnimation)
    
    scrollView.addConstraint(NSLayoutConstraint(item: button, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: 220))
    
    keepView(button, onPage: 3)
  }
  
  // MARK: - Gesture
  
  func buttonTapped(sender: UITapGestureRecognizer) {
    UIApplication.sharedApplication().keyWindow?.backgroundColor = UIColor(hexString: "#F5F5F5")
    
    UIView.animateWithDuration(0.4, animations: { () -> Void in
      self.fadeOutPage4()
      }) { (finished: Bool) -> Void in
        if finished {
          self.gotoMain()
        }
    }
  }
  
  private func gotoMain() {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    appDelegate.window?.rootViewController = appDelegate.mainTBC
    appDelegate.mainTBC.selectedIndex = 3
    appDelegate.mainTBC.navigationController?.pushViewController(InformVC(), animated: true)
  }
  
  private func fadeOutPage4() {
    self.view.transform = CGAffineTransformMakeScale(1.5, 1.5)
    self.view.alpha = 0.0
  }
  
}
