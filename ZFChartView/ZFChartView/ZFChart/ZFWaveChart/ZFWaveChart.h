//
//  ZFWaveChart.h
//  ZFChartView
//
//  Created by apple on 16/3/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFGenericChart.h"
#import "ZFConst.h"
#import "ZFPopoverLabel.h"
#import "ZFWave.h"
@class ZFWaveChart;

/*********************  ZFWaveChartDelegate(ZFWaveChart协议方法)  *********************/
@protocol ZFWaveChartDelegate <NSObject>

@optional

/**
 *  组宽(若不设置，默认为25.f)
 */
- (CGFloat)groupWidthInWaveChart:(ZFWaveChart *)waveChart;

/**
 *  组与组之间的间距(若不设置，默认为20.f)
 */
- (CGFloat)paddingForGroupsInWaveChart:(ZFWaveChart *)waveChart;

/**
 *  path颜色(若不设置，默认为ZFSkyBlue)
 *
 *  @return 返回UIColor
 */
- (UIColor *)pathColorInWaveChart:(ZFWaveChart *)waveChart;

/**
 *  用于编写x轴valueLabel点击后需要执行后续代码
 *
 *  @param index     点击的x轴valueLabel的位置下标
 */
- (void)waveChart:(ZFWaveChart *)waveChart popoverLabelAtIndex:(NSInteger)index;

@end


@interface ZFWaveChart : ZFGenericChart

@property (nonatomic, weak) id<ZFWaveChartDelegate> delegate;

/** 主题 */
@property (nonatomic, copy) NSString * topic;
/** y轴单位 */
@property (nonatomic, copy) NSString * unit;
/** 图表上label字体大小(默认为10.f) */
@property (nonatomic, assign) CGFloat valueOnChartFontSize;
/** x轴上名称字体大小(默认为10.f) */
@property (nonatomic, assign) CGFloat xLineNameFontSize;
/** y轴上数值字体大小(默认为10.f) */
@property (nonatomic, assign) CGFloat yLineValueFontSize;
/** 主题文字颜色(默认黑色) */
@property (nonatomic, strong) UIColor * topicColor;
/** 背景颜色(默认为白色) */
@property (nonatomic, strong) UIColor * backgroundColor;
/** 是否显示分割线(默认为NO) */
@property (nonatomic, assign) BOOL isShowSeparate;
/** 图表上value位置(默认为kChartValuePositionDefalut) */
@property (nonatomic, assign) kChartValuePosition valuePosition;
/** x轴valueLabel样式(默认为kPopoverLabelPatternPopover) */
@property (nonatomic, assign) kPopoverLabelPattern valueLabelPattern;
/** value文本颜色(默认黑色) */
@property (nonatomic, strong) UIColor * valueTextColor;
/** 超过y轴显示最大值时柱状条valueText颜色(默认为红色) */
@property (nonatomic, strong) UIColor * overMaxValueTextColor;
/** valueLabel当为气泡样式时，是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadowForValueLabel;
/** 波浪样式(默认为kWavePatternTypeForCurve) */
@property (nonatomic, assign) kWavePatternType wavePatternType;
/** 是否显示x轴的value(默认为YES，当需要自定义value显示样式时，可设置为NO) */
@property (nonatomic, assign) BOOL isShowXLineValue;

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
