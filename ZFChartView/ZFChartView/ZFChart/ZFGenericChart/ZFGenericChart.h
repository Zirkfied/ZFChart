//
//  ZFGenericChart.h
//  ZFChartView
//
//  Created by apple on 16/3/18.
//  Copyright © 2016年 apple. All rights reserved.
//

/// 带坐标轴的数据源

#import <UIKit/UIKit.h>
#import "ZFPopoverLabel.h"
@class ZFGenericChart;

/*********************  ZFChartDataSource(ZFChart数据源方法)  *********************/
@protocol ZFGenericChartDataSource <NSObject>

@required
/**
 *  value数据
 *  
 *  (PS:波浪图(ZFWaveChart)只支持1组数据,只能按以下①方式传值)
 *
 *  @return NSArray必须存储NSString类型
 *          eg: ①当只有1组数据时，NSArray存储 @[@"1", @"2", @"3", @"4"]
 *              ②当有多组数据时，NSArray存储 @[@[@"1", @"2", @"3", @"4"], @[@"1", @"2", @"3", @"4"]]
 */
- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart;

/**
 *  名称数据
 *
 *  @return NSArray必须存储NSString类型
 */
- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart;



@optional

/**
 *  颜色数组(若不设置，默认随机)
 *  
 *  (PS:此方法对 波浪图(ZFWaveChart) 无效)
 *
 *  @return NSArray必须存储UIColor类型
 */
- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart;

/**
 *  y轴(普通图表) 或 x轴(横向图表) 数值显示的最大值(若不设置，默认返回数据源最大值)
 *
 *  (PS: 此方法与 isResetAxisLineMaxValue 关联，具体查看该属性注释)
 *  (PS: The method is related to isResetAxisLineMaxValue, read the property notes to learn more details)
 */
- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart;

/**
 *  y轴(普通图表) 或 x轴(横向图表) 数值显示的最小值(若不设置，默认返回数据源最小值)
 *  
 *  (PS: 当 isResetAxisLineMinValue 为NO时，此方法无效)
 *  (PS: When isResetAxisLineMinValue is NO, the method is invalid)
 */
- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart;

/**
 *  y轴(普通图表) 或 x轴(横向图表) 数值显示的段数(若不设置,默认5段)
 */
- (NSUInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart;

@end;


@interface ZFGenericChart : UIView

@property (nonatomic, weak) id<ZFGenericChartDataSource> dataSource;

/** 主题Label */
@property (nonatomic, strong) UILabel * topicLabel;
/** y轴单位 */
@property (nonatomic, copy) NSString * unit;

/** 单位颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * unitColor;
/** 背景颜色(默认为白色) */
@property (nonatomic, strong) UIColor * backgroundColor;
/** x轴颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * xAxisColor;
/** y轴颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * yAxisColor;
/** y轴(普通图表) 或 x轴(横向图表) 标题颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * axisLineNameColor;
/** y轴(普通图表) 或 x轴(横向图表) value颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * axisLineValueColor;
/** 分割线颜色(默认为浅灰色) */
@property (nonatomic, strong) UIColor * separateColor;
/** y轴(普通图表) 或 x轴(横向图表) valueLabel阴影颜色(默认为浅灰色) */
@property (nonatomic, strong) UIColor * valueLabelShadowColor;
/** 图形bezierPath阴影颜色(默认为浅灰色) */
@property (nonatomic, strong) UIColor * shadowColor;

/** 图表上label字体大小(默认为10.f) */
@property (nonatomic, strong) UIFont * valueOnChartFont;
/** y轴(普通图表) 或 x轴(横向图表) 上名称字体大小(默认为10.f) */
@property (nonatomic, strong) UIFont * axisLineNameFont;
/** y轴(普通图表) 或 x轴(横向图表) 上数值字体大小(默认为10.f) */
@property (nonatomic, strong) UIFont * axisLineValueFont;

/** 图表透明度(范围0 ~ 1, 默认为1.f) */
@property (nonatomic, assign) CGFloat opacity;
/** x轴名称label与x轴之间的距离(默认为0.f)(横向图表无效) */
@property (nonatomic, assign) CGFloat xLineNameLabelToXAxisLinePadding;
/** x轴valueLabel样式(默认为kPopoverLabelPatternPopover) */
@property (nonatomic, assign) kPopoverLabelPattern valueLabelPattern;
/** y轴(普通图表) 或 x轴(横向图表) 数值的显示类型(保留有效小数或显示整数形式，默认为整数形式) */
@property (nonatomic, assign) kValueType valueType;

/** 是否一直显示固定的最大值，默认为NO，该属性有以下3种情况
    ①当为NO时，且不实现
    - (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart
    则自动计算返回的全部数据中的最大值
    ②当为NO时，且实现
    - (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart
    则当返回的全部数据的值都为"0"时，则最大值为该代理方法给予的值
    若数据的值并不都是"0"时，则自动计算返回的全部数据中的最大值
    ③当为YES时，则必须实现
    - (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart
    否则无法绘画图表，且任何情况最大值都为该代理方法给予的值
 */
@property (nonatomic, assign) BOOL isResetAxisLineMaxValue;
/** 该属性是否重设坐标轴最小值，默认为NO(不设置，从0开始)，当设置为YES时，则有以下2种情况
    ①若同时实现代理方法中的
        - (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart
        则y轴最小值为该方法的返回值
    ②若不实现①中的方法，则y轴最小值为数据源最小值
 
 
    Default is NO (Start to O). When set to YES, then there are 2 cases:
    ①If at the same time to implement the method in ZFGenericChartDataSource:
        ||- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart||
        then axisLineMinValue is the return value of the method.
    ②If not to implement the method in ①, then axisLineMinValue is the minimum value of the dataSource.
 */
@property (nonatomic, assign) BOOL isResetAxisLineMinValue;
/** 是否带动画显示(默认为YES，带动画) */
@property (nonatomic, assign) BOOL isAnimated;
/** valueLabel当为气泡样式时，是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadowForValueLabel;
/** 是否显示 y轴(普通图表) 或 x轴(横向图表) 的value(默认为YES，当需要自定义value显示样式时，可设置为NO) */
@property (nonatomic, assign) BOOL isShowAxisLineValue;
/** 是否显示x轴分割线(默认为NO) */
@property (nonatomic, assign) BOOL isShowXLineSeparate;
/** 是否显示y轴分割线(默认为NO) */
@property (nonatomic, assign) BOOL isShowYLineSeparate;
/** 是否显示坐标轴箭头(默认为YES) */
@property (nonatomic, assign) BOOL isShowAxisArrows;



#pragma mark - 此方法不需理会(Ignore this method)

- (void)commonInit;

@end
