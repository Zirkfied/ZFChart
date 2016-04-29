//
//  PieChartViewController.m
//  ZFChartView
//
//  Created by apple on 16/3/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PieChartViewController.h"
#import "ZFChart.h"

@interface PieChartViewController()<ZFPieChartDataSource>

@end

@implementation PieChartViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    ZFPieChart * pieChart = [[ZFPieChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    pieChart.dataSource = self;
//    pieChart.piePatternType = kPieChartPatternTypeForCircle;
//    pieChart.percentType = kPercentTypeInteger;
//    pieChart.isShadow = NO;
//    pieChart.isAnimated = NO;
    pieChart.isShowDetail = YES;
    pieChart.topic = @"xx小学各年级男女人数占比";
    [pieChart strokePath];
    [self.view addSubview:pieChart];
}

#pragma mark - ZFPieChartDataSource

- (NSArray *)valueArrayInPieChart:(ZFPieChart *)chart{
//    return @[@"200", @"256", @"300", @"283", @"490", @"236"];
    return @[@"200", @"256", @"300", @"283", @"490", @"236"];
}

- (NSArray *)nameArrayInPieChart:(ZFPieChart *)chart{
    return @[@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级"];
}

- (NSArray *)colorArrayInPieChart:(ZFPieChart *)chart{
    return @[ZFColor(71, 204, 255, 1), ZFColor(253, 203, 76, 1), ZFColor(214, 205, 153, 1), ZFColor(78, 250, 188, 1), ZFColor(16, 140, 39, 1), ZFColor(45, 92, 34, 1)];
}

@end
