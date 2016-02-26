//
//  ZFAxisLine.h
//  ZFChartView
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFAxisLine : UIView

/** x轴宽度 */
@property (nonatomic, assign) CGFloat xLineWidth;
/** x轴高度 */
@property (nonatomic, assign) CGFloat xLineHeight;
/** y轴宽度 */
@property (nonatomic, assign) CGFloat yLineWidth;
/** y轴高度 */
@property (nonatomic, assign) CGFloat yLineHeight;

/** y轴数值显示的段数 */
@property (nonatomic, assign) NSInteger yLineSectionCount;

#warning message - readonly(只读)

/** x轴开始x位置(从数学坐标轴(0.0)(左下角)开始) */
@property (nonatomic, assign, readonly) CGFloat xLineStartXPos;
/** x轴结束x位置(从数学坐标轴(0.0)(左下角)开始) */
@property (nonatomic, assign, readonly) CGFloat xLineEndXPos;
/** y轴开始x位置(从数学坐标轴(0.0)(左下角)开始) */
@property (nonatomic, assign, readonly) CGFloat yLineStartXPos;
/** y轴结束x位置(从数学坐标轴(0.0)(左下角)开始) */
@property (nonatomic, assign, readonly) CGFloat yLineEndXPos;
/** x轴开始Y位置(从数学坐标轴(0.0)(左下角)开始) */
@property (nonatomic, assign, readonly) CGFloat xLineStartYPos;
///** x轴结束Y位置(从数学坐标轴(0.0)(左下角)开始) */
//@property (nonatomic, assign) CGFloat xLineEndYPos;
/** y轴开始Y位置(从数学坐标轴(0.0)(左下角)开始) */
@property (nonatomic, assign, readonly) CGFloat yLineStartYPos;
/** y轴结束Y位置(从数学坐标轴(0.0)(左下角)开始) */
@property (nonatomic, assign, readonly) CGFloat yLineEndYPos;
/** 计算y轴分段高度的平均值 */
@property (nonatomic, assign, readonly) CGFloat yLineSectionHeightAverage;

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
