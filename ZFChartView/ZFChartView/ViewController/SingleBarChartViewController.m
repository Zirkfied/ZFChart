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
    
    ZFBarChart * barChart = [[ZFBarChart alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
    barChart.dataSource = self;
    barChart.delegate = self;
    barChart.topic = @"最高年化收益率";
    barChart.unit = @"年收益率(％)";
    barChart.topicColor = ZFOrange;
    barChart.isShadow = NO;
//    barChart.isShowXLineValue = NO;
  //  barChart.backgroundColor = ZFGreen;
    barChart.valueLabelPattern = kPopoverLabelPatternPopover;
    //isShadowForValueLabel
    barChart.isShadowForValueLabel = NO;
   // barChart.overMaxValueBarColor = [UIColor orangeColor];
    [self.view addSubview:barChart];
    

    [barChart strokePath];
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"2.01", @"3.02", @"4.03", @"5.11", @"6.50", @"7.7"];
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"7天", @"3个月", @"6个月", @"一年", @"二年", @"三年"];
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[ZFSkyBlue];
}

- (CGFloat)yLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return 8;
}

- (NSInteger)yLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 4;
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

- (void)barChart:(ZFBarChart *)barChart didSelectBarAtGroupIndex:(NSInteger)groupIndex barIndex:(NSInteger)barIndex{
    NSLog(@"第%ld组========第%ld个",(long)groupIndex,(long)barIndex);
    
}

- (void)barChart:(ZFBarChart *)barChart didSelectPopoverLabelAtGroupIndex:(NSInteger)groupIndex labelIndex:(NSInteger)labelIndex{
    NSLog(@"第%ld组========第%ld个",(long)groupIndex,(long)labelIndex);
}

@end
