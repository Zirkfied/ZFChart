//
//  MultiCirqueChartViewController.m
//  ZFChartView
//
//  Created by apple on 2016/10/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MultiCirqueChartViewController.h"
#import "ZFChart.h"

@interface MultiCirqueChartViewController ()<ZFCirqueChartDataSource, ZFCirqueChartDelegate>

@property (nonatomic, strong) ZFCirqueChart * cirqueChart;

@property (nonatomic, assign) CGFloat height;

@end

@implementation MultiCirqueChartViewController

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
    
    self.cirqueChart = [[ZFCirqueChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _height)];
    self.cirqueChart.dataSource = self;
    self.cirqueChart.delegate = self;
//    self.cirqueChart.textLabel.backgroundColor = ZFOrange;
    self.cirqueChart.textLabel.text = @"Season";
    self.cirqueChart.textLabel.textColor = ZFRed;
    self.cirqueChart.textLabel.font = [UIFont boldSystemFontOfSize:12.f];
    self.cirqueChart.isResetMaxValue = YES;
//    self.cirqueChart.isAnimated = NO;
//    self.cirqueChart.cirquePatternType = kCirquePatternTypeDefaultWithShadow;
//    self.cirqueChart.cirqueStartOrientation = kCirqueStartOrientationOnRight;
    [self.view addSubview:self.cirqueChart];
    [self.cirqueChart strokePath];
}

#pragma mark - ZFCirqueChartDataSource

- (NSArray *)valueArrayInCirqueChart:(ZFCirqueChart *)cirqueChart{
    return @[@"2000", @"5000", @"6500", @"3500", @"8000"];
}

- (id)colorArrayInCirqueChart:(ZFCirqueChart *)cirqueChart{
//    return ZFGrassGreen;
    return @[ZFRed, ZFOrange, ZFMagenta, ZFBlue, ZFPurple];
}

- (CGFloat)maxValueInCirqueChart:(ZFCirqueChart *)cirqueChart{
    return 10000.f;
}

#pragma mark - ZFCirqueChartDelegate

- (CGFloat)radiusInCirqueChart:(ZFCirqueChart *)cirqueChart{
    return 40.f;
}

//- (CGFloat)paddingForCirqueInCirqueChart:(ZFCirqueChart *)cirqueChart{
//    return 40.f;
//}
//
//- (CGFloat)lineWidthInCirqueChart:(ZFCirqueChart *)cirqueChart{
//    return 15.f;
//}


#pragma mark - 横竖屏适配(若需要同时横屏,竖屏适配，则添加以下代码，反之不需添加)

/**
 *  PS：size为控制器self.view的size，若图表不是直接添加self.view上，则修改以下的frame值
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        self.cirqueChart.frame = CGRectMake(0, 0, size.width, size.height - NAVIGATIONBAR_HEIGHT * 0.5);
        
    }else{
        self.cirqueChart.frame = CGRectMake(0, 0, size.width, size.height + NAVIGATIONBAR_HEIGHT * 0.5);
        
    }
    
    [self.cirqueChart strokePath];
}

@end
