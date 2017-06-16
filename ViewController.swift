//
//  ViewController.swift
//  LLChart
//
//  Created by apple on 2017/6/13.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let columnChart = LLColumnChart.init(frame: CGRect(x:0, y:64, width:self.view.frame.width, height:400))
//        columnChart.valueArr = [[168,100,224,356,290],[151,97,240,329,289]]
//            //[[100,97],[224,310],[245,329]]
//        columnChart.chartColorArr = [UIColor.green,UIColor.red]
//        columnChart.chartOrigin = CGPoint(x:40, y:30)
//        columnChart.xShowInfoText = ["8月","9月","10月","11月","12月"]
//        columnChart.YUnitStr = "单位(m³)"
//        columnChart.valueStrArr = ["上一年","本年"]
//        columnChart.isShowInfoView = true
//        columnChart.showAnimation()
//        self.view.addSubview(columnChart)

        let lineChart = LLLineChart.init(frame: CGRect(x:0, y:64, width:kScreenW, height:400))
        lineChart.valueArr = [[168,100,224,356,290],[151,50,280,269,249]]
        lineChart.chartColorArr = [UIColor.green,UIColor.red]
        lineChart.pointColorArr = [UIColor.orange,UIColor.blue]
        lineChart.chartOrigin = CGPoint(x:40, y:30)
        lineChart.xShowInfoText = ["8月","9月","10月","11月","12月"]
        lineChart.YUnitStr = "单位(m³)"
        lineChart.valueStrArr = ["上一年","本年"]
        lineChart.showAnimation()
        self.view.addSubview(lineChart)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }}

