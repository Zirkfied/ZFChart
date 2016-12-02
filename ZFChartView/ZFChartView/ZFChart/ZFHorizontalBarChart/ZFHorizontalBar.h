//
//  ZFHorizontalBar.h
//  ZFChartView
//
//  Created by apple on 16/5/31.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFConst.h"

@interface ZFHorizontalBar : UIControl

#warning message - 以下属性可在点击后根据自身需求改动

/** bar颜色 */
@property (nonatomic, strong) UIColor * barColor;
/** bar渐变色模型 */
@property (nonatomic, strong) ZFGradientAttribute * gradientAttribute;
/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;
/** 是否带动画显示(默认为YES，带动画) */
@property (nonatomic, assign) BOOL isAnimated;
/** 图形bezierPath阴影颜色(默认为浅灰色) */
@property (nonatomic, strong) UIColor * shadowColor;
/** 图表透明度(范围0 ~ 1, 默认为1.f) */
@property (nonatomic, assign) CGFloat opacity;


#warning message - 下列参数勿修改(Do not modify)

/** 百分比小数 */
@property (nonatomic, assign) CGFloat percent;
/** self所在第几组数据 */
@property (nonatomic, assign) NSInteger groupIndex;
/** self在该组数据的下标位置 */
@property (nonatomic, assign) NSInteger barIndex;


#warning message - readonly(只读)

/** bar终点X值 */
@property (nonatomic, assign, readonly) CGFloat endXPos;


#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
