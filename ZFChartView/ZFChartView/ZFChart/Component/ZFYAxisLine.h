//
//  ZFYAxisLine.h
//  ZFChartView
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 apple. All rights reserved.
//

/**
 *  Y轴
 */

#import <UIKit/UIKit.h>
#import "ZFConst.h"

@interface ZFYAxisLine : UIView

/** y轴高度 */
@property (nonatomic, assign) CGFloat yLineHeight;
/** y轴数值显示的段数 */
@property (nonatomic, assign) NSInteger yLineSectionCount;
/** 是否带动画显示(默认为YES，带动画) */
@property (nonatomic, assign) BOOL isAnimated;
/** 是否显示坐标轴箭头(默认为YES) */
@property (nonatomic, assign) BOOL isShowAxisArrows;
/** 坐标轴颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * axisColor;

#warning message - readonly(只读)

/** y轴宽度 */
@property (nonatomic, assign, readonly) CGFloat yLineWidth;

/** y轴开始x位置(从数学坐标轴(0.0)(左下角)开始) */
@property (nonatomic, assign, readonly) CGFloat yLineStartXPos;
/** y轴结束x位置(从数学坐标轴(0.0)(左下角)开始) */
@property (nonatomic, assign, readonly) CGFloat yLineEndXPos;
/** y轴开始Y位置(从数学坐标轴(0.0)(左下角)开始) */
@property (nonatomic, assign, readonly) CGFloat yLineStartYPos;
/** y轴结束Y位置(从数学坐标轴(0.0)(左下角)开始) */
@property (nonatomic, assign, readonly) CGFloat yLineEndYPos;
/** 计算y轴分段高度的平均值 */
@property (nonatomic, assign, readonly) CGFloat yLineSectionHeightAverage;
/** y轴箭头顶点yPos */
@property (nonatomic, assign, readonly) CGFloat yLineArrowTopYPos;

#pragma mark - public method

/**
 *  初始化方法
 *
 *  @param frame     frame
 *  @param direction kAxisDirection
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame direction:(kAxisDirection)direction;

/**
 *  重绘
 */
- (void)strokePath;

@end
