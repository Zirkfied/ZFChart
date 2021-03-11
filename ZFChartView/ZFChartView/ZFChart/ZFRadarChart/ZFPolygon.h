//
//  ZFPolygon.h
//  ZFChartView
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFPolygon : UIView

/** value数组 */
@property (nonatomic, strong) NSMutableArray * valueArray;
/** 多边形颜色 */
@property (nonatomic, strong) UIColor * polygonColor;
/** 多边形边线颜色 */
@property (nonatomic, strong) UIColor * polygonLineColor;
/** 多边形顶点颜色(默认为白色) */
@property (nonatomic, strong) UIColor * polygonPeakColor;
/** 多边形线宽(默认1.f) */
@property (nonatomic, assign) CGFloat polygonLineWidth;
/** 多边形顶点半径(默认5.f) */
@property (nonatomic, assign) CGFloat polygonPeakRadius;
/** 雷达中点平均角度 */
@property (nonatomic, assign) CGFloat averageRadarAngle;
/** 数值显示的最大值 */
@property (nonatomic, assign) CGFloat maxValue;
/** 数值显示的最小值 */
@property (nonatomic, assign) CGFloat minValue;
/** 半径 */
@property (nonatomic, assign) CGFloat maxRadius;
/** 多边形透明度 */
@property (nonatomic, assign) CGFloat opacity;

/** 是否带动画显示(默认为YES，带动画) */
@property (nonatomic, assign) BOOL isAnimated;
/** 是否显示多边形边线(默认为YES) */
@property (nonatomic, assign) BOOL isShowPolygonLine;
/** 是否显示多边形顶点(默认为NO) */
@property (nonatomic, assign) BOOL isShowPolygonPeak;


#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
