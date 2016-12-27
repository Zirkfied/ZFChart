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
- (NSArray *)valueArrayInPieChart:(ZFPieChart *)pieChart;

/**
 *  颜色数组
 *
 *  @return NSArray必须存储UIColor类型
 */
- (NSArray *)colorArrayInPieChart:(ZFPieChart *)pieChart;

@end



/*********************  ZFPieChartDelegate(ZFPieChart代理方法)  *********************/
@protocol ZFPieChartDelegate <NSObject>

@required

/**
 *  设置饼图的半径
 *
 *  @return 半径
 */
- (CGFloat)radiusForPieChart:(ZFPieChart *)pieChart;



@optional
/**
 *  用于点击path后需要执行后续代码
 *
 *  @param index 点击的path的位置下标
 */
- (void)pieChart:(ZFPieChart *)pieChart didSelectPathAtIndex:(NSInteger)index;

/**
 *  百分比Label显示的最小值限制 (譬如设置5，则当前百分比小于5%则不显示，默认为0)
 */
- (CGFloat)allowToShowMinLimitPercent:(ZFPieChart *)pieChart;

#warning message - 此代理方法只适用于圆环类型

/**
 *  当饼图类型为圆环类型时，可通过此方法把半径平均分成n段，圆环的线宽为n分之1，简单理解就是调整圆环线宽的粗细
 *  (若不设置，默认平均分2段)
 *  (e.g. radius为100，把半径平均分成4段，则圆环的线宽为100 * (1 / 4), 即25)
 *
 *  (PS:此方法对 整圆(kPieChartPatternTypeForCircle)类型 无效)
 *
 *  @return 设置半径平均段数(可以为小数, 返回的值必须大于1，当<=1时则自动返回默认值)
 */
- (CGFloat)radiusAverageNumberOfSegments:(ZFPieChart *)pieChart;

@end



/**
 *   百分比类型
 */
typedef enum{
    kPercentTypeDecimal = 0,   //保留2位小数形式(默认)
    kPercentTypeInteger = 1    //取整数形式(四舍五入)
}kPercentType;


@interface ZFPieChart : UIView

@property (nonatomic, weak) id<ZFPieChartDataSource> dataSource;
@property (nonatomic, weak) id<ZFPieChartDelegate> delegate;

/** 图表上百分比字体大小 */
@property (nonatomic, strong) UIFont * percentOnChartFont;

/** 饼图样式(若不设置，默认为kPieChartPatternTypeForCirque(圆环样式)) */
@property (nonatomic, assign) kPiePatternType piePatternType;
/** kPercentType类型 */
@property (nonatomic, assign) kPercentType percentType;
/** 显示百分比(默认为YES) */
@property (nonatomic, assign) BOOL isShowPercent;
/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;
/** 是否带动画显示(默认为YES，带动画) */
@property (nonatomic, assign) BOOL isAnimated;
/** 图表透明度(范围0 ~ 1, 默认为1.f) */
@property (nonatomic, assign) CGFloat opacity;

#pragma mark - public method

/**
 *  重绘(每次更新数据后都需要再调一次此方法)
 */
- (void)strokePath;

@end
