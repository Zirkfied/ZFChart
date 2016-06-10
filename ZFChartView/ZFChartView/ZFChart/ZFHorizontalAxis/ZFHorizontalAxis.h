//
//  ZFHorizontalAxis.h
//  ZFChartView
//
//  Created by apple on 16/5/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFXAxisLine.h"
#import "ZFYAxisLine.h"

@interface ZFHorizontalAxis : UIScrollView

/** X轴 */
@property (nonatomic, strong) ZFXAxisLine * xAxisLine;
/** Y轴 */
@property (nonatomic, strong) ZFYAxisLine * yAxisLine;
/** y轴数值数组 */
@property (nonatomic, strong) NSMutableArray * yLineValueArray;
/** y轴名字数组 */
@property (nonatomic, strong) NSMutableArray * yLineNameArray;
/** x轴数值显示的最大值 */
@property (nonatomic, assign) float xLineMaxValue;
/** x轴数值显示的最小值 */
@property (nonatomic, assign) float xLineMinValue;
/** x轴数值显示的段数 */
@property (nonatomic, assign) NSInteger xLineSectionCount;
/** y轴上名称字体大小(默认为10.f) */
@property (nonatomic, assign) CGFloat yLineNameFontSize;
/** x轴上数值字体大小(默认为10.f) */
@property (nonatomic, assign) CGFloat xLineValueFontSize;
/** 每组宽度(变相求y轴标题label高度) */
@property (nonatomic, assign) CGFloat groupHeight;
/** 组与组之间的间距 */
@property (nonatomic, assign) CGFloat groupPadding;
/** x轴单位 */
@property (nonatomic, copy) NSString * unit;
/** x轴单位颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * unitColor;
/** y轴标题颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * yLineNameColor;
/** x轴value颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * xLineValueColor;
/** 坐标轴背景颜色 */
@property (nonatomic, strong) UIColor * axisLineBackgroundColor;
/** 坐标轴颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * axisColor;
/** 是否显示分割线 */
@property (nonatomic, assign) BOOL isShowSeparate;
/** 是否带动画显示(默认为YES，带动画) */
@property (nonatomic, assign) BOOL isAnimated;
/** 分割线颜色(默认为浅灰色) */
@property (nonatomic, strong) UIColor * separateColor;
/** 坐标轴数值的显示类型(保留有效小数或显示整数形式) */
@property (nonatomic, assign) kAxisLineValueType axisLineValueType;


#warning message - readonly(只读)
/** 获取坐标轴起点x值 */
@property (nonatomic, assign, readonly) CGFloat axisStartXPos;
/** 获取坐标轴起点Y值 */
@property (nonatomic, assign, readonly) CGFloat axisStartYPos;
/** 获取x轴最大上限值x值 */
@property (nonatomic, assign, readonly) CGFloat xLineMaxValueXPos;
/** 获取x轴最大上限值与0值的宽度 */
@property (nonatomic, assign, readonly) CGFloat xLineMaxValueWidth;
/** 获取y轴宽度 */
@property (nonatomic, assign, readonly) CGFloat yLineHeight;


#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

/**
 *  把分段线放的父控件最上面
 */
- (void)bringSectionToFront;

@end
