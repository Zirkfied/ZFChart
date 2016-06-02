//
//  ZFWave.h
//  ZFChartView
//
//  Created by apple on 16/3/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kWavePatternTypeForCurve = 0,//曲线样式(默认样式)
    kWavePatternTypeForSharp = 1//直线样式
}kWavePatternType;

@interface ZFWave : UIView

@property (nonatomic, strong) UIColor * pathColor;
@property (nonatomic, strong) NSMutableArray * valuePointArray;
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
