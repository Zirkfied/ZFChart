//
//  ZFCirqueChart.h
//  ZFChartView
//
//  Created by apple on 2016/10/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFCirque.h"
#import "ZFLabel.h"
@class ZFCirqueChart;

/*********************  ZFCirqueChartDataSource(ZFPieChart数据源方法)  *********************/
@protocol ZFCirqueChartDataSource <NSObject>

@required

/**
 *  value数组
 *
 *  @return NSArray必须存储NSString类型(根据返回的数组个数自动生成N个圆环数)
 */
- (NSArray *)valueArrayInCirqueChart:(ZFCirqueChart *)cirqueChart;

/**
 *  颜色数组
 *
 *  @return 返回UIColor或者NSArray
 *          eg: ①return ZFRed;  若返回UIColor,则全部圆环path颜色为红色
 *              ②return @[ZFRed, ZFOrange, ZFBlue];  若返回数组,则每个圆环为对应数组下标的颜色
 *
 */
- (id)colorArrayInCirqueChart:(ZFCirqueChart *)cirqueChart;



@optional
/**
 *  数值显示的最大值(若不设置，默认返回数据源最大值)
 *
 *  (PS: 此方法与 isResetMaxValue 关联，具体查看该属性注释)
 */
- (CGFloat)maxValueInCirqueChart:(ZFCirqueChart *)cirqueChart;

@end



/*********************  ZFCirqueChartDelegate(ZFRadarChart代理方法)  *********************/
@protocol ZFCirqueChartDelegate <NSObject>

@required

/**
 *  设置圆环图半径(该半径是中心点与最内层圆的半径)
 */
- (CGFloat)radiusForCirqueChart:(ZFCirqueChart *)cirqueChart;



@optional

/**
 *  多个圆环时，圆环与圆环之间的间距(若不设置，默认为20.f)(当只有一个圆环时，此方法无效)
 */
- (CGFloat)paddingForCirqueInCirqueChart:(ZFCirqueChart *)cirqueChart;

/**
 *  圆环线宽(若不设置，默认为8.f)
 */
- (CGFloat)lineWidthInCirqueChart:(ZFCirqueChart *)cirqueChart;



@end

@interface ZFCirqueChart : UIView

@property (nonatomic, weak) id<ZFCirqueChartDataSource> dataSource;
@property (nonatomic, weak) id<ZFCirqueChartDelegate> delegate;

/** 圆环中心的Label */
@property (nonatomic, strong) ZFLabel * textLabel;

/** 是否一致显示固定的最大值，默认为NO，该属性有一下3种情况
    ①当为NO时，且不实现
    - (CGFloat)maxValueInRadarChart:(ZFRadarChart *)radarChart
    则自动计算返回的全部数据中的最大值
    ②当为NO时，且实现
    - (CGFloat)maxValueInRadarChart:(ZFRadarChart *)radarChart
    则当返回的全部数据的值都为"0"时，则最大值为该代理方法给予的值
    若数据的值并不都是"0"时，则自动计算返回的全部数据中的最大值
    ③当为YES时，则必须实现
    - (CGFloat)maxValueInRadarChart:(ZFRadarChart *)radarChart
    否则无法绘画图表，且任何情况最大值都为该代理方法给予的值
 */
@property (nonatomic, assign) BOOL isResetMaxValue;
/** 是否带动画显示(默认为YES，带动画) */
@property (nonatomic, assign) BOOL isAnimated;

/** 圆环样式(默认为kCirquePatternTypeForDefault) */
@property (nonatomic, assign) kCirquePatternType cirquePatternType;
/** 圆环起始位置(默认为kCirqueStartOrientationOnTop) */
@property (nonatomic, assign) kCirqueStartOrientation cirqueStartOrientation;
/** 阴影透明度(默认为1.f)(当cirquePatternType == kCirquePatternTypeForDefault 或 kCirquePatternTypeForNone该属性无效) */
@property (nonatomic, assign) CGFloat shadowOpacity;


#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
