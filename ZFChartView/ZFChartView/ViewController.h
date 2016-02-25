//
//  ViewController.h
//  ZFChartView
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kChartTypeBarChart = 0,
    kChartTypeLineChart = 1,
    kChartTypePieChart = 2
}kChartType;

@interface ViewController : UIViewController

@property (nonatomic, assign) kChartType chartType;

@end

