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
        let columnChart = LLColumnChart.init(frame: CGRect(x:0, y:64, width:self.view.frame.width, height:400))
        columnChart.valueArr = [[100,97],[224,310],[245,329]]
        columnChart.columnBgColorArr = [UIColor.green,UIColor.red]
        columnChart.chartOrigin = CGPoint(x:30, y:30)
        columnChart.xShowInfoText = ["9月","10月","11月"]
        columnChart.YUnitStr = "单位(m³)"
        columnChart.valueStrArr = ["上一年","本年"]
        columnChart.showAnimation()
        self.view.addSubview(columnChart)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

