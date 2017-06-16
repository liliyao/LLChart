//
//  LLTool.swift
//  LLChart
//
//  Created by apple on 2017/6/15.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
import UIKit

let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height-64
let standardWith: CGFloat = 375.00
let standardHeight: CGFloat = 667.00
let ScaleW : CGFloat = (kScreenW / standardWith)
let ScaleH : CGFloat = ((kScreenH + 64)/standardHeight)

/// 绘制线条
///
/// - Parameters:
///   - context: 上下文
///   - startPoint: 起点
///   - endPoint: 终点
///   - isDotted: 是否虚线
///   - lineColor: 线条颜色
func drawLine(context:CGContext,startPoint:CGPoint,endPoint:CGPoint,isDotted:Bool,lineColor:UIColor){
    //移动到点
    context.move(to:startPoint)
    //连接到点
    context.addLine(to:endPoint)
    //设置线条宽度
    context.setLineWidth(0.5)
    //填充颜色
    lineColor.setStroke()
    
    if isDotted{//如果是虚线
        context.setLineDash(phase:0, lengths:[0.5,2])
    }
    context.drawPath(using: CGPathDrawingMode.fillStroke)
}


/// 绘制线条
///
/// - Parameters:
///   - bezier: UIBezierPath
///   - startPoint: 起点
///   - endPoint: 终点
func  drawLine(bezier:UIBezierPath,startPoint:CGPoint,endPoint:CGPoint){
    bezier.move(to:startPoint)
    bezier.addLine(to:endPoint)
}


func drawDashLine(bezier:UIBezierPath,startPoint:CGPoint,endPoint:CGPoint){
    bezier.move(to:startPoint)
    bezier.addLine(to:endPoint)
    
}


/// 绘制文字
///
/// - Parameters:
///   - text: 文字
///   - textColor: 文字颜色
///   - textFont: 文字大小
///   - backGroundColor: 背景颜色
/// - Returns: 文字图层
func drawText(text:String,textColor:UIColor,textFont:CGFloat,backGroundColor:UIColor)->CATextLayer{
    let font = UIFont.systemFont(ofSize:textFont)
    let textLayer = CATextLayer.init()
    textLayer.fontSize = textFont
    textLayer.font = font
    textLayer.string = text
    textLayer.foregroundColor = textColor.cgColor
    textLayer.backgroundColor = backGroundColor.cgColor
    return textLayer
}


/// 画圆
///
/// - Parameters:
///   - bezierPath: UIBezierPath
///   - center:      中心点
///   - fillColor: 填充颜色
func drawArc(bezierPath:UIBezierPath,center:CGPoint,fillColor:UIColor){
    bezierPath.move(to:center)
    bezierPath.addArc(withCenter:center, radius:2.5, startAngle: 0.0, endAngle:CGFloat(Double.pi * 2), clockwise:true)
}

func getBasicAnimation(keyPath:String,duartion:CFTimeInterval)->CABasicAnimation{
    let basic = CABasicAnimation.init(keyPath:keyPath)
    basic.duration = duartion
    basic.fromValue = 0
    basic.toValue = 1
    basic.autoreverses = false
    basic.fillMode = kCAFillModeForwards
    return basic
}

//根据高度计算文字宽度
func autoLayoutContnetWidthWithHeight(height:CGFloat,font:CGFloat,content:String,lineSpace:CGFloat)-> CGSize{
    var actualsize = CGSize.zero
    let normalText:NSString = content as NSString
    let paragraphStyle = NSMutableParagraphStyle.init()
    paragraphStyle.lineSpacing = lineSpace
    var dict:Dictionary<String,Any> = [:]
    dict.updateValue(UIFont.systemFont(ofSize:font), forKey: NSFontAttributeName)
    dict.updateValue(paragraphStyle, forKey:NSParagraphStyleAttributeName)
    actualsize = normalText.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:height), options: NSStringDrawingOptions.usesLineFragmentOrigin,attributes:dict, context: nil).size
    return actualsize
}

