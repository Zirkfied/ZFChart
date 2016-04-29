//
//  ZFLine.h
//  ZFChartView
//
//  Created by apple on 16/3/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface ZFLine : CAShapeLayer

/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;

#pragma mark - public method

/**
 *  线
 *
 *  @param circleArray 当前线段圆环数组
 *
 *  @return self
 */
+ (instancetype)lineWithCircleArray:(NSMutableArray *)circleArray isAnimated:(BOOL)isAnimated shadowColor:(UIColor *)shadowColor;

@end
