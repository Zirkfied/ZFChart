//
//  SingleLineChartViewController.m
//  ZFChartView
//
//  Created by apple on 16/3/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SingleLineChartViewController.h"
#import "ZFChart.h"

@interface SingleLineChartViewController()<ZFGenericChartDataSource, ZFLineChartDelegate>

@end

@implementation SingleLineChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZFLineChart * lineChart = [[ZFLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    lineChart.dataSource = self;
    lineChart.delegate = self;
    lineChart.topic = @"近一个月涨跌幅－20.66%";
    lineChart.unit = @"";
    lineChart.topicColor = ZFPurple;
//    lineChart.backgroundColor = ZFGreen;
//    lineChart.valueLabelPattern = kPopoverLabelPatternBlank;
    lineChart.isShowSeparate = YES;
    lineChart.isShadow = NO;
    lineChart.isShadowForValueLabel = NO;
    
    [self.view addSubview:lineChart];
    [lineChart strokePath];
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"123", @"256", @"300", @"283", @"490", @"236",@"23",@"34",@"55",@"45",@"66" ];
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级"];
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[ZFMagenta];
}

- (CGFloat)yLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return 500;
}

- (NSInteger)yLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 10;
}

#pragma mark - ZFLineChartDelegate

//- (CGFloat)groupWidthInLineChart:(ZFLineChart *)lineChart{
//    return 25.f;
//}
//
//- (CGFloat)paddingForGroupsInLineChart:(ZFLineChart *)lineChart{
//    return 20.f;
//}
//
//- (CGFloat)circleRadiusInLineChart:(ZFLineChart *)lineChart{
//    return 5.f;
//}
//
//- (CGFloat)lineWidthInLineChart:(ZFLineChart *)lineChart{
//    return 2.f;
//}

- (void)lineChart:(ZFLineChart *)lineChart didSelectCircleAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex{
    NSLog(@"第%ld个", (long)circleIndex);
}

- (void)lineChart:(ZFLineChart *)lineChart didSelectPopoverLabelAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex{
    NSLog(@"第%ld个" ,(long)circleIndex);
}

@end
