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
 *  @return ①当只有1组数据时，NSArray存储 @[@"1", @"2", @"3", @"4"]
 *          ②当有多组数据时，NSArray存储 @[@[@"1", @"2", @"3", @"4"], @[@"1", @"2", @"3", @"4"]]
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
 *  y轴数值显示的最大值(若不设置，默认返回数据源最大值)
 */
- (CGFloat)yLineMaxValueInGenericChart:(ZFGenericChart *)chart;

/**
 *  y轴数值显示的最小值(若不设置，默认返回数据源最小值)
 *  
 *  (PS:当 isResetYLineMinValue 为NO时，此方法无效)
 */
- (CGFloat)yLineMinValueInGenericChart:(ZFGenericChart *)chart;

/**
 *  y轴数值显示的段数(若不设置,默认5段)
 */
- (NSInteger)yLineSectionCountInGenericChart:(ZFGenericChart *)chart;

@end;


@interface ZFGenericChart : UIView

@property (nonatomic, weak) id<ZFGenericChartDataSource> dataSource;

/** 主题 */
@property (nonatomic, copy) NSString * topic;
/** y轴单位 */
@property (nonatomic, copy) NSString * unit;
/** 主题文字颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * topicColor;
/** y轴单位颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * unitColor;
/** 背景颜色(默认为白色) */
@property (nonatomic, strong) UIColor * backgroundColor;
/** 坐标轴颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * axisColor;
/** x轴标题颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * xLineNameColor;
/** y轴value颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * yLineValueColor;
/** 分割线颜色(默认为浅灰色) */
@property (nonatomic, strong) UIColor * separateColor;
/** x轴valueLabel阴影颜色(默认为浅灰色) */
@property (nonatomic, strong) UIColor * valueLabelShadowColor;
/** 图形bezierPath阴影颜色(barChart默认为深灰色, lineChart、waveChart默认为浅灰色) */
@property (nonatomic, strong) UIColor * shadowColor;


/** 图表上label字体大小(默认为10.f) */
@property (nonatomic, assign) CGFloat valueOnChartFontSize;
/** x轴上名称字体大小(默认为10.f) */
@property (nonatomic, assign) CGFloat xLineNameFontSize;
/** y轴上数值字体大小(默认为10.f) */
@property (nonatomic, assign) CGFloat yLineValueFontSize;
/** x轴名称label与x轴之间的距离(默认为20.f) */
@property (nonatomic, assign) CGFloat xLineNameLabelToXAxisLinePadding;
/** x轴valueLabel样式(默认为kPopoverLabelPatternPopover) */
@property (nonatomic, assign) kPopoverLabelPattern valueLabelPattern;


/** 是否设置y轴最小值，默认为NO(不设置，从0开始)，当设置为YES时，则有以下2种情况
 ①若同时实现代理方法中的 - (CGFloat)yLineMinValueInGenericChart:(ZFGenericChart *)chart，则y轴最小值为该方法的返回值
 ②若不实现①中的方法，则y轴最小值为数据源最小值
 */
@property (nonatomic, assign) BOOL isResetYLineMinValue;
/** 是否带动画显示(默认为YES，带动画) */
@property (nonatomic, assign) BOOL isAnimated;
/** valueLabel当为气泡样式时，是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadowForValueLabel;
/** 是否显示x轴的value(默认为YES，当需要自定义value显示样式时，可设置为NO) */
@property (nonatomic, assign) BOOL isShowXLineValue;
/** 是否显示分割线(默认为NO) */
@property (nonatomic, assign) BOOL isShowSeparate;



#pragma mark - 此方法不需理会(Ignore this method)

- (void)commonInit;

@end
