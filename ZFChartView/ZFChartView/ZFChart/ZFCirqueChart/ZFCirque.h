//
//  ZFCirque.h
//  ZFChartView
//
//  Created by apple on 2016/10/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  圆环样式
 */
typedef enum{
    kCirquePatternTypeForDefault = 0,             //带轨迹背景(默认)
    kCirquePatternTypeForDefaultWithShadow = 1,   //带轨迹背景和阴影
    kCirquePatternTypeForNone = 2,                //没有轨迹背景和阴影
    kCirquePatternTypeForShadow = 3               //没有轨迹背景，但有阴影
}kCirquePatternType;

/**
 *  圆环起始位置
 */
typedef enum{
    kCirqueStartOrientationOnTop = 0,           //正上方(默认)
    kCirqueStartOrientationOnTopRight = 1,      //右上
    kCirqueStartOrientationOnRight = 2,         //正右方
    kCirqueStartOrientationOnBottomRight = 3,   //右下
    kCirqueStartOrientationOnBottom = 4,        //正下方
    kCirqueStartOrientationOnBottomLeft = 5,    //左下
    kCirqueStartOrientationOnLeft = 6,          //正左方
    kCirqueStartOrientationOnTopLeft = 7        //左上
}kCirqueStartOrientation;



@interface ZFCirque : UIView

/** 百分比小数 */
@property (nonatomic, assign) CGFloat percent;
/** 每个圆环的半径 */
@property (nonatomic, assign) CGFloat radius;
/** 圆环线宽 */
@property (nonatomic, assign) CGFloat lineWidth;
/** 阴影透明度(默认为1.f) */
@property (nonatomic, assign) CGFloat shadowOpacity;
/** 圆环样式(默认为kCirquePatternTypeForDefault) */
@property (nonatomic, assign) kCirquePatternType cirquePatternType;
/** 圆环起始位置(默认为kCirqueStartOrientationOnTop) */
@property (nonatomic, assign) kCirqueStartOrientation cirqueStartOrientation;

/** 是否带动画显示(默认为YES，带动画) */
@property (nonatomic, assign) BOOL isAnimated;
/** 圆环path颜色 */
@property (nonatomic, strong) UIColor * pathColor;



#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
