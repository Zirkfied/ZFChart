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

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

/**
 *  直接填写小数
 */
#define ZFDecimalColor(r, g, b, a) [UIColor colorWithRed:r green:g blue:b alpha:a]

/**
 *  直接填写整数
 */
#define ZFColor(r, g, b, a) [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:a]

/**
 *  随机颜色
 */
#define ZFRandomColor ZFColor(arc4random() % 256, arc4random() % 256, arc4random() % 256, 1)

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
 *  y轴label tag值
 */
extern NSInteger const YLineValueLabelTag;

/**
 *  x轴item宽度
 */
extern CGFloat const XLineItemWidth;

/**
 *  x轴item间隔
 */
extern CGFloat const XLineItemGapLength;

/**
 *  坐标y轴最大上限值到箭头的间隔距离
 */
extern CGFloat const ZFAxisLineGapFromYLineMaxValueToArrow;

/**
 *  饼图百分比label Tag值
 */
extern NSInteger const PieChartPercentLabelTag;

/**
 *  饼图详情背景容器 Tag值
 */
extern NSInteger const PieChartDetailBackgroundTag;

/**
 *  导航栏高度
 */
extern CGFloat const NAVIGATIONBAR_HEIGHT;

/**
 *  tabBar高度
 */
extern CGFloat const TABBAR_HEIGHT;

@interface ZFConst : NSObject

@end
