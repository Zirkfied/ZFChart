//
//  SingleRadarChartViewController.m
//  ZFChartView
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SingleRadarChartViewController.h"
#import "ZFChart.h"

@interface SingleRadarChartViewController()<ZFRadarChartDataSource, ZFRadarChartDelegate>

@property (nonatomic, strong) ZFRadarChart * radarChart;

@property (nonatomic, assign) CGFloat height;

@end

@implementation SingleRadarChartViewController

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
    [self setUp];
    
    self.radarChart = [[ZFRadarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _height)];
    self.radarChart.dataSource = self;
    self.radarChart.delegate = self;
    self.radarChart.unit = @" €";
    self.radarChart.itemTextColor = ZFBlue;
//    self.radarChart.backgroundColor = ZFCyan;
    self.radarChart.itemFont = [UIFont systemFontOfSize:12.f];
    self.radarChart.valueFont = [UIFont systemFontOfSize:12.f];
//    self.radarChart.radarLineWidth = 3.f;
//    self.radarChart.separateLineWidth = 3.f;
    self.radarChart.polygonLineWidth = 2.f;
    self.radarChart.isShowPolygonLine = NO;
//    self.radarChart.isShowValue = NO;
//    self.radarChart.isAnimated = NO;
    self.radarChart.isShowSeparate = NO;
    self.radarChart.valueType = kValueTypeDecimal;
    self.radarChart.numberOfDecimal = 2;
//    self.radarChart.isResetMinValue = YES;
//    self.radarChart.isResetMaxValue = YES;
    self.radarChart.valueTextColor = ZFOrange;
//    self.radarChart.radarPatternType = kRadarPatternTypeCircle;
    self.radarChart.radarLineColor = ZFClear;
    self.radarChart.isShowPolygonPeak = YES;
    self.radarChart.polygonPeakColor = ZFBlue;
    [self.view addSubview:self.radarChart];
    [self.radarChart strokePath];
}

#pragma mark - ZFRadarChartDataSource

- (NSArray *)itemArrayInRadarChart:(ZFRadarChart *)radarChart{
//    return @[@"item 1", @"item 2", @"item 3", @"item 4", @"item 5", @"item 6", @"item 7", @"item 8", @"item 9"];
    
    return @[@"item 1", @"item 2", @"item 3", @"item 4", @"item 5", @"item 6"];
}

- (NSArray *)valueArrayInRadarChart:(ZFRadarChart *)radarChart{
//    return @[@"4", @"10", @"4", @"9", @"7", @"8", @"3.2", @"5", @"8.4"];
    
    return @[@"4", @"10", @"4", @"9", @"7", @"8"];
}

//- (NSArray *)colorArrayInRadarChart:(ZFRadarChart *)radarChart{
//    return @[ZFRed];
//}

//- (CGFloat)maxValueInRadarChart:(ZFRadarChart *)radarChart{
//    return 10.f;
//}

#pragma mark - ZFRadarChartDelegate

- (CGFloat)radiusInRadarChart:(ZFRadarChart *)radarChart{
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        return (SCREEN_HEIGHT - 100) / 2;
    }else{
        return (SCREEN_WIDTH - 100) / 2;
    }
    
//    return 100.f;
}

- (NSArray<UIColor *> *)radarBackgroundColorArrayInRadarChart:(ZFRadarChart *)radarChart{
    return @[ZFColor(250, 250, 250, 1),
             ZFColor(195, 209, 235, 1),
             ZFColor(178, 195, 227, 1),
             ZFColor(195, 211, 241, 1),
             ZFColor(211, 223, 245, 1),
             ZFColor(235, 241, 252, 1)];
}

- (NSUInteger)sectionCountInRadarChart:(ZFRadarChart *)radarChart{
    return 6;
}

//- (CGFloat)radiusExtendLengthInRadarChart:(ZFRadarChart *)radarChart itemIndex:(NSInteger)itemIndex{
//    if (itemIndex == 7) {
//        return 50.f;
//    }
//    
//    return 25.f;
//}

//- (CGFloat)valueRotationAngleInRadarChart:(ZFRadarChart *)radarChart{
//    return 45.f;
//}

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
