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

@property (nonatomic, strong) ZFWaveChart * waveChart;

@property (nonatomic, assign) CGFloat height;

@end

@implementation WaveChartViewController

- (void)setUp{
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        //首次进入控制器为横屏时
        _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT * 0.5;
        
    }else{
        //首次进入控制器为竖屏时
        _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT;
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setUp];
    
    self.waveChart = [[ZFWaveChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _height)];
    self.waveChart.dataSource = self;
    self.waveChart.delegate = self;
    self.waveChart.topicLabel.text = @"xx小学各年级人数";
    self.waveChart.unit = @"人";
//    self.waveChart.isShowSeparate = YES;
    self.waveChart.topicLabel.textColor = ZFPurple;
//    self.waveChart.isAnimated = NO;
//    self.waveChart.isResetAxisLineMinValue = YES;
//    self.waveChart.isShowAxisLineValue = NO;
//    self.waveChart.isShadowForValueLabel = NO;
//    self.waveChart.valuePosition = kChartValuePositionOnBelow;
//    self.waveChart.valueLabelPattern = kPopoverLabelPatternBlank;
//    self.waveChart.wavePatternType = kWavePatternTypeForSharp;
//    self.waveChart.valueLabelToWaveLinePadding = 20.f;
    [self.waveChart strokePath];
    [self.view addSubview:self.waveChart];
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"123", @"256", @"300", @"283", @"490", @"236", @"401", @"356", @"270", @"369", @"463", @"399"];
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级", @"初一", @"初二", @"初三", @"高一", @"高二", @"高三"];
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return 500;
}

//- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart{
//    return 100;
//}

- (NSInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 10;
}

#pragma mark - ZFWaveChartDelegate

//- (CGFloat)groupWidthInWaveChart:(ZFWaveChart *)waveChart{
//    return 50.f;
//}

//- (CGFloat)paddingForGroupsInWaveChart:(ZFWaveChart *)waveChart{
//    return 20.f;
//}

- (UIColor *)pathColorInWaveChart:(ZFWaveChart *)waveChart{
    return ZFGrassGreen;
}

- (void)waveChart:(ZFWaveChart *)waveChart popoverLabelAtIndex:(NSInteger)index{
    NSLog(@"第%ld个Label",(long)index);
}

#pragma mark - 横竖屏适配(若需要同时横屏,竖屏适配，则添加以下代码，反之不需添加)

/**
 *  PS：size为控制器self.view的size，若图表不是直接添加self.view上，则修改以下的frame值
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator NS_AVAILABLE_IOS(8_0){
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        self.waveChart.frame = CGRectMake(0, 0, size.width, size.height - NAVIGATIONBAR_HEIGHT * 0.5);
    }else{
        self.waveChart.frame = CGRectMake(0, 0, size.width, size.height + NAVIGATIONBAR_HEIGHT * 0.5);
    }
    
    [self.waveChart strokePath];
}

@end
