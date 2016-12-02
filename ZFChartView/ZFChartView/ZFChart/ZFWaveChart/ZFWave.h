//
//  ZFWave.h
//  ZFChartView
//
//  Created by apple on 16/3/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFConst.h"

/**
 *  波浪图样式
 */
typedef enum{
    kWavePatternTypeForCurve = 0,   //曲线样式(默认样式)
    kWavePatternTypeForSharp = 1    //直线样式
}kWavePatternType;

@interface ZFWave : UIView

/** path颜色 */
@property (nonatomic, strong) UIColor * pathColor;
/** path边线颜色 */
@property (nonatomic, strong) UIColor * pathLineColor;
/** 数值坐标的数组 */
@property (nonatomic, strong) NSMutableArray * valuePointArray;
/** path渐变色模型 */
@property (nonatomic, strong) ZFGradientAttribute * gradientAttribute;
/** 间距 */
@property (nonatomic, assign) CGFloat padding;
/** 图表透明度(范围0 ~ 1, 默认为1.f) */
@property (nonatomic, assign) CGFloat opacity;
/** 波浪样式(默认为kWavePatternTypeForCurve) */
@property (nonatomic, assign) kWavePatternType wavePatternType;
/** 是否带动画显示(默认为YES，带动画) */
@property (nonatomic, assign) BOOL isAnimated;

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
