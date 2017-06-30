//
//  LLLineChart.swift
//  LLChart
//
//  Created by apple on 2017/6/15.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit
//折线图
class LLLineChart: LLChart {
    /// 每种折线图的线条颜色 设置必须保证数量和数据源数组的类型的个数相同 否则默认为蓝色
    var lineColorArr:Array<UIColor> = []
    // 每种折线图的点颜色 设置必须保证数量和数据源数组的类型的个数相同 否则默认为红色
    var pointColorArr:Array<UIColor>  = []
    
    //两点间的距离
    var pointSpace:CGFloat = 40
    
    private var pointArr:Array<Any> = []
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func showAnimation() {
        super.showAnimation()
        self.backgroundColor = bgViewBackgroundColor
        getMaxHeight()
        originY = self.frame.height - chartOrigin.y
        var width = self.frame.size.width
        if valueArr.count > 0 {
            let colW = chartOrigin.x + (pointSpace) * CGFloat(valueArr[0].count)  + 30
            width = colW > self.frame.size.width ? colW:self.frame.size.width
        }
        self.contentSize = CGSize(width:width, height:self.frame.size.height)
        contSize = self.contentSize
        if valueArr.count > 0 {
            pointSpace = ((contSize?.width)! - 30 - chartOrigin.x) / CGFloat(valueArr[0].count)
        }
        print(pointSpace)
        
        //绘制xy轴
        drawXY()
        
        //绘制x,y轴提示语
        drawXYTipText()
        
        //绘制折线图
        drawLineChart()
    }
    
    //绘制x,y轴提示语
    func drawXYTipText(){
        //绘制x轴提示语
        let arr = valueArr[0]
        if xShowInfoText.count == arr.count && xShowInfoText.count > 0 {
            for i in 0..<arr.count{
                let textLayer = drawText(text:xShowInfoText[i] as! String, textColor:textColorForXY, textFont:textFont, backGroundColor:UIColor.clear)
                let textOrgin = chartOrigin.x + pointSpace / 2
                let textX =  textOrgin + pointSpace * CGFloat(i)
                textLayer.frame = CGRect(x:textX, y:originY + 5, width:pointSpace, height:20*ScaleH)
                textLayer.alignmentMode = "center"
                textLayer.backgroundColor = UIColor.clear.cgColor
                self.layer.addSublayer(textLayer)
                self.layerArr.append(textLayer)
            }
        }
        
        //绘制y轴刻度  默认显示5个
        for i in 0..<markNum {
            let perHeight = (originY - spaceY) / CGFloat(markNum) * CGFloat(i)
            let perMark = maxHeight / CGFloat(markNum)
            let textLayer = drawText(text:"\(CGFloat(i) * perMark)", textColor:textColorForXY, textFont:textFont, backGroundColor: UIColor.clear)
            textLayer.frame = CGRect(x:3, y:originY - perHeight - 7.5, width:chartOrigin.x - 3, height:15*ScaleH)
            self.layerArr.append(textLayer)
            self.layer.addSublayer(textLayer)
        }
    }
    
    //绘制折线图
    func drawLineChart(){
        var pointColor = UIColor.red
        var lineColor = UIColor.blue
        for i in 0..<valueArr.count{
           let arr = valueArr[i]
            //点
            if pointColorArr.count == valueArr.count {
                pointColor = pointColorArr[i]
            }
            let pointPath = UIBezierPath.init()
            pointPath.lineWidth = 2
            
            let pointLayer  = CAShapeLayer.init()
            layerArr.append(pointLayer)
            self.layer.addSublayer(pointLayer)
            
            
            //线
            if chartColorArr.count == valueArr.count {
                lineColor = chartColorArr[i]
            }
            let linePatn = UIBezierPath.init()
            linePatn.lineWidth = 0.5
            
            let lineLayer = CAShapeLayer.init()
            layerArr.append(lineLayer)
            self.layer.addSublayer(lineLayer)
            
            //虚线
            let dashPath = UIBezierPath.init()
            dashPath.lineWidth = 0.5
            
            let dashLayer = CAShapeLayer.init()
            layerArr.append(dashLayer)
            self.layer.addSublayer(dashLayer)
        
            //终点 起点
            var startPoint:CGPoint?
            var endPoint:CGPoint?
            for j in 0..<arr.count{
                //画点
                let point = CGPoint(x:chartOrigin.x + pointSpace * CGFloat(j + 1), y:arr[j])
                drawArc(bezierPath:pointPath, center:point, fillColor:pointColor)
                let textlayer = drawText(text:"\(arr[j])", textColor:pointColor, textFont:12 * ScaleW, backGroundColor: UIColor.clear)
                textlayer.frame = CGRect(x:chartOrigin.x + pointSpace * CGFloat(j + 1) - 30*ScaleW, y:arr[j] - 15, width:60*ScaleW, height:15)
                textlayer.alignmentMode = "center"
                self.layer.addSublayer(textlayer)
                layerArr.append(textlayer)
                
                //画线
                if j == 0{
                   startPoint = point
                }else{
                   endPoint = point
                }
                if startPoint != nil && endPoint != nil {
                    drawLine(bezier:linePatn, startPoint: startPoint!, endPoint:endPoint!)
                }
                if j != 0 {
                    startPoint = endPoint
                }
                drawLine(bezier:dashPath, startPoint: CGPoint(x:chartOrigin.x, y:point.y), endPoint:point)
                drawLine(bezier:dashPath, startPoint:CGPoint(x:point.x, y:originY), endPoint:point)
            }
              let basic = getBasicAnimation(keyPath:KeyPathStr, duartion:1.5)
            pointLayer.path = pointPath.cgPath
            pointLayer.fillColor = pointColor.cgColor
            pointLayer.add(basic, forKey:nil)
            
            lineLayer.path = linePatn.cgPath
            lineLayer.strokeColor = lineColor.cgColor
            lineLayer.add(basic, forKey:nil)
            
            dashLayer.path = dashPath.cgPath
            dashLayer.strokeColor = UIColor.orange.cgColor
            dashLayer.lineDashPattern = [2,2]
            dashLayer.add(basic, forKey:nil)
        }
    }
}
