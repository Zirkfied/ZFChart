//
//  ZFCircle.h
//  ZFChartView
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFCircle : UIControl

#warning message - 以下属性可在点击后根据自身需求改动

/** 圆的颜色 */
@property (nonatomic, strong) UIColor * circleColor;
/** 是否带动画显示(默认为YES，带动画) */
@property (nonatomic, assign) BOOL isAnimated;
/** 图表透明度(范围0 ~ 1, 默认为1.f) */
@property (nonatomic, assign) CGFloat opacity;


#warning message - 下列参数勿修改(Do not modify)

/** self所在第几条线 */
@property (nonatomic, assign) NSInteger lineIndex;
/** self在该线的下标位置 */
@property (nonatomic, assign) NSInteger circleIndex;
/** 记录数据是否超出上限(默认为NO) */
@property (nonatomic, assign) BOOL isOverrun;
/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;
/** 图形bezierPath阴影颜色(barChart默认为深灰色, lineChart、waveChart默认为浅灰色) */
@property (nonatomic, strong) UIColor * shadowColor;


#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
