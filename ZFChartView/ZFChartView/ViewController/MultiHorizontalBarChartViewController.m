//
//  MultiHorizontalBarChartViewController.m
//  ZFChartView
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MultiHorizontalBarChartViewController.h"
#import "ZFChart.h"

@interface MultiHorizontalBarChartViewController ()<ZFGenericChartDataSource, ZFHorizontalBarChartDelegate>

@end

@implementation MultiHorizontalBarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZFHorizontalBarChart * barChart = [[ZFHorizontalBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    barChart.dataSource = self;
    barChart.delegate = self;
    barChart.topic = @"xx小学各年级男女人数";
    barChart.unit = @"人";
    barChart.topicColor = ZFPurple;
//    barChart.isShadow = NO;
    barChart.valueLabelPattern = kPopoverLabelPatternBlank;
//    barChart.isResetAxisLineMinValue = YES;
//    barChart.isShowSeparate = YES;
//    barChart.backgroundColor = ZFPurple;
//    barChart.unitColor = ZFWhite;
//    barChart.axisColor = ZFWhite;
//    barChart.axisLineNameColor = ZFWhite;
//    barChart.axisLineValueColor = ZFWhite;
    [self.view addSubview:barChart];
    [barChart strokePath];
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@[@"123", @"500", @"490", @"380", @"167", @"235"], @[@"256", @"283", @"236", @"240", @"183", @"200"], @[@"256", @"256", @"256", @"256", @"256", @"256"]];
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级"];
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[ZFColor(125, 229, 255, 1), ZFColor(254, 199, 116, 1), ZFColor(185, 255, 122, 1)];
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return 500;
}

//- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart{
//    return -150;
//}

//- (NSInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
//    return 10;
//}

#pragma mark - ZFHorizontalBarChartDelegate

//- (CGFloat)barHeightInHorizontalBarChart:(ZFHorizontalBarChart *)barChart{
//    return 60.f;
//}
//
//- (CGFloat)paddingForGroupsInHorizontalBarChart:(ZFHorizontalBarChart *)barChart{
//    return 20.f;
//}
//
//- (CGFloat)paddingForBarInHorizontalBarChart:(ZFHorizontalBarChart *)barChart{
//    return 5.f;
//}

- (id)valueTextColorArrayInHorizontalBarChart:(ZFHorizontalBarChart *)barChart{
    return ZFBlue;
//    return @[ZFColor(71, 204, 255, 1), ZFColor(253, 203, 76, 1), ZFColor(16, 140, 39, 1)];
}

- (void)horizontalBarChart:(ZFHorizontalBarChart *)barChart didSelectBarAtGroupIndex:(NSInteger)groupIndex barIndex:(NSInteger)barIndex{
    //特殊说明，因传入数据是3个subArray(代表3个类型)，每个subArray存的是6个元素(代表每个类型存了1~6年级的数据),所以这里的groupIndex是第几个subArray(类型)
    //eg：三年级第0个元素为 groupIndex为0，barIndex为2
    NSLog(@"第%ld个颜色中的第%ld个",(long)groupIndex,(long)barIndex);
}

- (void)horizontalBarChart:(ZFHorizontalBarChart *)barChart didSelectPopoverLabelAtGroupIndex:(NSInteger)groupIndex labelIndex:(NSInteger)labelIndex{
    //理由同上
    NSLog(@"第%ld组========第%ld个",(long)groupIndex,(long)labelIndex);
}

@end
