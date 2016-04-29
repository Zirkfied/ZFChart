//
//  ZFXAxisLine.h
//  ZFChartView
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 apple. All rights reserved.
//

/**
 *  X轴
 */

#import <UIKit/UIKit.h>

@interface ZFXAxisLine : UIView

/** x轴宽度 */
@property (nonatomic, assign) CGFloat xLineWidth;
/** x轴高度 */
@property (nonatomic, assign) CGFloat xLineHeight;
/** 是否带动画显示(默认为YES，带动画) */
@property (nonatomic, assign) BOOL isAnimated;
/** 坐标轴颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * axisColor;


#warning message - readonly(只读)

/** x轴开始x位置(从数学坐标轴(0.0)(左下角)开始) */
@property (nonatomic, assign, readonly) CGFloat xLineStartXPos;
/** x轴结束x位置(从数学坐标轴(0.0)(左下角)开始) */
@property (nonatomic, assign, readonly) CGFloat xLineEndXPos;
/** x轴开始Y位置(从数学坐标轴(0.0)(左下角)开始) */
@property (nonatomic, assign, readonly) CGFloat xLineStartYPos;
/** x轴结束Y位置(从数学坐标轴(0.0)(左下角)开始) */
@property (nonatomic, assign) CGFloat xLineEndYPos;


#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
