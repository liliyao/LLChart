//
//  LLColumnChart.swift
//  LLChart
//
//  Created by apple on 2017/6/13.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class LLColumnChart: LLChart {
    
    /// 每种柱状图的背景颜色 如果不设置默认值为绿色 设置必须保证数量和数据源数组的类型的个数相同 否则默认为蓝色
    var columnBgColorArr:Array<UIColor> = []
    
    ///  数据源数组 样式参考demo  必须设置
    var valueArr:Array<Array<CGFloat>> = []    //[[1,2,3],[4,5,6]]
    
    // 每种颜色柱状图表示的意思
    var valueStrArr:Array<String> = []
    
    //每项图标的X轴分类显示语
    var xShowInfoText:Array<Any> = []
    
    //两个柱状图的间距 非连续 默认为15
    var columnSpace:CGFloat = 15
    
    //柱状图的宽度 默认为30
    var columnWidth:CGFloat = 30
    
    //x,Y轴颜色  默认为灰色
    var colorForXYLine:UIColor = UIColor.gray
    
    //Y轴单位
    var YUnitStr:String = ""
    
    //x,Y轴字体颜色   默认黑色
    var textColorForXY:UIColor = UIColor.black
    
    //Y轴单位   默认没有
    var YUintStr:String = ""
    
    //柱状图起点距原点水平距离  默认15
    var drawFromOriginX:CGFloat = 15
    
    //视图背景颜色
    var bgViewBackgroundColor:UIColor = UIColor.white
    
    //Y轴刻度个数  默认为5个
    var markNum:Int = 5
    
    //Y轴最大数
    private var maxHeight:CGFloat =  0
    
    private let KeyPathStr:String = "strokeEnd"
    
    private let textFont:CGFloat = 12 * ScaleH
    
    //整个图往下15
    private let spaceY:CGFloat = 15
    
    //y轴终点
    private var originY:CGFloat  = 0
    
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
        
        //绘制xy轴
        drawXY()
        
        //绘制x,y轴提示语
        drawXYTipText()
       
        //绘制柱状图
        for i in 0..<valueArr.count{
          let arr = valueArr[i]
            for j in 0..<arr.count{
               //每个柱状图的高
                let columnHeight = arr[j] / maxHeight * (originY - spaceY)
                let x = CGFloat((i * arr.count + j)) * columnWidth
                let columnX =  x + CGFloat(i + 1) * columnSpace + chartOrigin.x
                let columnFrame = CGRect(x:columnX, y:originY - columnHeight, width:columnWidth, height:0)
                let columnItem = UIView.init()
                self.layer.addSublayer(columnItem.layer)
                layerArr.append(columnItem.layer)
                columnItem.frame = columnFrame
                columnItem.backgroundColor = columnBgColorArr.count != arr.count ? UIColor.blue:columnBgColorArr[j]
                weak var weakSelf = self
                UIView.animate(withDuration: 1.5, animations: { 
                    columnItem.frame = CGRect(x:columnX, y:self.originY - columnHeight, width:self.columnWidth, height:columnHeight)
                }, completion: { (isFinsh:Bool) in
                   let textLayer = weakSelf?.drawText(text:"\(arr[j])", textColor:(weakSelf?.columnBgColorArr.count)! != arr.count ? UIColor.blue:(weakSelf?.columnBgColorArr[j])!, textFont:(weakSelf?.textFont)!, backGroundColor: UIColor.white)
                    textLayer?.alignmentMode = "center"
                   textLayer?.frame = CGRect(x:columnFrame.origin.x, y:columnFrame.origin.y, width:(weakSelf?.columnWidth)!, height:20*ScaleH)
                    weakSelf?.layer.addSublayer(textLayer!)
                    weakSelf?.layerArr.append(textLayer!)
                    
                })
               
            }
        }
    }
    
    
    //画XY轴
    func drawXY() {
        //箭头相对轴线顶端偏移距离
        let arrowMoveY:CGFloat = 8
        
        //箭头相对轴线横向偏移距离
        let arrowMoveX:CGFloat = 5
        
        let chartMaxX:CGFloat = self.frame.width - 10
        
        //绘制X,Y轴
        let shapLayer = CAShapeLayer.init()
        layerArr.append(shapLayer)
        
        let bezier = UIBezierPath.init()
        bezier.lineWidth = 0.5    //线的宽度
        
        //每个颜色柱状图表示意思
        for i in 0..<valueStrArr.count{
            let quert = draw(CGRect(x:Int(self.frame.width - 10), y:5 + 8 * i, width:8, height:8))
            let textLayer = drawText(text:valueStrArr[i], textColor:colorForXYLine, textFont:textFont, backGroundColor: UIColor.clear)
           // textLayer.frame = CGRect(x:, y:, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
            
        }
        
        //Y轴
        drawLine(bezier:bezier, startPoint: CGPoint(x:chartOrigin.x, y:originY), endPoint:CGPoint(x:chartOrigin.x, y:spaceY))
        
        //Y轴箭头
        drawLine(bezier:bezier, startPoint: CGPoint(x:chartOrigin.x, y:spaceY), endPoint: CGPoint(x:chartOrigin.x - arrowMoveX, y:spaceY + arrowMoveY))
        drawLine(bezier:bezier, startPoint: CGPoint(x:chartOrigin.x, y:spaceY), endPoint: CGPoint(x:chartOrigin.x + arrowMoveX, y:spaceY + arrowMoveY))
        
        //x轴
        drawLine(bezier:bezier, startPoint: CGPoint(x:chartOrigin.x, y:originY), endPoint: CGPoint(x:chartMaxX, y: originY))
        
        //x轴箭头
        drawLine(bezier:bezier, startPoint: CGPoint(x:chartMaxX, y:originY), endPoint: CGPoint(x:chartMaxX - arrowMoveY, y:originY - arrowMoveX))
        drawLine(bezier:bezier, startPoint: CGPoint(x:chartMaxX, y:originY), endPoint:  CGPoint(x:chartMaxX - arrowMoveY, y:originY + arrowMoveX))
        
        //为绘画图层添加动画
        shapLayer.path = bezier.cgPath
        shapLayer.strokeColor = colorForXYLine.cgColor
        let basic = getBasicAnimation(keyPath:KeyPathStr, duartion:1.5)
        shapLayer.add(basic, forKey:nil)
        self.layer.addSublayer(shapLayer)
        
        //Y轴添加单位
        let unitLayer = drawText(text:YUnitStr, textColor:textColorForXY, textFont:textFont, backGroundColor: UIColor.clear)
        unitLayer.frame = CGRect(x:3, y:0, width:chartOrigin.x*2 - 6, height:15*ScaleH)
        self.layer.addSublayer(unitLayer)
        self.layerArr.append(unitLayer)
    }
    
    
    //绘制x,y轴提示语
    func drawXYTipText(){
        //绘制x轴提示语
        if xShowInfoText.count == valueArr.count && xShowInfoText.count > 0 {
            let arr = valueArr[0]
            let count = arr.count
            for i in 0..<valueArr.count{
                let textWidth = CGFloat(count) * columnWidth + columnWidth
                let textLayer = drawText(text:xShowInfoText[i] as! String, textColor:textColorForXY, textFont:textFont, backGroundColor:UIColor.clear)
                
                textLayer.frame = CGRect(x:CGFloat(i) * (CGFloat(count) * columnWidth + columnSpace) + columnWidth + chartOrigin.x, y:originY + 5, width:textWidth, height:20*ScaleH)
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
    
    
    //获取Y轴最大刻度
    func getMaxHeight() {
        var max:CGFloat = 0
        for arr:Array<CGFloat> in valueArr{
            for number in arr {
                if number > max {
                    max = number
                }
            }
        }
        
        if max < 5.0 {
           maxHeight = 5.0
        }else if max < 10.0{
           maxHeight = 10.0
        }else{
           maxHeight = max
        }
    }
}
