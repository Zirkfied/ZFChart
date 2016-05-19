//
//  PieChartViewController.m
//  ZFChartView
//
//  Created by apple on 16/3/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PieChartViewController.h"

#import "ZFChart.h"

@interface PieChartViewController()
{
    ZFPieChart *pieChart;
}

@end

@implementation PieChartViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    pieChart = [[ZFPieChart alloc] initWithFrame:CGRectMake(0, 80 ,410, 180)];
    pieChart.backgroundColor = [UIColor colorWithWhite:0.97 alpha:0.9];
    pieChart.lineWidth = 20.0;
    // pieChart.allMoneyLabel.text = @"总资产(元):502.10";
    pieChart.isShowPercent = NO; //不现实百分比
    pieChart.valueArray = [NSMutableArray arrayWithObjects:@12, @23, @44, @88, nil ];//金额 调用setter方法
    pieChart.nameArray = [NSMutableArray arrayWithObjects:@"名字1", @"名字2",@"名字3",@"名字4",nil];
    pieChart.colorArray = [NSMutableArray arrayWithObjects:[UIColor yellowColor],  [UIColor redColor],[UIColor greenColor], [UIColor purpleColor], nil];// 颜色
    [self.view addSubview:pieChart];
    //绘制
    [pieChart strokePath];
}

#pragma mark - ZFPieChartDataSource

//- (NSArray *)valueArrayInPieChart:(ZFPieChart *)chart{
//    return @[@"200", @"256", @"300", @"283", @"490", @"236"];
//}
//
//- (NSArray *)nameArrayInPieChart:(ZFPieChart *)chart{
//    return @[@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级"];
//}
//
//- (NSArray *)colorArrayInPieChart:(ZFPieChart *)chart{
//    return @[ZFColor(71, 204, 255, 1), ZFColor(253, 203, 76, 1), ZFColor(214, 205, 153, 1), ZFColor(78, 250, 188, 1), ZFColor(16, 140, 39, 1), ZFColor(45, 92, 34, 1)];
//}

@end
