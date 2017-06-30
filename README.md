# LLChart

柱状图的使用

let columnChart = LLColumnChart.init(frame: CGRect(x:0, y:64, width:self.view.frame.width, height:400))

columnChart.valueArr = [[168,100,224,356,290],[151,97,240,329,289]]  //数据源数组

columnChart.chartColorArr = [UIColor.green,UIColor.red]   //柱状图颜色

columnChart.chartOrigin = CGPoint(x:40, y:30)             //图标起始点

columnChart.xShowInfoText = ["8月","9月","10月","11月","12月"] //x轴表示含义

columnChart.YUnitStr = "单位(m³)"                             //y轴单位  

columnChart.valueStrArr = ["上一年","本年"]               //不同颜色柱状图表示的含义  

columnChart.showAnimation()

self.view.addSubview(columnChart)


