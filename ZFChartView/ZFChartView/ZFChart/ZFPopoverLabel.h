//
//  ZFPopoverLabel.h
//  ZFChartView
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 apple. All rights reserved.
//

//气泡Label

#import <UIKit/UIKit.h>

/**
 *  ZFPopoverLabel箭头方向
 */
typedef enum{
    kPopoverLaberArrowsOrientationOnTop = 0,//箭头在上方
    kPopoverLaberArrowsOrientationOnBelow = 1//箭头在下方
}kPopoverLaberArrowsOrientation;

/**
 *  ZFPopoverLabel样式
 */
typedef enum{
    kPopoverLabelPatternPopover = 0,//气泡样式(默认)
    kPopoverLabelPatternBlank = 1//空白样式(原样式)
}kPopoverLabelPattern;

@interface ZFPopoverLabel : UIView

/** 文本内容 */
@property (nonatomic, copy) NSString * text;
/** 箭头方向 */
@property (nonatomic, assign) kPopoverLaberArrowsOrientation arrowsOrientation;
/** 字体大小 */
@property (nonatomic, strong) UIFont * font;
/** 文本颜色 */
@property (nonatomic, strong) UIColor * textColor;
/** 样式 */
@property (nonatomic, assign) kPopoverLabelPattern pattern;
/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;

/**
 *  重绘
 */
- (void)strokePath;

@end
