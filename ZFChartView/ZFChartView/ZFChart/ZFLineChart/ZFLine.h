//
//  ZFLine.h
//  ZFChartView
//
//  Created by apple on 16/3/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface ZFLine : CAShapeLayer

/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;

/**
 *  线
 *
 *  @param circleArray 当前线段圆环数组
 *
 *  @return self
 */
+ (instancetype)lineWithCircleArray:(NSMutableArray *)circleArray;

@end
