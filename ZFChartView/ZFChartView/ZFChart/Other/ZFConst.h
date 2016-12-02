//
//  ZFConst.h
//  ZFChartView
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "ZFColor.h"
#import "ZFGradientAttribute.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

/**
 *  角度求三角函数sin值
 *  @param a 角度
 */
#define ZFSin(a) sin(a / 180.f * M_PI)

/**
 *  角度求三角函数cos值
 *  @param a 角度
 */
#define ZFCos(a) cos(a / 180.f * M_PI)

/**
 *  角度求三角函数tan值
 *  @param a 角度
 */
#define ZFTan(a) tan(a / 180.f * M_PI)

/**
 *  弧度转角度
 *  @param radian 弧度
 */
#define ZFAngle(radian) (radian / M_PI * 180.f)

/**
 *  角度转弧度
 *  @param angle 角度
 */
#define ZFRadian(angle) (angle / 180.f * M_PI)


/**
 *  坐标轴起点x值
 */
extern CGFloat const ZFAxisLineStartXPos;

/**
 *  坐标轴 label tag值
 */
extern NSInteger const ZFAxisLineValueLabelTag;

/**
 *  坐标轴 item宽度
 */
extern CGFloat const ZFAxisLineItemWidth;

/**
 *  坐标轴 组与组之间的间距
 */
extern CGFloat const ZFAxisLinePaddingForGroupsLength;

/**
 *  坐标轴 bar与bar之间间距
 */
extern CGFloat const ZFAxisLinePaddingForBarLength;

/**
 *  坐标轴最大上限值到箭头的间隔距离
 */
extern CGFloat const ZFAxisLineGapFromAxisLineMaxValueToArrow;

/**
 *  坐标轴分段线长度
 */
extern CGFloat const ZFAxisLineSectionLength;

/**
 *  坐标轴分段线高度
 */
extern CGFloat const ZFAxisLineSectionHeight;

/**
 *  开始系数(上方)
 */
extern CGFloat const ZFAxisLineStartRatio;

/**
 *  结束系数(下方)
 */
extern CGFloat const ZFAxisLineVerticalEndRatio;

/**
 *  横向坐标轴结束系数(下方)
 */
extern CGFloat const ZFAxisLineHorizontalEndRatio;

/**
 *  线状图圆的半径
 */
extern CGFloat const ZFLineChartCircleRadius;

/**
 *  雷达图半径延伸长度
 */
extern CGFloat const ZFRadarChartRadiusExtendLength;

/**
 *  饼图百分比label Tag值
 */
extern NSInteger const ZFPieChartPercentLabelTag;

/**
 *  导航栏高度
 */
extern CGFloat const NAVIGATIONBAR_HEIGHT;

/**
 *  tabBar高度
 */
extern CGFloat const TABBAR_HEIGHT;

/**
 *  topic高度
 */
extern CGFloat const TOPIC_HEIGHT;

/**
 *  圆周角
 */
extern CGFloat const ZFPerigon;

/**
 *  波浪图路径x点标识
 */
extern NSString * const ZFWaveChartXPos;

/**
 *  波浪图路径y点标识
 */
extern NSString * const ZFWaveChartYPos;

/**
 *  波浪图点是否等于0标识
 */
extern NSString * const ZFWaveChartIsHeightEqualZero;


/**
 *  线状图, 波浪图上的value的位置
 */
typedef enum{
    kChartValuePositionDefalut = 0,   //上下分布
    kChartValuePositionOnTop = 1,     //上方
    kChartValuePositionOnBelow = 2    //下方
}kChartValuePosition;

/**
 *  横向或竖向坐标轴
 */
typedef enum{
    kAxisDirectionVertical = 0,    //垂直方向
    kAxisDirectionHorizontal = 1   //水平方向
}kAxisDirection;

/**
 *  坐标轴y轴数值 或 雷达图分段数值 的显示类型
 */
typedef enum{
    kValueTypeInteger = 0,   //取整数形式(四舍五入)(默认)
    kValueTypeDecimal = 1,   //保留有效小数
}kValueType;

@interface ZFConst : NSObject

@end
