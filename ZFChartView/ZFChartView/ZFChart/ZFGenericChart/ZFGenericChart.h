//
//  ZFGenericChart.h
//  ZFChartView
//
//  Created by apple on 16/3/18.
//  Copyright © 2016年 apple. All rights reserved.
//

/// 带坐标轴的数据源

#import <UIKit/UIKit.h>
@class ZFGenericChart;

/*********************  ZFChartDataSource(ZFChart数据源方法)  *********************/
@protocol ZFGenericChartDataSource <NSObject>

@required
/**
 *  value数据
 *
 *  @return 当只有1组数据时，NSArray存储 @[@"1", @"2", @"3", @"4"]
 *          当有多组数据时，NSArray存储 @[@[@"1", @"2", @"3", @"4"], @[@"1", @"2", @"3", @"4"]]
 */
- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart;



@optional
/**
 *  名称数据
 *
 *  @return NSArray必须存储NSString类型
 */
- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart;

/**
 *  颜色数组(若不设置，默认随机)
 *
 *  @return NSArray必须存储UIColor类型
 */
- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart;

/**
 *  y轴数值显示的上限(若不设置，默认返回数据源最大值)
 */
- (CGFloat)yLineMaxValueInGenericChart:(ZFGenericChart *)chart;

/**
 *  y轴数值显示的段数(若不设置,默认5段)
 */
- (NSInteger)yLineSectionCountInGenericChart:(ZFGenericChart *)chart;

@end;


@interface ZFGenericChart : UIView

@property (nonatomic, weak) id<ZFGenericChartDataSource> dataSource;

@end
