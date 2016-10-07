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

@property (nonatomic, strong) ZFLineChart * lineChart;

@property (nonatomic, assign) CGFloat height;

@end

@implementation MultiLineChartViewController

- (void)setUp{
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        //首次进入控制器为横屏时
        _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT * 0.5;
        
    }else{
        //首次进入控制器为竖屏时
        _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    
    self.lineChart = [[ZFLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _height)];
    self.lineChart.dataSource = self;
    self.lineChart.delegate = self;
    self.lineChart.topicLabel.text = @"xx小学各年级男女人数";
    self.lineChart.unit = @"人";
    self.lineChart.topicLabel.textColor = ZFWhite;
    self.lineChart.isShowSeparate = YES;
//    self.lineChart.isAnimated = NO;
    self.lineChart.isResetAxisLineMinValue = YES;
//    self.lineChart.isShowAxisLineValue = NO;
//    self.lineChart.isShadowForValueLabel = NO;
    self.lineChart.isShadow = NO;
//    self.lineChart.valueLabelPattern = kPopoverLabelPatternBlank;
//    self.lineChart.valueCenterToCircleCenterPadding = 0;
//    self.lineChart.separateColor = ZFYellow;
    self.lineChart.unitColor = ZFWhite;
    self.lineChart.backgroundColor = ZFPurple;
    self.lineChart.axisColor = ZFWhite;
    self.lineChart.axisLineNameColor = ZFWhite;
    self.lineChart.axisLineValueColor = ZFWhite;
    self.lineChart.xLineNameLabelToXAxisLinePadding = 40;
    [self.view addSubview:self.lineChart];
    [self.lineChart strokePath];
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@[@"-52", @"300", @"490", @"380", @"167", @"451"],
             @[@"380", @"200", @"326", @"240", @"-258", @"137"],
             @[@"256", @"300", @"-89", @"430", @"256", @"256"]
             ];
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

- (NSUInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 10;
}

#pragma mark - ZFLineChartDelegate

//- (CGFloat)groupWidthInLineChart:(ZFLineChart *)lineChart{
//    return 40.f;
//}

//- (CGFloat)paddingForGroupsInLineChart:(ZFLineChart *)lineChart{
//    return 30.f;
//}

//- (CGFloat)circleRadiusInLineChart:(ZFLineChart *)lineChart{
//    return 10.f;
//}

//- (CGFloat)lineWidthInLineChart:(ZFLineChart *)lineChart{
//    return 5.f;
//}

//- (NSArray *)valuePositionInLineChart:(ZFLineChart *)lineChart{
//    return @[@(kChartValuePositionOnTop), @(kChartValuePositionDefalut), @(kChartValuePositionOnBelow)];
//}

- (void)lineChart:(ZFLineChart *)lineChart didSelectCircleAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex circle:(ZFCircle *)circle popoverLabel:(ZFPopoverLabel *)popoverLabel{
    NSLog(@"第%ld条线========第%ld个",(long)lineIndex,(long)circleIndex);
    
    //可在此处进行circle被点击后的自身部分属性设置,可修改的属性查看ZFCircle.h
//    circle.circleColor = ZFYellow;
//    circle.isAnimated = YES;
//    circle.opacity = 0.5;
//    [circle strokePath];
    
    //可将isShowAxisLineValue设置为NO，然后执行下句代码进行点击才显示数值
//    popoverLabel.hidden = NO;
}

- (void)lineChart:(ZFLineChart *)lineChart didSelectPopoverLabelAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex popoverLabel:(ZFPopoverLabel *)popoverLabel{
    NSLog(@"第%ld条线========第%ld个",(long)lineIndex,(long)circleIndex);
    
    //可在此处进行popoverLabel被点击后的自身部分属性设置
//    popoverLabel.textColor = ZFGold;
//    [popoverLabel strokePath];
}

#pragma mark - 横竖屏适配(若需要同时横屏,竖屏适配，则添加以下代码，反之不需添加)

/**
 *  PS：size为控制器self.view的size，若图表不是直接添加self.view上，则修改以下的frame值
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator NS_AVAILABLE_IOS(8_0){
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        self.lineChart.frame = CGRectMake(0, 0, size.width, size.height - NAVIGATIONBAR_HEIGHT * 0.5);
    }else{
        self.lineChart.frame = CGRectMake(0, 0, size.width, size.height + NAVIGATIONBAR_HEIGHT * 0.5);
    }
    
    [self.lineChart strokePath];
}

@end
