//
//  ZFLine.h
//  ZFChartView
//
//  Created by apple on 16/2/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFLine : UIView

/** 终点的坐标 */
@property (nonatomic, assign) CGPoint endPoint;
/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;
/** 线条颜色 */
@property (nonatomic, strong) UIColor * lineColor;

#pragma mark - public method

/**
 *  初始化方法
 *
 *  @param startPoint 开始的位置
 *  @param endPoint   结束的位置
 *
 *  @return self
 */
- (instancetype)initWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

/**
 *  重绘
 */
- (void)strokePath;

@end
