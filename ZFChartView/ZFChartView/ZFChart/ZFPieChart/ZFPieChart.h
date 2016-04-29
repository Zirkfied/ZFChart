//
//  ZFPieChart.h
//  ZFChartView
//
//  Created by apple on 16/3/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFPie.h"
@class ZFPieChart;

/*********************  ZFPieChartDataSource(ZFPieChart数据源方法)  *********************/
@protocol ZFPieChartDataSource <NSObject>

@required
/**
 *  value数据
 *
 *  @return NSArray必须存储NSString类型
 */
- (NSArray *)valueArrayInPieChart:(ZFPieChart *)chart;

/**
 *  颜色数组
 *
 *  @return NSArray必须存储UIColor类型
 */
- (NSArray *)colorArrayInPieChart:(ZFPieChart *)chart;



@optional
/**
 *  名称数据
 *
 *  @return NSArray必须存储NSString类型
 */
- (NSArray *)nameArrayInPieChart:(ZFPieChart *)chart;

@end




typedef enum{
    /**
     *  保留2位小数形式(默认)
     */
    kPercentTypeDecimal = 0,
    /**
     *  取整数形式(四舍五入)
     */
    kPercentTypeInteger = 1
}kPercentType;

@interface ZFPieChart : UIScrollView

@property (nonatomic, weak) id<ZFPieChartDataSource> dataSource;

/** 主题 */
@property (nonatomic, copy) NSString * topic;
/** 饼图样式(若不设置，默认为kPieChartPatternTypeForCirque(圆环样式)) */
@property (nonatomic, assign) kPiePatternType piePatternType;
/** kPercentType类型 */
@property (nonatomic, assign) kPercentType percentType;
/** 显示百分比(默认为YES) */
@property (nonatomic, assign) BOOL isShowPercent;
/** 图表上百分比字体大小 */
@property (nonatomic, assign) CGFloat percentOnChartFontSize;
/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;
/** 显示详细信息(默认为NO) */
@property (nonatomic, assign) BOOL isShowDetail;
/** 是否带动画显示(默认为YES，带动画) */
@property (nonatomic, assign) BOOL isAnimated;


#pragma mark - public method

/**
 *  重绘(每次更新数据后都需要再调一次此方法)
 */
- (void)strokePath;

@end
