//
//  ZFRadarChart.h
//  ZFChartView
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFConst.h"
@class ZFRadarChart;

/*********************  ZFRadarChartDataSource(ZFPieChart数据源方法)  *********************/
@protocol ZFRadarChartDataSource <NSObject>

@required

/**
 *  item数组(eg: 力量，智力，物防，法防，敏捷...)
 *
 *  PS:根据item数组的个数自动生成N边形
 *
 *  @return NSArray必须存储NSString类型
 */
- (NSArray *)itemArrayInRadarChart:(ZFRadarChart *)radarChart;

/**
 *  value数组
 *
 *  @return NSArray必须存储NSString类型
 *          eg: ①当只有1组数据时，NSArray存储 @[@"1", @"2", @"3", @"4"]
 *              ②当有多组数据时，NSArray存储 @[@[@"1", @"2", @"3", @"4"], @[@"1", @"2", @"3", @"4"]]
 */
- (NSArray *)valueArrayInRadarChart:(ZFRadarChart *)radarChart;



@optional

/**
 *  颜色数组(默认随机颜色)
 *
 *  @return NSArray必须存储UIColor类型
 */
- (NSArray *)colorArrayInRadarChart:(ZFRadarChart *)radarChart;

/**
 *  数值显示的最大值(若不设置，默认返回数据源最大值)
 *
 *  (PS: 此方法与 isResetMaxValue 关联，具体查看该属性注释)
 */
- (CGFloat)maxValueInRadarChart:(ZFRadarChart *)radarChart;

/**
 *  数值显示的最小值(若不设置，默认返回数据源最小值)
 */
- (CGFloat)minValueInRadarChart:(ZFRadarChart *)radarChart;

@end



/*********************  ZFRadarChartDelegate(ZFRadarChart代理方法)  *********************/
@protocol ZFRadarChartDelegate <NSObject>

@required

/**
 *  设置雷达图半径
 *
 *  @return 半径
 */
- (CGFloat)radiusForRadarChart:(ZFRadarChart *)radarChart;



@optional

/**
 *  雷达图显示的分段数(若不设置,默认5段)
 *
 *  @return 分段数
 */
- (NSUInteger)sectionCountInRadarChart:(ZFRadarChart *)radarChart;

/**
 *  设置雷达图半径延伸长度，用于计算item label的中心点位置(默认25.f)
 *
 *  @param itemIndex item下标(可根据item的字符长度自行调节item label的中心点位置)
 *
 *  @return 半径延伸长度
 */
- (CGFloat)radiusExtendLengthForRadarChart:(ZFRadarChart *)radarChart itemIndex:(NSInteger)itemIndex;

/**
 *  雷达图分段数值的角度位置(若不设置,默认为-90度(正上方))
 *
 *  @return 角度( 可调节范围 [-90, 270) )
 */
- (CGFloat)valueRotationAngleForRadarChart:(ZFRadarChart *)radarChart;

/**
 *  用于编写点击item Label后需要执行后续代码
 *
 *  @param labelIndex   点击的label下标
 *  @param itemLabel    当前点击的itemLabel对象
 */
- (void)radarChart:(ZFRadarChart *)radarChart didSelectItemLabelAtIndex:(NSInteger)labelIndex;

@end

@interface ZFRadarChart : UIView

@property (nonatomic, weak) id<ZFRadarChartDataSource> dataSource;
@property (nonatomic, weak) id<ZFRadarChartDelegate> delegate;

/** 单位 */
@property (nonatomic, copy) NSString * unit;
/** item字体颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * itemTextColor;
/** value字体颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * valueTextColor;
/** 雷达图边线颜色(默认为浅灰色) */
@property (nonatomic, strong) UIColor * radarLineColor;

/** item字体大小(默认15.f) */
@property (nonatomic, strong) UIFont * itemFont;
/** value字体大小(默认10.f) */
@property (nonatomic, strong) UIFont * valueFont;

/** 雷达图线宽(默认1.f) */
@property (nonatomic, assign) CGFloat radarLineWidth;
/** 雷达图分割线线宽(默认1.f) */
@property (nonatomic, assign) CGFloat separateLineWidth;
/** 多边形线宽(默认1.f) */
@property (nonatomic, assign) CGFloat polygonLineWidth;
/** 多边形透明度(默认0.3f) */
@property (nonatomic, assign) CGFloat opacity;
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
/** 该属性是否重设坐标轴最小值，默认为NO(不设置，从0开始)，当设置为YES时，则有以下2种情况
    ①若同时实现代理方法中的
        - (CGFloat)minValueInRadarChart:(ZFRadarChart *)radarChart
        则y轴最小值为该方法的返回值
    ②若不实现①中的方法，则y轴最小值为数据源最小值
 
    
    Default is No (Start to O). When set to YES, then there are 2 kinds of situations:
    ①If at the same time to implement the method in ZFRadarChartDataSource:
        ||- (CGFloat)minValueInRadarChart:(ZFRadarChart *)radarChart||
        then minValue is the return value of the method.
    ②If not to implement the method in ①, then minValue is the minimum value of the dataSource.
 */
@property (nonatomic, assign) BOOL isResetMinValue;
/** 是否带动画显示(默认为YES，带动画) */
@property (nonatomic, assign) BOOL isAnimated;
/** 是否显示多边形边线(默认为YES) */
@property (nonatomic, assign) BOOL isShowPolygonLine;
/** 是否显示分段数值(默认为YES) */
@property (nonatomic, assign) BOOL isShowValue;
/** 是否显示雷达图分割线(默认为YES) */
@property (nonatomic, assign) BOOL isShowSeparate;
/** 是否添加旋转手势(默认为YES) */
@property (nonatomic, assign) BOOL canRotation;
/** 雷达图分段数值的显示类型(保留有效小数或显示整数形式，默认为整数形式) */
@property (nonatomic, assign) kValueType valueType;


#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
