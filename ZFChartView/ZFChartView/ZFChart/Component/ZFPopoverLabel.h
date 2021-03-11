//
//  ZFPopoverLabel.h
//  ZFChartView
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 apple. All rights reserved.
//

//气泡Label

#import <UIKit/UIKit.h>
#import "ZFConst.h"

/**
 *  ZFPopoverLabel箭头方向
 */
typedef enum{
    kPopoverLaberArrowsOrientationOnTop = 0,    //箭头在上方
    kPopoverLaberArrowsOrientationOnBelow = 1   //箭头在下方
}kPopoverLaberArrowsOrientation;

/**
 *  ZFPopoverLabel样式
 */
typedef enum{
    kPopoverLabelPatternPopover = 0,   //气泡样式(默认)
    kPopoverLabelPatternBlank = 1      //空白样式(原样式)
}kPopoverLabelPattern;

@interface ZFPopoverLabel : UIControl

#warning message - 以下属性可在点击后根据自身需求改动

/** 字体大小 */
@property (nonatomic, strong) UIFont * font;
/** 文本颜色 */
@property (nonatomic, strong) UIColor * textColor;
/** 是否带动画显示(默认为YES，带动画) */
@property (nonatomic, assign) BOOL isAnimated;


#warning message - 下列参数勿修改(Do not modify)

/** 文本内容 */
@property (nonatomic, copy) NSString * text;
/** 箭头方向 */
@property (nonatomic, assign) kPopoverLaberArrowsOrientation arrowsOrientation;
/** 样式 */
@property (nonatomic, assign) kPopoverLabelPattern pattern;
/** self所在第几组 */
@property (nonatomic, assign) NSInteger groupIndex;
/** self所在的位置下标 */
@property (nonatomic, assign) NSInteger labelIndex;
/** 记录数据是否超出上限 */
@property (nonatomic, assign) BOOL isOverrun;
/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;
/** label阴影颜色(默认为浅灰色) */
@property (nonatomic, strong) UIColor * shadowColor;


#pragma mark - public method

- (instancetype)initWithFrame:(CGRect)frame direction:(kAxisDirection)direction;

/**
 *  重绘
 */
- (void)strokePath;

@end
