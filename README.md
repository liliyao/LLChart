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

![Image text](https://github.com/liliyao/LLChart/raw/master/imageFolder/colum.png)

折线图

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

![Image text](https://github.com/liliyao/LLChart/raw/master/imageFolder/line.png)


饼图
let pieChart = LLPieChart.init(frame: CGRect(x:0, y:64, width:kScreenW, height:kScreenH))

pieChart.dataArr = [168,100,224,356,290]

pieChart.pieShowStrArr = ["1月用气量:","2月用气量:","3月用气量:","4月用气量:","5月用气量:"]

pieChart.showAnimation()

self.view.addSubview(pieChart)

![Image text](https://github.com/liliyao/LLChart/raw/master/imageFolder/pie.png)
