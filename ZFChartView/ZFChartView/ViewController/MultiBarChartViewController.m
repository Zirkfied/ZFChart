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

@property (nonatomic, strong) NSMutableArray * array1;
@property (nonatomic, strong) NSMutableArray * array2;
@property (nonatomic, strong) NSMutableArray * totalArray;

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
    [barChart strokePath];
    [self.view addSubview:barChart];
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@[@"123", @"300", @"490", @"380", @"167", @"235"], @[@"256", @"283", @"236", @"240", @"183", @"200"], @[@"256", @"256", @"256", @"256", @"256", @"256"]];
    
    return _totalArray;
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

- (id)valueTextColorArrayInChart:(ZFBarChart *)chart{
    return ZFBlue;
    return @[ZFColor(71, 204, 255, 1), ZFColor(253, 203, 76, 1), ZFColor(16, 140, 39, 1)];
}

- (void)barChart:(ZFBarChart *)barChart didSelectBarAtGroupIndex:(NSInteger)groupIndex barIndex:(NSInteger)barIndex{
    //特殊说明，因传入数据是3个subArray(代表3个类型)，每个subArray存的是6个元素(代表每个类型存了1~6年级的数据),所以这里的groupIndex是第几个subArray(类型)
    //eg：三年级第0个元素为 groupIndex为0，barIndex为2
    NSLog(@"第%ld个颜色中的第%ld个",(long)groupIndex,(long)barIndex);
}

- (void)barChart:(ZFBarChart *)barChart didSelectPopoverLabelAtGroupIndex:(NSInteger)groupIndex labelIndex:(NSInteger)labelIndex{
    //理由同上
    NSLog(@"第%ld组========第%ld个",(long)groupIndex,(long)labelIndex);
}

@end
