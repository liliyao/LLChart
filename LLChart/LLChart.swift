//
//  LLChart.swift
//  LLChart
//
//  Created by apple on 2017/6/13.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit


class LLChart: UIScrollView {
    //图表视图与view的边界值
    var contenInset:UIEdgeInsets = UIEdgeInsets(top:0, left:0, bottom:0, right:0)
    //原点
    var chartOrigin:CGPoint = CGPoint(x:0, y:0)
    //表名
    var chartTitle:String = ""
    
    var layerArr:Array<CALayer> = []
    
    ///  数据源数组 样式参考demo  必须设置
    var valueArr:Array<Array<CGFloat>> = []    //[[1,2,3],[4,5,6]]
    
    /// 每种柱状图的背景颜色 设置必须保证数量和数据源数组的类型的个数相同 否则默认为蓝色
    var chartColorArr:Array<UIColor> = []

    
    // 每种颜色柱状图表示的意思   默认未设置
    var valueStrArr:Array<String> = []
    
    //每项图标的X轴分类显示语
    var xShowInfoText:Array<Any> = []

    //x,Y轴颜色  默认为灰色
    var colorForXYLine:UIColor = UIColor.gray
    
    //Y轴单位
    var YUnitStr:String = ""
    
    //x,Y轴字体颜色   默认黑色
    var textColorForXY:UIColor = UIColor.black
    
    //图表起点距原点水平距离  默认15
    var drawFromOriginX:CGFloat = 15
    
    //视图背景颜色
    var bgViewBackgroundColor:UIColor = UIColor.white
    
    //是否展示弹出视图   默认为不显示
    var isShowInfoView:Bool = false
    
    //Y轴刻度个数  默认为5个
    var markNum:Int = 5
    
    //Y轴最大数
    var maxHeight:CGFloat =  0
    
   let KeyPathStr:String = "strokeEnd"
    
    let textFont:CGFloat = 12 * ScaleH
    
    //整个图往下30
     let spaceY:CGFloat = 30
    
    //y轴终点
    var originY:CGFloat  = 0
    
    var contSize:CGSize?
    
    //动画开始
    func showAnimation(){
        clear()
        self.contSize = CGSize(width:self.frame.size.width, height:self.frame.size.height)
        self.showsHorizontalScrollIndicator = false
    }
    
    
    //清楚当前视图
    func clear(){
        for layer:CALayer in layerArr{
          layer.removeAllAnimations()
          layer.removeFromSuperlayer()
        }
    }
    
    //画XY轴
    func drawXY() {
        //箭头相对轴线顶端偏移距离
        let arrowMoveY:CGFloat = 8
        
        //箭头相对轴线横向偏移距离
        let arrowMoveX:CGFloat = 5
        
        let chartMaxX:CGFloat = contSize!.width - 10
        
        //绘制X,Y轴
        let shapLayer = CAShapeLayer.init()
        layerArr.append(shapLayer)
        
        let bezier = UIBezierPath.init()
        bezier.lineWidth = 0.5    //线的宽度
        
        //每个颜色图表示意思
        for i in 0..<valueStrArr.count{
            let quertFrame = CGRect(x:Int(self.frame.width - 10 - 8), y:5 + 17 * i, width:12, height:12)
            let quertLayer = CAShapeLayer.init()
            quertLayer.frame = quertFrame
            quertLayer.backgroundColor = chartColorArr.count != valueArr.count ? UIColor.blue.cgColor:chartColorArr[i].cgColor
            self.layer.addSublayer(quertLayer)
            layerArr.append(quertLayer)
            
            
            let textLayer = drawText(text:valueStrArr[i], textColor:colorForXYLine, textFont:textFont, backGroundColor: UIColor.clear)
            textLayer.frame = CGRect(x:quertFrame.origin.x-5-100*ScaleW, y:quertFrame.origin.y, width:100*ScaleH, height:15*ScaleH)
            textLayer.alignmentMode = "right"
            layerArr.append(textLayer)
            self.layer.addSublayer(textLayer)
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
        unitLayer.frame = CGRect(x:5, y:0, width:chartOrigin.x*2 - 10, height:15*ScaleH)
        unitLayer.alignmentMode = "center"
        self.layer.addSublayer(unitLayer)
        self.layerArr.append(unitLayer)
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







