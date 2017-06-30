//
//  LLPieChart.swift
//  LLChart
//
//  Created by apple on 2017/6/19.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit
//饼图
class LLPieChart: LLChart {
    //饼图数据数组
    var dataArr:Array<CGFloat>  = []
    //百分比数组
    var percentArr:Array<CGFloat> = []
    //扇形颜色数组  不设置默认为随机颜色
    var shapeColorArr:Array<UIColor> = []
    //每个扇形代表的含义数组
    var pieShowStrArr:Array<String> = []
    //角度数组
    private var angleArr:Array<CGFloat> = []
    override init(frame: CGRect) {
        super.init(frame:frame)
       //self.backgroundColor = UIColor.lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func showAnimation() {
        self.layer.sublayers?.removeAll()
        super.showAnimation()
        self.setNeedsDisplay()
        self.backgroundColor = UIColor.white
        congfigDataSource()
        
        //半径
        let radius = (self.frame.size.width - 100*ScaleW) / 4

        //圆的中心
        let center =  CGPoint(x:50*ScaleW + radius*2, y:(kScreenH - radius * 4)/2)
        
        //开始角度
        var startAngle:CGFloat = 0
        
        //结束角度
        var endAngle:CGFloat = -CGFloat(Double.pi / 2)
        
        
        
        //画饼图
        for i in 0..<percentArr.count{
            //CACAShapeLayer有着几点很重要:
            //1.它依附于一个给定的path,必须给与path,而且,即使path不完整也会自动首尾相接
            //2.strokerStart以及strokeEnd代表着在这个path中所占用的百分比
            //3.CAShapeLayer动画仅仅限于沿着边缘的动画效果,实现不了填充效果
            startAngle = endAngle
            angleArr.append(startAngle)
            endAngle = startAngle + percentArr[i] * CGFloat(Double.pi) * 2
            let path = UIBezierPath.init()
            path.addArc(withCenter:center, radius:radius, startAngle:startAngle, endAngle:endAngle, clockwise:true)
            
            //每个layer是整圆的一部分
            let shapLayer = CAShapeLayer.init()
            shapLayer.lineWidth = radius * 2
            shapLayer.path = path.cgPath
            shapLayer.strokeColor = shapeColorArr.count == percentArr.count ? shapeColorArr[i].cgColor:randomColor().cgColor
            shapeColorArr.append(UIColor.init(cgColor:shapLayer.strokeColor!))
            shapLayer.strokeStart = 0
            shapLayer.strokeEnd = 1
            shapLayer.fillColor = UIColor.clear.cgColor
            path.close()
            self.layer.addSublayer(shapLayer)
            self.layerArr.append(shapLayer)
 
            let perStr = String.init(format:"%.2f",percentArr[i] * 100)
            let textLayer = drawText(text:perStr + "%", textColor: UIColor.black, textFont:12*ScaleW, backGroundColor:UIColor.white)
            
            //计算角度
            let a = startAngle + (endAngle - startAngle) / 2  + CGFloat(Double.pi / 2)
            let x = radius * sin(a)
            let y = radius * cos(a)
            textLayer.frame = CGRect(x:center.x + x - 25 , y:center.y - y , width:50, height:20)
            self.layer.addSublayer(textLayer)
           
            let basic = CABasicAnimation.init(keyPath:"strokeEnd")
            basic.duration = 1.1
            basic.fromValue = 0
            basic.toValue = 1
            basic.isRemovedOnCompletion = true
            shapLayer.add(basic, forKey:"basic")
            print(shapLayer.frame)
        }
        angleArr.append(CGFloat(Double.pi / 2 * 3))
        
        //添加手势
        let tapGes = UITapGestureRecognizer.init(target:self, action: #selector(shapeLayerTapAction(ges:)))
        self.addGestureRecognizer(tapGes)
    }
    
    //绘制底部文字
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        //半径
        let radius = (self.frame.size.width - 180*ScaleW) / 4
        
        //圆的中心
        let center =  CGPoint(x:(kScreenW-160*ScaleW)/2, y:(kScreenH - radius * 2)/2)

        if pieShowStrArr.count == percentArr.count{
            for i in 0..<pieShowStrArr.count{
               let qurt = CGRect(x:center.x - radius * 2 + 50*ScaleW, y:center.y + radius * 2 + CGFloat(30*i), width:10, height:10)
               let textRt = CGRect(x:qurt.maxX + 10, y:qurt.origin.y, width:kScreenW - qurt.maxX - 10, height:20)
               drawQuart(context:context!, color:shapeColorArr[i], rt:qurt)
                
                let desText = pieShowStrArr[i] + "\(dataArr[i])" + "m³"
                let perStr = String.init(format:"%.2f",percentArr[i] * 100)
               drawText(context:context!, text:desText + "  " + "占比:\(perStr)%" , rt:textRt, textColor:shapeColorArr[i], textFont:12*ScaleW)
            }
        }
    }
    
    func shapeLayerTapAction(ges:UITapGestureRecognizer) {
        let loc = ges.location(in: self)
        for i in 0..<layerArr.count{
           let shapeLayer = layerArr[i]
            print(shapeLayer.contains(loc))
        }
    }
    
    func congfigDataSource() {
        var sum:CGFloat = 0
        for num in dataArr{
           sum = sum + num
        }
        
        for num in dataArr{
           let per = num / sum
            percentArr.append(per)
        }
    }
}
