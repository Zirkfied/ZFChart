//
//  WaveChartViewController.m
//  ZFChartView
//
//  Created by apple on 16/3/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WaveChartViewController.h"
#import "ZFChart.h"

@interface WaveChartViewController()<ZFGenericChartDataSource, ZFWaveChartDelegate>

@property (nonatomic, strong) NSMutableArray * pointArray;

@end

@implementation WaveChartViewController

- (NSMutableArray *)pointArray{
    if (!_pointArray) {
        _pointArray = [NSMutableArray array];
    }
    return _pointArray;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    ZFWaveChart * waveChart = [[ZFWaveChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    waveChart.dataSource = self;
    waveChart.delegate = self;
    waveChart.topic = @"xx小学各年级人数";
    waveChart.unit = @"人";
    waveChart.isShowSeparate = YES;
    waveChart.topicColor = ZFPurple;
//    waveChart.isShadowForValueLabel = NO;
//    waveChart.valuePosition = kChartValuePositionOnBelow;
//    waveChart.valueLabelPattern = kPopoverLabelPatternBlank;
    [waveChart strokePath];
    [self.view addSubview:waveChart];
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"123", @"256", @"300", @"283", @"490", @"236", @"401", @"356", @"270", @"369", @"463", @"399"];
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级", @"初一", @"初二", @"初三", @"高一", @"高二", @"高三"];
}

- (CGFloat)yLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return 500;
}

- (NSInteger)yLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 10;
}

#pragma mark - ZFWaveChartDelegate

//- (CGFloat)groupWidthInWaveChart:(ZFWaveChart *)waveChart{
//    return 50.f;
//}
//
//- (CGFloat)paddingForGroupsInWaveChart:(ZFWaveChart *)waveChart{
//    return 10.f;
//}
//
//- (UIColor *)pathColorInWaveChart:(ZFWaveChart *)waveChart{
//    return ZFOrange;
//}

@end
