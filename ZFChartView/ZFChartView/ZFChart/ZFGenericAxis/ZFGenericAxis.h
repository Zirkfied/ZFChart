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
/** y轴数值显示的最大值 */
@property (nonatomic, assign) CGFloat yLineMaxValue;
/** y轴数值显示的最小值 */
@property (nonatomic, assign) CGFloat yLineMinValue;
/** 每组宽度(变相求x轴标题label宽度) */
@property (nonatomic, assign) CGFloat groupWidth;
/** 组与组之间的间距 */
@property (nonatomic, assign) CGFloat groupPadding;
/** x轴名称label与x轴之间的距离(默认为0.f) */
@property (nonatomic, assign) CGFloat xLineNameLabelToXAxisLinePadding;
/** y轴数值显示的段数 */
@property (nonatomic, assign) NSInteger yLineSectionCount;

/** y轴单位 */
@property (nonatomic, copy) NSString * unit;
/** y轴单位颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * unitColor;
/** x轴标题颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * xLineNameColor;
/** y轴value颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * yLineValueColor;
/** 坐标轴背景颜色 */
@property (nonatomic, strong) UIColor * axisLineBackgroundColor;
/** x轴颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * xAxisColor;
/** y轴颜色(默认为黑色) */
@property (nonatomic, strong) UIColor * yAxisColor;


/** x轴上名称字体大小(默认为10.f) */
@property (nonatomic, strong) UIFont * xLineNameFont;
/** y轴上数值字体大小(默认为10.f) */
@property (nonatomic, strong) UIFont * yLineValueFont;

/** 是否显示x轴分割线(默认为NO) */
@property (nonatomic, assign) BOOL isShowXLineSeparate;
/** 是否显示y轴分割线(默认为NO) */
@property (nonatomic, assign) BOOL isShowYLineSeparate;
/** 是否带动画显示(默认为YES，带动画) */
@property (nonatomic, assign) BOOL isAnimated;
/** 是否显示坐标轴箭头(默认为YES) */
@property (nonatomic, assign) BOOL isShowAxisArrows;
/** 分割线颜色(默认为浅灰色) */
@property (nonatomic, strong) UIColor * separateColor;
/** 坐标轴y轴数值的显示类型(保留有效小数或显示整数形式，默认为整数形式) */
@property (nonatomic, assign) kValueType valueType;


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

/**
 *  把分段线放在父控件最上面
 */
- (void)bringSectionToFront;

@end
