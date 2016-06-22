//
//  ZFHorizontalBar.h
//  ZFChartView
//
//  Created by apple on 16/5/31.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFHorizontalBar : UIControl

/** bar颜色 */
@property (nonatomic, strong) UIColor * barColor;
/** 百分比小数 */
@property (nonatomic, assign) CGFloat percent;
/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;
/** self所在第几组数据 */
@property (nonatomic, assign) NSInteger groupAtIndex;
/** self在该组数据的下标位置 */
@property (nonatomic, assign) NSInteger barIndex;
/** 是否带动画显示(默认为YES，带动画) */
@property (nonatomic, assign) BOOL isAnimated;
/** 图形bezierPath阴影颜色(默认为浅灰色) */
@property (nonatomic, strong) UIColor * shadowColor;
/** 图表透明度(范围0 ~ 1, 默认为1.f) */
@property (nonatomic, assign) CGFloat opacity;


#warning message - readonly(只读)

/** bar终点X值 */
@property (nonatomic, assign, readonly) CGFloat endXPos;


#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
