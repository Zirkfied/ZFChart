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
#import "ZFCircle.h"
#import "ZFLine.h"
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
 *  图表上value位置(若不设置，默认全部为kChartValuePositionDefalut)
 *
 *  @return NSArray必须存储kChartValuePosition枚举类型
 *          eg: ①当只有1条线时，NSArray存储 @[@(kChartValuePositionOnTop)];
 *              ②当有3条线时(有多少条线，则存储多少个kChartValuePosition枚举类型)，  
 *                NSArray存储 @[@(kChartValuePositionOnTop), @(kChartValuePositionDefalut), @(kChartValuePositionOnBelow)];
 */
- (NSArray *)valuePositionInLineChart:(ZFLineChart *)lineChart;

/**
 *  用于编写circle点击后需要执行后续代码
 *
 *  @param lineIndex   点击的circle在第几条线
 *  @param circleIndex 点击的circle在该线的下标
 */
- (void)lineChart:(ZFLineChart *)lineChart didSelectCircleAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex circle:(ZFCircle *)circle popoverLabel:(ZFPopoverLabel *)popoverLabel;

/**
 *  用于编写点击x轴valueLabel后需要执行后续代码
 *
 *  @param groupIndex 点击的label在第几组
 *  @param labelIndex 点击的label在该组的下标
 */
- (void)lineChart:(ZFLineChart *)lineChart didSelectPopoverLabelAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex popoverLabel:(ZFPopoverLabel *)popoverLabel;

@end



@interface ZFLineChart : ZFGenericChart

@property (nonatomic, weak) id<ZFLineChartDelegate> delegate;

/** 图表上valueLabel中心点到对应圆的中心点的距离(默认为25.f) */
@property (nonatomic, assign) CGFloat valueCenterToCircleCenterPadding;
/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;
/** 超过y轴显示最大值时线状图上的圆颜色(默认为红色) */
@property (nonatomic, strong) UIColor * overMaxValueCircleColor;
/** 线样式(默认为kLinePatternTypeForSharp) */
@property (nonatomic, assign) kLinePatternType linePatternType;


#pragma mark - public method

/**
 *  重绘(每次更新数据后都需要再调一次此方法)
 */
- (void)strokePath;

@end
