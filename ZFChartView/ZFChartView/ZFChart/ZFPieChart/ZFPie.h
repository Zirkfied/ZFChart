//
//  ZFPie.h
//  ZFChartView
//
//  Created by apple on 16/3/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

/**
 *   饼图样式
 */
typedef enum{
    kPieChartPatternTypeForCirque = 0,   //圆环
    kPieChartPatternTypeForCircle = 1    //整圆
}kPiePatternType;


@interface ZFPie : CAShapeLayer

/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;

/**
 *  pie
 *
 *  @param startAngleArray 存储每部分开始角度的数组
 *  @param endAngleArray   存储每部分结束角度的数组
 *  @param piePatternType  pie样式
 *
 *  @return self
 */
+ (instancetype)pieWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle color:(UIColor *)color duration:(CFTimeInterval)duration piePatternType:(kPiePatternType)piePatternType isAnimated:(BOOL)isAnimated;

@end
