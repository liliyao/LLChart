//
//  LLColumnChart.swift
//  LLChart
//
//  Created by apple on 2017/6/13.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

//柱状图
class LLColumnChart: LLChart {
    
    //两个柱状图的间距 非连续 默认为15
    var columnSpace:CGFloat = 15
    
    //柱状图的宽度 默认为30
    var columnWidth:CGFloat = 30
    
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func showAnimation() {
        super.showAnimation()
        var width = self.frame.size.width
        if valueArr.count > 0 {
            let colW = chartOrigin.x + (columnSpace + columnWidth * 2 ) * CGFloat(valueArr[0].count)  + 30
            width = colW > self.frame.size.width ? colW:self.frame.size.width
        }
        self.contentSize = CGSize(width:width, height:self.frame.size.height)
        contSize = self.contentSize
        self.backgroundColor = bgViewBackgroundColor
        getMaxHeight()
        originY = self.frame.height - chartOrigin.y
        
        //绘制xy轴
        drawXY()
        
        //绘制x,y轴提示语
        drawXYTipText()
        
         //绘制柱状图
        drawColumn()
    }
    
    //绘制x,y轴提示语
    func drawXYTipText(){
        //绘制x轴提示语
        let arr = valueArr[0]
        if xShowInfoText.count == arr.count && xShowInfoText.count > 0 {
            let count = arr.count
            for i in 0..<arr.count{
                let textWidth = CGFloat(count) * columnWidth + columnWidth
                let textLayer = drawText(text:xShowInfoText[i] as! String, textColor:textColorForXY, textFont:textFont, backGroundColor:UIColor.clear)
                
                textLayer.frame = CGRect(x:CGFloat(i) * (CGFloat(valueArr.count) * columnWidth + columnSpace) + columnWidth + chartOrigin.x, y:originY + 5, width:textWidth, height:20*ScaleH)
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
    
    //绘制柱状图
    func drawColumn(){
        //绘制柱状图
        for i in 0..<valueArr.count{
            let arr = valueArr[i]
            for j in 0..<arr.count{
                //每个柱状图的高
                let columnHeight = arr[j] / maxHeight * (originY - spaceY)
                let x = CGFloat((i + j * 2)) * columnWidth
                let columnX =  x + CGFloat(j + 1) * columnSpace + chartOrigin.x
                let columnFrame = CGRect(x:columnX, y:originY - columnHeight, width:columnWidth, height:0)
                let columnItem = UIView.init()
                self.layer.addSublayer(columnItem.layer)
                layerArr.append(columnItem.layer)
                columnItem.frame = columnFrame
                columnItem.backgroundColor = chartColorArr.count != valueArr.count ? UIColor.blue:chartColorArr[i]
                weak var weakSelf = self
                UIView.animate(withDuration: 1.5, animations: {
                    columnItem.frame = CGRect(x:columnX, y:self.originY - columnHeight, width:self.columnWidth, height:columnHeight)
                }, completion: { (isFinsh:Bool) in
                    let textLayer = drawText(text:"\(arr[j])", textColor:(weakSelf?.chartColorArr.count)! != self.valueArr.count ? UIColor.blue:(weakSelf?.chartColorArr[i])!, textFont:(weakSelf?.textFont)!, backGroundColor: UIColor.white)
                    textLayer.alignmentMode = "center"
                    textLayer.frame = CGRect(x:columnFrame.origin.x, y:columnFrame.origin.y, width:(weakSelf?.columnWidth)!, height:20*ScaleH)
                    weakSelf?.layer.addSublayer(textLayer)
                    weakSelf?.layerArr.append(textLayer)
                    
                })
                
            }
        }
    }
}


