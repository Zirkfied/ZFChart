//
//  ZFLineChart.h
//  ZFChartView
//
//  Created by apple on 16/3/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFGenericChart.h"
#import "ZFConst.h"
#import "ZFPopoverLabel.h"
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

/**
 *  用于编写circle点击后需要执行后续代码
 *
 *  @param lineIndex   点击的circle在第几条线
 *  @param circleIndex 点击的circle在该线的下标
 */
- (void)lineChart:(ZFLineChart *)lineChart didSelectCircleAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex;

/**
 *  用于编写点击x轴valueLabel后需要执行后续代码
 *
 *  @param groupIndex 点击的label在第几组
 *  @param labelIndex 点击的label在该组的下标
 */
- (void)lineChart:(ZFLineChart *)lineChart didSelectPopoverLabelAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex;

@end





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
/** 图表上value位置(默认为kChartValuePositionDefalut) */
@property (nonatomic, assign) kChartValuePosition valuePosition;
/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;
/** 主题文字颜色(默认黑色) */
@property (nonatomic, strong) UIColor * topicColor;
/** 超过y轴显示最大值时线状图上的圆颜色(默认为红色) */
@property (nonatomic, strong) UIColor * overMaxValueCircleColor;
/** 背景颜色(默认为白色) */
@property (nonatomic, strong) UIColor * backgroundColor;
/** valueLabel样式(默认为kPopoverLabelPatternPopover) */
@property (nonatomic, assign) kPopoverLabelPattern valueLabelPattern;
/** 是否显示分割线(默认为NO) */
@property (nonatomic, assign) BOOL isShowSeparate;
/** valueLabel当为气泡样式时，是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadowForValueLabel;
/** 是否显示x轴的value(默认为YES，当需要自定义value显示样式时，可设置为NO) */
@property (nonatomic, assign) BOOL isShowXLineValue;


#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
