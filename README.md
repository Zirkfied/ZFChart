# ZFChart
A simple chart library for iOS , contains barChart, lineChart, pieChart, waveChart, radarChart, cirqueChart. Thanks for your star if you like.

模仿PNChart，Charts写的一个图表库，用法简单，暂时有柱状图，线状图，饼图，波浪图，雷达图，圆环图等类型，带动画效果，后续可能会更新新的类型，喜欢的欢迎star一个，有任何建议或问题可以加QQ群交流：451169423

###用法:
        第一步(step 1)
        将项目里ZFChart整个文件夹拖进新项目
        
        第二步(step 2)
        #import "ZFChart.h"
        
        第三步(step 3)
        
        
###     ZFGenericChartDataSource数据源方法
####    @required 必须实现的方法
        //返回value数据
        //当只有1组数据时，NSArray存储 @[@"1", @"2", @"3", @"4"]
          当有多组数据时，NSArray存储 @[@[@"123", @"300", @"490", @"380", @"167", @"235"], @[@"256", @"283", @"236", @"240", @"183", @"200"], @[@"256", @"256", @"256", @"256", @"256", @"256"]] 
        //barChart: 代表有6组，每组有3个item
        //lineChart: 代表有6组，每组有3个item（另一种理解就是有3条线，每条线上有6个点）
        
        - (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart;
        
####     @optional 可选实现的方法
        //返回名称数组(NSArray必须存储NSString类型)
        
        - (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
                return @[@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级"];
        }
        
        
        //返回颜色数组(NSArray必须存储UIColor类型, 若不设置，默认随机) 
        //barChart: 若每组有3个item,则返回3个颜色
        //lineChart：若有3条线，则返回3个颜色
        
        - (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
                return @[ZFSkyBlue, ZFOrange, ZFMagenta];
        }
        
        
        //y轴(普通图表) 或 x轴(横向图表) 数值显示的最大值(若不设置，默认返回数据源最大值)
        
        - (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart;
        
        //y轴(普通图表) 或 x轴(横向图表) 数值显示的最小值(若不设置，默认返回数据源最小值)
        //(PS:当 isResetAxisLineMinValue 为NO时，此方法无效)(When isResetAxisLineMinValue is NO, the method is invalid)
        
        - (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart;
        
        
        //y轴(普通图表) 或 x轴(横向图表) 数值显示的段数(若不设置,默认5段)
        
        - (NSInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart;
        
        
## BarChart(柱状图)
        须遵循ZFGenericChartDataSource数据源协议

        ZFBarChart * barChart = [[ZFBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
        barChart.dataSource = self;
        barChart.delegate = self;
        barChart.topicLabel.text = @"xx小学各年级人数";
        barChart.unit = @"人";
        [self.view addSubview:barChart];
        [barChart strokePath];
        
        
###     ZFBarChartDelegate协议方法
####    @optional 可选实现的方法
        //x轴value文本颜色数组(若不设置，则全部返回黑色)
        //返回UIColor或者NSArray(NSArray里必须存储UIColor类型)
        
        - (id)valueTextColorArrayInChart:(ZFGenericChart *)chart;


        //bar宽度(若不设置，默认为25.f)
        
        - (CGFloat)barWidthInBarChart:(ZFBarChart *)barChart;
        
        
        //组与组之间的间距(若不设置,默认为20.f)
        
        - (CGFloat)paddingForGroupsInBarChart:(ZFBarChart *)barChart;
        
        
        //每组里面，bar与bar之间的间距(若不设置，默认为5.f)(当只有一组数据时，此方法无效)
        
        - (CGFloat)paddingForBarInBarChart:(ZFBarChart *)barChart;
        
        
####效果展示

![](https://github.com/Zirkfied/Library/blob/master/bar1.png)
        
        - (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
                return @[@"123", @"256", @"300", @"283", @"490", @"236"];
        }

![](https://github.com/Zirkfied/Library/blob/master/bar4.png)
        
        - (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
                NSArray * array1 = @[@"123", @"300", @"490", @"380", @"167", @"235"];
                NSArray * array2 = @[@"256", @"283", @"236", @"240", @"183", @"200"];
                NSArray * array3 = @[@"256", @"256", @"256", @"256", @"256", @"256"];
    
                return @[array1, array2, array3];
        }
        
![](https://github.com/Zirkfied/Library/blob/master/bar2.png)
        
        //当只有一组数据时，必须返回UIColor
        - (id)valueTextColorArrayInChart:(ZFGenericChart *)chart{
                return ZFBlue;
        }
        
![](https://github.com/Zirkfied/Library/blob/master/bar4.png)

        //当有多组数据时，若返回UIColor，则所有value颜色一致
        - (id)valueTextColorArrayInChart:(ZFGenericChart *)chart{
                return ZFBlue;
        }
        
![](https://github.com/Zirkfied/Library/blob/master/bar3.png)

        //当有多组数据时，若返回NSarray，效果如上
        - (id)valueTextColorArrayInChart:(ZFGenericChart *)chart{
                return @[ZFColor(71, 204, 255, 1), ZFColor(253, 203, 76, 1), ZFColor(16, 140, 39, 1)];
        }
        
        
        
## LineChart(线状图)
        须遵循ZFGenericChartDataSource数据源协议
        
        ZFLineChart * lineChart = [[ZFLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
        lineChart.dataSource = self;
        lineChart.delegate = self;
        lineChart.topicLabel.text = @"xx小学各年级男女人数";
        lineChart.unit = @"人";
        [self.view addSubview:lineChart];
        [lineChart strokePath];
        
###     ZFLineChartDelegate协议方法
####    @optional 可选实现的方法
        //组宽(若不设置，默认为25.f)
        
        - (CGFloat)groupWidthInLineChart:(ZFLineChart *)lineChart;
        
        
        //组与组之间的间距(若不设置，默认为20.f)
        
        - (CGFloat)paddingForGroupsInLineChart:(ZFLineChart *)lineChart
        
        
        //圆的半径(若不设置，默认为5.f)
        
        - (CGFloat)circleRadiusInLineChart:(ZFLineChart *)lineChart;
        
        
        线宽(若不设置，默认为2.f)
        
        - (CGFloat)lineWidthInLineChart:(ZFLineChart *)lineChart;


####效果展示

![](https://github.com/Zirkfied/Library/blob/master/line1.png)

        - (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
                return @[@"123", @"256", @"300", @"283", @"490", @"236"];
        }
        
![](https://github.com/Zirkfied/Library/blob/master/line2.png)

        - (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
                NSArray * array1 = @[@"123", @"300", @"490", @"380", @"167", @"451"];
                NSArray * array2 = @[@"380", @"200", @"326", @"240", @"50", @"137"];
                NSArray * array3 = @[@"256", @"300", @"89", @"430", @"256", @"256"];
    
                return @[array1, array2, array3];
        }
        
## PieChart(饼图)
        须遵循ZFPieChartDataSource，ZFPieChartDelegate协议

        ZFPieChart * pieChart = [[ZFPieChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
        pieChart.dataSource = self;
        pieChart.delegate = self;
        [self.view addSubview:pieChart];
        [pieChart strokePath];
        
###     ZFPieChartDataSource数据源方法
####    @required 必须实现的方法
        //返回value数据(NSArray必须存储NSString类型)
        
        - (NSArray *)valueArrayInPieChart:(ZFPieChart *)chart;
        
        
        //返回颜色数组(NSArray必须存储UIColor类型)
        
        - (NSArray *)colorArrayInPieChart:(ZFPieChart *)chart;
        
###     ZFPieChartDelegate代理方法
####    @required 必须实现的方法
        //设置饼图的半径
        
        - (CGFloat)radiusForPieChart:(ZFPieChart *)pieChart;

####    @optional 可选实现的方法
        /**
          *  当饼图类型为圆环类型时，可通过此方法把半径平均分成n段，圆环的线宽为n分之1，间接计算圆环线宽，简单理解就是调整圆环线宽的粗细
          *  (若不设置，默认平均分2段)
          *  (e.g. 当radius为150，把半径平均分成4段，则圆环的线宽为150 * (1 / 4), 即37.5)，如下图所示
          *
          *  (PS:此方法对 整圆(kPieChartPatternTypeForCircle)类型 无效)
          *
          *  @return 设置半径平均段数(可以为小数, 返回的值必须大于1，当<=1时则自动返回默认值)
          */
        
        - (CGFloat)radiusAverageNumberOfSegments:(ZFPieChart *)pieChart;
        
![](https://github.com/Zirkfied/Library/blob/master/pie4.png)
        
        
####效果展示

![](https://github.com/Zirkfied/Library/blob/master/pie1.png)

![](https://github.com/Zirkfied/Library/blob/master/pie2.png)
        
###饼图其余属性
        
![](https://github.com/Zirkfied/Library/blob/master/pie3.png)

        //当piePatternType设置为kPieChartPatternTypeForCircle时，则饼图为整圆，如上图所示
        pieChart.piePatternType = kPieChartPatternTypeForCircle;


        
## WaveChart(波浪图)
        须遵循ZFGenericChartDataSource数据源协议
        
        ZFWaveChart * waveChart = [[ZFWaveChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
        waveChart.dataSource = self;
        waveChart.delegate = self;
        waveChart.topicLabel.text = @"xx小学各年级人数";
        waveChart.unit = @"人";
        [self.view addSubview:waveChart];
        [waveChart strokePath];
        
###     ZFWaveChartDelegate协议方法
####    @optional 可选实现的方法
        //组宽(若不设置，默认为25.f)
        
        - (CGFloat)groupWidthInWaveChart:(ZFWaveChart *)waveChart;
        
        
        //组与组之间的间距(若不设置，默认为20.f)
        
        - (CGFloat)paddingForGroupsInWaveChart:(ZFWaveChart *)waveChart;


        //path颜色(若不设置，默认为ZFSkyBlue)
        
        - (UIColor *)pathColorInWaveChart:(ZFWaveChart *)waveChart;
        
        
####效果展示

![](https://github.com/Zirkfied/Library/blob/master/wave2.png)
        
        //波浪图只支持显示1组数据，NSArray里只能存NSString类型
        - (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
                return @[@"123", @"256", @"300", @"283", @"490", @"236"];
        }

![](https://github.com/Zirkfied/Library/blob/master/wave1.png)
        
        //设置波浪样式，默认为(kWavePatternTypeForCurve)
        waveChart.wavePatternType = kWavePatternTypeForSharp
        
        
        
## HorizontalBarChart(横向柱状图)
        须遵循ZFGenericChartDataSource数据源协议
        delegate是ZFHorizontalBarChartDelegate

        ZFHorizontalBarChart * barChart = [[ZFHorizontalBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
        barChart.dataSource = self;
        barChart.delegate = self;
        barChart.topicLabel.text = @"xx小学各年级人数";
        barChart.unit = @"人";
        [self.view addSubview:barChart];
        [barChart strokePath];


####效果展示

![image](https://github.com/Zirkfied/Library/blob/master/HorizontalBarChart.gif)



## RadarChart(雷达图)
        须遵循ZFRadarChartDataSource，ZFRadarChartDelegate协议
        
        ZFRadarChart * radarChart = [[ZFRadarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
        radarChart.dataSource = self;
        radarChart.delegate = self;
        [self.view addSubview:radarChart];
        [radarChart strokePath];

###     ZFRadarChartDataSource数据源方法
####    @required 必须实现的方法
        /**
         *  item数组(eg: 力量，智力，物防，法防，敏捷...)
         *
         *  PS:根据item数组的个数自动生成N边形
         *
         *  @return NSArray必须存储NSString类型
         */
        - (NSArray *)itemArrayInRadarChart:(ZFRadarChart *)radarChart;

        /**
         *  value数组
         *
         *  @return NSArray必须存储NSString类型
         */
        - (NSArray *)valueArrayInRadarChart:(ZFRadarChart *)radarChart;


###     ZFRadarChartDelegate协议方法
####    @required 必须实现的方法
        /**
         *  设置雷达图半径
         *
         *  @return 半径
         */
        - (CGFloat)radiusForRadarChart:(ZFRadarChart *)radarChart;
        
####    @optional 可选实现的方法
        /**
         *  设置雷达图半径延伸长度，用于计算item label的中心点位置(默认25.f)
         *
         *  @param itemIndex item下标(可根据item的字符长度自行调节item label的中心点位置)
         *
         *  @return 半径延伸长度
         */
        - (CGFloat)radiusExtendLengthForRadarChart:(ZFRadarChart *)radarChart itemIndex:(NSInteger)itemIndex;

        /**
         *  雷达图分段数值的角度位置(若不设置,默认为-90度(正上方))
         *
         *  @return 角度( 可调节范围 [-90, 270) )
         */
        - (CGFloat)valueRotationAngleForRadarChart:(ZFRadarChart *)radarChart;


####效果展示

![image](https://github.com/Zirkfied/Library/blob/master/RadarChart.gif)



## CirqueChart(圆环图)
        须遵循ZFCirqueChartDataSource，ZFCirqueChartDelegate协议
        
        ZFCirqueChart * cirqueChart = [[ZFCirqueChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
        cirqueChart.dataSource = self;
        cirqueChart.delegate = self;
        [self.view addSubview:cirqueChart];
        [cirqueChart strokePath];
        
       
####效果展示

![image](https://github.com/Zirkfied/Library/blob/master/ZFCirqueChart.gif)

####其余样式

![image](https://github.com/Zirkfied/Library/blob/master/kCirquePatternType.png)



###其余说明
####    
        1.  ZFGenericChartDataSource是柱状图(ZFBarChart, ZFHorizontalBarChart),线状图(ZFLineChart),波浪图(ZFWaveChart)的数据源方法
            ZFPieChartDataSource是饼图(ZFPieChart)的数据源方法
            根据自身使用的图表遵循对应的数据源
        
        2.  ZFBarChartDelegate是柱状图(ZFBarChart)的部分常量设置的协议方法
            ZFLineChartDelegate是线状图(ZFLineChart)的部分常量设置的协议方法
            ZFPieChartDelegate是饼图(ZFLineChart)的部分常量设置的协议方法
            ZFWaveChartDelegate是波浪图(ZFWaveChart)的部分常量设置的协议方法
            ZFHorizontalBarChartDelegate是柱状图(ZFHorizontalBarChart)的部分常量设置的协议方法
        
        3.  因再一次进行封装，柱状图(ZFBarChart, ZFHorizontalBarChart)，线状图(ZFLineChart)，波浪图(ZFWaveChart)均继承ZFGenericChart，故ZFGenericChartDataSource数据源方法 和 通用属性请查看 ZFGenericChart.h
            ZFBarChartDelegate协议方法 和 柱状图(ZFBarChart)专有属性 请查看 ZFBarChart.h
            ZFLineChartDelegate协议方法 和 线状图(ZFLineChart)专有属性 请查看 ZFLineChart.h
            ZFPieChartDataSource数据源方法 和 饼图(ZFPieChart)其余属性 请查看 ZFPieChart.h
            ZFWaveChartDelegate协议方法 和 波浪图(ZFWaveChart)专有属性 请查看 ZFWaveChart.h
            ZFHorizontalBarChartDelegate协议方法 和 横向柱状图(ZFHorizontalBarChart)专有属性 请查看 ZFHorizontalBarChart.h
        
        4.柱状图(ZFBarChart, ZFHorizontalBarChart),线状图(ZFLineChart),波浪图(ZFWaveChart)的valueLabel新增气泡样式，对应属性valueLabelPattern，现已默认为
          kPopoverLabelPatternPopover(气泡样式)，若要改回原样式，则设置为kPopoverLabelPatternBlank；
          
          eg:  barChart.valueLabelPattern = kPopoverLabelPatternBlank;
          
        5.关于自定义设置y轴最小值说明：
          /** 该属性是否重设y轴最小值，默认为NO(不设置，从0开始)，当设置为YES时，则有以下2种情况
              ①若同时实现代理方法中的 - (CGFloat)yLineMinValueInGenericChart:(ZFGenericChart *)chart，则y轴最小值为该方法的返回值
              ②若不实现①中的方法，则y轴最小值为数据源最小值
 
 
              Default is No (Start to O). When set to YES, then there are 2 kinds of situations:
              ①If at the same time to implement the method in ZFGenericChartDataSource:
               ||- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart||,
               then axisLineMinValue is the return value of the method.
              ②If not implemented the method in ①, then axisLineMinValue is the minimum value of the dataSource.
           */
           @property (nonatomic, assign) BOOL isResetAxisLineMinValue;
          
        6.每当更新数据后或更改属性设置，则需重新调用一次 - (void)strokePath 方法。
          网络获取数据后，才调用 - (void)strokePath 方法


###更新日志
        2016.02.25 初版发布
        
        2016.02.26 新增柱状图和线状图表上的数值显示
        
        2016.02.29 ①新增阴影效果
                   ②新增线状图Value位置选项
                   
        2016.03.23 ①添加柱状图,线状图多组数据显示
                   ②更改数据源传入模式，用法请参考UITableView
                   ③饼图新增整圆模式
                   若更新，请删除旧版本的文件
                   
        2016.03.30 ①新增波浪图表(ZFWaveChart)
                   ②柱状图(ZFBarChart),线状图(ZFLineChart),波浪图(ZFWaveChart)的valueLabel新增气泡样式，
                    请查看ZFPopoverLabel.h的kPopoverLabelPattern枚举类型
                   ③柱状图(ZFBarChart),线状图(ZFLineChart),波浪图(ZFWaveChart)新增坐标轴的分割线显示
                   ④优化线状图(LineChart)重绘时在真机上卡帧问题
                   ⑤修复其余Bug
                   
        2016.04.07 ①波浪图(ZFWaveChart)新增曲线样式
                   ②柱状图(ZFBarChart),线状图(ZFLineChart),波浪图(ZFWaveChart)新增事件点击代理，
                    点击bar,圆或popoverLaber进行后续操作，具体看Demo和对应的代理方法
                    
        2016.04.29 ①新增是否以动画展示
                   ②新增y轴最小值自定义设置，具体用法看上其余说明或看Demo说明
                   ③新增坐标轴自定义颜色设置
                   ④本次更新进行了进一步的封装，故柱状图(ZFBarChart),线状图(ZFLineChart),波浪图(ZFWaveChart)的通用属性设置
                    现已全部挪动到他们的父类ZFGenericChart.h，各自专有的属性依旧在他们自身.h文件
                    
        2016.06.02 ①新增横向柱状图(ZFHorizontalBarChart)
                   ②部分数据源方法名和属性名称进行了修改，替换时注意修改对应属性
                   
        2016.07.21 ①新增ZFPieChartDelegate协议方法，现可通过协议方法自定义饼图的半径和线宽
                   ②新增饼图(ZFPieChart)事件点击协议方法，可用于点击某个path进行后续操作
                   ③删除饼图(ZFPieChart)的ZFPieChartDataSource数据源方法的- (NSArray *)nameArrayInPieChart:(ZFPieChart *)pieChart
                   ④删除饼图(ZFPieChart)的isShowDetail（显示详情）的属性和控件，方便自定义排版
                   ⑤删除柱状图(ZFBarChart),线状图(ZFLineChart),波浪图(ZFWaveChart),新增横向柱状图(ZFHorizontalBarChart)的topic和topicColor属性，现已直接给出topicLabel控件，方便进行标题其余属性的更改
                   ⑥现已支持横竖屏适配
                   ⑦现已修复打印控制台的一堆警告
                   
        2016.10.07 ①新增雷达图(ZFRadarChart)
                   ②柱状图(ZFBarChart),线状图(ZFLineChart),波浪图(ZFWaveChart),横向柱状图(ZFHorizontalBarChart),雷达图(ZFRadarChart)新增isResetMaxValue属性
                   ③新增ZFLineChartDelegate协议方法: - (NSArray *)valuePositionInLineChart:(ZFLineChart *)lineChart,现可根据该方法独立设置每条线的value位置
                   ④柱状图(ZFBarChart),线状图(ZFLineChart),波浪图(ZFWaveChart),横向柱状图(ZFHorizontalBarChart),雷达图(ZFRadarChart)代理点击方法进行扩展，现可根据自身需求进行点击控件才显示value或对被点击的控件进行属性修改，具体代码查看Demo
                   ⑤现将所有字体大小属性从CGFloat类型转换成UIFont类型，比以往更方便对字体进行修改，减少源码的变动
                   ⑥新增部分属性设置，具体请自行探索（因为我自己都忘了-_-! ）
                   ⑦修复特殊情况下crash问题
                   ⑧部分属性名或方法名进行修改并优化部分bug
                   
        2016.10.27 ①新增圆环图(ZFCirqueChart)
                   ②ZFGenericChart.h新增isShowAxisArrows属性，现可隐藏坐标轴箭头
                   
        
##本人其他开源框架
####[ZFChart - 一款简单好用的图表库，目前有柱状，线状，饼图，波浪图类型](https://github.com/Zirkfied/ZFChart)
####[ZFScan - 仿微信 二维码/条形码 扫描](https://github.com/Zirkfied/ZFScan)
