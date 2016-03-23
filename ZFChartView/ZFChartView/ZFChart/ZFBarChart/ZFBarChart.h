//
//  ZFBarChart.h
//  ZFChartView
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFGenericChart.h"
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
 *  每组里面，bar与bar之间的间距(若不设置，默认为5.f)(当只有一组数据时，此方法无效)
 */
- (CGFloat)paddingForBarInBarChart:(ZFBarChart *)barChart;

/**
 *  x轴value文本颜色数组(若不设置，则全部返回黑色)
 *
 *  @return 返回UIColor或者NSArray
 *          eg: return ZFRed;  若返回UIColor,则全部value文本颜色为红色,当只有一组数据时,只允许返回UIColor
 *              return @[ZFRed, ZFOrange, ZFBlue];  若返回数组,则不同类别的bar上的value文本颜色为
 *                                                  数组对应下标的颜色，样式看Github文档
 */
- (id)valueTextColorArrayInChart:(ZFGenericChart *)chart;



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


#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
