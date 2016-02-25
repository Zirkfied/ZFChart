# ZFChart
A simple chart library for iOS , contains barChart, lineChart, pieChart. Thanks for your star if you like.

模仿PNChart写的一个图表库，用法简单，暂时有柱状图，线状图，饼图三种类型，后续可能会更新新的类型，喜欢的欢迎star一个，有问题可以加QQ群交流：451169423

## BarChart(柱状图)

![](https://github.com/Zirkfied/Library/blob/master/bar.png)

        ZFBarChart * barChart = [[ZFBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];  
        barChart.title = @"xx小学各年级人数占比";  
        barChart.xLineValueArray = [NSMutableArray arrayWithObjects:@"280", @"255", @"308", @"273", @"236", @"267", nil];  
        barChart.xLineTitleArray = [NSMutableArray arrayWithObjects:@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级", nil];
        barChart.yLineMaxValue = 500;
        barChart.yLineSectionCount = 10;
        [self.view addSubview:barChart];
        [barChart strokePath];
        
## LineChart(线状图)

![](https://github.com/Zirkfied/Library/blob/master/line.png)

        ZFLineChart * lineChart = [[ZFLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        lineChart.title = @"xx小学各年级人数占比";
        lineChart.xLineValueArray = [NSMutableArray arrayWithObjects:@"280", @"255", @"308", @"273", @"236", @"267", nil];
        lineChart.xLineTitleArray = [NSMutableArray arrayWithObjects:@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级", nil];
        lineChart.yLineMaxValue = 500;
        lineChart.yLineSectionCount = 10;
        [self.view addSubview:lineChart];
        [lineChart strokePath];
        
## PieChart(饼图)

![](https://github.com/Zirkfied/Library/blob/master/pie.png)

        ZFPieChart * pieChart = [[ZFPieChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        pieChart.title = @"xx小学各年级人数占比";
        pieChart.valueArray = [NSMutableArray arrayWithObjects:@"280", @"255", @"308", @"273", @"236", @"267", nil];
        pieChart.nameArray = [NSMutableArray arrayWithObjects:@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级", nil];
        pieChart.colorArray = [NSMutableArray arrayWithObjects:ZFRandomColor, ZFRandomColor, ZFRandomColor, ZFRandomColor, ZFRandomColor, ZFRandomColor, nil];
        [self.view addSubview:pieChart];
        [pieChart strokePath];

