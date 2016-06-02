//
//  MultiLineChartViewController.m
//  ZFChartView
//
//  Created by apple on 16/3/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MultiLineChartViewController.h"
#import "ZFChart.h"

@interface MultiLineChartViewController()<ZFGenericChartDataSource, ZFLineChartDelegate>

@end

@implementation MultiLineChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZFLineChart * lineChart = [[ZFLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    lineChart.dataSource = self;
    lineChart.delegate = self;
    lineChart.topic = @"xx小学各年级男女人数";
    lineChart.unit = @"人";
    lineChart.topicColor = ZFWhite;
    lineChart.isShowSeparate = YES;
//    lineChart.isAnimated = NO;
    lineChart.isResetAxisLineMinValue = YES;
//    lineChart.isShowAxisLineValue = NO;
//    lineChart.isShadowForValueLabel = NO;
    lineChart.isShadow = NO;
//    lineChart.valueLabelPattern = kPopoverLabelPatternBlank;
//    lineChart.valueCenterToCircleCenterPadding = 0;
//    lineChart.separateColor = ZFYellow;
    lineChart.unitColor = ZFWhite;
    lineChart.backgroundColor = ZFPurple;
    lineChart.axisColor = ZFWhite;
    lineChart.axisLineNameColor = ZFWhite;
    lineChart.axisLineValueColor = ZFWhite;
    lineChart.xLineNameLabelToXAxisLinePadding = 40;
    [self.view addSubview:lineChart];
    [lineChart strokePath];
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@[@"-52", @"300", @"490", @"380", @"167", @"451"], @[@"380", @"200", @"326", @"240", @"-258", @"137"], @[@"256", @"300", @"-89", @"430", @"256", @"256"]];
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级"];
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[ZFSkyBlue, ZFOrange, ZFMagenta];
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return 500;
}

//- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart{
//    return -150;
//}

- (NSInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 10;
}

#pragma mark - ZFLineChartDelegate

//- (CGFloat)groupWidthInLineChart:(ZFLineChart *)lineChart{
//    return 40.f;
//}
//
//- (CGFloat)paddingForGroupsInLineChart:(ZFLineChart *)lineChart{
//    return 30.f;
//}
//
//- (CGFloat)circleRadiusInLineChart:(ZFLineChart *)lineChart{
//    return 10.f;
//}
//
//- (CGFloat)lineWidthInLineChart:(ZFLineChart *)lineChart{
//    return 5.f;
//}

- (void)lineChart:(ZFLineChart *)lineChart didSelectCircleAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex{
    NSLog(@"第%ld条线========第%ld个",(long)lineIndex,(long)circleIndex);
}

- (void)lineChart:(ZFLineChart *)lineChart didSelectPopoverLabelAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex{
    NSLog(@"第%ld条线========第%ld个",(long)lineIndex,(long)circleIndex);
}

@end
