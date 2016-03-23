//
//  SingleBarChartViewController.m
//  ZFChartView
//
//  Created by apple on 16/3/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SingleBarChartViewController.h"
#import "ZFChart.h"

@interface SingleBarChartViewController ()<ZFGenericChartDataSource, ZFBarChartDelegate>

@end

@implementation SingleBarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZFBarChart * barChart = [[ZFBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    barChart.dataSource = self;
    barChart.delegate = self;
    barChart.topic = @"xx小学各年级人数";
    barChart.unit = @"人";
    barChart.topicColor = ZFPurple;
//    lineChart.backgroundColor = ZFGreen;
    [self.view addSubview:barChart];
    [barChart strokePath];
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"123", @"256", @"300", @"283", @"490", @"236"];
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级"];
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[ZFSkyBlue];
}

- (CGFloat)yLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return 500;
}

- (NSInteger)yLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 10;
}

#pragma mark - ZFBarChartDelegate

//- (CGFloat)barWidthInBarChart:(ZFBarChart *)barChart{
//    return 40.f;
//}
//
//- (CGFloat)paddingForGroupsInBarChart:(ZFBarChart *)barChart{
//    return 40.f;
//}
//
//- (id)valueTextColorArrayInChart:(ZFGenericChart *)chart{
//    return ZFBlue;
//}

@end
