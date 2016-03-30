//
//  ZFGenericAxis.h
//  ZFChartView
//
//  Created by apple on 16/3/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFXAxisLine.h"
#import "ZFYAxisLine.h"

@interface ZFGenericAxis : UIScrollView

/** X轴 */
@property (nonatomic, strong) ZFXAxisLine * xAxisLine;
/** Y轴 */
@property (nonatomic, strong) ZFYAxisLine * yAxisLine;
/** x轴数值数组 */
@property (nonatomic, strong) NSMutableArray * xLineValueArray;
/** x轴名字数组 */
@property (nonatomic, strong) NSMutableArray * xLineNameArray;
/** y轴数值显示的上限 */
@property (nonatomic, assign) float yLineMaxValue;
/** y轴数值显示的段数 */
@property (nonatomic, assign) NSInteger yLineSectionCount;
/** x轴上名称字体大小(默认为10.f) */
@property (nonatomic, assign) CGFloat xLineNameFontSize;
/** y轴上数值字体大小(默认为10.f) */
@property (nonatomic, assign) CGFloat yLineValueFontSize;
/** 每组宽度(变相求x轴标题label宽度) */
@property (nonatomic, assign) CGFloat groupWidth;
/** 组与组之间的间距 */
@property (nonatomic, assign) CGFloat groupPadding;
/** y轴单位 */
@property (nonatomic, copy) NSString * unit;
/** 坐标轴背景颜色 */
@property (nonatomic, strong) UIColor * axisLineBackgroundColor;
/** 是否显示分割线 */
@property (nonatomic, assign) BOOL isShowSeparate;
/** 分段线颜色 */
@property (nonatomic, strong) UIColor * sectionColor;


#warning message - readonly(只读)
/** 获取坐标轴起点x值 */
@property (nonatomic, assign, readonly) CGFloat axisStartXPos;
/** 获取坐标轴起点Y值 */
@property (nonatomic, assign, readonly) CGFloat axisStartYPos;
/** 获取y轴最大上限值y值 */
@property (nonatomic, assign, readonly) CGFloat yLineMaxValueYPos;
/** 获取y轴最大上限值与0值的高度 */
@property (nonatomic, assign, readonly) CGFloat yLineMaxValueHeight;
/** 获取x轴宽度 */
@property (nonatomic, assign, readonly) CGFloat xLineWidth;

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;


@end
