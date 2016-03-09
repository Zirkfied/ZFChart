//
//  ZFBarChart.h
//  ZFChartView
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFBarChart : UIScrollView

#pragma mark - 初始化时必须要赋值的属性

/** x轴数值数组 (存储的是NSString类型) */
@property (nonatomic, strong) NSMutableArray * xLineValueArray;
/** x轴名字数组 (存储的是NSString类型) */
@property (nonatomic, strong) NSMutableArray * xLineTitleArray;
/** y轴数值显示的上限 */
@property (nonatomic, assign) float yLineMaxValue;


#pragma mark - 可选属性

/** y轴数值显示的段数(默认5段) */
@property (nonatomic, assign) NSInteger yLineSectionCount;
/** 标题 */
@property (nonatomic, copy) NSString * title;
/** 是否显示bar上方的label(默认为YES) */
@property (nonatomic, assign) BOOL isShowValueOnChart;
/** 图表上label字体大小(默认为10.f) */
@property (nonatomic, assign) CGFloat valueOnChartFontSize;
/** x轴上名称字体大小(默认为10.f) */
@property (nonatomic, assign) CGFloat xLineTitleFontSize;
/** x轴上数值字体大小(默认为10.f) */
@property (nonatomic, assign) CGFloat xLineValueFontSize;
/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;
/** 柱状条bar颜色 */
@property (nonatomic, strong) UIColor * barColor;
/** 超过y轴显示最大值时柱状条bar颜色(默认为红色) */
@property (nonatomic, strong) UIColor * overMaxValueBarColor;

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
