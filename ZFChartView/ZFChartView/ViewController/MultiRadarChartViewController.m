//
//  MultiRadarChartViewController.m
//  ZFChartView
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MultiRadarChartViewController.h"
#import "ZFChart.h"

@interface MultiRadarChartViewController()<ZFRadarChartDataSource, ZFRadarChartDelegate>

@property (nonatomic, strong) ZFRadarChart * radarChart;

@property (nonatomic, assign) CGFloat height;

@end

@implementation MultiRadarChartViewController

- (void)setUp{
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        //首次进入控制器为横屏时
        _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT * 0.5;
        
    }else{
        //首次进入控制器为竖屏时
        _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT;
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.radarChart = [[ZFRadarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    self.radarChart.dataSource = self;
    self.radarChart.delegate = self;
//    self.radarChart.unit = @" ¥";
    self.radarChart.itemTextColor = ZFBlue;
//    self.radarChart.backgroundColor = ZFCyan;
    self.radarChart.polygonLineWidth = 2.f;
    self.radarChart.itemFont = [UIFont systemFontOfSize:12.f];
    self.radarChart.valueFont = [UIFont systemFontOfSize:12.f];
//    self.radarChart.isResetMinValue = YES;
//    self.radarChart.valueType = kValueTypeDecimal;
    self.radarChart.valueTextColor = ZFDeepPink;
    self.radarChart.radarPatternType = kRadarPatternTypeCircle;
//    self.radarChart.radarLineColor = ZFBlack;
    self.radarChart.radarBackgroundColor = ZFMagenta;
    self.radarChart.isShowRadarPeak = YES;
    self.radarChart.radarPeakColor = ZFGrassGreen;
//    self.radarChart.radarPeakRadius = 10.f;
    [self.view addSubview:self.radarChart];
    [self.radarChart strokePath];
}

#pragma mark - ZFRadarChartDataSource

- (NSArray *)itemArrayInRadarChart:(ZFRadarChart *)radarChart{
    return @[@"item 1", @"item 2", @"item 3", @"item 4", @"item 5", @"item 6", @"item 7", @"item 8"];
}

- (NSArray *)valueArrayInRadarChart:(ZFRadarChart *)radarChart{
    return @[@[@"2", @"5", @"2", @"4.5", @"3.5", @"4", @"4.8", @"2.5"],
             @[@"3.8", @"2", @"4.5", @"4", @"5", @"1.5", @"2.8", @"3.9"]];
}

- (NSArray *)colorArrayInRadarChart:(ZFRadarChart *)radarChart{
    return @[ZFGold, ZFBlue];
}

- (CGFloat)maxValueInRadarChart:(ZFRadarChart *)radarChart{
    return 5.f;
}

//- (CGFloat)minValueInRadarChart:(ZFRadarChart *)radarChart{
//    return 1.f;
//}

#pragma mark - ZFRadarChartDelegate

- (CGFloat)radiusForRadarChart:(ZFRadarChart *)radarChart{
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        return (SCREEN_HEIGHT - 100) / 2;
    }else{
        return (SCREEN_WIDTH - 100) / 2;
    }
    
//    return 100.f;
}

//- (NSUInteger)sectionCountInRadarChart:(ZFRadarChart *)radarChart{
//    return 4;
//}

//- (CGFloat)radiusExtendLengthForRadarChart:(ZFRadarChart *)radarChart itemIndex:(NSInteger)itemIndex{
//    if (itemIndex == 7) {
//        return 50.f;
//    }
//
//    return 25.f;
//}

- (CGFloat)valueRotationAngleForRadarChart:(ZFRadarChart *)radarChart{
    return 45.f;
}

- (void)radarChart:(ZFRadarChart *)radarChart didSelectItemLabelAtIndex:(NSInteger)labelIndex{
    NSLog(@"当前点击的下标========%ld", (long)labelIndex);
}


#pragma mark - 横竖屏适配(若需要同时横屏,竖屏适配，则添加以下代码，反之不需添加)

/**
 *  PS：size为控制器self.view的size，若图表不是直接添加self.view上，则修改以下的frame值
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        self.radarChart.frame = CGRectMake(0, 0, size.width, size.height - NAVIGATIONBAR_HEIGHT * 0.5);
        
    }else{
        self.radarChart.frame = CGRectMake(0, 0, size.width, size.height + NAVIGATIONBAR_HEIGHT * 0.5);
        
    }
    
    [self.radarChart strokePath];
}

@end
