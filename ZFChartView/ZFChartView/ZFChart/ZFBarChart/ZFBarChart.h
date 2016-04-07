//
//  ZFBarChart.h
//  ZFChartView
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFGenericChart.h"
#import "ZFPopoverLabel.h"
@class ZFBarChart;

/*********************  ZFBarChartDelegate(ZFBarChart协议方法)  *********************/
@protocol ZFBarChartDelegate <NSObject>

@optional
/**
 *  bar宽度(若不设置，默认为25.f)
 */
- (CGFloat)barWidthInBarChart:(ZFBarChart *)barChart;

/**
 *  组与组之间的间距(若不设置,默认为20.f)
 */
- (CGFloat)paddingForGroupsInBarChart:(ZFBarChart *)barChart;

/**
 *  每组里面，bar与bar之间的间距(若不设置，默认为5.f)(当只有一组数组时，此方法无效)
 */
- (CGFloat)paddingForBarInBarChart:(ZFBarChart *)barChart;

/**
 *  x轴value文本颜色数组(若不设置，则全部返回黑色)
 *
 *  @return 返回UIColor或者NSArray
 *          eg: ①return ZFRed;  若返回UIColor,则全部value文本颜色为红色,当只有一组数据时,只允许返回UIColor
 *              ②return @[ZFRed, ZFOrange, ZFBlue];  若返回数组,则不同类别的bar上的value文本颜色     
 *                                                    为数组对应下标的颜色，样式看Github文档
 *
 */
- (id)valueTextColorArrayInChart:(ZFBarChart *)chart;

/**
 *  用于编写点击bar后需要执行后续代码
 *
 *  @param groupIndex 点击的bar在第几组
 *  @param barIndex   点击的bar在该组的下标
 */
- (void)barChart:(ZFBarChart *)barChart didSelectBarAtGroupIndex:(NSInteger)groupIndex barIndex:(NSInteger)barIndex;

/**
 *  用于编写点击x轴valueLabel后需要执行后续代码
 *
 *  @param groupIndex 点击的label在第几组
 *  @param labelIndex 点击的label在该组的下标
 */
- (void)barChart:(ZFBarChart *)barChart didSelectPopoverLabelAtGroupIndex:(NSInteger)groupIndex labelIndex:(NSInteger)labelIndex;

@end





@interface ZFBarChart : ZFGenericChart

@property (nonatomic, weak) id<ZFBarChartDelegate> delegate;

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
/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;
/** 主题文字颜色(默认黑色) */
@property (nonatomic, strong) UIColor * topicColor;
/** 超过y轴显示最大值时柱状条bar颜色(默认为红色) */
@property (nonatomic, strong) UIColor * overMaxValueBarColor;
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
