//
//  CircularProgressView.swift
//  SuperService
//
//  Created by Qin Yejun on 4/28/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CircularProgressView: UIControl {
  //进度条颜色（
  @IBInspectable var circleColor: UIColor = UIColor(
    red: (3.0/255.0), green: (169.0/255), blue: (244.0/255.0), alpha: 1.0)
  
  //进度条半径
  //@IBInspectable var circleRadius:CGFloat = 70
  
  //进度0～1（内圈、中间、外圈）
  @IBInspectable var percent:CGFloat = 0.75 {
    didSet {
      setNeedsDisplay()
    }
  }
  
  //进度条宽度
  @IBInspectable var circleWeight:CGFloat = 16
  
  //进度条背景槽透明度（黑色舞台背景建议0.3，白色舞台背景建议0.15）
  @IBInspectable var barBgAlpha:CGFloat = 0.3
  
  // 是否选择
  @IBInspectable var checked:Bool = false {
    didSet {
      setNeedsDisplay()
    }
  }
  
  //对钩颜色
  @IBInspectable var checkMarkColor: UIColor = UIColor.whiteColor()
  
  //对钩宽度
  @IBInspectable var checkMarkLineWidth:CGFloat = 6.0
  
  // mask 不透明度
  @IBInspectable var maskOpacity:CGFloat = 0.6 {
    didSet {
      setNeedsDisplay()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    backgroundColor = UIColor.clearColor()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = UIColor.clearColor()
  }
  
  // 绘制
  override func drawRect(rect: CGRect) {
    if let sublayers = self.layer.sublayers {
      for sub in sublayers {
        sub.removeFromSuperlayer()
      }
    }
    // 添加环形进度条
    let radius = min(rect.width, rect.height) / 2 - circleWeight / 2
    self.addCirle(radius, color: circleColor, percent: percent)
    self.addMask(rect)
  }
  
  //添加环形进度
  func addCirle(arcRadius: CGFloat, color: UIColor, percent:CGFloat) {
    let X = CGRectGetMidX(self.bounds)
    let Y = CGRectGetMidY(self.bounds)
    
    // 进度条圆弧背景
    var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
    color.getRed(&r, green: &g, blue: &b, alpha: &a)
    let barBgColor = UIColor(red: r, green: g, blue: b, alpha: barBgAlpha);
    
    let barBgPath = UIBezierPath(arcCenter: CGPoint(x: X, y: Y), radius: arcRadius,
                                 startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI*1.5),
                                 clockwise: true).CGPath
    self.addOval(circleWeight, path: barBgPath, strokeStart: 0, strokeEnd: 1,
                 strokeColor: barBgColor, fillColor: UIColor.clearColor(),
                 shadowRadius: 0, shadowOpacity: 0, shadowOffsset: CGSizeZero)
    
    // 进度条圆弧
    let barPath = UIBezierPath(arcCenter: CGPoint(x: X, y: Y), radius: arcRadius,
                               startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI*1.5),
                               clockwise: true).CGPath
    self.addOval(circleWeight, path: barPath, strokeStart: 0, strokeEnd: percent,
                 strokeColor: color, fillColor: UIColor.clearColor(),
                 shadowRadius: 0, shadowOpacity: 0, shadowOffsset: CGSizeZero)
    
    if percent > 0 {
      // 进度条起点圆头
      let startPath = UIBezierPath(ovalInRect: CGRectMake(X-circleWeight/2,
        Y-arcRadius-circleWeight/2, circleWeight, circleWeight)).CGPath
      self.addOval(0.0, path: startPath, strokeStart: 0, strokeEnd: 1.0,
                   strokeColor: color, fillColor: color,
                   shadowRadius: 0, shadowOpacity: 0, shadowOffsset: CGSizeZero)
      
      // 进度条终点圆头
      let endDotPoint = calcCircleCoordinateWithCenter(CGPoint(x: X, y: Y),
                                                       radius: arcRadius, angle: -percent*360+90)
      let endDotPath = UIBezierPath(ovalInRect: CGRectMake(endDotPoint.x-circleWeight/2,
        endDotPoint.y-circleWeight/2, circleWeight, circleWeight)).CGPath
      self.addOval(0.0, path: endDotPath, strokeStart: 0, strokeEnd: 1.0,
                   strokeColor: color, fillColor: color,
                   shadowRadius: 5.0, shadowOpacity: 0.5, shadowOffsset: CGSizeZero)
      
      // 进度条遮罩1(圆弧)
      let barMaskPath = UIBezierPath(arcCenter: CGPoint(x: X, y: Y), radius: arcRadius,
                                     startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI*1.5),
                                     clockwise: true).CGPath
      self.addOval(circleWeight, path: barMaskPath,
                   strokeStart: percent/6, strokeEnd: percent,
                   strokeColor: color, fillColor: UIColor.clearColor(),
                   shadowRadius: 0, shadowOpacity: 0, shadowOffsset: CGSizeZero)
      // 进度条遮罩2(圆)
      if percent < 0.5{
        self.addOval(0.0, path: startPath, strokeStart: 0, strokeEnd: 1.0,
                     strokeColor: color, fillColor: color,
                     shadowRadius: 0, shadowOpacity: 0, shadowOffsset: CGSizeZero)
      }
    }
  }
  
  //计算圆弧上点的坐标
  func calcCircleCoordinateWithCenter(center:CGPoint, radius:CGFloat, angle:CGFloat)
    -> CGPoint {
      let x2 = radius*CGFloat(cosf(Float(angle)*Float(M_PI)/Float(180)));
      let y2 = radius*CGFloat(sinf(Float(angle)*Float(M_PI)/Float(180)));
      return CGPointMake(center.x+x2, center.y-y2);
  }
  
  //添加圆弧
  func addOval(lineWidth: CGFloat, path: CGPathRef, strokeStart: CGFloat,
               strokeEnd: CGFloat, strokeColor: UIColor, fillColor: UIColor,
               shadowRadius: CGFloat, shadowOpacity: Float, shadowOffsset: CGSize) {
    
    let arc = CAShapeLayer()
    arc.lineWidth = lineWidth
    arc.path = path
    arc.strokeStart = strokeStart
    arc.strokeEnd = strokeEnd
    arc.strokeColor = strokeColor.CGColor
    arc.fillColor = fillColor.CGColor
    arc.shadowColor = UIColor.blackColor().CGColor
    arc.shadowRadius = shadowRadius
    arc.shadowOpacity = shadowOpacity
    arc.shadowOffset = shadowOffsset
    layer.addSublayer(arc)
  }
  
  func  addMask(rect: CGRect) {
    if checked {
      let length = min(rect.width,rect.height)
      let mask = CAShapeLayer()
      let circle = UIBezierPath(ovalInRect: CGRectMake((rect.width - length)/2, (rect.height - length)/2, length, length))
      mask.path = circle.CGPath
      mask.fillColor = circleColor.CGColor
      mask.opacity = Float(self.maskOpacity)
      
      layer.addSublayer(mask)
      
      addCheckMark(rect)
    }
  }
  
  func addCheckMark(rect: CGRect) {
    let offsetX:CGFloat = rect.width / 2 - 20
    let offsetY:CGFloat = rect.height / 2 - 15
    
    let markPath = UIBezierPath()
    markPath.moveToPoint(CGPointMake(2 + offsetX, 15 + offsetY))
    markPath.addLineToPoint(CGPointMake(20 + offsetX, 33 + offsetY))
    markPath.addLineToPoint(CGPointMake(50 + offsetX, 2 + offsetY))
    markPath.lineCapStyle = .Round;
    markPath.lineJoinStyle = .Round;
    
    let markLayer = CAShapeLayer()
    markLayer.lineWidth = checkMarkLineWidth
    markLayer.path = markPath.CGPath
    markLayer.fillColor = UIColor.clearColor().CGColor
    markLayer.strokeColor = checkMarkColor.CGColor
    
    layer.addSublayer(markLayer)
    
  }
}