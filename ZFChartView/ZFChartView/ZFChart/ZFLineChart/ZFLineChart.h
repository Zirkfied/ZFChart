//
//  ZFLineChart.h
//  ZFChartView
//
//  Created by apple on 16/3/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFGenericChart.h"
@class ZFLineChart;

/*********************  ZFLineChartDelegate(ZFLineChart协议方法)  *********************/
@protocol ZFLineChartDelegate <NSObject>

@optional
/**
 *  组宽(若不设置，默认为25.f)
 */
- (CGFloat)groupWidthInLineChart:(ZFLineChart *)lineChart;

/**
 *  组与组之间的间距(若不设置，默认为20.f)
 */
- (CGFloat)paddingForGroupsInLineChart:(ZFLineChart *)lineChart;

/**
 *  圆的半径(若不设置，默认为5.f)
 */
- (CGFloat)circleRadiusInLineChart:(ZFLineChart *)lineChart;

/**
 *  线宽(若不设置，默认为2.f)
 */
- (CGFloat)lineWidthInLineChart:(ZFLineChart *)lineChart;

@end





/**
 *  线状图上的value的位置
 */
typedef enum{
    kLineChartValuePositionDefalut = 0,//上下分布
    kLineChartValuePositionOnTop = 1,//圆的上方
    kLineChartValuePositionOnBelow = 2//圆的下方
}kLineChartValuePosition;

@interface ZFLineChart : ZFGenericChart

@property (nonatomic, weak) id<ZFLineChartDelegate> delegate;

/** 主题 */
@property (nonatomic, copy) NSString * topic;
/** y轴单位 */
@property (nonatomic, copy) NSString * unit;
/** 图表上label字体大小(默认为10.f) */
@property (nonatomic, assign) CGFloat valueOnChartFontSize;
/** x轴上名称字体大小(默认为10.f) */
@property (nonatomic, assign) CGFloat xLineNameFontSize;
/** y轴上数值字体大小(默认为10.f) */
@property (nonatomic, assign) CGFloat yLineValueFontSize;
/** value中心到圆中心的距离(默认25.f) */
@property (nonatomic, assign) CGFloat valueCenterToCircleCenterPadding;
/** 圆上的value位置(默认为kLineChartValuePositionDefalut) */
@property (nonatomic, assign) kLineChartValuePosition valuePosition;
/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;
/** 主题文字颜色(默认黑色) */
@property (nonatomic, strong) UIColor * topicColor;
/** 超过y轴显示最大值时线状图上的圆颜色(默认为红色) */
@property (nonatomic, strong) UIColor * overMaxValueCircleColor;
/** 背景颜色(默认为白色) */
@property (nonatomic, strong) UIColor * backgroundColor;

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
