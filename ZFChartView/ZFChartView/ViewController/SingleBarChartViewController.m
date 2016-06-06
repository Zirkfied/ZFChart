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
//    barChart.isAnimated = NO;
//    barChart.isResetAxisLineMinValue = YES;
//    barChart.isShowAxisLineValue = NO;
//    barChart.valueLabelPattern = kPopoverLabelPatternBlank;
    barChart.isShowSeparate = YES;
//    barChart.topicColor = ZFWhite;
//    barChart.unitColor = ZFWhite;
//    barChart.axisColor = ZFWhite;
//    barChart.axisLineNameColor = ZFWhite;
//    barChart.axisLineValueColor = ZFWhite;
//    barChart.backgroundColor = ZFPurple;
    barChart.xLineNameLabelToXAxisLinePadding = -40.f;
    [self.view addSubview:barChart];
    [barChart strokePath];
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"123", @"256", @"300", @"283", @"490", @"236"];
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"一年级一年级一年级一年级一年级一年级一年级一年级一年级一年级一年级一年级一年级一年级一年级一年级一年级一年级一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级"];
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[ZFMagenta];
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return 500;
}

//- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart{
//    return 50;
//}

- (NSInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
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
//- (id)valueTextColorArrayInBarChart:(ZFGenericChart *)barChart{
//    return ZFBlue;
//}

- (void)barChart:(ZFBarChart *)barChart didSelectBarAtGroupIndex:(NSInteger)groupIndex barIndex:(NSInteger)barIndex{
    NSLog(@"第%ld组========第%ld个",(long)groupIndex,(long)barIndex);
}

- (void)barChart:(ZFBarChart *)barChart didSelectPopoverLabelAtGroupIndex:(NSInteger)groupIndex labelIndex:(NSInteger)labelIndex{
    NSLog(@"第%ld组========第%ld个",(long)groupIndex,(long)labelIndex);
}

@end
