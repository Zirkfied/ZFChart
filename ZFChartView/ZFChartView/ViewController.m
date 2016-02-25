//
//  ViewController.m
//  ZFChartView
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "ZFChartView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZFWhite;
    
    switch (self.chartType) {
        case 0:
            [self showBarChart];
            break;
            
        case 1:
            [self showLineChart];
            break;
            
        case 2:
            [self showPieChart];
            break;
    }
}

- (void)showBarChart{
    ZFBarChart * barChart = [[ZFBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    barChart.title = @"xx小学各年级人数占比";
    barChart.xLineValueArray = [NSMutableArray arrayWithObjects:@"280", @"255", @"308", @"273", @"236", @"267", nil];
    barChart.xLineTitleArray = [NSMutableArray arrayWithObjects:@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级", nil];
    barChart.yLineMaxValue = 500;
    barChart.yLineSectionCount = 10;
    [self.view addSubview:barChart];
    [barChart strokePath];
}

- (void)showLineChart{
    ZFLineChart * lineChart = [[ZFLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    lineChart.title = @"xx小学各年级人数占比";
    lineChart.xLineValueArray = [NSMutableArray arrayWithObjects:@"280", @"255", @"308", @"273", @"236", @"267", nil];
    lineChart.xLineTitleArray = [NSMutableArray arrayWithObjects:@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级", nil];
    lineChart.yLineMaxValue = 500;
    lineChart.yLineSectionCount = 10;
    [self.view addSubview:lineChart];
    [lineChart strokePath];
}

- (void)showPieChart{
    ZFPieChart * pieChart = [[ZFPieChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    pieChart.title = @"xx小学各年级人数占比";
    pieChart.valueArray = [NSMutableArray arrayWithObjects:@"280", @"255", @"308", @"273", @"236", @"267", nil];
    pieChart.nameArray = [NSMutableArray arrayWithObjects:@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级", nil];
    pieChart.colorArray = [NSMutableArray arrayWithObjects:ZFColor(71, 204, 255, 1), ZFColor(253, 203, 76, 1), ZFColor(214, 205, 153, 1), ZFColor(78, 250, 188, 1), ZFColor(16, 140, 39, 1), ZFColor(45, 92, 34, 1), nil];
    [self.view addSubview:pieChart];
    [pieChart strokePath];
}

@end
