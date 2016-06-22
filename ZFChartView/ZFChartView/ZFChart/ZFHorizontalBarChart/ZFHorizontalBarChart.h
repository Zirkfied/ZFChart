//
//  ZFHorizontalBarChart.h
//  ZFChartView
//
//  Created by apple on 16/5/31.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFGenericChart.h"
#import "ZFConst.h"
@class ZFHorizontalBarChart;

/*********************  ZFHorizontalBarChartDelegate(ZFHorizontalBarChart协议方法)  *********************/
@protocol ZFHorizontalBarChartDelegate <NSObject>

@optional
/**
 *  bar高度(若不设置，默认为25.f)
 */
- (CGFloat)barHeightInHorizontalBarChart:(ZFHorizontalBarChart *)barChart;

/**
 *  组与组之间的间距(若不设置,默认为20.f)
 */
- (CGFloat)paddingForGroupsInHorizontalBarChart:(ZFHorizontalBarChart *)barChart;

/**
 *  每组里面，bar与bar之间的间距(若不设置，默认为5.f)(当只有一组数组时，此方法无效)
 */
- (CGFloat)paddingForBarInHorizontalBarChart:(ZFHorizontalBarChart *)barChart;

/**
 *  y轴value文本颜色数组(若不设置，则全部返回黑色)
 *
 *  @return 返回UIColor或者NSArray
 *          eg: ①return ZFRed;  若返回UIColor,则全部value文本颜色为红色,当只有一组数据时,只允许返回UIColor
 *              ②return @[ZFRed, ZFOrange, ZFBlue];  若返回数组,则不同类别的bar上的value文本颜色
 *                                                    为数组对应下标的颜色，样式看Github文档
 *
 */
- (id)valueTextColorArrayInHorizontalBarChart:(ZFHorizontalBarChart *)barChart;

/**
 *  用于编写点击bar后需要执行后续代码
 *
 *  @param groupIndex 点击的bar在第几组
 *  @param barIndex   点击的bar在该组的下标
 */
- (void)horizontalBarChart:(ZFHorizontalBarChart *)barChart didSelectBarAtGroupIndex:(NSInteger)groupIndex barIndex:(NSInteger)barIndex;

/**
 *  用于编写点击y轴valueLabel后需要执行后续代码
 *
 *  @param groupIndex 点击的label在第几组
 *  @param labelIndex 点击的label在该组的下标
 */
- (void)horizontalBarChart:(ZFHorizontalBarChart *)barChart didSelectPopoverLabelAtGroupIndex:(NSInteger)groupIndex labelIndex:(NSInteger)labelIndex;

@end


@interface ZFHorizontalBarChart : ZFGenericChart

@property (nonatomic, weak) id<ZFHorizontalBarChartDelegate> delegate;
/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;
/** 超过y轴显示最大值时柱状条bar颜色(默认为红色) */
@property (nonatomic, strong) UIColor * overMaxValueBarColor;
/** valueLabel到bar的距离(默认为5.f) */
@property (nonatomic, assign) CGFloat valueLabelToBarPadding;

#pragma mark - public method

/**
 *  重绘(每次更新数据后都需要再调一次此方法)
 */
- (void)strokePath;

@end
