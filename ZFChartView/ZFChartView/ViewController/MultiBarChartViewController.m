//
//  MultiBarChartViewController.m
//  ZFChartView
//
//  Created by apple on 16/3/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MultiBarChartViewController.h"
#import "ZFChart.h"

@interface MultiBarChartViewController ()<ZFGenericChartDataSource, ZFBarChartDelegate>

@end

@implementation MultiBarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZFBarChart * barChart = [[ZFBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    barChart.dataSource = self;
    barChart.delegate = self;
    barChart.topic = @"xx小学各年级男女人数";
    barChart.unit = @"人";
    barChart.topicColor = ZFPurple;
//    barChart.isShadowForValueLabel = NO;
//    barChart.valueLabelPattern = kPopoverLabelPatternBlank;
//    barChart.isShowSeparate = YES;
    [self.view addSubview:barChart];
    [barChart strokePath];
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@[@"123", @"300", @"490", @"380", @"167", @"235"], @[@"256", @"283", @"236", @"240", @"183", @"200"], @[@"256", @"256", @"256", @"256", @"256", @"256"]];
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级"];
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[ZFColor(71, 204, 255, 1), ZFColor(253, 203, 76, 1), ZFColor(16, 140, 39, 1)];
}

- (CGFloat)yLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return 500;
}

- (NSInteger)yLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 10;
}

#pragma mark - ZFBarChartDelegate

//- (CGFloat)barWidthInBarChart:(ZFBarChart *)barChart{
//    return 25.f;
//}
//
//- (CGFloat)paddingForGroupsInBarChart:(ZFBarChart *)barChart{
//    return 20.f;
//}
//
//- (CGFloat)paddingForBarInBarChart:(ZFBarChart *)barChart{
//    return 5.f;
//}

- (id)valueTextColorArrayInChart:(ZFGenericChart *)chart{
    return ZFBlue;
    return @[ZFColor(71, 204, 255, 1), ZFColor(253, 203, 76, 1), ZFColor(16, 140, 39, 1)];
}

@end
